## ----------------- Build Image ----------------- ##
FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS java

ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH}

ENV GRAAL_JDK_VERSION=21.0.2
ENV MVN_VERSION=3.9.9

## Install dependencies
RUN dnf -y update \
    && dnf install -y bash unzip tar gzip bzip2-devel gcc gcc-c++ gcc-gfortran \
    less libcurl-devel openssl openssl-devel readline-devel xz-devel \
    zlib-devel glibc-static libstdc++-static llvm \
    && dnf clean all

# Graal VM
WORKDIR /opt/graalvm
RUN export GRAAL_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "aarch64" || echo "x64") \
    && curl -4 -L https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${GRAAL_JDK_VERSION}/graalvm-community-jdk-${GRAAL_JDK_VERSION}_linux-${GRAAL_ARCH}_bin.tar.gz | tar -xvz --strip-components=1 \
    && mv /opt/graalvm /usr/lib/graalvm \
    && ln -s /usr/lib/graalvm/bin/native-image /usr/bin/native-image
  
# Maven
WORKDIR /opt/maven
ENV MVN_FOLDERNAME=apache-maven-${MVN_VERSION}
RUN curl -4 -L https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz | tar -xvz \
    && mv $MVN_FOLDERNAME /usr/lib/maven \
    && rm -rf $MVN_FOLDERNAME \
    && ln -s /usr/lib/maven/bin/mvn /usr/bin/mvn

ENV JAVA_HOME=/usr/lib/graalvm
ENV PATH="/usr/lib/graalvm/bin:${PATH}"

## Reset Working directory
WORKDIR /usr/src/app

ENTRYPOINT ["java"]

## ----------------- Build Artifact----------------- ##

FROM java AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean native:compile -Pnative -DskipTests


## ----------------- Release Image ----------------- ##

FROM public.ecr.aws/lambda/provided:al2023 AS release
ARG ARTIFACT_ID

EXPOSE 8080

COPY --from=build /app/target/${ARTIFACT_ID} /app
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter

ENTRYPOINT ["/app"]
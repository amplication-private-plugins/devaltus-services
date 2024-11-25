target_region = "us-east-1"

api_name            = "pets-api"
domain_prefix       = "pets"
hosted_zone_name    = "c3lifesandbox01use1.3clife.info"

authorizer_issuer    = "https://dev-pbxehnhy10cx2ksm.us.auth0.com/"
authorizer_audience  = "pets.api.c3lifesandbox01use1.3clife.info"
authorizer_jwks_url  = "https://dev-pbxehnhy10cx2ksm.us.auth0.com/.well-known/jwks.json"

tags = {
    Environment = "sandbox"
}
-record(google_authenticator_uri_params,
    { type             :: google_authenticator_uri:type()
    , account_name     :: binary()
    , secret           :: binary()
    , issuer    = none :: none | {some, binary()} % Optional, but strongly-recommended
    , algorithm = sha  :: google_authenticator_uri:algorithm()
    , digits    = 6    :: google_authenticator_uri:digits()
    }).

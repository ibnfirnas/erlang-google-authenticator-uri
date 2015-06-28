-module(google_authenticator_uri_SUITE).

-include("google_authenticator_uri_params.hrl").

%% Callbacks
-export(
    [ all/0
    , groups/0
    ]).

%% Test cases
-export(
    [ t_example/1
    ]).

-define(GROUP, google_authenticator_uri).

%% ============================================================================
%% Common Test callbacks
%% ============================================================================

all() ->
    [ {group, ?GROUP}
    ].

groups() ->
    Tests =
        [ t_example
        ],
    Properties = [parallel],
    [ {?GROUP, Properties, Tests}
    ].

%% =============================================================================
%%  Test cases
%% =============================================================================

t_example(_Cfg) ->
    % Example from Google Authenticator wiki:
    % https://github.com/google/google-authenticator/wiki/Key-Uri-Format
    ExpectedSecret      = <<"JBSWY3DPEHPK3PXP">>,
    ExpectedAccountName = <<"alice@google.com">>,
    ExpectedIssuer      = <<"Example">>,
    ExpectedURI =
        << "otpauth://totp/"
         , "Example:", ExpectedAccountName/binary
         , "?secret=", ExpectedSecret/binary
         , "&issuer=", ExpectedIssuer/binary
         % The following params are not in the example, since wiki says they're
         % ignored and defaults are used, but we explicitly set the defaults
         % anyway, for future-proofing against changed defaults:
         , "&algorithm=SHA1"
         , "&digits=6"
         , "&period=30"
        >>,
    Params = #google_authenticator_uri_params
        { type         = totp
        , account_name = ExpectedAccountName
        , secret       = base32:decode(ExpectedSecret)
        , issuer       = {some, ExpectedIssuer}
        },
    ConstructedURI = google_authenticator_uri:cons(Params),
    ct:log("ConstructedURI: ~p", [ConstructedURI]),
    ct:log("ExpectedURI: ~p", [ExpectedURI]),
    ConstructedURI = ExpectedURI.

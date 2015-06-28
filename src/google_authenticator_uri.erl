-module(google_authenticator_uri).

-include("google_authenticator_uri_params.hrl").

-export_type(
    [ params/0
    , type/0
    , algorithm/0
    , digits/0
    ]).

-export(
    [ cons/1
    ]).

-type type() ::
      {hotp, {counter, integer()}} % Initial counter value.
    | totp
    .

-type algorithm() ::
      sha
    | sha256
    | sha512
    .

-type digits() ::
      6
    | 8
    .

-type params() ::
    #google_authenticator_uri_params{}.

-spec cons(params()) ->
    binary().
cons(#google_authenticator_uri_params
    { type         = Type
    , account_name = AccountName
    , secret       = Secret
    , issuer       = IssuerOpt
    , algorithm    = Algorithm
    , digits       = Digits
    }
) ->
    TypeBin = type_to_bin(Type),
    Label = label_of_account_name_and_issuer_opt(AccountName, IssuerOpt),
    ParamIssuer =
        case IssuerOpt
        of  {some, <<Issuer/binary>>} -> [{<<"issuer">>, Issuer}]
        ;   none                      -> []
        end,
    ParamCounter =
        case Type
        of  {hotp, {counter, C}} -> [{<<"counter">>, integer_to_binary(C)}]
        ;   totp                 -> []
        end,
    ParamPeriod =
        case Type
        of  totp                 -> [{<<"period">>, <<"30">>}]
        ;   {hotp, {counter, _}} -> []
        end,
    Params =
        [ {<<"secret">>    , base32:encode(Secret)}
        ]
        ++ ParamIssuer ++
        [ {<<"algorithm">> , algorithm_to_bin(Algorithm)}
        , {<<"digits">>    , digits_to_bin(Digits)}
        ]
        ++ ParamCounter
        ++ ParamPeriod,
    ParamsBin = cow_qs:qs(Params),
    << "otpauth://"
     , TypeBin/binary
     , "/"
     , Label/binary
     , "?"
     , ParamsBin/binary
    >>.

-spec type_to_bin(type()) ->
    binary().
type_to_bin({hotp, _}) ->
    <<"hotp">>;
type_to_bin(totp) ->
    <<"totp">>.

-spec label_of_account_name_and_issuer_opt(binary(), none | {some, binary()}) ->
    binary().
label_of_account_name_and_issuer_opt(<<AccountName/binary>>, IssuerOpt) ->
    case IssuerOpt
    of  {some, <<Issuer/binary>>} ->
            <<Issuer/binary, ":", AccountName/binary>>
    ;   none ->
            AccountName
    end.

-spec algorithm_to_bin(algorithm()) ->
    binary().
algorithm_to_bin(sha) ->
    <<"SHA1">>;
algorithm_to_bin(sha256) ->
    <<"SHA256">>;
algorithm_to_bin(sha512) ->
    <<"SHA512">>.

-spec digits_to_bin(digits()) ->
    binary().
digits_to_bin(6) ->
    <<"6">>;
digits_to_bin(8) ->
    <<"8">>.

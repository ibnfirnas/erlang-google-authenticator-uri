[![Build Status](https://travis-ci.org/ibnfirnas/erlang-google-authenticator-uri.svg?branch=master)](https://travis-ci.org/ibnfirnas/erlang-google-authenticator-uri)

Google Authenticator URI constructor
====================================

Example:

```erlang
1> rr(google_authenticator_uri).
[google_authenticator_uri_params]
2>
2> ParamsTOTP = #google_authenticator_uri_params
2>     { type         = totp
2>     , account_name = <<"dude@lebowski.io">>
2>     , secret       = <<"allDudesGoBowling">>
2>     , issuer       = {some, <<"TheBigLebowski">>}
2>     },
2> UriTOTP = google_authenticator_uri:cons(ParamsTOTP),
2> io:format("~p~n", [UriTOTP]).
<<"otpauth://totp/TheBigLebowski:dude@lebowski.io?secret=MFWGYRDVMRSXGR3PIJXXO3DJNZTQ%3D%3D%3D%3D&issuer=TheBigLebowski&algorithm=SHA1&digits=6&period=30">>
ok
3>
3> ParamsHOTP = #google_authenticator_uri_params
3>     { type         = {hotp, {counter, 0}}
3>     , account_name = <<"dude@lebowski.io">>
3>     , secret       = <<"allDudesGoBowling">>
3>     , issuer       = {some, <<"TheBigLebowski">>}
3>     },
3> UriHOTP = google_authenticator_uri:cons(ParamsHOTP),
3> io:format("~p~n", [UriHOTP]).
<<"otpauth://hotp/TheBigLebowski:dude@lebowski.io?secret=MFWGYRDVMRSXGR3PIJXXO3DJNZTQ%3D%3D%3D%3D&issuer=TheBigLebowski&algorithm=SHA1&digits=6&counter=0">>
ok
4>
```

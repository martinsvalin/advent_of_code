-module(inverse_captcha_test).
-include_lib("eunit/include/eunit.hrl").

part1_test() -> 3 = inverse_captcha:part1([1,1,2,2]).

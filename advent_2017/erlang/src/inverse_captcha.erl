-module(inverse_captcha).
-export([part1/1, part2/1]).

part1([H | T] = Input) ->
  RotateOne =  T ++ [H],
  Paired = lists:zip(Input, RotateOne),
  lists:foldl(fun sum_same/2, 0, Paired).

sum_same({A, A}, Sum) -> Sum + A;
sum_same(_, Sum) -> Sum.

part2(_) ->
  bar.

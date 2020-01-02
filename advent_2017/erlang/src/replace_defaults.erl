-module(replace_defaults).

-export([ replace_defaults/2
        , replace_in_order/3
        ]).

%% @doc replace any property in the data with the leaves of the overrides
replace_defaults(Data, []) -> Data;
%% when the Value is a proplist (tree node):
replace_defaults(Data, [{Key, [{_,_} | _] = Value} | Overrides]) ->
  case lists:keyfind(Key, 1, Data) of
    {Key, [{_,_}|_] = Proplist} -> % tree property, override recursively
      DataNew = lists:keystore(
                  Key, 1, Data, {Key, replace_defaults(Proplist, Value)}),
      replace_defaults(DataNew, Overrides);
    {Key, _DataValue} -> % leaf property, override completely
      DataNew = lists:keystore(Key, 1, Data, {Key, Value}),
      replace_defaults(DataNew, Overrides)
  end;
%% when the value is a nested list of lists to be merged
replace_defaults(Data, [{Key, [L|_] = List, merge} | Overrides])
  when is_list(L) ->
  case lists:keyfind(Key, 1, Data) of
    {Key, [H|_] = Old} when is_list(H) ->
      % default is list of lists, merge in order
      NewList = replace_in_order(Old, List, []),
      NewData = lists:keystore(Key, 1, Data, {Key, NewList}),
      replace_defaults(NewData, Overrides);
    {Key, _DataValue} ->
      % default is something else, replace completely
      NewData = lists:keystore(Key, 1, Data, {Key, List}),
      replace_defaults(NewData, Overrides)
  end;
%% when the value is a single value (leaf node)
replace_defaults(Data, [{Key, Value} | Overrides]) ->
  DataNew = case Value of
              optional -> lists:keydelete(Key, 1, Data);
              Value -> lists:keystore(Key, 1, Data, {Key, Value})
            end,
  replace_defaults(DataNew, Overrides).

replace_in_order([], Overrides, Acc) -> lists:reverse(Acc, Overrides);
replace_in_order(Rest, [], Acc) -> lists:reverse(Acc, Rest);
replace_in_order([H | T], [NewH | NewT], Acc) ->
  replace_in_order(T, NewT, [replace_defaults(H, NewH) | Acc]).


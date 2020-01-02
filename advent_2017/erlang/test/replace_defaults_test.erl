-module(replace_defaults_test).
-include_lib("eunit/include/eunit.hrl").

simple_replacement_test() ->
  Data = [{key, old}],
  Overrides = [{key, new}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual(Overrides, Actual).

simple_addition_test() ->
  Data = [],
  Overrides = [{key, new}],
  Expected = [{key, new}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual(Expected, Actual).

untouched_test() ->
  Data = [{key, value}],
  Actual = replace_defaults:replace_defaults(Data, []),
  ?assertEqual(Data, Actual).

replace_one_leave_one_test() ->
  Data = [{key, old}, {another, whatever}],
  Overrides = [{key, new}],
  Expected = [{key, new}, {another, whatever}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual(Expected, Actual).

nested_proplist_replace_one_test() ->
  Data = [{outer, [{inner, old}, {another, whatever}]}],
  Overrides = [{outer, [{inner, new}]}],
  Expected = [{outer, [{inner, new}, {another, whatever}]}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual(Expected, Actual).

replace_leaf_with_proplist_test() ->
  Data = [{outer, value}],
  Overrides = [{outer, [{inner, new}]}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual(Overrides, Actual).

replace_missing_key_with_proplist_value_test() ->
  Overrides = [{key, [{inner, value}]}],
  ?assertException(error, {case_clause, false},
                  replace_defaults:replace_defaults([], Overrides)).

replace_missing_key_with_ordered_list_test() ->
  Overrides = [{key, [[{inner, value}]], merge}],
  ?assertException(error, {case_clause, false},
                  replace_defaults:replace_defaults([], Overrides)).

replace_missing_key_with_value_test() ->
  Override = [{key, new}],
  Actual = replace_defaults:replace_defaults([], Override),
  ?assertEqual(Override, Actual).

replace_nested_list_without_merging_test() ->
  Data = [{key, [[{inner, old}, {another_field, also_old}], [{second, item}]]}],
  Override = [{key, [[{inner, new}]]}],
  Actual = replace_defaults:replace_defaults(Data, Override),
  ?assertEqual(Override, Actual).

remove_value_with_optional_word_test() ->
  Data = [{key, value}],
  Overrides = [{key, optional}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual([], Actual).

nested_list_of_proplists_test() ->
  Data = [{outer, [[], [{inner, second}]]}],
  Overrides = [{outer, [[{inner, first}]], merge}],
  Expected = [{outer, [[{inner, first}], [{inner, second}]]}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual(Expected, Actual).

nested_list_adding_entry_test() ->
  Data = [{outer, [[{inner, first}]]}],
  Overrides = [{outer, [[], [{inner, second}]], merge}],
  Expected = [{outer, [[{inner, first}], [{inner, second}]]}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual(Expected, Actual).  

values_that_happen_to_be_lists_work_test() ->
  Data = [{key, "a string is a list, you know"}],
  Overrides = [{key, "new"}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual(Overrides, Actual).

can_override_empty_nested_list_test() ->
  Data = [{key, []}],
  Overrides = [{key, [[{inner, new}]]}],
  Actual = replace_defaults:replace_defaults(Data, Overrides),
  ?assertEqual(Overrides, Actual).

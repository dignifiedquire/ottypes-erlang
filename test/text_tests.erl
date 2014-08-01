-module(text_tests).
-include_lib("eunit/include/eunit.hrl").

evaluate_list(Cases) ->
    lists:map(fun({Expected, Input}) ->
                  ?_assertEqual(Expected, erlang:apply(text, apply, Input))
              end, Cases).

simple_test() ->
    Correct_cases = [
                     {<<"hello world">> , [<<"hello">>, [5, <<" world">>]]},
                     {<<"">>, [<<"hello">>, [{d, 5}]]},
                     {<<"hello">>, [<<"">>, [<<"hello">>]]},
                     {<<"hellöö">>, [<<"hellö">>, [5, <<"ö">>]]}
                    ],
    evaluate_list(Correct_cases).

apply_test_() ->
    [simple_test()].

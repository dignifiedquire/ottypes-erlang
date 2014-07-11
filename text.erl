-module(text).

-export([apply/2]).


safe_substring(Text, Pos) ->
    case Text == "" of
        true  -> Text;
        false ->
            case Pos == 0 of
                true  -> "";
                false -> string:sub_string(Text, Pos)
            end
    end.

safe_substring(Text, Pos1, Pos2) ->
    case Text == "" of
        true  -> Text;
        false ->
            case Pos1 == Pos2 of
                true  -> "";
                false -> string:sub_string(Text, Pos1, Pos2)
            end
    end.


apply(Content, Ops) ->

    %% TODO: Validate Ops

    {NewContent, _} = lists:foldl(
      fun (Op, {Text, Pos}) ->

              case Op of
                  Ins when is_list(Ins) ->
                      {
                        string:join([
                                     safe_substring(Text, 1, Pos - 1),
                                     Ins,
                                     safe_substring(Text, Pos)
                                    ], ""),
                        Pos + string:len(Ins)
                      };
                  Mov when is_integer(Mov) ->
                      {Text, Pos + Mov};
                  {d, Length} ->
                      NewText = string:concat(
                                  safe_substring(Text, 1, Pos),
                                  safe_substring(Text, Pos + Length)
                                 ),
                      {NewText, Pos}
              end
      end, {Content, 1}, Ops),
    NewContent.

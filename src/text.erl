%%
%% OT Type Text
%%
-module(text).

-export([apply/2]).


%% Types

-type text_op() :: binary() | {d, binary()} | integer().

%% API

-spec apply(binary(), [text_op()]) -> binary().
apply(Content, Ops) ->
    %% TODO: Validate Ops
    {NewContent, _} = lists:foldl(fun apply_op/2, {Content, 1}, Ops),
    NewContent.


-spec apply_op(text_op(), {binary(), integer()}) -> binary().
apply_op(Ins, {Text, Pos}) when is_binary(Ins) ->
    %% "some text" insertion
    Head = part(Text, 0, Pos - 1),
    Tail = part(Text, Pos - 1),
    {
      <<Head/binary, Ins/binary, Tail/binary>>,
      Pos + byte_size(Ins)
    };

apply_op(Mov, {Text, Pos}) when is_integer(Mov) ->
    %% Move the cursor
    { Text, Pos + Mov };

apply_op({d, Length}, {Text, Pos}) ->
    %% Delete operations
    Head = part(Text, 0, Pos - 1),
    Tail = part(Text, Pos - 1 + Length),
    { <<Head/binary, Tail/binary>>, Pos }.


%% Internal Functions

-spec part(binary(), integer()) -> binary().

part(Input, From) ->
    binary:part(Input, From, byte_size(Input) - From).

-spec part(binary(), integer(), integer()) -> binary().
part(Input, From, To) ->
    binary:part(Input, From, To - From).

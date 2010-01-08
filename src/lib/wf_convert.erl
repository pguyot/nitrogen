% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (wf_convert).
-export ([
	clean_lower/1,
	to_iodata/1,
	to_list/1, 
	to_atom/1, 
	to_binary/1, 
	to_integer/1,
	html_encode/1, html_encode/2
]).

-include ("wf.inc").

%%% CONVERSION %%%

clean_lower(L) -> string:strip(string:to_lower(to_list(L))).

-spec(to_iodata/1::(undefined | atom() | integer() | iodata() | list()) -> iodata()).
to_iodata(undefined) -> [];
to_iodata(L) when ?IS_STRING(L) -> L;
to_iodata(A) when is_atom(A) -> atom_to_list(A);
to_iodata(B) when is_binary(B) -> B;
to_iodata(I) when is_integer(I) -> integer_to_list(I);
to_iodata(L) when is_list(L) ->
    to_iodata_r(L, []).

to_iodata_r([H|T], Acc) ->
    to_iodata_r(T, [to_iodata(H)|Acc]);
to_iodata_r([], Acc) ->
    lists:reverse(Acc);
to_iodata_r(ImproperTail, Acc) ->
    to_iodata_r([], [to_iodata(ImproperTail)|Acc]).

to_list(undefined) -> [];
to_list(L) when ?IS_STRING(L) -> L;
to_list(L) when is_list(L) ->
    SubLists = [inner_to_list(X) || X <- L],
    lists:flatten(SubLists);
to_list(A) -> inner_to_list(A).
inner_to_list(A) when is_atom(A) -> atom_to_list(A);
inner_to_list(B) when is_binary(B) -> binary_to_list(B);
inner_to_list(I) when is_integer(I) -> integer_to_list(I);
inner_to_list(L) when is_list(L) -> L.

to_atom(A) when is_atom(A) -> A;
to_atom(B) when is_binary(B) -> to_atom(binary_to_list(B));
to_atom(I) when is_integer(I) -> to_atom(integer_to_list(I));
to_atom(L) when is_list(L) -> list_to_atom(binary_to_list(list_to_binary(L))).

to_binary(A) when is_atom(A) -> to_binary(atom_to_list(A));
to_binary(B) when is_binary(B) -> B;
to_binary(I) when is_integer(I) -> to_binary(integer_to_list(I));
to_binary(L) when is_list(L) -> list_to_binary(L).

to_integer(A) when is_atom(A) -> to_integer(atom_to_list(A));
to_integer(B) when is_binary(B) -> to_integer(binary_to_list(B));
to_integer(I) when is_integer(I) -> I;
to_integer(L) when is_list(L) -> list_to_integer(L).

%%% HTML ENCODE %%%

-spec(html_encode/1::(iodata()) -> iodata()).
html_encode(L) -> html_encode(L, true).

-spec(html_encode/2::(iodata(), false | true | whites) -> iodata()).
html_encode(L, false) -> to_iodata(L);
html_encode(L, true) -> html_encode0(to_iodata(L));
html_encode(L, whites) -> html_encode_whites0(to_iodata(L)).

html_encode0(IOData) ->
    lists:foldl(fun({RE, Repl}, Acc) ->
        re:replace(Acc, RE, Repl, [global])
    end, IOData, [{<<"&">>, <<"\\&amp;">>}, {<<"<">>, <<"\\&lt;">>}, {<<">">>, <<"\\&gt;">>}, {<<"\"">>, <<"\\&quot;">>}, {<<"'">>, <<"\\&#39;">>}]).

html_encode_whites0(IOData) ->
    lists:foldl(fun({RE, Repl}, Acc) ->
        re:replace(Acc, RE, Repl, [global])
    end, html_encode(IOData), [{<<" ">>, <<"\\&nbsp;">>}, {<<"\t">>, <<"\\&nbsp;\\&nbsp;\\&nbsp;\\&nbsp;\\&nbsp;">>}, {<<"\n">>, <<"<br/>">>}]).

%%%-------------------------------------------------------------------
%%% @author Hiroe Shin <hiroe.orz@gmail.com>
%%% @copyright (C) 2011, Hiroe Shin
%%% @doc
%%%
%%% @end
%%% Created : 11 Oct 2011 by Hiroe Shin <hiroe.orz@gmail.com>
%%%-------------------------------------------------------------------
-module(sent_timeline_tests).
-include_lib("eunit/include/eunit.hrl").
-include("message.hrl").

add_message_key_test() ->
    test_before(),
    UserId = 1,
    ?assertEqual(ok, sent_timeline:add_message_key(UserId, <<"msg_1">>)),
    ?assertEqual(ok, sent_timeline:add_message_key(UserId, <<"msg_2">>)),
    ?assertEqual(ok, sent_timeline:add_message_key(UserId, <<"msg_3">>)),
    ?assertEqual(ok, sent_timeline:add_message_key(UserId, <<"msg_4">>)),
    ?assertEqual(ok, sent_timeline:add_message_key(UserId, <<"msg_5">>)),
    test_after().

get_timeline_test() ->
    test_before(),
    UserId = 1,
    {ok, Id1, Key_1} = message:save_message(101, "text 1"),
    sent_timeline:add_message_key(UserId, Key_1),    
    {ok, Id2, Key_2} = message:save_message(102, "text 2"),
    sent_timeline:add_message_key(UserId, Key_2),
    {ok, Id3, Key_3} = message:save_message(103, "text 3"),
    sent_timeline:add_message_key(UserId, Key_3),

    ?assertMatch({ok, _}, sent_timeline:get_timeline(UserId, 3)),

    {ok, SentTimeLine} = sent_timeline:get_timeline(UserId, 3),

    [Msg1 | Tail1] = SentTimeLine, 
    ?assertEqual(Id1, Msg1#message.id),
    ?assertEqual("text 1", Msg1#message.text),
    ?assertEqual(101, Msg1#message.user_id),

    [Msg2 | Tail2] = Tail1, 
    ?assertEqual(Id2, Msg2#message.id),
    ?assertEqual("text 2", Msg2#message.text),
    ?assertEqual(102, Msg2#message.user_id),

    [Msg3 | _Tail3] = Tail2, 
    ?assertEqual(Id3, Msg3#message.id),
    ?assertEqual("text 3", Msg3#message.text),
    ?assertEqual(103, Msg3#message.user_id),
    test_after().

test_before() ->
    eredis_pool:start(),
    eredis_pool:create_pool(dbsrv, 10),
    eredis_pool:q({global, dbsrv}, ["DEL", <<"sent_1">>]),
    lists:map(fun(Id) -> 
                      Key = list_to_binary("msg" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)).

test_after() ->
    eredis_pool:q({global, dbsrv}, ["DEL", <<"sent_1">>]),
    lists:map(fun(Id) -> 
                      Key = list_to_binary("msg" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)).


%%%-------------------------------------------------------------------
%%% @author Hiroe Shin <hiroe.orz@gmail.com>
%%% @copyright (C) 2011, Hiroe Shin
%%% @doc
%%%
%%% @end
%%% Created : 11 Oct 2011 by Hiroe Shin <hiroe.orz@gmail.com>
%%%-------------------------------------------------------------------
-module(mentions_timeline_tests).
-include_lib("eunit/include/eunit.hrl").
-include("message.hrl").

add_message_key_test() ->
    test_before(),
    UserId = 1,
    ?assertEqual(ok, mentions_timeline:add_message_key(UserId, <<"msg_1">>)),
    ?assertEqual(ok, mentions_timeline:add_message_key(UserId, <<"msg_2">>)),
    ?assertEqual(ok, mentions_timeline:add_message_key(UserId, <<"msg_3">>)),
    ?assertEqual(ok, mentions_timeline:add_message_key(UserId, <<"msg_4">>)),
    ?assertEqual(ok, mentions_timeline:add_message_key(UserId, <<"msg_5">>)),
    test_after().

get_timeline_test() ->
    test_before(),
    UserId = 1,
    {ok, Id1, Key_1} = message:save_message(101, "text 1"),
    mentions_timeline:add_message_key(UserId, Key_1),    
    {ok, Id2, Key_2} = message:save_message(102, "text 2"),
    mentions_timeline:add_message_key(UserId, Key_2),
    {ok, Id3, Key_3} = message:save_message(103, "text 3"),
    mentions_timeline:add_message_key(UserId, Key_3),

    ?assertMatch({ok, _}, mentions_timeline:get_timeline(UserId, 3)),

    {ok, MentionsTimeLine} = mentions_timeline:get_timeline(UserId, 3),

    [Msg1 | Tail1] = MentionsTimeLine, 
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

add_mention_to_followers_test() ->
    test_before(),
    MsgKey = <<"msg_101">>,
    TextBin = <<"@taro dororicchi now! :-) @nobody @neko">>,
    
    {ok, _} = msb3_user:add_user("shin", "shin@mail", "pass"),
    {ok, _} = msb3_user:add_user("taro", "shin@mail", "pass"),
    {ok, _} = msb3_user:add_user("neko", "shin@mail", "pass"),
    {ok, _} = msb3_user:add_user("goro", "shin@mail", "pass"),

    ?assertEqual(ok, mentions_timeline:add_mention(MsgKey, TextBin)),
    msb3_util:sleep(100),

    ?assertEqual({ok, []}, 
                 eredis_pool:q({global, dbsrv}, ["LRANGE", "m_1", 0, -1])),

    ?assertEqual({ok, [MsgKey]}, 
                 eredis_pool:q({global, dbsrv}, ["LRANGE", "m_2", 0, -1])),
    
    ?assertEqual({ok, [MsgKey]}, 
                 eredis_pool:q({global, dbsrv}, ["LRANGE", "m_3", 0, -1])),

    ?assertEqual({ok, []}, 
                 eredis_pool:q({global, dbsrv}, ["LRANGE", "m_4", 0, -1])),

    test_after().

test_before() ->
    eredis_pool:start(),
    eredis_pool:create_pool(dbsrv, 10),
    eredis_pool:q({global, dbsrv}, ["DEL", <<"mentions_1">>]),
    lists:map(fun(Id) -> 
                      Key = list_to_binary("m_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)),

    lists:map(fun(Id) -> 
                      Key = list_to_binary("h_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 10001)),

    lists:map(fun(Id) -> 
                      Key = list_to_binary("follower_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)),
    lists:map(fun(Id) -> 
                      Key = list_to_binary("follow_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)),

    lists:map(fun(Id) -> 
                      Key = list_to_binary("usr_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)).

test_after() ->
    eredis_pool:q({global, dbsrv}, ["DEL", <<"mentions_1">>]),
    lists:map(fun(Id) -> 
                      Key = list_to_binary("m_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)),
    
    lists:map(fun(Id) -> 
                      Key = list_to_binary("h_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 10001)),

    lists:map(fun(Id) -> 
                      Key = list_to_binary("follower_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)),
    lists:map(fun(Id) -> 
                      Key = list_to_binary("follow_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)),

    lists:map(fun(Id) -> 
                      Key = list_to_binary("usr_" ++ integer_to_list(Id)),
                      eredis_pool:q({global, dbsrv}, ["DEL", Key])
              end, lists:seq(1, 100)).



#Module home_send_server#
* [Description](#description)
* [Function Index](#index)
* [Function Details](#functions)


.



Copyright (c) (C) 2011, Hiroe Shin

__Behaviours:__ [`gen_server`](gen_server.md).

__Authors:__ Hiroe Shin ([`shin@u720170.xgsfmg6.imtp.tachikawa.mopera.net`](mailto:shin@u720170.xgsfmg6.imtp.tachikawa.mopera.net)).<a name="index"></a>

##Function Index##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#add_home_to_followers-2">add_home_to_followers/2</a></td><td>
プロセスプールからワーカーを一つ取り出して以下の処理を行います。
受け取ったIdのユーザの各フォロワーのhomeにメッセージIdを保存する。
処理は非同期に行います。.</td></tr><tr><td valign="top"><a href="#add_home_to_followers-3">add_home_to_followers/3</a></td><td>
受け取ったIdのユーザの全フォロワーのhomeに受け取ったメッセージへのキーを保存する。
処理は非同期に行います。.</td></tr><tr><td valign="top"><a href="#start_link-1">start_link/1</a></td><td>
Starts the server.</td></tr><tr><td valign="top"><a href="#stop-0">stop/0</a></td><td></td></tr><tr><td valign="top"><a href="#stop-1">stop/1</a></td><td></td></tr></table>


<a name="functions"></a>

##Function Details##

<a name="add_home_to_followers-2"></a>

###add_home_to_followers/2##




<pre>add_home_to_followers(UserId::integer(), MsgKey::binary()) -&gt; ok</pre>
<br></br>





プロセスプールからワーカーを一つ取り出して以下の処理を行います。
受け取ったIdのユーザの各フォロワーのhomeにメッセージIdを保存する。
処理は非同期に行います。<a name="add_home_to_followers-3"></a>

###add_home_to_followers/3##




<pre>add_home_to_followers(Name_OR_Pid::pid() | atom(), UserId::integer(), MsgKey::binary()) -&gt; ok</pre>
<br></br>





受け取ったIdのユーザの全フォロワーのhomeに受け取ったメッセージへのキーを保存する。
処理は非同期に行います。<a name="start_link-1"></a>

###start_link/1##




<pre>start_link(Name_Or_Args::list() | atom()) -&gt; {ok, Pid::pid()} | ignore | {error, Error::atom()}</pre>
<br></br>





Starts the server
<a name="stop-0"></a>

###stop/0##




<pre>stop() -&gt; ok</pre>
<br></br>


<a name="stop-1"></a>

###stop/1##




<pre>stop(Name_OR_Pid::atom() | pid()) -&gt; ok</pre>
<br></br>



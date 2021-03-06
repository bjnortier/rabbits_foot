%%   The contents of this file are subject to the Mozilla Public License
%%   Version 1.1 (the "License"); you may not use this file except in
%%   compliance with the License. You may obtain a copy of the License at
%%   http://www.mozilla.org/MPL/
%%
%%   Software distributed under the License is distributed on an "AS IS"
%%   basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
%%   License for the specific language governing rights and limitations
%%   under the License.
%%
%%   The Original Code is the RabbitMQ Erlang Client.
%%
%%   The Initial Developers of the Original Code are LShift Ltd.,
%%   Cohesive Financial Technologies LLC., and Rabbit Technologies Ltd.
%%
%%   Portions created by LShift Ltd., Cohesive Financial
%%   Technologies LLC., and Rabbit Technologies Ltd. are Copyright (C)
%%   2007 LShift Ltd., Cohesive Financial Technologies LLC., and Rabbit
%%   Technologies Ltd.;
%%
%%   All Rights Reserved.
%%
%%   Contributor(s): Ben Hood <0x6e6562@gmail.com>.
%%   Contributor(s): Benjamin Nortier <bjnortier@gmail.com>
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                           Original rabbit.hrl                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


-record(user, {username, password, is_admin}).
-record(permission, {scope, configure, write, read}).
-record(user_vhost, {username, virtual_host}).
-record(user_permission, {user_vhost, permission}).

-record(vhost, {virtual_host, dummy}).

-record(connection, {protocol, user, timeout_sec, frame_max, vhost,
                     client_properties}).

-record(content,
        {class_id,
         properties, %% either 'none', or a decoded record/tuple
         properties_bin, %% either 'none', or an encoded properties binary
         %% Note: at most one of properties and properties_bin can be
         %% 'none' at once.
         protocol, %% The protocol under which properties_bin was encoded
         payload_fragments_rev %% list of binaries, in reverse order (!)
         }).

-record(resource, {virtual_host, kind, name}).

-record(exchange, {name, type, durable, auto_delete, arguments}).

-record(amqqueue, {name, durable, auto_delete, exclusive_owner = none,
                   arguments, pid}).

%% mnesia doesn't like unary records, so we add a dummy 'value' field
-record(route, {binding, value = const}).
-record(reverse_route, {reverse_binding, value = const}).

-record(binding, {exchange_name, key, queue_name, args = []}).
-record(reverse_binding, {queue_name, key, exchange_name, args = []}).

-record(listener, {node, protocol, host, port}).

-record(basic_message, {exchange_name, routing_key, content, guid,
                        is_persistent}).

-record(ssl_socket, {tcp, ssl}).
-record(delivery, {mandatory, immediate, txn, sender, message}).
-record(amqp_error, {name, explanation, method = none}).

-record(event, {type, props, timestamp}).

%%----------------------------------------------------------------------------

-define(COPYRIGHT_MESSAGE, "Copyright (C) 2007-2010 LShift Ltd., Cohesive Financial Technologies LLC., and Rabbit Technologies Ltd.").
-define(INFORMATION_MESSAGE, "Licensed under the MPL.  See http://www.rabbitmq.com/").
-define(PROTOCOL_VERSION, "AMQP 0-9-1 / 0-9 / 0-8").
-define(ERTS_MINIMUM, "5.6.3").

-define(MAX_WAIT, 16#ffffffff).

-define(HIBERNATE_AFTER_MIN,        1000).
-define(DESIRED_HIBERNATE,         10000).
-define(STATS_INTERVAL,             5000).

-ifdef(debug).
-define(LOGDEBUG0(F), rabbit_log:debug(F)).
-define(LOGDEBUG(F,A), rabbit_log:debug(F,A)).
-define(LOGMESSAGE(D,C,M,Co), rabbit_log:message(D,C,M,Co)).
-else.
-define(LOGDEBUG0(F), ok).
-define(LOGDEBUG(F,A), ok).
-define(LOGMESSAGE(D,C,M,Co), ok).
-endif.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Original rabbit_framing.hrl                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


-define(PROTOCOL_PORT, 5672).
-define(FRAME_METHOD, 1).
-define(FRAME_HEADER, 2).
-define(FRAME_BODY, 3).
-define(FRAME_HEARTBEAT, 8).
-define(FRAME_MIN_SIZE, 4096).
-define(FRAME_END, 206).
-define(REPLY_SUCCESS, 200).
-define(CONTENT_TOO_LARGE, 311).
-define(NO_ROUTE, 312).
-define(NO_CONSUMERS, 313).
-define(ACCESS_REFUSED, 403).
-define(NOT_FOUND, 404).
-define(RESOURCE_LOCKED, 405).
-define(PRECONDITION_FAILED, 406).
-define(CONNECTION_FORCED, 320).
-define(INVALID_PATH, 402).
-define(FRAME_ERROR, 501).
-define(SYNTAX_ERROR, 502).
-define(COMMAND_INVALID, 503).
-define(CHANNEL_ERROR, 504).
-define(UNEXPECTED_FRAME, 505).
-define(RESOURCE_ERROR, 506).
-define(NOT_ALLOWED, 530).
-define(NOT_IMPLEMENTED, 540).
-define(INTERNAL_ERROR, 541).
-define(FRAME_OOB_METHOD, 4).
-define(FRAME_OOB_HEADER, 5).
-define(FRAME_OOB_BODY, 6).
-define(FRAME_TRACE, 7).
-define(NOT_DELIVERED, 310).
%% Method field records.
-record('connection.start', {version_major = 0, version_minor = 9, server_properties, mechanisms = <<"PLAIN">>, locales = <<"en_US">>}).
-record('connection.start_ok', {client_properties, mechanism = <<"PLAIN">>, response, locale = <<"en_US">>}).
-record('connection.secure', {challenge}).
-record('connection.secure_ok', {response}).
-record('connection.tune', {channel_max = 0, frame_max = 0, heartbeat = 0}).
-record('connection.tune_ok', {channel_max = 0, frame_max = 0, heartbeat = 0}).
-record('connection.open', {virtual_host = <<"/">>, capabilities = <<"">>, insist = false}).
-record('connection.open_ok', {known_hosts = <<"">>}).
-record('connection.close', {reply_code, reply_text = <<"">>, class_id, method_id}).
-record('connection.close_ok', {}).
-record('connection.redirect', {host, known_hosts = <<"">>}).
-record('channel.open', {out_of_band = <<"">>}).
-record('channel.open_ok', {channel_id = <<"">>}).
-record('channel.flow', {active}).
-record('channel.flow_ok', {active}).
-record('channel.close', {reply_code, reply_text = <<"">>, class_id, method_id}).
-record('channel.close_ok', {}).
-record('channel.alert', {reply_code, reply_text = <<"">>, details = []}).
-record('access.request', {realm = <<"/data">>, exclusive = false, passive = true, active = true, write = true, read = true}).
-record('access.request_ok', {ticket = 1}).
-record('exchange.declare', {ticket = 0, exchange, type = <<"direct">>, passive = false, durable = false, auto_delete = false, internal = false, nowait = false, arguments = []}).
-record('exchange.declare_ok', {}).
-record('exchange.delete', {ticket = 0, exchange, if_unused = false, nowait = false}).
-record('exchange.delete_ok', {}).
-record('queue.declare', {ticket = 0, queue = <<"">>, passive = false, durable = false, exclusive = false, auto_delete = false, nowait = false, arguments = []}).
-record('queue.declare_ok', {queue, message_count, consumer_count}).
-record('queue.bind', {ticket = 0, queue, exchange, routing_key = <<"">>, nowait = false, arguments = []}).
-record('queue.bind_ok', {}).
-record('queue.purge', {ticket = 0, queue, nowait = false}).
-record('queue.purge_ok', {message_count}).
-record('queue.delete', {ticket = 0, queue, if_unused = false, if_empty = false, nowait = false}).
-record('queue.delete_ok', {message_count}).
-record('queue.unbind', {ticket = 0, queue, exchange, routing_key = <<"">>, arguments = []}).
-record('queue.unbind_ok', {}).
-record('basic.qos', {prefetch_size = 0, prefetch_count = 0, global = false}).
-record('basic.qos_ok', {}).
-record('basic.consume', {ticket = 0, queue, consumer_tag = <<"">>, no_local = false, no_ack = false, exclusive = false, nowait = false, arguments = []}).
-record('basic.consume_ok', {consumer_tag}).
-record('basic.cancel', {consumer_tag, nowait = false}).
-record('basic.cancel_ok', {consumer_tag}).
-record('basic.publish', {ticket = 0, exchange = <<"">>, routing_key = <<"">>, mandatory = false, immediate = false}).
-record('basic.return', {reply_code, reply_text = <<"">>, exchange, routing_key}).
-record('basic.deliver', {consumer_tag, delivery_tag, redelivered = false, exchange, routing_key}).
-record('basic.get', {ticket = 0, queue, no_ack = false}).
-record('basic.get_ok', {delivery_tag, redelivered = false, exchange, routing_key, message_count}).
-record('basic.get_empty', {cluster_id = <<"">>}).
-record('basic.ack', {delivery_tag = 0, multiple = false}).
-record('basic.reject', {delivery_tag, requeue = true}).
-record('basic.recover_async', {requeue = false}).
-record('basic.recover', {requeue = false}).
-record('basic.recover_ok', {}).
-record('tx.select', {}).
-record('tx.select_ok', {}).
-record('tx.commit', {}).
-record('tx.commit_ok', {}).
-record('tx.rollback', {}).
-record('tx.rollback_ok', {}).
-record('file.qos', {prefetch_size = 0, prefetch_count = 0, global = false}).
-record('file.qos_ok', {}).
-record('file.consume', {ticket = 1, queue, consumer_tag = <<"">>, no_local = false, no_ack = false, exclusive = false, nowait = false}).
-record('file.consume_ok', {consumer_tag}).
-record('file.cancel', {consumer_tag, nowait = false}).
-record('file.cancel_ok', {consumer_tag}).
-record('file.open', {identifier, content_size}).
-record('file.open_ok', {staged_size}).
-record('file.stage', {}).
-record('file.publish', {ticket = 1, exchange = <<"">>, routing_key = <<"">>, mandatory = false, immediate = false, identifier}).
-record('file.return', {reply_code = 200, reply_text = <<"">>, exchange, routing_key}).
-record('file.deliver', {consumer_tag, delivery_tag, redelivered = false, exchange, routing_key, identifier}).
-record('file.ack', {delivery_tag = 0, multiple = false}).
-record('file.reject', {delivery_tag, requeue = true}).
-record('stream.qos', {prefetch_size = 0, prefetch_count = 0, consume_rate = 0, global = false}).
-record('stream.qos_ok', {}).
-record('stream.consume', {ticket = 1, queue, consumer_tag = <<"">>, no_local = false, exclusive = false, nowait = false}).
-record('stream.consume_ok', {consumer_tag}).
-record('stream.cancel', {consumer_tag, nowait = false}).
-record('stream.cancel_ok', {consumer_tag}).
-record('stream.publish', {ticket = 1, exchange = <<"">>, routing_key = <<"">>, mandatory = false, immediate = false}).
-record('stream.return', {reply_code = 200, reply_text = <<"">>, exchange, routing_key}).
-record('stream.deliver', {consumer_tag, delivery_tag, exchange, queue}).
-record('dtx.select', {}).
-record('dtx.select_ok', {}).
-record('dtx.start', {dtx_identifier}).
-record('dtx.start_ok', {}).
-record('tunnel.request', {meta_data}).
-record('test.integer', {integer_1, integer_2, integer_3, integer_4, operation}).
-record('test.integer_ok', {result}).
-record('test.string', {string_1, string_2, operation}).
-record('test.string_ok', {result}).
-record('test.table', {table, integer_op, string_op}).
-record('test.table_ok', {integer_result, string_result}).
-record('test.content', {}).
-record('test.content_ok', {content_checksum}).
%% Class property records.
-record('P_connection', {}).
-record('P_channel', {}).
-record('P_access', {}).
-record('P_exchange', {}).
-record('P_queue', {}).
-record('P_basic', {content_type, content_encoding, headers, delivery_mode, priority, correlation_id, reply_to, expiration, message_id, timestamp, type, user_id, app_id, cluster_id}).
-record('P_tx', {}).
-record('P_file', {content_type, content_encoding, headers, priority, reply_to, message_id, filename, timestamp, cluster_id}).
-record('P_stream', {content_type, content_encoding, headers, priority, timestamp}).
-record('P_dtx', {}).
-record('P_tunnel', {headers, proxy_name, data_name, durable, broadcast}).
-record('P_test', {}).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Original amqp_client.hrl                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-define(PROTOCOL_VERSION_MAJOR, 0).
-define(PROTOCOL_VERSION_MINOR, 9).
-define(PROTOCOL_HEADER, <<"AMQP", 0, 0, 9, 1>>).
-define(PROTOCOL, rabbit_framing_amqp_0_9_1).

-define(MAX_CHANNEL_NUMBER, 65535).

-record(amqp_msg, {props = #'P_basic'{}, payload = <<>>}).

-record(amqp_params, {username          = <<"guest">>,
                      password          = <<"guest">>,
                      virtual_host      = <<"/">>,
                      host              = "localhost",
                      port              = ?PROTOCOL_PORT,
                      channel_max       = 0,
                      frame_max         = 0,
                      heartbeat         = 0,
                      ssl_options       = none,
                      client_properties = []}).

-define(LOG_DEBUG(Format), error_logger:info_msg(Format)).
-define(LOG_INFO(Format, Args), error_logger:info_msg(Format, Args)).
-define(LOG_WARN(Format, Args), error_logger:warning_msg(Format, Args)).

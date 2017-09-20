#start Project Anti Spam V1:)
json = dofile('./libs/JSON.lua')
serpent = dofile("./libs/serpent.lua")
local lgi = require ('lgi')
local notify = lgi.require('Notify')
notify.init ("Telegram updates")
Redis =  require ('redis')
redis = Redis.connect('127.0.0.1', 6379)
SUDO_ID = {363936960}
local TD_ID = redis:get('BOT-ID')
function is_sudo(msg)
  local var = false
 for v,user in pairs(SUDO_ID) do
    if user == msg.sender_user_id then
      var = true
    end
  end
  if redis:sismember("SUDO-ID", msg.sender_user_id) then
    var = true
  end
  return var
end
function do_notify (user, msg)
	local n = notify.Notification.new(user, msg)
	n:show ()
end
function is_GllobalBan(user)
  local var = false
  local hash = 'gban'
  local gbanned = redis:sismember(hash, user)
  if gbanned then
    var = true
  end
  return var
end
-- chs maqam
function is_Owner(msg) 
  local hash = redis:sismember('OwnerList'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) then
return true
else
return false
end
end
function is_Mod(msg) 
  local hash = redis:sismember('ModList:'..msg.chat_id_,msg.sender_user_id)
if hash or is_sudo(msg) or is_owner(msg) then
return true
else
return false
end
end
function is_Bannd(chat,user)
   local hash =  redis:sismember('BanUser'..chat,user)
  if hash then
    return true
    else
    return false
    end
  end
function is_filter(msg,value)
 local list = redis:smembers('Filters:'..msg.chat_id)
 var = false
  for i=1, #list do
    if value:match(list[i]) then
      var = true
    end
    end
    return var
  end
function is_MuteUser(chat,user)
   local hash =  db:sismember('mutes'..chat,user)
  if hash then
    return true
    else
    return false
    end
  end
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)

  if chat_id:match('^-100') then
    local channel_id = chat_id:gsub('-100', '')
    chat = {id = channel_id, type = 'channel'}
  else
    local group_id = chat_id:gsub('-', '')
    chat = {id = group_id, type = 'group'}
  end

  return chat
end
function getMe(cb)
  	assert (tdbot_function ({
    	_ = "getMe",
    }, cb, nil))
end
function Pin(channel_id, message_id)
  	tdbot_function ({
    	_ = "pinChannelMessage",
    	channel_id = getChatId(channel_id)._,
    	message_id = message_id,
  	}, dl_cb, nil)
end

function KickUser(chat_id, user_id)
  	tdbot_function ({
    	_ = "changeChatMemberStatus",
    	chat_id = chat_id,
    	user_id = user_id,
    	status = {
      		_ = "chatMemberStatusBanned"
    	},
  	}, dl_cb, nil)
end
function promoteToAdmin(chat_id, user_id)
  	tdbot_function ({
    	_ = "changeChatMemberStatus",
    	chat_id = chat_id,
    	user_id = user_id,
    	status = {
      		_ = "chatMemberStatusAdministrator"
    	},
  	}, dl_cb, nil)
end
function resolve_username(username)
    tdbot_function ({
        _ = "searchPublicChat",
        username = username
    }, dl_cb, nil)
end

function getChatHistory(chat_id, from_message_id, offset, limit,cb)
  tdbot_function ({
    _ = "getChatHistory",
    chat_id = chat_id,
    from_message_id = from_message_id,
    offset = offset,
    limit = limit
  }, cb, nil)
end
function deleteMessagesFromUser(chat_id, user_id)
  tdbot_function ({
    _ = "deleteMessagesFromUser",
    chat_id = chat_id,
    user_id = user_id
  }, dl_cb, nil)
end
 function deleteMessages(chat_id, message_ids)
  tdbot_function ({
    _= "deleteMessages",
    chat_id = chat_id,
    message_ids = message_ids -- vector {[0] = id} or {id1, id2, id3, [0] = id}
  }, dl_cb, nil)
end
local function getMessage(chat_id, message_id,cb)
 tdbot_function ({
    	_ = "getMessage",
    	chat_id = chat_id,
    	message_id = message_id
  }, cb, nil)
end
local function GeChat(chatid,cb)
 assert (tdbot_function ({
    _ = 'getChat',
    chat_id = chatid
 }, cb, nil))
end
function sendText(chat_id,msg, text, parse)
    assert( tdbot_function ({
    	_ = "sendMessage",
    	chat_id = chat_id,
    	reply_to_message_id = msg,
    	disable_notification = 0,
    	from_background = 1,
    	reply_markup = nil,
    	input_message_content = {
    		_ = "inputMessageText",
    		text = text,
    		disable_web_page_preview = 1,
    		clear_draft = 0,
    		parse_mode = getParse(parse),
    		entities = {}
    	}
    }, dl_cb, nil))

end

function  viewMessages(chat_id, message_ids)
  	tdbot_function ({
    	_ = "viewMessages",
    	chat_id = chat_id,
    	message_ids = message_ids
  }, dl_cb, nil)
end
function getChannelMembers(channelid, off, lim, mbrfilter,cb)
  local lim = lim or 200
  lim = lim > 200 and 200 or lim
  assert (tdbot_function ({
    _ = 'getChannelMembers',
    channel_id = getChatId(channelid).id,
    filter = {
      _ = 'channelMembersFilter' .. mbrfilter,
    },
    offset = off,
    limit = lim
  }, cb, nil))
  
end
local function vardump(value)
  print '\n-------------------------------------------------------------- START'
  print(serpent.block(value, {comment=false}))
  print '--------------------------------------------------------------- STOP\n'
end
function dl_cb(arg, data)
  -- print '\n===================================================================='
  vardump(arg)
  vardump(data)
  -- print '--==================================================================\n'
end
 function showedit(msg,data)
         if msg then
   viewMessages(msg.chat_id, {[0] = msg.id})
      if msg.send_state._ == "messageIsSuccessfullySent" then
      return false 
      end   
if not redis:sismember('AllGroup',msg.chat_id) then
       redis:sadd('AllGroup',msg.chat_id)
end  
------------Chat Type------------
function is_supergroup(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then 
    if not msg.is_post then
    return true
    end
  else
    return false
  end
end

function is_channel(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then 
  if msg.is_post then -- message is a channel post
    return true
  else
    return false
  end
  end
end

function is_group(msg)
  chat_id= tostring(msg.chat_id)
  if chat_id:match('^-100') then 
    return false
  elseif chat_id_:match('^-') then
    return true
  else
    return false
  end
end
function getParse(parse)
	if parse  == 'md' then
		return {_ = "textParseModeMarkdown"}
	elseif parse == 'html' then
		return {_ = "textParseModeHTML"}
	else
		return nil
	end
end

function is_private(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-') then
    return false
  else
    return true
  end
end
local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
function check_markdown(text)
		str = text
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
	return output
end
-------------MSG MATCHES------------
local cerner = msg.content.text
		 if msg_type == 'text' and cerner then
      if cerner:match('^[/]') then
      cerner=  cerner:gsub('^[/]','')
      end
    end
--------------MSG TYPE----------------
 if msg.content._== "messageText" then
         print("This is [ TEXT ]")
      msg_type = 'text'
    end
if cerner == 'id' then
 sendText(msg.chat_id,msg.id,'*CerNer Company*\n*Chat ID :* [`'..msg.chat_id..'`*]*\n*User ID : [*`'..msg.sender_user_id..'`*]*', 'md')
end

-------------------------------
end
end
 ------CerNer Company---------.
   if cerner then
      if not redis:get('BOT-ID') then
         function cb(CerNer,Company)
         redis:set('BOT-ID',Company.id)
         end
getMe(cb)
      end
    end
function tdbot_update_callback(data)
    if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then
     showedit(data.message,data)
vardump(data)
     elseif (data._== "updateMessageEdited") then
    data = data
    local function edit(extra,result,success)
      showedit(result,data)
    end
		tdbot_function ({
    	_ = "openChat",
    	chat_id = data.chat_id
}, dl_cb, nil)
     tdbot_function ({
	 _ = "getMessage", 
	 chat_id = data.chat_id,
	 message_id = data.message_id
	 }, edit, nil)
 assert (tdbot_function ({
    _ = 'openMessageContent',
    chat_id = data.chat_id,
    message_id = data.message_id
	}, dl_cb, nil))
    tdbot_function ({
	_="getChats",
	offset_order="9223372036854775807",
	offset_chat_id=0,
	limit=20
	}, dl_cb, nil)

end
end
---End Version 1 

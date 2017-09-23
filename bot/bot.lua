#start Project Anti Spam V2:)
json = dofile('./libs/JSON.lua')
serpent = dofile("./libs/serpent.lua")
local lgi = require ('lgi')
local notify = lgi.require('Notify')
notify.init ("Telegram updates")
Redis =  require ('redis')
redis = Redis.connect('127.0.0.1', 6379)
SUDO_ID = {363936960,310217440}
local minute = 60
local hour = 3600
local day = 86400
local week = 604800
TD_ID = redis:get('BOT-ID')
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
function is_GloballBan(user_id)
  local var = false
  local hash = 'GloballBan:'
  local gbanned = redis:sismember(hash, user_id)
  if gbanned then
    var = true
  end
  return var
end
-- Owner Msg
function is_Owner(msg) 
  local hash = redis:sismember('OwnerList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) then
return true
else
return false
end
end
-----CerNer Company
function is_Mod(msg) 
  local hash = redis:sismember('ModList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) then
return true
else
return false
end
end
function is_Vip(msg) 
  local hash = redis:sismember('Vip:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) or is_Mod(msg) then
return true
else
return false
end
end
function is_Banned(chat_id,user_id)
   local hash =  redis:sismember('BanUser:'..chat_id,user_id)
  if hash then
    return true
    else
    return false
    end
  end
function private(chat_id,user_id)
  local Owner = redis:sismember('OwnerList'..chat_id,user_id)
  local Mod = redis:sismember('ModList'..chat_id,user_id)
local Vip = redis:sismember('Vip:'..chat_id,user_id)
 if tonumber(SUDO_ID) == tonumber(user) or Owner or Mod or Vip then
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
function is_MuteUser(chat_id,user_id)
   local hash =  redis:sismember('MuteUser:'..chat_id,user_id)
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
local function getParse(parse_mode)
  local P = {}
  if parse_mode then
    local mode = parse_mode:lower()
    if mode == 'markdown' or mode == 'md' then
      P._ = 'textParseModeMarkdown'
    elseif mode == 'html' then
      P._ = 'textParseModeHTML'
    end
  end

  return P
end
local function getMe(cb)
  	assert (tdbot_function ({
    	_ = "getMe",
    }, cb, nil))
end
function Pin(channelid,messageid,disablenotification)
    assert (tdbot_function ({
    	_ = "pinChannelMessage",
   channel_id = getChatId(channelid).id,
    message_id = messageid,
    disable_notification = disablenotification
  	}, dl_cb, nil))
end
function Unpin(channelid)
  assert (tdbot_function ({
    _ = 'unpinChannelMessage',
    channel_id = getChatId(channelid).id
   }, dl_cb, nil))
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
function Left(chat_id, user_id, s)
   assert (tdbot_function ({
    _ = "changeChatMemberStatus",
    chat_id = chat_id,
    user_id = user_id,
    status = {
      _ = "chatMemberStatus" ..s
    },
  }, dl_cb, nil))
end
function mute(chat_id, user_id, Restricted, right)
  local chat_member_status = {}
 if Restricted == 'Restricted' then
    chat_member_status = {
     is_member = right[1] or 1,
      restricted_until_date = right[2] or 0,
      can_send_messages = right[3] or 1,
      can_send_media_messages = right[4] or 1,
      can_send_other_messages = right[5] or 1,
      can_add_web_page_previews = right[6] or 1
         }

  chat_member_status._ = 'chatMemberStatus' .. Restricted

  assert (tdbot_function ({
    _ = 'changeChatMemberStatus',
    chat_id = chat_id,
    user_id = user_id,
    status = chat_member_status
   }, dl_cb, nil))
end
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
function resolve_username(username,cb)
    assert ( tdbot_function ({
        _ = "searchPublicChat",
        username = username
  }, cb, nil))
end
function RemoveFromBanList(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusLeft"
},
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
 function GetChat(chatid,cb)
 assert (tdbot_function ({
    _ = 'getChat',
    chat_id = chatid
 }, cb, nil))
end
function getQuery(bot_user_id, chat_id, latitude, longitude, query,offset, cb)
  assert (tdbot_function ({
_ = 'getInlineQueryResults',
 bot_user_id = bot_user_id,
chat_id = chat_id,
user_location = {
 _ = 'location',
latitude = latitude,
longitude = longitude 
},
query = query,
offset = offset
}, cb, nil))
end
function StartBot(bot_user_id, chat_id, parameter)
  assert (tdbot_function ({_ = 'sendBotStartMessage',bot_user_id = bot_user_id,chat_id = chat_id,parameter = tostring(parameter)},  dl_cb, nil))
end
function sendText(chat_id,msg, text, parse)
assert( tdbot_function ({_ = "sendMessage",chat_id = chat_id,reply_to_message_id = msg,disable_notification = 0,from_background = 1,reply_markup = nil,input_message_content = {_ = "inputMessageText",text = text,disable_web_page_preview = 1,clear_draft = 0,parse_mode = getParse(parse),entities = {}}}, dl_cb, nil))
end
function  viewMessages(chat_id, message_ids)
  	tdbot_function ({
    	_ = "viewMessages",
    	chat_id = chat_id,
    	message_ids = message_ids
  }, dl_cb, nil)
end
local function getInputFile(file, conversion_str, expectedsize)
  local input = tostring(file)
  local infile = {}

  if (conversion_str and expectedsize) then
    infile = {
      _ = 'inputFileGenerated',
      original_path = tostring(file),
      conversion = tostring(conversion_str),
      expected_size = expectedsize
    }
  else
    if input:match('/') then
      infile = {_ = 'inputFileLocal', path = file}
    elseif input:match('^%d+$') then
      infile = {_ = 'inputFileId', id = file}
    else
      infile = {_ = 'inputFilePersistentId', persistent_id = file}
    end
  end

  return infile
end
function GetChannelFull(channelid)
assert (tdbot_function ({
 _ = 'getChannelFull',
channel_id = getChatId(channelid).id
}, cb, nil))
end
function sendGame(chat_id, reply_to_message_id, botuserid, gameshortname, disable_notification, from_background, reply_markup)
  local input_message_content = {
    _ = 'inputMessageGame',
    bot_user_id = botuserid,
    game_short_name = tostring(gameshortname)
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup)
end
local function sendMessage(chatid, replytomessageid, InputMessageContent, disablenotification, frombackground, replymarkup, callback, data)
  assert (tdbot_function ({
    _ = 'sendMessage',
    chat_id = chatid,
    reply_to_message_id = replytomessageid,
    disable_notification = disablenotification or 0,
    from_background = frombackground or 1,
    reply_markup = replymarkup,
    input_message_content = InputMessageContent
  }, callback or dl_cb, data))
end

function sendPhoto(chat_id, reply_to_message_id, photo_file, caption, disable_notification, from_background, reply_markup)
  local input_message_content = {
    _ = 'inputMessagePhoto',
    photo = getInputFile(photo_file),
    added_sticker_file_ids ={},
    width = 0,
    height = 0,
    caption = caption,
  }
    sendMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup)

end
function GetUser(user_id, cb)
  assert (tdbot_function ({
    _ = 'getUser',
    user_id = user_id
	  }, cb, nil))
end
local function GetUserFull(user_id,cb)
  assert (tdbot_function ({
    _ = "getUserFull",
    user_id = user_id
  }, cb, nil))

end
function ForMsg(chat_id, from_chat_id, message_id,from_background)
     assert (tdbot_function ({
        _ = "forwardMessages",
        chat_id = chat_id,
        from_chat_id = from_chat_id,
        message_ids = message_id,
        disable_notification = 0,
        from_background = from_background
    }, dl_cb, nil))
end
function getChannelMembers(channelid, off, limit, mbrfilter,cb)
if not limit or limit > 200 then
    limit = 200
  end  
assert (tdbot_function ({
    _ = 'getChannelMembers',
    channel_id = getChatId(channelid).id,
    filter = {
      _ = 'channelMembersFilter' .. mbrfilter,
    },
    offset = off,
    limit = limit
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
 if is_Owner(msg) then
 if msg.content._ == 'messagePinMessage' then
print '      Pinned By Owner       '
 redis:set('Pin_id'..msg.chat_id, msg.content.message_id)
 end
 end
if msg.date < os.time() - 10 then
print("\027[ m>>> OLD MSG <<<\027[00m")
return false
end
NUM_MSG_MAX = 6
if redis:get('Flood:Max:'..msg.chat_id) then
NUM_MSG_MAX = redis:get('Flood:Max:'..msg.chat_id)
end
NUM_CH_MAX = 2000
if redis:get('NUM_CH_MAX:'..msg.chat_id) then
NUM_CH_MAX = redis:get('NUM_CH_MAX:'..msg.chat_id)
end
TIME_CHECK = 2
if redis:get('Flood:Time:'..msg.chat_id) then
TIME_CHECK = redis:get('Flood:Time:'..msg.chat_id)
end
-------------Flood Check------------
    if redis:get('Lock:Flood:'..msg.chat_id) then
    if not is_Mod(msg) then
      local post_count = 'user:' .. msg.sender_user_id .. ':floodc'
      local msgs = tonumber(redis:get(post_count) or 0)
      if msgs > tonumber(NUM_MSG_MAX) then
    KickUser(msg.chat_id,msg.sender_user_id)
sendText(msg.chat_id, msg.id,'*User * : `'..msg.sender_user_id..'` * has been kicked for flooding *\n\n@CerNerCompany','md')

      end
      redis:setex(post_count, tonumber(TIME_CHECK), msgs+1)
    end
     end
-------------MSG CerNer ------------
local cerner = msg.content.text
local cerner1 = msg.content.text

	if cerner and (cerner:match("[A-Z]") or cerner:match("[a-z]"))  then
		cerner = cerner:lower()
end
		 if MsgType == 'text' and cerner then
      if cerner:match('^[/#!]') then
      cerner= cerner:gsub('^[/#!]','')
      end
    end
------------------------------------
--------------MSG TYPE----------------
 if msg.content._== "messageText" then
         print("This is [ TEXT ]")
      MsgType = 'text'
    end
 if msg.content._ == "messageChatAddMembers" then
         print("This is [ AddUser ]")

       MsgType = 'AddUser'
    end
    if msg.content._ == "messageChatJoinByLink" then
       MsgType = 'JoinedByLink'
    end
   if msg.content._ == "messageDocument" then
        print("This is [ File Or Document ]")
         MsgType = 'Document'
      end
      -------------------------
      if msg.content._ == "messageSticker" then
        print("This is [ Sticker ]")
         MsgType = 'Sticker'
      end
      -------------------------
      if msg.content._ == "messageAudio" then
        print("This is [ Audio ]")
         MsgType = 'Audio'
      end
      -------------------------
      if msg.content._ == "messageVoice" then
        print("This is [ Voice ]")
         MsgType = 'Voice'
      end
      -------------------------
      if msg.content._ == "messageVideo" then
        print("This is [ Video ]")
         MsgType = 'Video'
      end
      -------------------------
      if msg.content._ == "messageAnimation" then
        print("This is [ Gif ]")
         MsgType = 'Gif'
      end
      -------------------------
      if msg.content._ == "messageLocation" then
        print("This is [ Location ]")
         MsgType = 'Location'
      end
      if msg.content._ == "messageForwardedFromUser" then
        print("This is [ messageForwardedFromUser ]")
         MsgType = 'messageForwardedFromUser'
end
      -------------------------
      if msg.content._ == "messageContact" then
        print("This is [ Contact ]")
         MsgType = 'Contact'
      end
 if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
        print("This is [ MarkDown ]")
         MsgType = 'Markreed'
      end
if msg.content.game then
print("This is [ Game ]")
MsgType = 'Game'
end
    if msg.content._ == "messagePhoto" then
      MsgType = 'Photo'
end
if msg.sender_user_id and is_GloballBan(msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
end
if MsgType == 'AddUser' and msg.content.member_user_ids[0] then
if is_GloballBan(msg.content.member_user_ids[0]) then
KickUser(msg.chat_id_,msg.content.member_user_ids[0])
print '                      >>>>Is  Globall Banned <<<<<                        '
sendText(msg.chat_id, msg.id,'*User * : `'..msg.content.member_user_ids[0]..'` *is Globall Banned *','md')
end
end
if MsgType == 'AddUser' and msg.content.member_user_ids[0] then
if is_Banned(msg.chat_id,msg.content.member_user_ids[0]) then
KickUser(msg.chat_id_,msg.content.member_user_ids[0])
print '                      >>>>Is  Banned <<<<<                        '
sendText(msg.chat_id, msg.id,'*User * : `'..msg.content.member_user_ids[0]..'` *is Banned *','md')
end
end
if msg.sender_user_id and is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
end
local welcome = (redis:get('Welcome:'..msg.chat_id) or 'disable') 
if welcome == 'enable' then
if MsgType == 'JoinedByLink' then
print '                       JoinedByLink                        '
if not is_Banned(msg.chat_id,msg.sender_user_id) then
function WelcomeByLink(CerNer,Company)
if redis:get('Text:Welcome:'..msg.chat_id) then
txt = redis:get('Text:Welcome:'..msg.chat_id)
else
txt = 'سلام {first}\nخوش امدی'
end
local txt = txt:gsub('{first}',Company.first_name)
local txt = txt:gsub('{lastname}',Company.last_name or '')
local txt = txt:gsub('{username}',Company.username or '')
sendText(msg.chat_id, msg.id, txt,'html')
 end
GetUser(msg.sender_user_id,WelcomeByLink)
end
end
if MsgType == 'AddUser' then
if not is_Banned(msg.chat_id,msg.content.member_user_ids[0]) then
print('New User : \nChatID : '..msg.chat_id..'\nUser ID : '..msg.content.member_user_ids[0]..'')
if redis:get('Text:Welcome:'..msg.chat_id) then
txt = redis:get('Text:Welcome:'..msg.chat_id)
else
txt = 'سلام \nخوش امدی'
end
sendText(msg.chat_id, msg.id, txt,'md')
end
end
end
viewMessages(msg.chat_id, {[0] = msg.id})
redis:incr('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
if msg.send_state._ == "messageIsSuccessfullySent" then
return false 
end   
if cerner and not is_sudo(msg) then
if not redis:sismember('CompanyAll',msg.chat_id) then
redis:sadd('CompanyAll',msg.chat_id)
  redis:set("ExpireData:"..msg.chat_id,'waiting')
        else
          if redis:get("ExpireData:"..msg.chat_id) then
            if redis:ttl("ExpireData:"..msg.chat_id) and tonumber(redis:ttl("ExpireData:"..msg.chat_id)) < 432000 and not redis:get('CheckExpire:'..msg.chat_id) then
      sendText(msg.chat_id,0,"شارژ  "..msg.chat_id.." به اتمام رسیده است ",'md')
        redis:set('CheckExpire:'..msg.chat_id,true)
      end
        elseif not redis:get("ExpireData:"..msg.chat_id) then
      sendText(msg.chat_id,0,"شارژ  "..msg.chat_id.." به اتمام رسیده است ",'md')
redis:srem("group:",msg.chat_id)
redis:del("OwnerList:",msg.chat_id)
redis:del("ModList:",msg.chat_id)
redis:del("Filters:",msg.chat_id)
redis:del("MuteList:",msg.chat_id)
        Left(msg.chat_id,TD_ID, "Left")
        end
        end       
      end
----------Msg Checks-------------
local chat = msg.chat_id
if redis:get('CheckBot:'..msg.chat_id)  then
if not is_Owner(msg) then
if redis:get('Lock:Pin:'..chat) then
if msg.content._ == 'messagePinMessage' then
print '      Pinned By Not Owner       '

sendText(msg.chat_id, msg.id, 'Only Owners\n\n@CerNerCompany', 'md')
Unpin(msg.chat_id)
local PIN_ID = redis:get('Pin_id'..msg.chat_id)
if Pin_id then
Pin(msg.chat_id, tonumber(PIN_ID), 0)
end
end
end
end
if not is_Mod(msg) and not is_Vip(msg)  then
local chat = msg.chat_id
local user = msg.sender_user_id
----------Lock Link-------------
if redis:get('Lock:Link'..chat) then
 if cerner then
local link = cerner:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or cerner:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or cerner:match("[Tt].[Mm][Ee]/") or cerner:match('(.*)[.][mM][Ee]')
if link then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end

if msg.content.caption then
local cap = msg.content.caption
local link = cap:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or cap:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or cap:match("[Tt].[Mm][Ee]/") or cap:match('(.*)[.][mM][Ee]')
if link then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
end 
---------------------------
if redis:get('Lock:Tag:'..chat) then
if cerner then
local tag = cerner:match("@(.*)")
if tag then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
if msg.content.caption then
local cerner = msg.content.caption
local tag = cerner:match("@(.*)")
if itag then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
end
---------------------------
if redis:get('Lock:HashTag:'..chat) then
if cerner then
local hashtag = (cerner:match("#(.*)") or cerner:match("#"))
if hashtag then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [HashTag] ")

end
end
if msg.content.caption then
local cerner = msg.content.caption
local hashtag = (cerner:match("#(.*)") or cerner:match("#"))
if hashtag then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
end

---------------------------
if redis:get('Lock:Video_note:'..chat) then
if msg.content._ == 'messageVideoNote' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [VideoNote] ")
end
end
---------------------------
if redis:get('Lock:Arabic:'..chat) then
 if cerner and cerner:match("[\216-\219][\128-\191]") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Persian] ")
end 
if msg.content.caption then
local cerner = msg.content.caption
local is_persian = cerner:match("[\216-\219][\128-\191]")
if is_persian then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Persian] ")
end
end
end
--------------------------
if redis:get('Lock:English:'..chat) then
if cerner and (cerner:match("[A-Z]") or cerner:match("[a-z]")) then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [English] ")
end 
if msg.content.caption then
local cerner = msg.content.caption
local is_english = (cerner:match("[A-Z]") or cerner:match("[a-z]"))
if is_english then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [ENGLISH] ")
end
end
end
----------Filter------------
if cerner then
 if is_filter(msg,cerner) then
 deleteMessages(msg.chat_id, {[0] = msg.id})
 end 
end
-----------------------------------------------
if redis:get('Lock:Inline:'..chat) then
 if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
 deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Inline] ")
end
end
----------------------------------------------
if redis:get('Lock:TGservise:'..chat) then
if msg.content._ == "messageChatJoinByLink" or msg.content._ == "messageChatAddMembers" or msg.content._ == "messageChatDeleteMember" then
 deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
------------------------------------------------
if redis:get('Lock:Forward:'..chat) then
if msg.forward_info then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
--------------------------------
if redis:get('Lock:Sticker:'..chat) then
if  MsgType == 'Sticker' then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
----------Lock Edit-------------
if redis:get('Lock:Edit'..chat) then
if msg.edit_date > 0 then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
-------------------------------Mutes--------------------------
if redis:get('Mute:Text:'..chat) then
if MsgType == 'text' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Text] ")
end
end
--------------------------------
if redis:get('Mute:Photo:'..chat) then
 if MsgType == 'Photo' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Photo] ")
end
end 
-------------------------------
if redis:get('Mute:Caption:'..chat) then
if msg.content.caption then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] ")
end
end 
-------------------------------
if redis:get('Mute:Reply:'..chat) then
if msg.reply_to_message_id then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Reply] ")
end
end 
-------------------------------
if redis:get('Mute:Document:'..chat) then
if MsgType == 'Document' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Docment] ")
end
end
---------------------------------
if redis:get('Mute:Location:'..chat) then
if MsgType == 'Location' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Location] ")
end
end
-------------------------------
if redis:get('Mute:Voice:'..chat) then
if MsgType == 'Voice' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ CerNerCompany ] Deleted [Lock] [Voice] ")
end
end
-------------------------------
if redis:get('Mute:Contact:'..chat) then
if MsgType == 'Contact' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ CerNerCompany ] Deleted [Lock] [Contact] ")
end
end
-------------------------------
if redis:get('Mute:Game:'..chat) then
if MsgType == 'Game' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ CerNerCompany ] Deleted [Lock] [Game] ")
end
end
--------------------------------
if redis:get('Mute:Video:'..chat) then
if MsgType == 'Video' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ CerNerCompany ] Deleted [Lock] [Video] ")
end
end
--------------------------------
if redis:get('Mute:Music:'..chat) then
if MsgType == 'Audio' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ CerNerCompany ] Deleted [Lock] [Music] ")
end
end
--------------------------------
if redis:get('Mute:Gif:'..chat) then
if MsgType == 'Gif' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ CerNerCompany ] Deleted [Lock] [Gif] ")
end
end
 ------------------------------
end
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
			output = str:gsub('_',[[_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
	return output
end
if is_supergroup(msg) then
if is_sudo(msg) then
if cerner == 'bc' and tonumber(msg.reply_to_message_id) > 0 then
function CerNerCompany(CerNer,Company)
local text = Company.content.text
local list = redis:smembers('CompanyAll')
for k,v in pairs(list) do
sendText(v, 0, text, 'md')
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),CerNerCompany)
end
if cerner == 'fwd' and tonumber(msg.reply_to_message_id) > 0 then
function CerNerCompany(CerNer,Company)
local list = redis:smembers('CompanyAll')
for k,v in pairs(list) do
ForMsg(v, msg.chat_id, {[0] = Company.id}, 1)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),CerNerCompany)
end
 if msg.content._ == "messageChatAddMembers" == TD_ID then
redis:set("ExpireData:"..msg.chat_id,true)
redis:setex("ExpireData:"..msg.chat_id,day,true)
  redis:sadd("group:"..msg.chat_id,msg.chat_id)
redis:set('CheckExpire:'..msg.chat_id,true)
end
if cerner == 'add' then
local function GetName(CerNer, Company)
redis:set("ExpireData:"..msg.chat_id,true)
redis:setex("ExpireData:"..msg.chat_id,day,true)
  redis:sadd("group:"..msg.chat_id,msg.chat_id)
redis:set('CheckExpire:'..msg.chat_id,true)
if  redis:get('CheckBot:'..msg.chat_id) then
local text = 'Group `'..Company.title..'` is *Already* Added'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '`Group` *'..Company.title..'* ` Added`'
redis:set('CheckBot:'..msg.chat_id,true) 
 sendText(msg.chat_id, msg.id,text,'md')
end
end
GetChat(msg.chat_id,GetName)
end
if cerner == 'reload' then
 dofile('./bot/bot.lua')
sendText(msg.chat_id,msg.id,'Bot Reloaded \n\n@CerNerCompany','md')
end
if cerner == 'vardump' then 
function id_by_reply(extra, result, success)
    local TeXT = serpent.block(result, {comment=false})
text= string.gsub(TeXT, "\n","\n\r\n")
sendText(msg.chat_id, msg.id, text,'html')
 end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, 
tonumber(msg.reply_to_message_id),id_by_reply)
end
end
if cerner == 'rem' then
local function GetName(CerNer, Company)
redis:del("ExpireData:"..msg.chat_id)
  redis:srem("group:",msg.chat_id)
  redis:del("OwnerList:",msg.chat_id)
  redis:del("ModList:",msg.chat_id)
redis:del('CheckExpire:'..msg.chat_id)
 if not redis:get('CheckBot:'..msg.chat_id) then
local text = 'Group `'..Company.title..'` is *Already* Removed\n\n@CerNerCompany'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '`Group` *'..Company.title..'* ` Removed `\n\n@CerNerCompany'
 sendText(msg.chat_id, msg.id,text,'md')
 redis:del('CheckBot:'..msg.chat_id) 
end
end
GetChat(msg.chat_id,GetName)
end
if cerner and cerner:match('^charge (%d+)$') then
local function GetName(CerNer, Company)
local time = tonumber(cerner:match('^charge (%d+)$')) * day
 redis:setex("ExpireData:"..msg.chat_id,time,true)
local ti = math.floor(time / day )
local text = '`Group` *'..Company.title..'* ` Charged` For *'..ti..'* Day\n\n@CerNerCompany'
sendText(msg.chat_id, msg.id,text,'md')
if redis:get('CheckExpire:'..msg.chat_id) then
 redis:set('CheckExpire:'..msg.chat_id,true)
end
end
GetChat(msg.chat_id,GetName)
end
if cerner == "expire" then
local ex = redis:ttl("ExpireData:"..msg.chat_id)
if ex == -1 then
sendText(msg.chat_id, msg.id,  "\n\n@CerNerCompanyنامحدود" , 'md' )
else
local d = math.floor(ex / day ) + 1
sendText(msg.chat_id, msg.id,d.."  Day\n\n@CerNerCompany",  'md' )
end
end
if cerner == 'leave' then
Left(msg.chat_id, TD_ID, 'Left')
end
if cerner == 'stats' then
local allmsgs = redis:get('allmsgs')
local supergroup = redis:scard('ChatSuper:Bot')
local Groups = redis:scard('Chat:Normal')
local users = redis:scard('ChatPrivite')
local text =[[
All Msgs : ]]..allmsgs..[[


SuperGroups :]]..supergroup..[[


Groups : ]]..Groups..[[


Users : ]]..users..[[


@CerNerCompany]]
sendText(msg.chat_id, msg.id,text,  'md' )
end
if cerner == 'ownerlist' then
local list = redis:smembers('OwnerList:'..msg.chat_id)
local t = 'ModList\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t..'\n\n@CerNerCompany'
if #list == 0 then
t = 'صاحبی مشخص نشده است\n\n@CerNerCompany'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner and cerner:match('^setrank (.*)$') then
local rank = cerner:match('^setrank (.*)$') 
local function SetRank_Rep(CerNer, Company)
redis:set('rank'..Company.sender_user_id,rank)
local user = Company.sender_user_id
 sendText(msg.chat_id, msg.id,'Rank the '..user..' to *'..rank..'* the change', 'md')
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetRank_Rep)
end
end

if cerner == 'setowner' then
local function SetOwner_Rep(CerNer, Company)
redis:sadd('OwnerList:'..msg.chat_id,Company.sender_user_id)
local user = Company.sender_user_id
sendText(msg.chat_id, msg.id,'User '..Company.sender_user_id..' Has Been Added To OwnerList\n\n@CerNerCompany', 'md')
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetOwner_Rep)
end
end
if cerner == 'gban' then
function GbanByReply(CerNer,Company)
if redis:sismember('GloballBan:'..Company.sender_user_id) then
sendText(msg.chat_id, msg.id,  '`User : ` *'..Company.sender_user_id..'* is *Already* `a Globall Banned..!`\n\n@CerNerCompany', 'md')
else
sendText(msg.chat_id, msg.id,'_ User : _ `'..Company.sender_user_id..'` *is* to `Globall Banned`..\n\n@CerNerCompany', 'md')
redis:sadd('GloballBan:'..msg.chat_id, Company.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GbanByReply)
end
if cerner == 'gbans' then
local list = redis:smembers('GloballBan:'..msg.chat_id)
local t = 'Globall Ban:\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t..'\n\n\n@CerNerCompany'
if #list == 0 then
t = 'Nil\n\n@CerNerCompany'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner == 'ungban' then
function UnGbanByReply(CerNer,Company)
if redis:sismember('GloballBan:'..Company.sender_user_id) then
sendText(msg.chat_id, msg.id,  '`User : ` *'..Company.sender_user_id..'* is *Not* `a Globall Banned..!`\n\n@CerNerCompany', 'md')
else
sendText(msg.chat_id, msg.id,'_ User : _ `'..Company.sender_user_id..'` *is Removed* From `Globall Banned`..\n\n@CerNerCompany', 'md')
redis:srem('GloballBan:'..msg.chat_id, Company.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnGbanByReply)
end
if cerner == 'remowner' then
local function SetOwner_Rep(CerNer, Company)
redis:srem('OwnerList:'..msg.chat_id,Company.sender_user_id)
local user = Company.sender_user_id
sendText(msg.chat_id, msg.id,'User '..Company.sender_user_id..' Has Been Removed from OwnerList\n\n@CerNerCompany', 'md')
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetOwner_Rep)
end
end
end
if is_Owner(msg) then
if cerner == 'modlist' then
local list = redis:smembers('ModList:'..msg.chat_id)
local t = 'ModList\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t..'\n\n\n@CerNerCompany'
if #list == 0 then
t = 'لیست مدیران گروه خالی است\n\n@CerNerCompany'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner and cerner:match('^unmuteuser (%d+)$') then
local mutes =  cerner:match('^unmuteuser (%d+)$')
redis:srem('MuteList:'..msg.chat_id,mutes)
mute(msg.chat_id, mutes,'Restricted',   {0, 0, 0, 0, 0,1})
sendText(msg.chat_id, msg.id,"_Done_ \n*User* `"..mutes.."` *Has Been Unmuted* *\nRestricted*\n\n@CerNerCompany",  'md' )
end
 if cerner == 'promote' then
 function PromoteByReply(CerNer,Company)
 redis:sadd('ModList:'..msg.chat_id,Company.sender_user_id)
 local user = Company.sender_user_id
sendText(msg.chat_id, msg.id, 'User '..user..' Has Been Promoted\n\n@CerNerCompany','md')
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), PromoteByReply)  
end
end
if cerner == 'demote' then
function DemoteByReply(CerNer,Company)
redis:srem('ModList:'..msg.chat_id,Company.sender_user_id)
sendText(msg.chat_id, msg.id, 'User `'..Company.sender_user_id..'`* Has Been Demoted*\n\n@CerNerCompany', 'md')
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DemoteByReply)  
end
end
if cerner and cerner:match('^demote @(.*)') then
local username = cerner:match('^demote @(.*)')
function DemoteByUsername(CerNer,Company)
if Company.id then
print(''..Company.id..'')
redis:srem('ModList:'..msg.chat_id,Company.id)
text = 'User `'..Company.id..'` Has Been Demoted\n\n@CerNerCompany'
else 
text = '*User NotFound*'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,DemoteByUsername)
end
--------------------
if cerner and cerner:match('^promote @(.*)') then
local username = cerner:match('^promote @(.*)')
function PromoteByUsername(CerNer,Company)
if Company.id then
print(''..Company.id..'')
redis:sadd('ModList:'..msg.chat_id,Company.id)
text = 'User `'..Company.id..'` Has Been Promoted\n\n@CerNerCompany'
else 
text = '*User NotFound*'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,PromoteByUsername)
end
----------------------
if cerner and cerner:match('^promote (%d+)') then
local user = cerner:match('promote (%d+)')
redis:sadd('ModList:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, 'User `'..user..'`* Has Been Promoted*\n\n@CerNerCompany', 'md')
end
if cerner == 'pin' then
sendText(msg.chat_id,msg.reply_to_message_id, 'Msg Has Been Pinned' ,'md')
Pin(msg.chat_id,msg.reply_to_message_id, 1)
end
if cerner == 'unpin' then
sendText(msg.chat_id,msg.id, 'Msg Has Been UnPinned' ,'md')
Unpin(msg.chat_id)
end
if cerner and cerner:match('^demote (%d+)') then
local user = cerner:match('demote (%d+)')
redis:srem('ModList:'..msg.chat_id_,user)
sendText(msg.chat_id, msg.id, 'User `'..user..'`* Has Been Demoted*\n\n@CerNerCompany', 'md')
end
if cerner == 'mute all' then
    local function pro(arg,data)
if redis:get("Check:Mutell:"..msg.chat_id) then
text = 'هر 5دقیقه یکبار ممکن است'
end
for k,v in pairs(data.members) do
redis:set('MuteAll:'..msg.chat_id,true)
 mute(msg.chat_id, v.user_id,'Restricted',   {1, 1, 0, 0, 0,0})
   redis:setex("Check:Mutell:"..msg.chat_id,350,true)
end
end
getChannelMembers(msg.chat_id, 0, 100000000000, "Recent",pro)
      sendText(msg.chat_id, msg.id,'All Members Has Been Muted' ,'md')
end
if cerner == 'unmute all' then
    local function pro(arg,data)
if redis:get("Check:UNMutell:"..msg.chat_id) then
text = 'هر 5دقیقه یکبار ممکن است'
end
for k,v in pairs(data.members) do
redis:del('MuteAll:'..msg.chat_id)
 mute(msg.chat_id, v.user_id,'Restricted',    {0, 0, 0, 0, 1,1})
   redis:setex("Check:UNMutell:"..msg.chat_id,350,true)

end
end
getChannelMembers(msg.chat_id, 0, 100000000000, "Recent",pro)
      sendText(msg.chat_id, msg.id,'All Members Has Been UnMuted' ,'md')
end
 
----
end
----
if is_Mod(msg) then
if cerner == 'viplist' then
local list = redis:smembers('Vip:'..msg.chat_id)
local t = 'Vip Users\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t..'\n\n\n@CerNerCompany'
if #list == 0 then
t = 'Nil\n\n@CerNerCompany'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner == 'Banlist' then
local list = redis:smembers('BanUser:'..msg.chat_id)
local t = 'Ban Users\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t..'\n\n\n@CerNerCompany'
if #list == 0 then
t = 'Nil\n\n@CerNerCompany'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
  if cerner == 'clean banlist'  then
local function Clean(CerNer,Company)
for k,v in pairs(Company.members) do
RemoveFromBanList(msg.chat_id, v.user_id) 
end
end
sendText(msg.chat_id, msg.id,  'All User Banned Has Been Cleaned From BanList\n\n@CerNerCompany', 'md')
getChannelMembers(msg.chat_id, 0, 200, "Banned",Clean)
end
if cerner == 'setvip' then
function SetVipByReply(CerNer,Company)
if redis:sismember('Vip:'..msg.chat_id, Company.sender_user_id) then
sendText(msg.chat_id, msg.id,  '`User : ` *'..Company.sender_user_id..'* is *Already* `a VIP member..!`\n\n@CerNerCompany', 'md')
else
sendText(msg.chat_id, msg.id,'_ User : _ `'..Company.sender_user_id..'` *Promoted* to `VIP` member..\n\n@CerNerCompany', 'md')
redis:sadd('Vip:'..msg.chat_id, Company.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetVipByReply)
end
if cerner == 'remvip' then
function RemVipByReply(CerNer,Company)
if redis:sismember('Vip:'..msg.chat_id, Company.sender_user_id) then
sendText(msg.chat_id, msg.id,'_User : _ `'..Company.sender_user_id..'` *Demoted From VIP Member..*\n\n@CerNerCompany', 'md')
redis:srem('Vip:'..msg.chat_id, Company.sender_user_id)
else
sendText(msg.chat_id, msg.id,  '`User : ` *'..Company.sender_user_id..'* `Not VIP Member..!`\n\n@CerNerCompany', 'md')

end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RemVipByReply)
end

if cerner and cerner:match('^muteuser (%d+)$') then
local mutess = cerner:match('^muteuser (%d+)$') 
mute(msg.chat_id, mutess,'Restricted',   {1, 1, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,mutess)
sendText(msg.chat_id, msg.id,"*Done User* `"..mutess.."` *Has Been  Muteed :) \nRestricted*\n\n@CerNerCompany",  'md' )
end
if cerner == 'muteuser' then
function Restricted(CerNer,Company)
mute(msg.chat_id, Company.sender_user_id,'Restricted',   {1, 1, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,Company.sender_user_id)
sendText(msg.chat_id, msg.id,"*Done User* `"..Company.sender_user_id.."` *Has Been  Muteed :) \nRestricted*\n\n@CerNerCompany",  'md' )
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if cerner == 'unmuteuser' then
function Restricted(CerNer,Company)
redis:srem('MuteList:'..msg.chat_id,Company.sender_user_id)
mute(msg.chat_id,Company.sender_user_id,'Restricted',   {0, 0, 0, 0, 0,1})
sendText(msg.chat_id, msg.id,"_Done_ \n*User* `"..Company.sender_user_id.."` *Has Been Unmuted* *\nRestricted*\n\n@CerNerCompany",  'md' )
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if cerner and cerner:match('^unmuteuser (%d+)$') then
local mutes =  cerner:match('^unmuteuser (%d+)$')
redis:srem('MuteList:'..msg.chat_id,mutes)
mute(msg.chat_id, mutes,'Restricted',   {0, 0, 0, 0, 0,1})
sendText(msg.chat_id, msg.id,"_Done_ \n*User* `"..mutes.."` *Has Been Unmuted* *\nRestricted*\n\n@CerNerCompany",  'md' )
end
if cerner == 'ban' and tonumber(msg.reply_to_message_id) > 0 then
function BanByReply(CerNer,Company)
sendText(msg.chat_id, msg.id, 'User `'..Company.sender_user_id..'` *Has Been Banned ..!*', 'md')
redis:sadd('BanList:'..msg.chat_id,Company.sender_user_id)
KickUser(msg.chat_id,Company.sender_user_id)
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),BanByReply)
end
if cerner == 'filterlist' then
local list = redis:smembers('Filters:'..msg.chat_id)
local t = 'Filters \n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t..'\n\n\n@CerNerCompany'
if #list == 0 then
t = 'Nil\n\n@CerNerCompany'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner == 'mutelist' then
local list = redis:smembers('MuteList:'..msg.chat_id)
local t = 'Mute List \n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t..'\n\n\n@CerNerCompany'
if #list == 0 then
t = 'Nil\n\n@CerNerCompany'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner and cerner:match('^unban (%d+)') then
local user_id = cerner:match('^unban (%d+)')
redis:srem('BanUser:'..msg.chat_id,user_id)
RemoveFromBanList(msg.chat_id,user_id)
sendText(msg.chat_id, msg.id, '`'..user_id..'` Removed From BanList..!*', 'md')
end
if cerner and cerner:match('^unban @(.*)') then
local username = cerner:match('^unban @(.*)')
function UnBanByUserName(CerNer,Company)
if Company.id then
redis:srem('BanUser:'..msg.chat_id,Company.id)
RemoveFromBanlist(msg.chat_id,Company.id)
txt=  '@['..check_markdown(username)..'] [`'..Company.id..'`] * Removed From BanList..!*'
else 
txt = 'User Not Found'
sendText(msg.chat_id, msg.id, text,  'md')
end
end
resolve_username(username,UnBanByUserName)
end
if cerner== 'kick' and tonumber(msg.reply_to_message_id) > 0 then
function kick_by_reply(CerNer,Company)
sendText(msg.chat_id, msg.id, 'User `'..Company.sender_user_id..'`* Has Been Kicked*', 'md')
KickUser(msg.chat_id,Company.sender_user_id)
RemoveFromBanlist(msg.chat_id,Company.sender_user_id)

 end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),kick_by_reply)
end
if cerner == 'clean deleted' then 
    function CleanDeleted(CerNer, Company) 
    for k, v in pairs(Company.members) do 
local function CerNer(CerNer,Company)
if not data.first_name then
if tonumber(user) == tonumber(TD_ID)  then
   return true
    else
KickUser(msg.chat_id,Company.id)
end
end
GetUser(v.user_id,CerNer, nil)
 end 
end
sendText(msg.chat_id, msg.id,'Done\nAll Deleted User Has Been Kicked', 'md') 
end 
getChannelMembers(msg.chat_id, 0, 200, "Recent",CleanDeleted)
end 

if cerner and cerner:match('^kick (%d+)') then
local user_id = cerner:match('^kick (%d+)')
KickUser(msg.chat_id,user_id)
sendText(msg.chat_id, msg.id, 'User `'..user_id..'`* Has Been Kicked*', 'md')
RemoveFromBanlist(msg.chat_id,user_id)
end
if cerner and cerner:match('^setflood (%d+)') then
local num = cerner:match('^setflood (%d+)')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, '`Select a number greater than` *2*','md')
else
redis:set('Flood:Max:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '`Flood Sensitivity change to` *'..num..'*', 'md')
end
end
if cerner and cerner:match('^setfloodtime (%d+)') then
local num = cerner:match('^setfloodtime (%d+)')
if tonumber(num) < 1 then
sendText(msg.chat_id, msg.id, '`Select a number greater than` *1*','md')
else
redis:set('Flood:Time:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '`Flood time change to` *'..num..'*', 'md')
end
end
if cerner and cerner:match('^rmsg (%d+)$') then
local limit = tonumber(cerner:match('^rmsg (%d+)$'))
if limit > 100 then
sendText(msg.chat_id, msg.id, '*عددی بین * [`1-100`] را انتخاب کنید', 'md')
else
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
end
end
getChatHistory(msg.chat_id,msg.id, 0,  limit,cb)
sendText(msg.chat_id, msg.id, limit..'Has Been Deleted', 'md')
end
end
if cerner == 'settings' then
local function GetName(CerNer, Company)
local chat = msg.chat_id
if redis:get('Welcome:'..msg.chat_id) == 'enable' then
welcome = 'Enable'
else
welcome = 'Disable'
end
if redis:get('Lock:Edit'..chat) then
edit = 'Enable'
else
edit = 'Disable'
end
if redis:get('Lock:Link'..chat) then
Link = 'Enable'
else
Link = 'Disable' 
end
if redis:get('Lock:Tag:'..chat) then
tag = 'Enable'
else
tag = 'Disable' 
end
if redis:get('Lock:HashTag:'..chat) then
hashtag = 'Enable'
else
hashtag = 'Disable' 
end
if redis:get('Lock:Video_note:'..chat) then
video_note = 'Enable'
else
video_note = 'Disable' 
end
if redis:get('Lock:Inline:'..chat) then
inline = 'Enable'
else
inline = 'Disable' 
end
if redis:get('Lock:Pin:'..chat) then
pin = 'Enable'
else
pin = 'Disable' 
end
if redis:get('Lock:Forward:'..chat) then
fwd = 'Enable'
else
fwd = 'Disable' 
end
if redis:get('Lock:Arabic:'..chat) then
arabic = 'Enable'
else
arabic = 'Disable' 
end
if redis:get('Lock:English:'..chat) then
en = 'Enable'
else
en = 'Disable' 
end
if redis:get('Lock:TGservise:'..chat) then
tg = 'Enable'
else
tg = 'Disable' 
end
if redis:get('Lock:Sticker:'..chat) then
sticker = 'Enable'
else
sticker = 'Disable' 
end
if redis:get('CheckBot:'..msg.chat_id) then
TD = 'Enable'
else
TD = 'Disable'
end
-------------------------------------------
---------Mute Settings----------------------
if redis:get('Mute:Text:'..msg.chat_id) then
txt = 'Enable'
else
txt = 'Disable'
end
if redis:get('Mute:Contact:'..msg.chat_id) then
contact = 'Enable'
else
contact = 'Disable'
end
if redis:get('Mute:Document:'..msg.chat_id) then
document = 'Enable'
else
document = 'Disable'
end
if redis:get('Mute:Location:'..msg.chat_id) then
location = 'Enable'
else
location = 'Disable'
end
if redis:get('Mute:Voice:'..msg.chat_id) then
voice = 'Enable'
else
voice = 'Disable'
end
if redis:get('Mute:Photo:'..msg.chat_id) then
photo = 'Enable'
else
photo = 'Disable'
end
if redis:get('Mute:Game:'..msg.chat_id) then
game = 'Enable'
else
game = 'Disable'
end
if redis:get('MuteAll:'..chat) then
muteall = 'Enable'
else
muteall = 'Disable' 
end
if redis:get('Lock:Flood:'..msg.chat_id) then
flood = 'Enable'
else
flood = 'Disable'
end
if redis:get('Mute:Video:'..msg.chat_id) then
video = 'Enable'
else
video = 'Disable'
end
if redis:get('Mute:Music:'..msg.chat_id) then
music = 'Enable'
else
music = 'Disable'
end
if redis:get('Mute:Gif:'..msg.chat_id) then
gif = 'Enable'
else
gif = 'Disable'
end
local expire = redis:ttl("ExpireData:"..msg.chat_id)
if expire == -1 then
EXPIRE = "نامحدود"
else
local d = math.floor(expire / day ) + 1
EXPIRE = d.."  Day"
end
------------------------More Settings-------------------------
local Text = '`CerNer Company `\n\n*TD Bot* : `'..TD..'`\n\n*Settings For* `'..Company.title..'`\n\n*Links *:` '..Link..'`\n*Edit* : `'..edit..'`\n*Tag :* `'..tag..'`\n*HashTag : *`'..hashtag..'`\n*Inline : *`'..inline..'`\n*Video Note :* `'..video_note..'`\n*Pin :* `'..pin..'`\n*Forward :* `'..fwd..'`\n*Arabic : *`'..arabic..'`\n*English :* `'..en..'`\n*Tgservise :* `'..tg..'`\n*Sticker : *`'..sticker..'`\n\n_Mute Settings_ \n\n*Photo :* `'..photo..'`\n*Music : *`'..music..'`\n*Voice : *`'..voice..'`\n*Docoment :*`'..document..'`\n*Video : *`'..video..'`\n*Game :*`'..game..'`\n*Location : *`'..location..'`\n*Contact : *`'..contact..'`\n*Text :*`'..txt..'`\n*All* : `'..muteall..'`\n\n_More Locks_\n\n*Flood :* `'..flood..'`\n*Max Flood :* `'..NUM_MSG_MAX..'`\n*Flood Time :* `'..TIME_CHECK..'`\n*Expire :* `'..EXPIRE..'`\n*Welcome :* `'..welcome..'`\n\nChannel : @CerNerCompany'
sendText(msg.chat_id, msg.id, Text, 'md')
end
GetChat(msg.chat_id,GetName)
end
---------------------Welcome----------------------
if cerner == 'welcome enable' then
if redis:get('Welcome:'..msg.chat_id) == 'enable' then
sendText(msg.chat_id, msg.id,'*Welcome* is _Already_ Enable\n\n@CerNerCompany' ,'md')
else
sendText(msg.chat_id, msg.id,'*Welcome* Has Been Enable\n\n@CerNerCompany' ,'md')
redis:del('Welcome:'..msg.chat_id,'disable')
redis:set('Welcome:'..msg.chat_id,'enable')

end
end
if cerner == 'welcome disable' then
if redis:get('Welcome:'..msg.chat_id) then
sendText(msg.chat_id, msg.id,'*Welcome* Has Been Disable\n\n@CerNerCompany' ,'md')
redis:set('Welcome:'..msg.chat_id,'disable')
redis:del('Welcome:'..msg.chat_id,'enable')
else
sendText(msg.chat_id, msg.id,'*Welcome* is _Already_ Disable\n\n@CerNerCompany' ,'md')
end
end
---------------------------------------------------------
-----------------------------------------------Locks------------------------------------------------------------
-----------------Lock Link--------------------
if cerner == 'lock link' then
if redis:get('Lock:Link'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Link*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Link* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Link'..msg.chat_id,true)
end
end
if cerner == 'unlock link' then
if redis:get('Lock:Link'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Link* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Link'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Link*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------
if cerner == 'lock tag' then
if redis:get('Lock:Tag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Tag*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Tag* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Tag:'..msg.chat_id,true)
end
end
if cerner == 'unlock tag' then
if redis:get('Lock:Tag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Tag* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Tag:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Tag*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
--------------------------------------------
if cerner == 'lock hashtag' then
if redis:get('Lock:HashTag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *HadshTag*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else 
sendText(msg.chat_id, msg.id, '`Lock` *HashTag* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:HashTag:'..msg.chat_id,true)
end
end
if cerner == 'unlock hashtag' then
if redis:get('Lock:HashTag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *HashTag* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:HashTag:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *HashTag*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
-----------------------------------------------
if cerner == 'lock video_note' then
if redis:get('Lock:Video_note:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Video note*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Video note* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Video_note:'..msg.chat_id,true)
end
end
if cerner == 'unlock vide_onote' then
if redis:get('Lock:Video_note:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Video note* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Video_note:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Video note*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
-------------------------------------------------
if cerner == 'lock inline' then
if redis:get('Lock:Inline:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Inline*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Inline* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Inline:'..msg.chat_id,true)
end
end
if cerner == 'unlock inline' then
if redis:get('Lock:Inline:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Inline* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Inline:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Inline*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
-----------------------------------------------
if cerner == 'lock pin' then
if redis:get('Lock:Pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Pin*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Pin* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Pin:'..msg.chat_id,true)
end
end
if cerner == 'unlock pin' then
if redis:get('Lock:pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Pin* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Pin:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Pin*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end-----------------------------------------------
if cerner == 'lock flood' then
if redis:get('Lock:Flood:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Flood*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Flood* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Flood:'..msg.chat_id,true)
end
end
if cerner == 'unlock flood' then
if redis:get('Lock:Flood:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Flood* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Flood:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Flood*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
----------------------------------------------
if cerner == 'lock forward' then
if redis:get('Lock:Forward:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Forward*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Forward* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Forward:'..msg.chat_id,true)
end
end
if cerner == 'unlock forward' then
if redis:get('Lock:Forward:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Forward* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Forward:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Forward*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
------------------------------------------------
if cerner == 'lock arabic' then
if redis:get('Lock:Arabic:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Arabic*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Arabic* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Arabic:'..msg.chat_id,true)
end
end
if cerner == 'unlock arabic' then
if redis:get('Lock:Arabic:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Arabic* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Arabic:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Forward*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
--------------------------------------------
if cerner == 'lock edit' then
if redis:get('Lock:Edit'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Edit*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Edit* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Edit'..msg.chat_id,true)
end
end
if cerner == 'unlock edit' then
if redis:get('Lock:Edit'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Edit* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Edit'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Edit*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
-----------------------------------------------
if cerner == 'lock english' then
if redis:get('Lock:English:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *English*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *English* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:English:'..msg.chat_id,true)
end
end
if cerner == 'unlock english' then
if redis:get('Lock:English:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *English* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:English:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Forward*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
--------------------------------------------
if cerner == 'lock tgservise' then
if redis:get('Lock:TGservise:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *TGservise*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *TGservise* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:TGservise:'..msg.chat_id,true)
end
end
if cerner == 'unlock tgservise' then
if redis:get('Lock:TGservise:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *TGservise* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:TGservise:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Forward*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
-------------------------------------------
if cerner == 'lock sticker' then
if redis:get('Lock:Sticker:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Sticker*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Sticker* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Sticker:'..msg.chat_id,true)
end
end
if cerner == 'unlock sticker' then
if redis:get('Lock:Sticker:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Sticker* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Lock:Sticker:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Lock` *Forward*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
--------------------------------------------
-------------------------Mutes-----------------------------------------
if cerner == 'mute text' then
if redis:get('Mute:Text:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Text*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Text* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Text:'..msg.chat_id,true)
end
end
if cerner == 'unmute text' then
if redis:get('Mute:Text:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Text* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Text:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Text*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------------------------------------------
if cerner == 'mute contact' then
if redis:get('Mute:Contact:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Contact*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Mute` *Contact* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Contact:'..msg.chat_id,true)
end
end
if cerner == 'unmute contact' then
if redis:get('Mute:Contact:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Contact* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Contact:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Contact*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------------------------------------------
if cerner == 'mute document' then
if redis:get('Mute:Document:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Document*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Mute` *Document* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Document:'..msg.chat_id,true)
end
end
if cerner == 'unmute document' then
if redis:get('Mute:Document:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Document* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Document:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Document*  is _Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------------------------------------------
if cerner == 'mute location' then
if redis:get('Mute:Location:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Location*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Mute` *Location* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Location:'..msg.chat_id,true)
end
end
if cerner == 'unmute location' then
if redis:get('Mute:Location:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Location* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Location:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Location*  _is Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------------------------------------------
if cerner == 'mute voice' then
if redis:get('Mute:Voice:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Voice*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Mute` *Voice* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Voice:'..msg.chat_id,true)
end
end
if cerner == 'unmute voice' then
if redis:get('Mute:Voice:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Voice* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Voice:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Voice*  _is Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------------------------------------------
if cerner == 'mute photo' then
if redis:get('Mute:Photo:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Photo*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Mute` *Photo* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Photo:'..msg.chat_id,true)
end
end
if cerner == 'unmute photo' then
if redis:get('Mute:Photo:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Photo* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Photo:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Photo*  _is Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------------------------------------------
if cerner == 'mute game' then
if redis:get('Mute:Game:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Game*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Mute` *Game* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Game:'..msg.chat_id,true)
end
end
if cerner == 'unmute game' then
if redis:get('Mute:Game:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Game* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Game:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Game*  _is Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------------------------------------------
if cerner == 'mute video' then
if redis:get('Mute:Video:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Video*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Mute` *Video* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Video:'..msg.chat_id,true)
end
end
if cerner == 'unmute video' then
if redis:get('Mute:Video:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Video* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Video:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Video*  _is Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------------------------------------------
if cerner == 'mute music' then
if redis:get('Mute:Music:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Music*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Mute` *Music* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Music:'..msg.chat_id,true)
end
end
if cerner == 'unmute music' then
if redis:get('Mute:Music:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Music* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Music:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Music*  _is Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
---------------------------------------------------------------------------------
if cerner == 'mute gif' then
if redis:get('Mute:Gif:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Gif*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Mute` *Gif* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Mute:Gif:'..msg.chat_id,true)
end
end
if cerner == 'unmute gif' then
if redis:get('Mute:Gif:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Mute` *Gif* `Has Been Disable`\n\n@CerNerCompany' , 'md')
redis:del('Mute:Gif:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '`Mute` *Gif*  _is Already_  `Disable`\n\n@CerNerCompany' , 'md')
end
end
-----------End Mutes---------------
----------------------------------------------------------------------------------
if cerner1 and cerner1:match('^[Ss]etlink (.*)') then
local link = cerner1:match('^[Ss]etlink (.*)')
redis:set('Link:'..msg.chat_id,link)
sendText(msg.chat_id, msg.id,'*New Link Has Been Seted*\n\n@CerNerCompany', 'md')
end
if cerner == 'link' then
local link = redis:get('Link:'..msg.chat_id) 
if link then
sendText(msg.chat_id,msg.id,  '*Group Link:*\n'..link..'\n\n@CerNerCompany', 'md')
else
sendText(msg.chat_id, msg.id, '*Link Not Set*\n\n@CerNerCompany', 'md')
end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------
if cerner and cerner:match('^filter +(.*)') then
local word = cerner:match('^filter +(.*)')
redis:sadd('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id, '`'..word..'` *Added To BadWord List!*', 'md')
end
if cerner and cerner:match('^remfilter +(.*)') then
local word = cerner:match('^remfilter +(.*)')
redis:srem('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id,'`'..word..'` *Removed From BadWord List!*', 'md')
end
------
end
------
if redis:get('CheckBot:'..msg.chat_id) then
if cerner and cerner:match('^id @(.*)') then
local username = cerner:match('^id @(.*)')
 function IdByUserName(CerNer,Company)
if Company.id then
text = 'CerNer Company\n\nUser ID : ['..Company.id..']\n\n@CerNerCompany'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,IdByUserName)
 end
if cerner == 'id' then
function GetID(CerNer, Company)
local text = 'CerNer Company\n\nUser ID : ['..Company.sender_user_id..']\n\n@CerNerCompany'
sendText(msg.chat_id, msg.id, text, 'md')
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GetID)
end
end
if cerner == 'id' then 
local function GetName(CerNer, Company)
if tonumber(msg.reply_to_message_id) == 0  then 
Msgs = redis:get('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
if is_sudo(msg) then
rank = 'Sudo' 
elseif is_Owner(msg) then
rank = 'Owner' 
elseif is_Mod(msg) then
rank = 'Admin' 
elseif not is_Mod(msg) then
rank = ''..(redis:get('rank'..msg.sender_user_id) or "Member")..''
end
sendText(msg.chat_id, msg.id,  '`CerNer Company`!!\n\nChat Name : ['..Company.title..']\n\nChat ID : ['..msg.chat_id..']\n\nUser ID : ['..msg.sender_user_id..']\n\nRank : ['..rank..']\n\nTotal Msgs : '..Msgs..'\n\nTD ID : '..TD_ID..'\n\n@CerNerCompany', 'md')
end
end
GetChat(msg.chat_id,GetName)
end
if cerner == 'me' then
local function GetName(CerNer, Company)
if is_sudo(msg) then
rank = 'Sudo' 
elseif is_Owner(msg) then
rank = 'Owner' 
elseif is_Mod(msg) then
rank = 'Admin' 
elseif not is_Mod(msg) then
rank = ''..(redis:get('rank'..msg.sender_user_id) or "Member")..''
end
if Company.first_name then
CompanyName = check_markdown(Company.first_name)
else  
CompanyName = '\n\n@CerNerCompany'
end
if Company.username then
CompanyUserName = '@'..check_markdown(Company.username)
else 
CompanyUserName = 'nil\n@CerNerCompany'
end
Msgs = redis:get('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
sendText(msg.chat_id, msg.id,  '`CerNer Company`!!\n\nYour Name : ['..CompanyName..']\n\nUserName : ['..CompanyUserName..']\n\nUser ID : ['..msg.sender_user_id..']\n\nRank : ['..rank..']\n\nTotal Msgs : ['..Msgs..']\n\n@CerNerCompany', 'md')
end
GetUser(msg.sender_user_id,GetName)
end
if cerner == 'about me' then
function GetName(extra, result, success) 
if result.about then
CompanyName = result.about
else  
CompanyName = 'nil\n\n@CerNerCompany'
end
if result.common_chat_count  then
Companycommon_chat_count  = result.common_chat_count 
else 
Companycommon_chat_count  = 'nil\n\n@CerNerCompany'
end
if result.has_private_calls  then
Companyhas_private_calls  = result.has_private_calls
else 
Companyhas_private_calls  = 'nil\n\n@CerNerCompany'
end
if result.is_blocked   then
Companyis_blocked  = result.is_blocked 
else 
Companyis_blocked  = 'nil\n\n@CerNerCompany'
end
sendText(msg.chat_id, msg.id,  '`CerNer Company`!!\n\nBio : ['..CompanyName..']\n\nCommon chat count : ['..Companycommon_chat_count..']\n\n@CerNerCompany', 'md')
end
GetUserFull(msg.sender_user_id,GetName)
end
-------------------------------
end
if cerner == 'ping' then
txt = [[PONG

@CerNerCompany]]
sendText(msg.chat_id, msg.id, txt, 'md')
end
if cerner == 'help' then
if is_sudo(msg) then
text =[[Soon..!]]
elseif is_Owner(msg) then
text =[[Soon..!]]
elseif is_Mod(msg) then
text =[[Soon..!]]
elseif not is_Mod(msg) then
text =[[شما میتوانید از 

id

me

about me

استفاده کنید]]
end
sendText(msg.chat_id, msg.id, text, 'md')
end
end


------CerNer Company---------.
if cerner  then
if not redis:get('BOT-ID') then
local function cb(a,b,c)
redis:set('BOT-ID',b.id)
end
getMe(cb)
end
end
if msg.sender_user_id == TD_ID then
redis:incr("Botmsg")
end
redis:incr("allmsgs")
if msg.chat_id then
      local id = tostring(msg.chat_id)
      if id:match('-100(%d+)') then
        if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
          redis:sadd("ChatSuper:Bot",msg.chat_id)
        end
----------------------------------
elseif id:match('^-(%d+)') then
if not  redis:sismember("Chat:Normal",msg.chat_id) then
redis:sadd("Chat:Normal",msg.chat_id)
end
-----------------------------------------
elseif id:match('') then
if not redis:sismember("ChatPrivite",msg.chat_id) then;redis:sadd("ChatPrivite",msg.chat_id);end;else
if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
redis:sadd("ChatSuper:Bot",msg.chat_id);end;end;end;end;end;function tdbot_update_callback(data);if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then;showedit(data.message,data);vardump(data);elseif (data._== "updateMessageEdited") then;vardump(data);data = data;local function edit(sepehr,amir,hassan);showedit(amir,data);end ;tdbot_function ({_ = "openChat",chat_id = data.chat_id}, dl_cb, nil) tdbot_function ({_ = "getMessage", chat_id = data.chat_id,message_id = data.message_id }, edit, nil)assert (tdbot_function ({ _ = 'openMessageContent',chat_id = data.chat_id,message_id = data.message_id}, dl_cb, nil));tdbot_function ({_="getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=20}, dl_cb, nil)
end
end
---End Version 3

#start Project Anti Spam V1:)
json = dofile('./libs/JSON.lua')
serpent = dofile("./libs/serpent.lua")
local lgi = require ('lgi')
local notify = lgi.require('Notify')
notify.init ("Telegram updates")
Redis =  require ('redis')
redis = Redis.connect('127.0.0.1', 6379)
SUDO_ID = {363936960}
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
function is_GlloballBan(user_id)
  local var = false
  local hash = 'GloballBan'
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
function is_Bannd(chat_id,user_id)
   local hash =  redis:sismember('BanUser'..chat_id,user_id)
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
   local hash =  db:sismember('mutes'..chat_id,user_id)
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
local function getMe(cb)
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
function mute(chatid, userid, rank, right)
  local chat_member_status = {}
 if rank == 'Restricted' then
    chat_member_status = {
     is_member = right[1] or 1,
      restricted_until_date = right[2] or 0,
      can_send_messages = right[3] or 1,
      can_send_media_messages = right[4] or 1,
      can_send_other_messages = right[5] or 1,
      can_add_web_page_previews = right[6] or 1
         }

  chat_member_status._ = 'chatMemberStatus' .. rank

  assert (tdbot_function ({
    _ = 'changeChatMemberStatus',
    chat_id = chatid,
    user_id = userid,
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
  }, dl_cb, nil))
end

function getChannelMembers(channelid, off, limit, mbrfilter,cb)
if not limit or limit > 200 then
    limit = 200
  end  assert (tdbot_function ({
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
 NUM_MSG_MAX = 6
    if redis:get('FloodMax'..msg.chat_id) then
      NUM_MSG_MAX = redis:get('FloodMax'..msg.chat_id)
      end
    NUM_CH_MAX = 2000
    if redis:get('NUM_CH_MAX:'..msg.chat_id) then
      NUM_CH_MAX = redis:get('NUM_CH_MAX:'..msg.chat_id)
      end
      TIME_CHECK = 2
    if redis:get('FloodTime:'..msg.chat_id) then
      TIME_CHECK = redis:get('FloodTime:'..msg.chat_id)
      end
-------------Flood Check------------
    if redis:get('Flood:Seetings:'..msg.chat_id) then
    if not is_Mod(msg) then
      local post_count = 'user:' .. msg.sender_user_id .. ':floodc'
      local msgs = tonumber(redis:get(post_count) or 0)
      if msgs > tonumber(NUM_MSG_MAX) then
       local type = redis:get('flood:Type'..msg.chat_id)
    KickUser(msg.chat_id,msg.sender_user_id )
      end
      redis:setex(post_count, tonumber(TIME_CHECK), msgs+1)
    end
     end
-------------MSG CerNer ------------
local cerner = msg.content.text
		 if MsgType == 'text' and cerner then
      if cerner:match('^[/]') then
      cerner= cerner:gsub('^[/]','')
      end
    end
------------------------------------
--------------MSG TYPE----------------
 if msg.content._== "messageText" then
         print("This is [ TEXT ]")
      MsgType = 'text'
    end
 if msg.content._ == "messageChatAddMembers" then
print(serpent.block(data))

       MsgType = 'AddMembers'
    end
    if msg.content == "MessageChatJoinByLink" then
       MsgType = 'JoinByLink'
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
  if msg.content._ == "messageEntityTextUrl" then
 print("This is [ URL]")
         MsgType = 'Url'
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
    
      -------------------------
      if msg.content._ == "messageContact" then
        print("This is [ Contact ]")
         MsgType = 'Contact'
      end
      
 if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
        print("This is [ MarkDown ]")
         MsgType = 'Markreed'
      end
    if msg.content._ == "messagePhoto" then
      MsgType = 'Photo'
end

viewMessages(msg.chat_id, {[0] = msg.id})
redis:incr('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
if msg.send_state._ == "messageIsSuccessfullySent" then
return false 
end   
if not redis:sismember('AllGroup',msg.chat_id) then
redis:sadd('AllGroup',msg.chat_id)
end  
----------Msg Checks-------------
if not is_Mod(msg) and not is_Vip(msg)  then
if redis:get('CheckBot:'..msg.chat_id)  then
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
----------Filter------------
 if is_filter(msg,text) then
 deleteMessages(msg.chat_id, {[0] = msg.id})
 end 
------------------------------------------------
----------Lock Edit-------------
if redis:get('Lock:Edit'..chat) then
if msg.edit_date > 0 then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
--------------Mute All------------
 if redis:get('MuteAll:'..msg.chat_id) then
print 'Mute All'
if user then
deleteMessages(msg.chat_id, {[0] = msg.id})
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
      if cerner== 'add' then
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
sendText(msg.chat_id, msg.id, text,0)
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

if cerner and cerner:match('^Charge (%d+)$') then
local function GetName(CerNer, Company)
local time = tonumber(cerner:match('^Charge (%d+)$')) * day
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
if cerner and cerner:match('^muteuser (%d+)$') then
local mutess = cerner:match('^muteuser (%d+)$') 
mute(msg.chat_id, mutess,'Restricted',   {1, 1, 0, 0, 0,0})
       sendText(msg.chat_id, msg.id,"*Done User* `"..mutess.."` *Has Been  Muteed :) \nRestricted*\n\n@CerNerCompany",  'md' )
end
if cerner == 'modlist' then
local list = redis:smembers('ModList:'..msg.chat_id)
local t = 'ModList\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t..'\n\n\n@CerNerCompany'
if #list == 0 then
t = 'لیست مدیران گروه خال است\n\n@CerNerCompany'
end
      sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner and cerner:match('^unmuteuser (%d+)$') then
local mutes =  cerner:match('^unmuteuser (%d+)$')
mute(msg.chat_id, mutes,'Restricted',   {0, 0, 1, 1, 1,0})
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
if cerner and cerner:match('^demote (%d+)') then
local user = cerner:match('demote (%d+)')
redis:srem('ModList:'..msg.chat_id_,user)
sendText(msg.chat_id, msg.id, 'User `'..user..'`* Has Been Demoted*\n\n@CerNerCompany', 'md')
end
if cerner == 'mute all' then
redis:set('MuteAll:'..msg.chat_id,true)
sendText(msg.chat_id, msg.id,  'Mute All Has Been Enabled\n\n@CerNerCompany', 'md')
end
if cerner == 'unmute all' then
redis:del('MuteAll:'..msg.chat_id)
sendText(msg.chat_id, msg.id, 'Mute All Has Been Disabled\n\n@CerNerCompany', 'md')
end
 
----
end
----
if is_Mod(msg) then
if cerner == 'kick' and tonumber(msg.reply_to_message_id) > 0 then
function kick_by_reply(CerNer,Company)
sendText(msg.chat_id, msg.id, 'User `'..Company.sender_user_id..'`* Has Been Kicked*', 'md')
KickUser(msg.chat_id,Company.sender_user_id)
 end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),kick_by_reply)
end
if cerner == 'settings' then
local function GetName(CerNer, Company)

local chat = msg.chat_id
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
if redis:get('MuteAll:'..chat) then
muteall = 'Enable'
else
muteall = 'Disable' 
end
if redis:get('CheckBot:'..msg.chat_id) then
TD = 'Enable'
else
TD = 'Disable'
end
local Text = '`CerNer Company `\n\n*TD Bot* : `'..TD..'`\n\n*Settings For* `'..Company.title..'`\n\n*Links *:` '..Link..'`\n*Edit* : `'..edit..'`\n\n_Mute Settings_ \n\n*Mute All* : `'..muteall..'`\n\nChannel : @CerNerCompany'
sendText(msg.chat_id, msg.id, Text, 'md')
end
GetChat(msg.chat_id,GetName)
end
if cerner == 'lock link' then
if redis:get('Lock:Link'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Link*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Link* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Link'..msg.chat_id,true)
end
end
if cerner == 'lock edit' then
if redis:get('Lock:Edit'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '`Lock` *Edit*  is _Already_ `Enable`\n\n@CerNerCompany' , 'md')
else
sendText(msg.chat_id, msg.id, '`Lock` *Edit* `Has Been Enable`\n\n@CerNerCompany' , 'md')
redis:set('Lock:Edit'..msg.chat_id,true)
end
end
if cerner and cerner:match('^setlink (.*)') then
local link = cerner:match('^setlink (.*)')
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

-----
end
----
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
              rank = ''..redis:get('rank'..msg.sender_user_id) or Member..''
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
              rank = ''..redis:get('rank'..msg.sender_user_id) or Member..''

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
-------------------------------
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
redis:sadd("ChatSuper:Bot",msg.chat_id);end;end;end;end;end;function tdbot_update_callback(data);if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then;showedit(data.message,data);vardump(data);elseif (data._== "updateMessageEdited") then;vardump(data);data = data;local function edit(extra,result,success);showedit(result,data);end ;tdbot_function ({_ = "openChat",chat_id = data.chat_id}, dl_cb, nil) tdbot_function ({_ = "getMessage", chat_id = data.chat_id,message_id = data.message_id }, edit, nil)assert (tdbot_function ({ _ = 'openMessageContent',chat_id = data.chat_id,message_id = data.message_id}, dl_cb, nil));tdbot_function ({_="getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=20}, dl_cb, nil)
end
end
---End Version 1.3

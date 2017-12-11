#start Project Anti Spam V5:)
json = dofile('./libs/JSON.lua')
serpent = dofile("./libs/serpent.lua")
redis =  dofile("./libs/redis.lua")
minute = 60
hour = 3600
day = 86400
week = 604800
local color = {
  black = {30, 40},
  red = {31, 41},
  green = {32, 42},
  yellow = {33, 43},
  blue = {34, 44},
  magenta = {35, 45},
  cyan = {36, 46},
  white = {37, 47}
}
SendApi = 'Token !'
TD_ID = redis:get('BOT-ID')
http = require "socket.http"
utf8 = dofile('./bot/utf8.lua')
json = dofile('./libs/JSON.lua')
djson = dofile('./libs/dkjson.lua')
http = require("socket.http")
https = require("ssl.https")
URL = require("socket.url")
https = require "ssl.https"
CerNerCompany = '`اختصاصی  کمپانی کرنر `'
SUDO_ID = {363936960}
Full_Sudo = {363936960}
ChannelLogs = -13
BotHelper = 90
Channel = '@CerNerCompany'
MsgTime = os.time() - 60
Plan1 = 2592000
Plan2 = 7776000
function UpTime()
  local uptime = io.popen("uptime"):read("*all")
  days = uptime:match("up %d+ days")
  hours = uptime:match(",  %d+:")
  minutes = uptime:match(":%d+,")
    sec = uptime:match(":%d+ up")
  if hours then
    hours = hours
  else
    hours = ""
  end
  if days then
    days = days
  else
    days = ""
  end
  if minutes then
    minutes = minutes
  else
    minutes = ""
  end
  days = days:gsub("up", "")
  local a_ = string.match(days, "%d+")
  local b_ = string.match(hours, "%d+")
  local c_ = string.match(minutes, "%d+")
   local d_ = string.match(sec, "%d+")
  if a_ then
    a = a_
  else
    a = 0
  end
  if b_ then
    b = b_
  else
    b = 0
  end
  if c_ then
    c = c_
  else
    c = 0
  end
    if d_ then
    d = d_
  else
    d = 0
  end
return a..'روز و '..b..' ساعت و '..c..' دقیقه و '..d..' ثانیه'
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
function is_Fullsudo(msg)
local var = false
for v,user in pairs(Full_Sudo) do
if user == msg.sender_user_id then
var = true
end
end
return var 
end
function is_GlobalyBan(user_id)
local var = false
local hash = 'GlobalyBanned:'
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
local Mod = redis:sismember('ModList:'..chat_id,user_id)
local Vip = redis:sismember('Vip:'..chat_id,user_id)
local Owner = redis:sismember('OwnerList:'..chat_id,user_id)
if tonumber(user_id) == tonumber(TD_ID) or Owner or Mod or Vip then
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
function ec_name(name) 
cerner = name
if cerner then
if cerner:match('_') then
cerner = cerner:gsub('_','')
end
if cerner:match('*') then
cerner = cerner:gsub('*','')
end
if cerner:match('`') then
cerner = cerner:gsub('`','')
end
return cerner
end
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
function sendText(chat_id,msg,text, parse)
assert( tdbot_function ({
_ = "sendMessage",chat_id = chat_id,
reply_to_message_id = msg,
disable_notification = 0,
from_background = 1,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",text = text,
disable_web_page_preview = 1,
clear_draft = 0,
parse_mode = getParse(parse),
entities = {}
}
}, dl_cb, nil))
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
function getFile(fileid,cb)
assert (tdbot_function ({
_ = 'getFile',
file_id = fileid
}, cb, nil))
end
function Call(userid)
  assert (tdbot_function ({
    _ = 'createCall',
    user_id = userid,
  }, dl_cb, nil))
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
function changeDes(CerNer,Company)
assert (tdbot_function ({
_ = 'changeChannelDescription',
channel_id = getChatId(CerNer).id,
description = Company
}, dl_cb, nil))
end
function changeChatTitle(chat_id, title)
assert (tdbot_function ({
_ = "changeChatTitle",
chat_id = chat_id,
title = title
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
tdbot_function ({
_ = "searchPublicChat",
username = username
}, cb, nil)
end
function RemoveFromBanList(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatus" .."Left"
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
function sendInline(chatid, replytomessageid, disablenotification, frombackground, queryid, resultid)
assert (tdbot_function ({
_ = 'sendInlineQueryResultMessage',
chat_id = chatid,
reply_to_message_id = replytomessageid,
disable_notification = disablenotification,
from_background = frombackground,
query_id = queryid,
result_id = tostring(resultid)
}, dl_cb,nil))
end
function get(bot_user_id, chat_id, latitude, longitude, query,offset, cb)
  assert (tdbot_function ({
_ = 'getInlineQueryResults',
 bot_user_id = bot_user_id,
chat_id = chat_id,
user_location = {
 _ = 'location',
latitude = latitude,
longitude = longitude 
},
query = tostring(query),
offset = tostring(off)
}, cb, nil))
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
local function getVector(str)
  local v = {}
  local i = 1
  for k in string.gmatch(str, '(%d%d%d+)') do
    v[i] = '[' .. i-1 .. ']="' .. k .. '"'
    i = i+1
  end
  v = table.concat(v, ',')
  return load('return {' .. v .. '}')()
end
function addChatMembers(chatid, userids)
  assert (tdbot_function ({
    _ = 'addChatMembers',
    chat_id = chatid,
    user_ids = getVector(userids),
}, dl_cb, nil))
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
function SendMetin(chat_id, user_id, msg_id, text, offset, length)
assert (tdbot_function ({
_ = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = 0,
from_background = true,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",
text = text,
disable_web_page_preview = 1,
clear_draft = false,
entities = {[0] = {
offset = offset,
length = length,
_ = "textEntity",
type = {
user_id = user_id,
 _ = "textEntityTypeMentionName"}
}
}
}
}, dl_cb, nil))
end
local function edit(chat_id, message_id, text,length,user_id)
tdbot_function ({
_ = "editMessageText",
chat_id = chat_id,
message_id = message_id,
reply_markup= 0, -- reply_markup:ReplyMarkup
input_message_content = {
_= "inputMessageText",
text = text,
disable_web_page_preview = 1,
clear_draft = 0,
entities = {[0] = {
offset = 0,
length = length,
_ = "textEntity",
type = {
user_id = user_id,
 _ = "textEntityTypeMentionName"}
}
}
}
}, dl_cb, nil)
end
function changeChatPhoto(chat_id,photo)
assert (tdbot_function ({
_ = 'changeChatPhoto',
chat_id = chat_id,
photo = getInputFile(photo)
}, dl_cb, nil))
end
function getFile(fileid)
assert (tdbot_function ({
_ = 'getFile',
file_id = fileid
},dl_cb,nil))
end
function GetWeb(messagetext,cb)
assert (tdbot_function ({
_ = 'getWebPagePreview',
message_text = tostring(messagetext)
}, cb, nil))
end
function downloadFile(fileid)
assert (tdbot_function ({
_ = 'downloadFile',
file_id = fileid,
},  dl_cb, nil))
end
local function sendMessage(c, e, r, n, e, r, callback, data)
assert (tdbot_function ({
_ = 'sendMessage',
chat_id = c,
reply_to_message_id =e,
disable_notification = r or 0,
from_background = n or 1,
reply_markup = e,
input_message_content = r
}, callback or dl_cb, data))
end
local function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
assert (tdbot_function ({
_= "sendMessage",
chat_id = chat_id,
reply_to_message_id = reply_to_message_id,
disable_notification = disable_notification,
from_background = from_background,
reply_markup = reply_markup,
input_message_content = {
_ = "inputMessagePhoto",
photo = getInputFile(photo),
added_sticker_file_ids = {},
width = 0,
height = 0,
caption = caption.."\n"..check_markdown(Channel)
},
}, dl_cb, nil))
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
function file_exists(name)
local f = io.open(name,"r")
if f ~= nil then
io.close(f)
return true
else
return false
end
end
function getChannelFull(CerNer,Company)
assert (tdbot_function ({
_ = 'getChannelFull',
channel_id = getChatId(CerNer).id
}, Company, nil))
end
function setProfilePhoto(photo_path)
assert (tdbot_function ({
_ = 'setProfilePhoto',
photo = photo_path
},  dl_cb, nil))
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
function getChannelMembers(channelid,mbrfilter,off, limit,cb)
if not limit or limit > 2000000000 then
limit = 2000000000 
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
function sendVideoNote(chat_id, reply_to_message_id,disable_notification,from_background ,reply_markup,videonote, vnote_thumb, vnote_duration, vnote_length)
assert (tdbot_function ({
_= "sendMessage",
chat_id = chat_id,
reply_to_message_id = reply_to_message_id,
disable_notification = disable_notification,
from_background = from_background,
reply_markup = reply_markup,
input_message_content = {
_ = 'inputMessageVideoNote',
video_note = getInputFile(videonote),
},
}, dl_cb, nil))
end
function sendGame(chat_id, msg_id, botuserid, gameshortname)
assert (tdbot_function ({
_ = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = 0,
from_background = true,
reply_markup = nil,
input_message_content = {
_ = 'inputMessageGame',
bot_user_id = botuserid,
game_short_name = tostring(gameshortname)
}
}, dl_cb, nil))
end
function file_exists(name)
local f = io.open(name,"r")
if f ~= nil then
io.close(f)
return true
else
return false
end
end
function SendMetion(chat_id, user_id, msg_id, text, offset, length)
assert (tdbot_function ({
_ = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = 0,
from_background = true,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",
text = text,
disable_web_page_preview = 1,
clear_draft = false,
entities = {[0] = {
offset =  offset,
length = length,
_ = "textEntity",
type = {user_id = user_id, _ = "textEntityTypeMentionName"}}}
}
}, dl_cb, nil))
end
function dl_cb(arg, data)
end
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
 function showedit(msg,data)
if msg then
if msg.date < tonumber(MsgTime) then
print('OLD MESSAGE')
return false
end
if is_supergroup(msg) then
if not is_sudo(msg) then
if not redis:sismember('CompanyAll',msg.chat_id) then
redis:sadd('CompanyAll',msg.chat_id)
redis:set("ExpireData:"..msg.chat_id,'w')
else
if redis:get("ExpireData:"..msg.chat_id) then
if redis:ttl("ExpireData:"..msg.chat_id) and tonumber(redis:ttl("ExpireData:"..msg.chat_id)) < 432000 and not redis:get('CheckExpire:'..msg.chat_id) then
end
redis:set('CheckExpire:'..msg.chat_id,true)
elseif not redis:get("ExpireData:"..msg.chat_id) then
sendText(msg.chat_id,0,"شارژ  "..msg.chat_id.." این گروه به اتمام رسیده است لطفا به مدیر ربات مراجعه کنید","md")
local Link = redis:get('Link:'..msg.chat_id) or 'ثبت نشده'
local textt =[[ شارز گروه زیر به اتمام رسیده است 
شناسه گروه : ]]..msg.chat_id..[[
لینگ گروه : ]]..Link..[[
]]

sendText(ChannelLogs,0,textt,'md')
print(Link)
redis:del("OwnerList:",msg.chat_id)
redis:del("ModList:",msg.chat_id)
redis:del("Filters:",msg.chat_id)
redis:del("MuteList:",msg.chat_id)
Left(msg.chat_id,TD_ID, "Left")
end       
end
end
end
if is_Owner(msg) then
if msg.content._ == 'messagePinMessage' then
print '      Pinned By Owner       '
redis:set('Pin_id'..msg.chat_id, msg.content.message_id)
end
end
forcemax = 3
if redis:get('force:Max:'..msg.chat_id) then
forcemax = redis:get('force:Max:'..msg.chat_id)
end
forcetime = 30
if redis:get('force:Time:'..msg.chat_id) then
forcetime = redis:get('force:Time:'..msg.chat_id)
end
NUM_MSG_MAX = 6
if redis:get('Flood:Max:'..msg.chat_id) then
NUM_MSG_MAX = redis:get('Flood:Max:'..msg.chat_id)
end
NUM_CH_MAX = 200
if redis:get('NUM_CH_MAX:'..msg.chat_id) then
NUM_CH_MAX = redis:get('NUM_CH_MAX:'..msg.chat_id)
end
TIME_CHECK = 2
if redis:get('Flood:Time:'..msg.chat_id) then
TIME_CHECK = redis:get('Flood:Time:'..msg.chat_id)
end
warn = 5
if redis:get('Warn:Max:'..msg.chat_id) then
warn = redis:get('Warn:Max:'..msg.chat_id)
end
if redis:get('Force:CH'..msg.chat_id) then
warn = redis:get('Force:CH:'..msg.chat_id)
end
if is_supergroup(msg) then
forceaddfor = msg.chat_id..'AddedOK'
added = tonumber(redis:hget('addeduser'..msg.chat_id,msg.sender_user_id) or 1)
function forcestats(msg,status)
if status == "new user" then
if msg.content._ == "messageChatJoinByLink" or msg.content._ == "messageChatAddMembers" then
redis:sadd('forceaddfor'..msg.chat_id,msg.sender_user_id)
deleteMessages(msg.chat_id, {[0] = msg.id})
elseif msg.add then
deleteMessages(msg.chat_id, {[0] = msg.id})
redis:sadd('forceaddfor'..msg.chat_id,msg.add)
end
end
if status == "all" then
if msg.sender_user_id then
deleteMessages(msg.chat_id, {[0] = msg.id})
redis:sadd('forceaddfor'..msg.chat_id,msg.sender_user_id)
end
end
end
if redis:get('forceAdd:'..msg.chat_id) and not is_Mod(msg) and not redis:hget(forceaddfor,msg.sender_user_id) then
print'                  Force Add Enable                          '
local status = redis:get('Force:Status:'..msg.chat_id)
forcestats(msg,status)
end
if redis:sismember('forceaddfor'..msg.chat_id,msg.sender_user_id) and not redis:hget('test'..msg.chat_id,msg.sender_user_id) then
sendText(msg.chat_id,msg.id,"کاربر : "..msg.sender_user_id.." شما باید ("..forcemax..") نفر به گروه اضافه کنید تا مجوز سخن گفتن را بدست بیاورید","md")
redis:hset('test'..msg.chat_id,msg.sender_user_id,true) 
end
if redis:sismember('forceaddfor'..msg.chat_id,msg.sender_user_id) then
deleteMessagesFromUser(msg.chat_id,msg.sender_user_id) 
end
if redis:get('forceAdd:'..msg.chat_id) and not redis:get('deleteallmsgs:'..msg.chat_id) then
deleteMessagesFromUser(msg.chat_id,TD_ID) 
redis:setex('deleteallmsgs:'..msg.chat_id,tonumber(forcetime),true)
end
-------------Mute All -------------
function muteallstats(msg,status)
if status == "Restricted" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
return true
end
redis:sadd('Mutes:'..msg.chat_id,msg.sender_user_id)
deleteMessages(msg.chat_id, {[0] = msg.id})
print ' mute all '
mute(msg.chat_id,msg.sender_user_id,'Restricted',  {1,0, 0, 0, 0,0})
end
if status == "deletemsg" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
return true
end
deleteMessages(msg.chat_id, {[0] = msg.id})
print ' mute all '
deleteMessagesFromUser(msg.chat_id,msg.sender_user_id) 
end
end
-------------Flood Check------------
function antifloodstats(msg,status)
if status == "kickuser" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
return true
end
sendText(msg.chat_id, msg.id,'_کاربر ـ  : `'..(msg.sender_user_id)..'`  ـبه علت ارسال بیش از حد پیام  از گروه اخراج شدـ' ,'md')
KickUser(msg.chat_id,msg.sender_user_id)
end
if status == "deletemsg" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
return true
end
sendText(msg.chat_id, msg.id,'تمام پیام های  : `'..(msg.sender_user_id)..'` به علت ارسال بیش از حد پیام پاک شد' ,'md')
deleteMessagesFromUser(msg.chat_id,msg.sender_user_id) 
end
if status == "muteuser" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
return true
end
if is_MuteUser(msg.chat_id,msg.sender_user_id) then
 else
sendText(msg.chat_id, msg.id,'کاربر : `'..(msg.sender_user_id)..'` به علت ارسال بیش از حد پیام در گروه محدود شد' ,'md')
mute(msg.chat_id,msg.sender_user_id,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,msg.sender_user_id)
end
end
end
if redis:get('Lock:Flood:'..msg.chat_id) then
if not is_Mod(msg) then
local post_count = 'user1:' .. msg.sender_user_id .. ':flooder'
local msgs = tonumber(redis:get(post_count) or 0)
if msgs > tonumber(NUM_MSG_MAX) then
if redis:get('user:'..msg.sender_user_id..':flooder') then
local status = redis:get('Flood:Status:'..msg.chat_id)
antifloodstats(msg,status)
return false
else
redis:setex('user:'..msg.sender_user_id..':flooder', 15, true)
end
end
redis:setex(post_count, tonumber(TIME_CHECK), msgs+1)
end
end
end
function forcejoin(msg) 
local url  = https.request('https://api.telegram.org/bot'..SendApi..'/getchatmember?chat_id='..Channel..'&user_id='..msg.sender_user_id)
Company = json:decode(url)
local force = forcestatus
if Company.result.status == "left" or Company.result.status == "kicked" or not Company.ok then
forcestatus = sendText(msg.chat_id,msg.id,'ابتدا باید در کانال زیر عضو شوید،سپس مجدد دستور خود را ارسال کنید\n'..Channel, 'html')
end
return forcestatus
end
-------------MSG CerNer ------------
local cerner = msg.content.text
local cerner1 = msg.content.text
if cerner then
cerner = cerner:lower()
end
 if MsgType == 'text' and cerner then
if cerner:match('^[/#!]') then
cerner= cerner:gsub('^[/#!]','')
end
end
--------------MSG TYPE----------------
 if msg.content._== "messageText" then
MsgType = 'text'
end
 if msg.content._== "messageText" then
local function GetM(Company,CerNer)
local function GetName(Companys,Company)
print("\027[" ..color.blue[1].. "m["..os.date("%H:%M:%S").."]\027[00m  >>>> "..msg.content.text.."")
end
GetUser(msg.sender_user_id,GetName)
end
GetChat(msg.chat_id,GetM)
end
if msg.content.caption then
function GetM(Company,CerNer)
function GetName(Companys,Company)
print("["..os.date("%H:%M:%S").."] "..CerNer.title.." "..Company.first_name.." >>>> "..msg.content.caption.."")
end
GetUser(msg.sender_user_id,GetName)
end
GetChat(msg.chat_id,GetM)
end
if msg.content._ == "messageChatAddMembers" then
for i=0,#msg.content.member_user_ids do
msg.add = msg.content.member_user_ids[i]
MsgType = 'AddUser'
end
end
if msg.content._ == "messageChatJoinByLink" then
MsgType = 'JoinedByLink'
end
if msg.content._ == "messageDocument" then
function GetM(Company,CerNer)
function GetName(Companys,Company)
print("["..os.date("%H:%M:%S").."] "..CerNer.title.." "..Company.first_name.." >>>>[messageDocument][  "..Company.id.."]")
MsgType = 'Document'
end
GetUser(msg.sender_user_id,GetName)
end
GetChat(msg.chat_id,GetM)
end
if msg.content._ == "messageSticker" then
print("[ CerNerCompany ]\nThis is [ Sticker ]")
MsgType = 'Sticker'
end
if msg.content._ == "messageAudio" then
print("[ CerNerCompany ]\nThis is [ Audio ]")
MsgType = 'Audio'
end
if msg.content._ == "messageVoice" then
print("[ CerNerCompany ]\nThis is [ Voice ]")
MsgType = 'Voice'
end
if msg.content._ == "messageVideo" then
print("[ CerNerCompany ]\nThis is [ Video ]")
MsgType = 'Video'
end
if msg.content._ == "messageAnimation" then
print("[ CerNerCompany ]\nThis is [ Gif ]")
MsgType = 'Gif'
end
if msg.content._ == "messageLocation" then
print("[ CerNerCompany ]\nThis is [ Location ]")
MsgType = 'Location'
end
if msg.content._ == "messageForwardedFromUser" then
print("[ CerNerCompany ]\nThis is [ messageForwardedFromUser ]")
MsgType = 'messageForwardedFromUser'
end

if msg.content._ == "messageContact" then
print("[ CerNerCompany ]\nThis is [ Contact ]")
MsgType = 'Contact'
end
if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
print(serpent.block(data))
print("[ CerNerCompany ]\nThis is [ MarkDown ]")
MsgType = 'Markreed'
end
if msg.content.game then
print("[ CerNerCompany ]\nThis is [ Game ]")
MsgType = 'Game'
end
if msg.content._ == "messagePhoto" then
MsgType = 'Photo'
end
if msg.sender_user_id and is_GlobalyBan(msg.sender_user_id) and not TD_ID then
sendText(msg.chat_id, msg.id,'کاربر  : `'..msg.sender_user_id..'` شما در لیست سیاه ربات قرارر دارید','md')
KickUser(msg.chat_id,msg.sender_user_id)
end

if MsgType == 'AddUser' then
function ByAddUser(CerNer,Company)
if is_GlobalyBan(Company.id) then
print '                      >>>>Is  Globall Banned <<<<<       '
sendText(msg.chat_id, msg.id,'کاربر : `'..Company.id..'` در لیست سیاه قرار دارد','md')
end
GetUser(msg.content.member_user_ids[0],ByAddUser)
end
end
if msg.sender_user_id and is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
end
local welcome = (redis:get('Welcome:'..msg.chat_id) or 'disable') 
if welcome == 'enable' then
if MsgType == 'JoinedByLink' then
print '                       JoinedByLink                        '
if is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
sendText(msg.chat_id, msg.id,'کاربر : `'..msg.sender_user_id..'` شما از این گروه محروم شده اید','md')
else
function WelcomeByLink(CerNer,Company)
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام \nخوش امدی'
end
local hash = "Rules:"..msg.chat_id
local cerner = redis:get(hash) 
if cerner then
rules=cerner
else
rules= '`قوانین ثبت نشده است`'
end
local hash = "Link:"..msg.chat_id
local cerner = redis:get(hash) 
if cerner then
link=cerner
else
link= 'لینک گروه ثبت نشده است'
end
local txtt = txtt:gsub('{first}',ec_name(Company.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{last}',Company.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(Company.username) or '')
sendText(msg.chat_id, msg.id, txtt,'md')
 end
GetUser(msg.sender_user_id,WelcomeByLink)
end
end
if msg.add then
if is_Banned(msg.chat_id,msg.add) then
KickUser(msg.chat_id,msg.add)
sendText(msg.chat_id, msg.id,'کاربر : `'..msg.add..'` در لیست سیاه قرار دارد','md')
else
function WelcomeByAddUser(CerNer,Company)
print('New User : \nChatID : '..msg.chat_id..'\nUser ID : '..msg.add..'')
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام \n خوش امدی'
end
local hash = "Rules:"..msg.chat_id
local cerner = redis:get(hash) 
if cerner then
rules=cerner
else
rules= 'قوانین ثبت نشده است'
end
local hash = "Link:"..msg.chat_id
local cerner = redis:get(hash) 
if cerner then
link=cerner
else
link= 'لینک گروه ثبت نشده است'
end
local txtt = txtt:gsub('{first}',ec_name(Company.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{last}',Company.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(Company.username) or '')
sendText(msg.chat_id, msg.id, txtt,'html')
end
GetUser(msg.add,WelcomeByAddUser)
end
end
end
viewMessages(msg.chat_id, {[0] = msg.id})
redis:incr('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
if msg.send_state._ == "messageIsSuccessfullySent" then
return false 
end   
if redis:get('forceAdd:'..msg.chat_id) and not redis:hget(forceaddfor,msg.sender_user_id) and not is_Mod(msg) and not is_Vip(msg) then 
if MsgType == 'AddUser' then
function forceAdd(CerNer,Company)
if Company.type._ == "userTypeBot" then
print '               Bot added              '  
sendText(msg.chat_id, msg.id, 'کاربر '..ec_name(Company.first_name)..' شما نمیتوانید ربات را به گروه اضافه کنید ', 'md')
KickUser(msg.chat_id,Company.id)
else
if tonumber(forcemax) == tonumber(added) then
redis:hset(forceaddfor,msg.sender_user_id,true)
redis:srem('forceaddfor'..msg.chat_id,msg.sender_user_id)
redis:hdel('test'..msg.chat_id,msg.sender_user_id) 
else 
added = tonumber(added) + 1
sendText(msg.chat_id,msg.id,"متشکرم : "..ec_name(Company.first_name).." شما یک نفر را به گروه اضافه کردید \nتعداد مانده : "..forcemax.."/"..added,"md")
redis:hset('addeduser'..msg.chat_id,msg.sender_user_id,added)
print '             ok Adding            '
end 
end
end
GetUser(msg.add,forceAdd)
end
end
----------Msg Checks-------------
local chat = msg.chat_id
if redis:get('CheckBot:'..msg.chat_id)  then
if not is_Owner(msg) then
if redis:get('Lock:Pin:'..chat) then
if msg.content._ == 'messagePinMessage' then
print '      Pinned By Not Owner       '
sendText(msg.chat_id, msg.id, 'Only Owners', 'md')
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
local link = (cerner:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or cerner:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or cerner:match("[Tt].[Mm][Ee]/") or cerner:match('(.*)[.][mM][Ee]') or cerner:match('[Ww][Ww][Ww].(.*)') or cerner:match('(.*).[Ii][Rr]') or cerner:match('[Hh][Tt][Tt][Pp][Ss]://(.*)') or cerner:match('[Ww][Ww][Ww].(.*)') or msg.content.text:match('http://(.*)'))
if link  then
if msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeUrl" then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Link] ")
end
end
end

if msg.content.caption then
local cap = msg.content.caption
local link = (cap:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or cap:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or cap:match("[Tt].[Mm][Ee]/") or cap:match('(.*)[.][mM][Ee]') or cap:match('(.*).[Ii][Rr]') or cap:match('[Ww][Ww][Ww].(.*)') or cap:match('[Hh][Tt][Tt][Pp][Ss]://') or msg.content.caption:match('http://(.*)'))
if link then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] [Link] ")

end
end
end 
---------------------------
if redis:get('Lock:Tag:'..chat) then
if cerner then
local tag = cerner:match("@(.*)") or cerner:match("@")
if tag then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Tag] ")

end
end
if msg.content.caption then
local cerner = msg.content.caption
local tag = cerner:match("@(.*)")
if tag then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] [Tag] ")
end
end
end
---------------------------
if redis:get('Lock:HashTag:'..chat) then
if msg.content.text then
if msg.content.text:match("#(.*)") or msg.content.text:match("#(.*)") or msg.content.text:match("#") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [HashTag] ")
end
end
if msg.content.caption then
if msg.content.caption:match("#(.*)")  or msg.content.caption:match("(.*)#") or msg.content.caption:match("#") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] [HashTag] ")

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
if redis:get('Spam:Lock:'..chat) then
 if MsgType == 'text' then
 local _nl, ctrl_chars = string.gsub(msg.content.text, '%c', '')
 local _nl, real_digits = string.gsub(msg.content.text, '%d', '')
local hash = 'NUM_CH_MAX:'..msg.chat_id
if not redis:get(hash) then
sens = 40
else
sens = tonumber(redis:get(hash))
end
local max_real_digits = tonumber(sens) * 50
local max_len = tonumber(sens) * 51
if string.len(msg.content.text) >  sens or ctrl_chars > sens or real_digits >  sens then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Spam] ")
end
end
end
----------Filter------------
if cerner then
 if is_filter(msg,cerner) then
 deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Filter] ")

 end 
end
-----------------------------------------------
if redis:get('Lock:Bot:'..chat) then
if MsgType == 'AddUser' and msg.add then
function ByAddUser(CerNer,Company)
if Company.type._ == "userTypeBot" then
print '               Bot added              '  
KickUser(msg.chat_id,Company.id)
end
end
GetUser(msg.add,ByAddUser)
end
end
-----------------------------------------------
if redis:get('Lock:Markdown:'..chat) then
if msg.content.entities and msg.content.entities[0] and (msg.content.entities[0].type._ == "textEntityTypeBold" or msg.content.entities[0].type._ == "textEntityTypeCode" or msg.content.entities[0].type._ == "textEntityTypeitalic") then 
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Markdown] ")
end
end
----------------------------------------------
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
if redis:get('automuteall'..msg.chat_id) and (redis:get("automutestart"..msg.chat_id) or redis:get("automuteend"..msg.chat_id)) then
local time = os.date("%H%M")
local start = redis:get("automutestart"..msg.chat_id)
local endtime = redis:get("automuteend"..msg.chat_id)
if tonumber(endtime) < tonumber(start) then
if tonumber(time) <= 2359 and tonumber(time) >= tonumber(start) then
if not redis:get("MuteAll:"..msg.chat_id) then
redis:set("MuteAll:"..msg.chat_id,true)
end
elseif tonumber(time) >= 0000 and tonumber(time) < tonumber(endtime) then
if not redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'گروه قفل میباشد لطفا پیامی ارسال نکنید !' , 'md')
redis:set("MuteAll:"..msg.chat_id,true)
end
else
if redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'قفل خودکار غیرفعال شد !' , 'md')
local mutes =  redis:smembers('Mutes:'..msg.chat_id)
for k,v in pairs(mutes) do
redis:srem('MuteList:'..msg.chat_id,v)
mute(msg.chat_id,v,'Restricted',   {1, 1, 1, 1, 1,1})
redis:del("MuteAll:"..msg.chat_id)
end
end
end
elseif tonumber(endtime) > tonumber(start) then
if tonumber(time) >= tonumber(start) and tonumber(time) < tonumber(endtime) then
if not redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'گروه قفل میباشد لطفا پیامی ارسال نکنید !' , 'md')
redis:set("MuteAll:"..msg.chat_id,true)
end
else
if redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'قفل خودکار غیرفعال شد !' , 'md')
redis:del("MuteAll:"..msg.chat_id)
end
end
end
end
-----------------------------------------
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
if tonumber(msg.reply_to_message_id) > 0 then
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
-----------Mtes Gif------------
if redis:get('Mute:Gif:'..chat) then
if MsgType == 'Gif' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ CerNerCompany ] Deleted [Lock] [Gif] ")
end
end
end
end
------------Chat Type------------
function is_channel(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-100') then 
if msg.is_post then
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
if chat_id:match('^(%d+)') then
print'           ty                                   '
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

if is_Fullsudo(msg) then
if cerner and cerner:match('^setsudo (%d+)') then
local sudo = cerner:match('^setsudo (%d+)')
redis:sadd('SUDO-ID',sudo)
sendText(msg.chat_id, msg.id, '• کاربر `'..sudo..'` به لیست مدیران ربات اضافه شد', 'md')
end
if cerner and cerner:match('^remsudo (%d+)') then
local sudo = cerner:match('^remsudo (%d+)')
redis:srem('SUDO-ID',sudo)
sendText(msg.chat_id, msg.id, '• کاربر `'..sudo..'` از لیست صاحبان ربات حذف شد', 'md')
end
if cerner == 'sudolist' then
local hash =  "SUDO-ID"
local list = redis:smembers(hash)
local t = '*Sudo list: *\n'
for k,v in pairs(list) do 
local user_info = redis:hgetall('user:'..v)
if user_info and user_info.username then
local username = user_info.username
t = t..k.." - @"..username.." ["..v.."]\n"
else
t = t..k.." - "..v.."\n"
end
end
if #list == 0 then
t = 'لیست خالی لیست'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
end
if is_supergroup(msg) then
if cerner == 'test' then
redis:del('Request1:')
end
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
if cerner and cerner:match('^addme (-100)(%d+)$') then
local chat_id = cerner:match('^addme (.*)$')
sendText(msg.chat_id,msg.id,'با موفقيت تورو به گروه '..chat_id..' اضافه کردم.','md')
addChatMembers(chat_id,{[0] = msg.sender_user_id})
end
if cerner == 'add' then
local function GetName(CerNer, Company)
if not redis:get("ExpireData:"..msg.chat_id) then
redis:setex("ExpireData:"..msg.chat_id,day,true)
end 
  redis:sadd("group:",msg.chat_id)
if redis:get('CheckBot:'..msg.chat_id) then
local text = '• گروه `'..Company.title..'` از قبل در لیست گروه های مدیریتی ربات وجود دارد'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '• `گروه ` *'..Company.title..'* ` به لیست گروه های مدیریتی اضافه شد`'
local Hash = 'StatsGpByName'..msg.chat_id
local ChatTitle = Company.title
redis:set(Hash,ChatTitle)
print('• New Group\nChat name : '..Company.title..'\nChat ID : '..msg.chat_id..'\nBy : '..msg.sender_user_id)
local textlogs =[[•• گروه جدیدی به لیست مدیریت اضافه شد 
• اطلاعات گروه :
• نام گروه ]]..Company.title..[[
• آیدی گروه : ]]..msg.chat_id..[[
• توسط : ]]..msg.sender_user_id..[[
• برای عضویت در گروه میتوانید از  دستور  [addme] استفاده کنید 
> مثال : addme -10023456789878
]]
redis:set('CheckBot:'..msg.chat_id,true) 
if not redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
 sendText(msg.chat_id, msg.id,text,'md')

 sendText(ChannelLogs, 0,textlogs,'html')
end
end
GetChat(msg.chat_id,GetName)
end
if cerner == 'ids' then 
sendText(msg.chat_id,msg.id,''..msg.chat_id..'','md')
end
			
if cerner == 'reload' then
 dofile('./bot/bot.lua')
sendText(msg.chat_id,msg.id,'• سیستم ربات بروز شد','md')
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
redis:del("OwnerList:"..msg.chat_id)
redis:del("ModList:"..msg.chat_id)
redis:del('StatsGpByName'..msg.chat_id)
redis:del('CheckExpire:'..msg.chat_id)
 if not redis:get('CheckBot:'..msg.chat_id) then
local text = '• گروه  `'..Company.title..'` در لیست گروه های مدیریتی قرار ندارد'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '• `گروه ` *'..Company.title..'* ` از لیست گروه های مدیریتی حذف شد`'
local Hash = 'StatsGpByName'..msg.chat_id
redis:del(Hash)
 sendText(msg.chat_id, msg.id,text,'md')
 redis:del('CheckBot:'..msg.chat_id) 
end
end
GetChat(msg.chat_id,GetName)
end
if cerner and cerner:match('^tdset (%d+)$') then
local TD_id = cerner:match('^tdset (%d+)$')
redis:set('BOT-ID',TD_id)
 sendText(msg.chat_id, msg.id,'شناسه ربات جدید ذخیره شد \n شناسه  : '..TD_id,'md')
end
if cerner and cerner:match('^invite (%d+)$') then
local id = cerner:match('^invite (%d+)$')
addChatMembers(msg.chat_id,{[0] = id})
 sendText(msg.chat_id, msg.id,'کاربر به گروه دعوت شد','md')
end
if cerner1 and cerner1:match('^plan1 (-100)(%d+)$') then
local chat_id = cerner1:match('^plan1 (.*)$')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
redis:setex("ExpireData:"..chat_id,Plan1,true)
sendText(msg.chat_id,msg.id,'پلن 1 با موفقيت براي گروه '..chat_id..' فعال شد\nاين گروه تا 30 روز ديگر اعتبار دارد! ( 1 ماه )','md')
sendText(chat_id,0,"ربات با موفقيت فعال شد و تا 30 روز ديگر اعتبار دارد!",'md')
end
------------------Charge Plan 2--------------------------
if cerner and cerner:match('^plan2 (-100)(%d+)$') then
local chat_id = cerner:match('^plan2 (.*)$')
redis:setex("ExpireData:"..chat_id,Plan2,true)
sendText(msg.chat_id,msg.id,'پلن 2 با موفقيت براي گروه '..chat_id..' فعال شد\nاين گروه تا 90 روز ديگر اعتبار دارد! ( 3 ماه )','md')
sendText(chat_id,0,"ربات با موفقيت فعال شد و تا 90 روز ديگر اعتبار دارد! ( 3 ماه )",'md')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
end
-----------------Charge Plan 3---------------------------
if cerner and cerner:match('^plan3 (-100)(%d+)$') then
local chat_id = cerner:match('^plan3 (.*)$')
redis:set("ExpireData:"..chat_id,true)
sendText(msg.chat_id ,msg.id,''..chat_id..'_پلن شماره 3 براي گروه مورد نظر فعال شد!_','md')
sendText(chat_id,0,"_پلن شماره ? براي اين گروه تمديد شد \nمدت اعتبار پنل (نامحدود)!_",'md')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
end
-----------Leave----------------------------------
if cerner1 and cerner1:match('^leave (-100)(%d+)$') then
local chat_id = cerner1:match('^leave (.*)$') 
redis:del("ExpireData:"..chat_id)
redis:srem("group:",chat_id)
redis:del("OwnerList:"..chat_id)
redis:del("ModList:"..chat_id)
redis:del('StatsGpByName'..chat_id)
redis:del('CheckExpire:'..chat_id)
sendText(msg.chat_id,msg.id,'ربات از گروه  '..chat_id..' خارج شد','md')
sendText(chat_id,0,'','md')
Left(chat_id,TD_ID, "Left")
end 
if cerner == 'groups' then
local list = redis:smembers('group:')
local t = '• Groups\n'
for k,v in pairs(list) do
local GroupsName = redis:get('StatsGpByName'..v)
t = t..k.."  *"..v.."*\n "..(GroupsName or '---').."\n" 
end
if #list == 0 then
t = '• لیست خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner and cerner:match('^charge (%d+)$') then
local function GetName(CerNer, Company)
local time = tonumber(cerner:match('^charge (%d+)$')) * day
 redis:setex("ExpireData:"..msg.chat_id,time,true)
local ti = math.floor(time / day )
local text = '• `گروه ` *'..Company.title..'* ` شارژ شد ` به مدت  *'..ti..'* روز'
sendText(msg.chat_id, msg.id,text,'md')
if redis:get('CheckExpire:'..msg.chat_id) then
 redis:set('CheckExpire:'..msg.chat_id,true)
end
end
GetChat(msg.chat_id,GetName)
end
if cerner == 'message_id' then
sendText(msg.chat_id, msg.id,msg.reply_to_message_id,'md')
end
if cerner == "expire" then
local ex = redis:ttl("ExpireData:"..msg.chat_id)
if ex == -1 then
sendText(msg.chat_id, msg.id,  "• نامحدود", 'md' )
else
local d = math.floor(ex / day ) + 1
sendText(msg.chat_id, msg.id,d.."  Day",  'md' )
end
end
if cerner == 'leave' then
sendText(msg.chat_id, msg.id,  "• ربات از گروه خارج میشود", 'md' )
Left(msg.chat_id, TD_ID, 'Left')
end
if cerner and cerner:match('^call (%d+)$') then
local user_id = cerner:match('^call (%d+)$')
Call(user_id)
sendText(msg.chat_id, msg.id,"Done",  'md' )
end
if cerner == 'stats' then
local allmsgs = redis:get('allmsgs')
local supergroup = redis:scard('ChatSuper:Bot')
local Groups = redis:scard('Chat:Normal')
local users = redis:scard('ChatPrivite')
local user = io.popen("whoami"):read('*a')
 local uptime = UpTime()
local totalredis = io.popen("du -h /var/lib/redis/dump.rdb"):read("*a")
sizered= string.gsub(totalredis, "/var/lib/redis/dump.rdb","")
local totalbot = io.popen("du -h ./bot/bot.lua"):read("*a")
SourceSize = string.gsub(totalbot, "./bot/bot.lua","")
local text =[[
• تمام پیام های چک شده  : ]]..allmsgs..[[

سوپر گروه ها :]]..supergroup..[[

گروه ها : ]]..Groups..[[

کاربران   : ]]..users..[[

یوزر : ]]..user..[[
آپتایم : ]]..uptime..[[

مقدار مصرف شده ردیس : ]]..sizered..
[[
حجم سورس : ]]..SourceSize
sendText(msg.chat_id, msg.id,text,  'md' )
end
if cerner == 'reset' then
 redis:del('allmsgs')
redis:del('ChatSuper:Bot')
 redis:del('Chat:Normal')
 redis:del('ChatPrivite')
sendText(msg.chat_id, msg.id,'آمار ربات از نو شروع شد',  'md' )
end
if cerner == 'ownerlist' then
local list = redis:smembers('OwnerList:'..msg.chat_id)
local t = '• OwnerList\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #list == 0 then
t = 'The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner and cerner:match('^setrank (.*)$') then
local rank = cerner:match('^setrank (.*)$') 
local function SetRank_Rep(CerNer, Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:set('rank'..Company.sender_user_id,rank)
local user = Company.sender_user_id
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• مقام کاربر '..user..' به '..rank..' تغییر کرد', 13,string.len(Company.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetRank_Rep)
end
end
----------------------SetOwner--------------------------------
if cerner == 'setowner' then
local function SetOwner_Rep(CerNer, Company)
local user = Company.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• کاربر : '..Company.sender_user_id..' در لیست صاحبان گروه قرار دارد..!', 10,string.len(Company.sender_user_id))
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• کاربر : '..Company.sender_user_id..' به لیست صاحبان گروه اضافه شد ..', 10,string.len(Company.sender_user_id))
redis:sadd('OwnerList:'..msg.chat_id,user)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetOwner_Rep)
end
end
if cerner and cerner:match('^setowner (%d+)') then
local user = cerner:match('setowner (%d+)')
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '• کاربر : '..user..' از قبل در لیست صاحبان گروه قرار داشت', 10,string.len(user))
else
SendMetion(msg.chat_id,user, msg.id, '• کاربر : '..user..' به لیست صاحبان گروه اضافه شد', 10,string.len(user))
redis:sadd('OwnerList:'..msg.chat_id,user)
end
end
if cerner and cerner:match('^setowner @(.*)') then
local username = cerner:match('^setowner @(.*)')
function SetOwnerByUsername(CerNer,Company)
if Company.id then
print(''..Company.id..'')
if redis:sismember('OwnerList:'..msg.chat_id,Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '• کاربر  : '..Company.id..'از قبل در لیست صاحبان گروه قرار داشت ', 10,string.len(Company.id))
else
SendMetion(msg.chat_id,Company.id, msg.id, '• کاربر : '..Company.id..' به لیست صاحبان گروه اضافه شد', 10,string.len(Company.id))
redis:sadd('OwnerList:'..msg.chat_id,Company.id)
end
else 
text = '• کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,SetOwnerByUsername)
end
if cerner == 'remowner' then
local function RemOwner_Rep(CerNer, Company)
local user = Company.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id, Company.sender_user_id) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• کاربر  : '..(Company.sender_user_id)..' از لیست صاحبان گروه حذف شد ', 9,string.len(Company.sender_user_id))
redis:srem('OwnerList:'..msg.chat_id,Company.sender_user_id)
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• کاربر  : '..(Company.sender_user_id)..' در لیست صاحبان گروه وجود ندارد', 9,string.len(Company.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RemOwner_Rep)
end
end
if cerner and cerner:match('^remowner (%d+)') then
local user = cerner:match('remowner (%d+)')
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '• کاربر : '..user..' از لیست صاحبان گروه حذف شد ', 10,string.len(user))
redis:srem('OwnerList:'..msg.chat_id,user)
else
SendMetion(msg.chat_id,user, msg.id, '• کاربر : '..user..' در لیست صاحبان گروه وجود ندارد',10,string.len(user))
end
end
if cerner and cerner:match('^remowner @(.*)') then
local username = cerner:match('^remowner @(.*)')
function RemOwnerByUsername(CerNer,Company)
if Company.id then
print(''..Company.id..'')
if redis:sismember('OwnerList:'..msg.chat_id, Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '• کاربر : '..Company.id..' از لیست صاحبان گروه پاک شد', 10,string.len(Company.id))
redis:srem('OwnerList:'..msg.chat_id,Company.id)
else
SendMetion(msg.chat_id,Company.id, msg.id, '• کاربر : '..Company.id..' در لیست صاحبان گروه وجود ندارد', 10,string.len(Company.id))
end
else  
text = '• کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,RemOwnerByUsername)
end
if cerner == 'clean ownerlist' then
redis:del('OwnerList:'..msg.chat_id)
sendText(msg.chat_id, msg.id,'لیست صاحبان گروه پاکسازی شد', 'md')
end
---------Start---------------Globaly Banned-------------------
if cerner == 'banall' then
function GbanByReply(CerNer,Company)
if redis:sismember('GlobalyBanned:',Company.sender_user_id) then
sendText(msg.chat_id, msg.id,  '• `کاربر : ` *'..(Company.sender_user_id)..'* قبلا در لیست وجود دارد', 'md')
else
sendText(msg.chat_id, msg.id,'• _ کاربر : _ `'..(Company.sender_user_id)..'` به لیست سیاه اضافه شد', 'md')
redis:sadd('GlobalyBanned:',Company.sender_user_id)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GbanByReply)
end
end
if cerner and cerner:match('^banall (%d+)') then
local user = cerner:match('^banall (%d+)')
if redis:sismember('GlobalyBanned:',user) then
sendText(msg.chat_id, msg.id,  '• `کاربر : ` *'..user..'* قبلا در لیست سیاه وجود دارد', 'md')
else
sendText(msg.chat_id, msg.id,'• _ User : _ `'..user..'` به لیست سیاه اضافه شد', 'md')
redis:sadd('GlobalyBanned:',user)
end
end
if cerner and cerner:match('^banall @(.*)') then
local username = cerner:match('^banall @(.*)')
function BanallByUsername(CerNer,Company)
if Company.id then
print(''..Company.id..'')
if redis:sismember('GlobalyBanned:', Company.id) then
text  ='• `کاربر : ` *'..Company.id..'* از قبل در لیست سیاه وجود دارد'
else
text= '• _ کاربر : _ `'..Company.id..'` به لیست سیاه اضافه شد'
redis:sadd('GlobalyBanned:',Company.id)
end
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,BanallByUsername)
end
if cerner == 'gbans' then
local list = redis:smembers('GlobalyBanned:')
local t = 'Globaly Ban:\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #list == 0 then
t = 'لیست '
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner == 'clean gbans' then
redis:del('GlobalyBanned:')
sendText(msg.chat_id, msg.id,'• لیست سیاه پاکسازی شد', 'md')
end
---------------------Unbanall--------------------------------------
if cerner and cerner:match('^unbanall (%d+)') then
local user = cerner:match('unbanall (%d+)')
if tonumber(user) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if redis:sismember('GlobalyBanned:',user) then
sendText(msg.chat_id, msg.id,'• _ کاربر : _ `'..user..'` از لیست سیاه حذف  شد', 'md')
redis:srem('GlobalyBanned:',user)
else
sendText(msg.chat_id, msg.id,  '• `کاربر : ` *'..user..'* در لیست سیاه وجود ندارد', 'md')
end
end
if cerner and cerner:match('^unbanall @(.*)') then
local username = cerner:match('^unbanall @(.*)')
function UnbanallByUsername(CerNer,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if Company.id then
print(''..Company.id..'')
if redis:sismember('GlobalyBanned:',Company.id) then
text = '• _ کاربر : _ `'..Company.id..'` از لیست حذف شد'
redis:srem('GlobalyBanned:',Company.id)
else
text = '• `کاربر : ` *'..user..'* در لیست سیاه وجود ندارد'
end
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,UnbanallByUsername)
end
if cerner == 'unbanall' then
function UnGbanByReply(CerNer,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if redis:sismember('GlobalyBanned:',Company.sender_user_id) then
sendText(msg.chat_id, msg.id,'• _ کاربر : _ `'..(Company.sender_user_id)..'` از لیست سیاه حذف شد', 'md')
redis:srem('GlobalyBanned:',Company.sender_user_id)
else
sendText(msg.chat_id, msg.id,  '• `کاربر : ` *'..(Company.sender_user_id)..'* در لیست سیاه وجود ندارد', 'md')
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnGbanByReply)
end
end
if cerner == 'clean members' then 
function CleanMembers(CerNer, Company) 
for k, v in pairs(Company.members) do 
if tonumber(v.user_id) == tonumber(TD_ID)  then
end
KickUser(msg.chat_id,v.user_id)
end
end
print('CerNer')
getChannelMembers(msg.chat_id,"Recent",0, 2000000,CleanMembers)
sendText(msg.chat_id, msg.id,'• مقداری از کاربران گروه اخراج شده اند', 'md') 
end 
if cerner == 'addkick'  then
local function Clean(CerNer,Company)
for k,v in pairs(Company.members) do
addChatMembers(msg.chat_id,{[0] = v.user_id})
end
end
sendText(msg.chat_id, msg.id, 'کاربران لیست سیاه به گروه اضافه شده اند', 'md')
getChannelMembers(msg.chat_id,"Banned", 0, 2000,Clean)
end
-------------------------------
end
if is_Owner(msg) then
if cerner == 'lock pin' then
if redis:get('Lock:Pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• قفل سنجاق از قبل فعال بود' , 'md')
else
sendText(msg.chat_id, msg.id, '• قفل سنجاق فعال شد' , 'md')
redis:set('Lock:Pin:'..msg.chat_id,true)
end
end
if cerner == 'unlock pin' then
if redis:get('Lock:pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• قفل سنجاق غیرفعال شد' , 'md')
redis:del('Lock:Pin:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• قفل سنجاق از قبل غیرفعال بود' , 'md')
end
end
if cerner == 'config' then
if not limit or limit > 200 then
limit = 200
end  
local function GetMod(extra,result,success)
local c = result.members
for i=0 , #c do
redis:sadd('ModList:'..msg.chat_id,c[i].user_id)
end
sendText(msg.chat_id,msg.id,"*تمام مدیران گروه به رسمیت شناخته شده اند*!", "md")
end
getChannelMembers(msg.chat_id,'Administrators',0,limit,GetMod)
end
if cerner == 'modlist' then
local list = redis:smembers('ModList:'..msg.chat_id)
local t = '• ModList\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #list == 0 then
t = 'لیست مدیران خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if cerner and cerner:match('^unmuteuser (%d+)$') then
local mutes =  cerner:match('^unmuteuser (%d+)$')
if tonumber(mutes) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('MuteList:'..msg.chat_id,mutes)
mute(msg.chat_id, mutes,'Restricted',   {1, 1, 1, 1, 1,1})
sendText(msg.chat_id, msg.id,"• *کاربر* `"..mutes.."` از حالت سکوت خارج شد",  'md' )
end
if cerner == "clean deleted" then
function list(CerNer,Company)
for k,v in pairs(Company.members) do
local function Checkdeleted(CerNer,Company)
if Company.type._ == "userTypeDeleted" then
KickUser(msg.chat_id,Company.id)
end
end
GetUser(v.user_id,Checkdeleted)
print(v.user_id)
end
sendText(msg.chat_id, msg.id,'تمام کاربران دیلیت اکانتی از گروه حذف شداند' ,'md')
end
tdbot_function ({_= "getChannelMembers",channel_id = getChatId(msg.chat_id).id,offset = 0,limit= 1000}, list, nil)
end
if cerner == 'promote' then
function PromoteByReply(CerNer,Company)
local user = Company.sender_user_id
sendText(msg.chat_id, msg.id, '• کاربر '..(user)..' ترفیع یافت ','md')
redis:sadd('ModList:'..msg.chat_id,user)
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), PromoteByReply)  
end
end
if cerner == 'demote' then
function DemoteByReply(CerNer,Company)
redis:srem('ModList:'..msg.chat_id,Company.sender_user_id)
sendText(msg.chat_id, msg.id, '• کاربر `'..(Company.sender_user_id)..'` عزل مقام شد', 'md')
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
text = '• کاربر `'..Company.id..'` عزل مقام شد'
else 
text = '• کاربر یافت نشد'
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
text = '• کاربر `'..Company.id..'` ترفیع یافت '
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,PromoteByUsername)
end
----------------------
if cerner1 and cerner1:match('^[Ss]etdescription (.*)') then
local description = cerner1:match('^[Ss]etdescription (.*)')
changeDes(msg.chat_id,description)
local text = [[درباره گروه به  ]]..description..[[ تغییر یا

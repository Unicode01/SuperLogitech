@getcode
curl method=post url=https://api.un1c0de.com/api/register output=a proxy=socks5://127.0.0.1:10808
time text type=getbetween text1_name=a text2=,"Token":" text3=","TokenTimeout": output=token
echo token:{token}
call loop
end
@loop
curl method=post url=https://api.un1c0de.com/api/requests binname=token output=resp proxy=socks5://127.0.0.1:10808
time text type=getbetween text1_name=resp text2="DailyRequests": text3=} output=resp
echo DailyRequests:{resp}
call loop
end

echo start register
call getcode


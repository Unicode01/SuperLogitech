@getcode
curl method=post url=https://api.un1c0de.com/api/register output=a proxy=socks5://127.0.0.1:10808
time text type=parsejson text1_name=a text2=Token output=token delquo=true
echo token:{token}
call loop
end
@loop
curl method=post url=https://api.un1c0de.com/api/getmyip binname=token output=resp proxy=socks5://127.0.0.1:10808
time text type=parsejson text1_name=resp text2=proxyip output=proxyip delquo=true
time text type=parsejson text1_name=resp text2=realip output=realip delquo=true
echo proxyip:{proxyip}
echo realip:{realip}
call loop
end
call getcode

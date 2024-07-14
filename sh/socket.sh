
@a
sock method=create type=tcp output=sockint
sock method=connect host=127.0.0.1 port=80 symbol={sockint} sucsymbol=istrue timeout=10000 

echo connected to server
sock method=sendbin binname=head symbol={sockint} sucsymbol=istrue timeout=10000
echo sent data:{head} to server
sock method=recvbin binname=data symbol={sockint} sucsymbol=istrue timeout=10000
sock method=closeconn symbol={sockint} sucsymbol=istrue
sock method=destroy symbol={sockint} sucsymbol=istrue
call a
end

set head GET{space}/index.html{space}HTTP/1.1{endl}Host:{space}www.un1c0de.com{endl}{endl}
call a

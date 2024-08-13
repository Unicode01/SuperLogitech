
@a
simple_calc + {count} 1
set count {simple_calc_result}
set head GET{space}/index.html{space}HTTP/1.1{endl}Host:{space}www.un1c0de.com{endl}Range:{space}bytes={count}-{count}{endl}{endl}
sock method=create type=tcp output=sockint
sock method=connect host=127.0.0.1 port=10808 symbol={sockint} sucsymbol=istrue timeout=10000 

echo connected to server
sock method=sendbin binname=head symbol={sockint} sucsymbol=istrue timeout=10000
echo sent data:{head} to server
time sock method=recvbin binname=data symbol={sockint} sucsymbol=istrue timeout=10000
echo received data:{data} from server
sock method=closeconn symbol={sockint} sucsymbol=istrue
sock method=destroy symbol={sockint} sucsymbol=istrue
call a
end
set count 0
echo 1
call a
echo 2
sleep 200000
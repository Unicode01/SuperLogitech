@closeconn
sock method=closeconn symbol={sockint} sucsymbol=istrue clientsym={client}
end

@send(true)
echo sent data to client
call closeconn
end

@send(false)
echo failed to send data to client
call closeconn
end

@recv(true)
set FileHandle
file type=open openfilehandle=FileHandle file={startupdir}..\webtest\{file}
set data
file type=read filehandle={FileHandle} readbin=data
sock method=sendbin binname=data sucsymbol=istrue timeout=10000 clientsym={client}
file type=close filehandle={LastOpenFileHandle}
call send({istrue})
call listen(true)
end
@recv(false)
echo failed to recv data from client
call closeconn
call listen(true)
end

@conn(true)
sock method=recvbin binname=data sucsymbol=istrue timeout=10000 clientsym={client}
text type=replace text1=`{data}` text2=` ` text3=`^` output=file frequency=2
text type=replace text1=`{file}` text2=`/` text3=`` output=file frequency=1
text type=getbetween text1=`{file}` text2=`GET^` text3=`^HTTP/1.1` output=file startfrom=1
text type=replace text1=`{file}` text2=`/` text3=`\` output=file
code type=url textname=file output=file UTF8=true encode=false
text type=replace text1=`{file}` text2=` ` text3=`^` output=file
echo {file}
call recv({istrue})
end

@conn(false)
echo failed to recv conn to client
call listen(true)
end

@listen(true)
sock method=recvconn symbol={sockint} sucsymbol=istrue timeout=-1 output=client clientip=clientip clientport=clientport
echo connected to client {clientip}:{clientport}
call conn({istrue})
end

@listen(false)
echo failed to connect to server
end

@startconnection
set host 0.0.0.0
set port 80
echo {startupdir}
set resp HTTP/1.1{space}200{space}OK{endl}{endl}
sock method=create type=tcp output=sockint
sock method=listen host={host} port={port} symbol={sockint} sucsymbol=istrue max_allowconn=512
echo listen server {host}:{port}
call listen({istrue})
end

call startconnection
call closeconn
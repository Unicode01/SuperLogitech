@closeconn
sock method=closeconn symbol={sockint} sucsymbol=istrue clientsym={client}
end

@send(true)

call closeconn
end

@send(false)

call closeconn
end

@recv(true)
text type=readline output=data text1={data} text2=1
text type=getbetween text1={data} text2=GET{space}/ text3={space}HTTP/1.1 output=file
echo {file}
text type=replace text1={file} text2=/ text3=\ output=file
code type=url textname=file output=file UTF8=true encode=false
set FileHandle
file type=open openfilehandle=FileHandle file={startupdir}..\webtest\{file}
set data
file type=read filehandle={FileHandle} readbin=data
sock method=sendbin binname=data sucsymbol=istrue timeout=10000 clientsym={client} await=true
file type=close filehandle={LastOpenFileHandle}
call send({istrue})
call listen(true)
end

@recv(false)
call closeconn
call listen(true)
end

@conn(true)
sock method=recvbin binname=data sucsymbol=istrue timeout=10000 clientsym={client}
call recv({istrue})
end
@conn(false)
call listen(true)
end

@listen(true)
sock method=recvconn symbol={sockint} sucsymbol=istrue timeout=-1 output=client clientip=clientip clientport=clientport
call conn({istrue})
end

@listen(false)

end

@startconnection
set host 0.0.0.0
set port 80

set resp HTTP/0.9{space}200{space}OK{endl}{endl}
sock method=create type=tcp output=sockint
sock method=listen host={host} port={port} symbol={sockint} sucsymbol=istrue max_allowconn=512
call listen({istrue})
end

call startconnection
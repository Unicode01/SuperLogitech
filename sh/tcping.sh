@ErrorIP
call inputip
end
@ErrorPort
call inputport
end
@ErrorTimeout
call inputtimeout
end
@inputip
input 输入tcping ip:
call ErrorIP{input}
set ip {input}
end
@inputport
input 输入tcping port:
call ErrorPort{input}
set port {input}
end
@inputtimeout
input 输入tcping timeout,单位秒:
call ErrorTimeout{input}
set timeout {input}
end
@tcping
tcping /ip {ip} /port {port} /timeout {timeout} 
end
call inputip
call inputport
call inputtimeout
call tcping
set input
system cmd /c pause
input 输入延迟时间,单位分钟:&set time {input}&set input
set Jumpkey_before {jumpkey}
set AllowThreadWhileRunningCommand_before {AllowThreadWhileRunningCommand}
set AllowThreadWhileRunningCommand true
set jumpkey 69
simple_calc * {time} 60 1000
set sleep_time {simple_calc_result}
sleep {sleep_time}

set AllowThreadWhileRunningCommand {AllowThreadWhileRunningCommand_before}
set jumpkey {jumpkey_before}
set AllowThreadWhileRunningCommand_before
set jumpkey_before
set sleep_time
set time
set simple_calc_result
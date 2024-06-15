
echo
echo loading autotranslater...
set AllowThreadWhileRunningCommand_before {AllowThreadWhileRunningCommand}
set LastError -1
set AllowThreadWhileRunningCommand true
sleep 10000
translate /r
set AllowThreadWhileRunningCommand {AllowThreadWhileRunningCommand_before}
echo load autotranslater... done
jsrun return new Date().getTime(); /*setLasterrorToNowTimeStamp*/
set AllowThreadWhileRunningCommand_before
cd sh
set js_ret_text
set js_ret_digital
set js_lasterror
@-1
set chosefile_HAUOF
end

@0
echo 正在打开文件:{chosefile_HAUOF}
system rundll32.exe shell32.dll,OpenAs_RunDLL {chosefile_HAUOF}
set chosefile_HAUOF
end

@textPredel
text type=replace text1=`{chosefile_HAUOF}` text2=` ` text3=`^` output=chosefile_HAUOF strict=false
end

choosefile type=open title=选择要打开的文件 createmessage=false output=chosefile_HAUOF
set issuc {lasterror}
call textPredel
call {issuc}
set issuc
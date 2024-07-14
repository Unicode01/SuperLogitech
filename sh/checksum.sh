@check
call choosetype
end

@check1
checksum {file} all b
end

@check2
checksum {file} md2 b
end

@check3
checksum {file} md5 b
end

@check4
checksum {file} sha1 b
end

@check5
checksum {file} sha256 b
end

@check6
checksum {file} sha512 b
end

@chooseError
echo 错误的输入文件:{file}
call choosefile
end

@choosetype
echo 请选择校验类型:
echo 1.全部校验
echo 2.MD2校验
echo 3.MD5校验
echo 4.SHA1校验
echo 5.SHA256校验
echo 6.SHA512校验
input 请输入:&set type {input}&set input
call choosefile
call check{type}
end

@textPredel
text type=replace text1=`{file}` text2=` ` text3=`^` output=file
end

@choosefile
choosefile type=open title=选择一个需要校验的文件 output=file
call textPredel
call chooseError{file}
end

@pause
system cmd /c pause
end

call choosetype
set type
call pause
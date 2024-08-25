@loop
simple_calc + {simple_calc_result} 1
call loop
end
@test
set
sleep 1000
call test
end
echo start loop
thread loop
thread loop
thread loop
call test

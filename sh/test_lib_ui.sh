@create_ui
lib_ui output_handle=main_window_handle method=create type=window title=main_window_title x=100 y=100 width=200 height=270 style=WS_VISIBLE|WS_CAPTION|WS_SYSMENU|WS_MINIMIZEBOX|WS_THICKFRAME extrastyle=WS_EX_WINDOWEDGE|WS_EX_TOPMOST|WS_EX_TOOLWINDOW

lib_ui output_handle=main_label1_handle method=create type=label parent={main_window_handle} title=main_label1 x=10 y=10 width=40 height=20 style=WS_VISIBLE|WS_CHILD
lib_ui output_handle=main_editbox_ip_handle method=create type=editbox_ip parent={main_window_handle} x=60 y=10 width=120 height=20 style=WS_VISIBLE|WS_CHILD

lib_ui output_handle=main_label2_handle method=create type=label parent={main_window_handle} title=main_label2 x=10 y=40 width=40 height=20 style=WS_VISIBLE|WS_CHILD
lib_ui output_handle=main_editbox_port_handle method=create type=editbox title=port_default parent={main_window_handle} x=60 y=40 width=120 height=20 style=WS_VISIBLE|WS_CHILD|ES_NUMBER|WS_BORDER

lib_ui output_handle=main_label3_handle method=create type=label parent={main_window_handle} title=main_label3 x=10 y=70 width=40 height=20 style=WS_VISIBLE|WS_CHILD
lib_ui output_handle=main_editbox_timeout_handle method=create type=editbox title=timeout_default parent={main_window_handle} x=60 y=70 width=120 height=20 style=WS_VISIBLE|WS_CHILD|ES_NUMBER|WS_BORDER

lib_ui output_handle=main_button_start_handle method=create type=button parent={main_window_handle} title=main_button_start_text x=10 y=100 width=80 height=20 style=WS_VISIBLE|WS_CHILD
lib_ui output_handle=main_button_stop_handle method=create type=button parent={main_window_handle} title=main_button_stop_text x=100 y=100 width=80 height=20 style=WS_VISIBLE|WS_CHILD|WS_DISABLED

lib_ui output_handle=main_editbox_output_handle method=create type=editbox parent={main_window_handle} x=10 y=130 width=180 height=100 style=WS_VISIBLE|WS_CHILD|ES_MULTILINE|ES_READONLY|WS_VSCROLL|WS_HSCROLL

lib_ui method=setfocus handle={main_editbox_ip_handle}
end

@setEnv
set true true
set false false
set main_window_title connect{space}test
set main_label1 ip:
set main_label2 port:
set main_label3 timeout:
set main_button_start_text start
set main_button_stop_text stop
set port_default 80
set timeout_default 1000
end

@blind_events
lib_ui handle={main_button_start_handle} method=blindevent type=button blindevent=onclick blindmethod=start_tcping
lib_ui handle={main_button_stop_handle} method=blindevent type=button blindevent=onclick blindmethod=stop_tcping
lib_ui handle={main_window_handle} method=blindevent type=window blindevent=onuserclose blindmethod=on_user_close
end

@start_tcping
lib_ui output=ip method=editbox_ip.getip handle={main_editbox_ip_handle}
lib_ui output=port method=get.text handle={main_editbox_port_handle}
lib_ui output=timeout method=get.text handle={main_editbox_timeout_handle}
lib_ui method=addstyle handle={main_button_start_handle} style=WS_DISABLED
lib_ui method=addstyle handle={main_editbox_port_handle} style=WS_DISABLED
lib_ui method=addstyle handle={main_editbox_ip_handle} style=WS_DISABLED
lib_ui method=addstyle handle={main_editbox_timeout_handle} style=WS_DISABLED

lib_ui method=removestyle handle={main_button_stop_handle} style=WS_DISABLED

lib_ui method=redraw handle={main_button_start_handle}
lib_ui method=redraw handle={main_editbox_ip_handle}
lib_ui method=redraw handle={main_editbox_port_handle}
lib_ui method=redraw handle={main_editbox_timeout_handle}
lib_ui method=redraw handle={main_button_stop_handle}

set start_tcping_bool true
set timeusedAll 0
set packet_count 0
thread __sart_tcping__loop
end

@__sart_tcping__loop
call __sart_tcping__({start_tcping_bool})
end

@__sart_tcping__(true)
sock method=create type=tcp output=sockint
time start
sock method=connect host={ip} port={port} symbol={sockint} sucsymbol=istrue timeout={timeout}
call connectEnd({istrue})
sock method=closeconn symbol={sockint}
sock method=destroy symbol={sockint}
call __sart_tcping__loop
end

@connectEnd(true)
time end
set timeuse {lasterror}
simple_calc + {timeusedAll} {timeuse}
set timeusedAll {simple_calc_result}
simple_calc + {packet_count} 1
set packet_count {simple_calc_result}
set output_text connected(timeused{space}{timeuse}ms){endl}
lib_ui method=editbox.addtext handle={main_editbox_output_handle} title=output_text
end
@connectEnd(false)
set output_text connection failed{endl}
lib_ui method=editbox.addtext handle={main_editbox_output_handle} title=output_text
end
@stop_tcping
set start_tcping_bool false
simple_calc / {timeusedAll} {packet_count}
set lastoutput average{space}time{space}used:{space}{simple_calc_result}ms{endl}
lib_ui method=editbox.addtext handle={main_editbox_output_handle} title=lastoutput
set lastoutput
lib_ui method=removestyle handle={main_button_start_handle} style=WS_DISABLED
lib_ui method=removestyle handle={main_editbox_port_handle} style=WS_DISABLED
lib_ui method=removestyle handle={main_editbox_ip_handle} style=WS_DISABLED
lib_ui method=removestyle handle={main_editbox_timeout_handle} style=WS_DISABLED
lib_ui method=addstyle handle={main_button_stop_handle} style=WS_DISABLED
lib_ui method=redraw handle={main_button_start_handle}
lib_ui method=redraw handle={main_editbox_ip_handle}
lib_ui method=redraw handle={main_editbox_port_handle}
lib_ui method=redraw handle={main_editbox_timeout_handle}
lib_ui method=redraw handle={main_button_stop_handle}
end

@on_user_close
lib_ui method=exit
end
@main
call setEnv
call create_ui
call blind_events
lib_ui method=run
end


call main
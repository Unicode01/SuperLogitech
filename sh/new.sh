
@create_ui
lib_ui output_handle=main_window_handle method=create type=window title=main_window_title x=100 y=100 width=200 height=270 style=WS_CAPTION|WS_SYSMENU|WS_MINIMIZEBOX|WS_THICKFRAME extrastyle=WS_EX_WINDOWEDGE|WS_EX_TOPMOST|WS_EX_TOOLWINDOW

lib_ui output_handle=main_label1_handle method=create type=label parent={main_window_handle} title=main_label1 x=10 y=10 width=40 height=20 style=WS_VISIBLE|WS_CHILD
lib_ui output_handle=main_editbox_ip_handle method=create type=editbox_ip parent={main_window_handle} x=60 y=10 width=120 height=20 style=WS_VISIBLE|WS_CHILD
lib_ui method=editbox_ip.setip handle={main_editbox_ip_handle} title=default_ip
lib_ui output_handle=main_label2_handle method=create type=label parent={main_window_handle} title=main_label2 x=10 y=40 width=40 height=20 style=WS_VISIBLE|WS_CHILD
lib_ui output_handle=main_editbox_port_handle method=create type=editbox title=port_default parent={main_window_handle} x=60 y=40 width=120 height=20 style=WS_VISIBLE|WS_CHILD|ES_NUMBER|WS_BORDER

lib_ui output_handle=main_label3_handle method=create type=label parent={main_window_handle} title=main_label3 x=10 y=70 width=40 height=20 style=WS_VISIBLE|WS_CHILD
lib_ui output_handle=main_editbox_timeout_handle method=create type=editbox title=timeout_default parent={main_window_handle} x=60 y=70 width=120 height=20 style=WS_VISIBLE|WS_CHILD|ES_NUMBER|WS_BORDER

lib_ui output_handle=main_button_start_handle method=create type=button parent={main_window_handle} title=main_button_start_text x=10 y=100 width=80 height=20 style=WS_VISIBLE|WS_CHILD
lib_ui output_handle=main_button_stop_handle method=create type=button parent={main_window_handle} title=main_button_stop_text x=100 y=100 width=80 height=20 style=WS_VISIBLE|WS_CHILD|WS_DISABLED

lib_ui output_handle=main_listbox_output_handle method=create type=listbox parent={main_window_handle} x=10 y=130 width=180 height=100 style=WS_VISIBLE|WS_CHILD|WS_VSCROLL|WS_HSCROLL|LBS_NOINTEGRALHEIGHT|LBS_MULTIPLESEL

lib_ui method=show handle={main_window_handle}
lib_ui method=updatewindow handle={main_window_handle}

lib_ui method=setfocus handle={main_editbox_ip_handle}
end

@setEnv
set true true
set false false
set main_window_title connect{space}test
set main_label1 ip:
set default_ip 127.0.0.1
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
lib_ui handle={main_listbox_output_handle} method=blindevent type=listbox blindevent=OnItemDBClick blindmethod=on_item_dbclick
end

@on_item_dbclick
set output_text_all
lib_ui method=listbox.getallchosen handle={main_listbox_output_handle} output=output_chosen
text type=replace text1={output_chosen} text2=| text3={endl} output=output_text
set line_count 1
call generate_clipboard_text
clipboard method=settext text=output_text_all
set output_text copied{space}to{space}clipboard!
lib_ui method=set.text handle={main_window_handle} title=output_text
thread title_update
end

@generate_clipboard_text
set output_text_line
set output_text_add
text type=readline text1={output_text} text2={line_count} output=output_text_line
if output_text_line!=null lib_ui method=listbox.getitemtext handle={main_listbox_output_handle} index={output_text_line} output=output_text_add
if output_text_line!=null set output_text_all {output_text_all}{output_text_add}{endl}
if output_text_line!=null simple_calc + {line_count} 1
if output_text_line!=null set line_count {simple_calc_result}
if output_text_add!=null call generate_clipboard_text
end

@title_update
sleep 1000
lib_ui method=set.text handle={main_window_handle} title=main_window_title
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
lib_ui method=redraw handle={main_button_stop_handle}

set start_tcping_bool true
set timeusedAll 0
set packet_loss 0
set packet_count 0
thread __start_tcping__loop
lib_ui method=listbox.clear handle={main_listbox_output_handle}
set lastoutput start{space}test{space}tcping{space}...
lib_ui method=listbox.additem handle={main_listbox_output_handle} title=lastoutput output=output_index
lib_ui method=listbox.settopviewitem handle={main_listbox_output_handle} index={output_index}
end

@__start_tcping__loop
call __start_tcping__loop({start_tcping_bool})
end

@__start_tcping__loop(true)
sock method=create type=tcp output=sockint
time start
sock method=connect host={ip} port={port} symbol={sockint} sucsymbol=istrue timeout={timeout}
call connectEnd({istrue})
sock method=closeconn symbol={sockint}
sock method=destroy symbol={sockint}
call __start_tcping__loop
end

@connectEnd(true)
time end
set timeuse {lasterror}
simple_calc + {timeusedAll} {timeuse}
set timeusedAll {simple_calc_result}
simple_calc + {packet_count} 1
set packet_count {simple_calc_result}
set output_text connected(timeused{space}{timeuse}ms)
if start_tcping_bool==true lib_ui method=listbox.additem handle={main_listbox_output_handle} title=output_text output=output_index
if start_tcping_bool==true lib_ui method=listbox.settopviewitem handle={main_listbox_output_handle} index={output_index}
end
@connectEnd(false)
simple_calc + {packet_loss} 1
set packet_loss {simple_calc_result}
set output_text connection failed
if start_tcping_bool==true lib_ui method=listbox.additem handle={main_listbox_output_handle} title=output_text output=output_index
if start_tcping_bool==true lib_ui method=listbox.settopviewitem handle={main_listbox_output_handle} index={output_index}
end
@stop_tcping
set start_tcping_bool false
simple_calc / {timeusedAll} {packet_count}
set lastoutput average{space}time{space}used:{space}{simple_calc_result}ms
lib_ui method=listbox.additem handle={main_listbox_output_handle} title=lastoutput output=output_index
lib_ui method=listbox.settopviewitem handle={main_listbox_output_handle} index={output_index}
simple_calc / {packet_loss} {packet_count}
simple_calc * 100 {simple_calc_result}
set lastoutput packet{space}loss:{space}{simple_calc_result}%
lib_ui method=listbox.additem handle={main_listbox_output_handle} title=lastoutput output=output_index
lib_ui method=listbox.settopviewitem handle={main_listbox_output_handle} index={output_index}
set lastoutput
lib_ui method=removestyle handle={main_button_start_handle} style=WS_DISABLED
lib_ui method=removestyle handle={main_editbox_port_handle} style=WS_DISABLED
lib_ui method=removestyle handle={main_editbox_ip_handle} style=WS_DISABLED
lib_ui method=removestyle handle={main_editbox_timeout_handle} style=WS_DISABLED
lib_ui method=addstyle handle={main_button_stop_handle} style=WS_DISABLED
lib_ui method=redraw handle={main_button_start_handle}
lib_ui method=redraw handle={main_button_stop_handle}
end

@on_user_close
echo user close
lib_ui method=exit
end
@main
sep load lib_ui echo clipboard simple_calc sleep sock text EnvComp time
call setEnv
call create_ui
call blind_events
lib_ui method=run
end


call main
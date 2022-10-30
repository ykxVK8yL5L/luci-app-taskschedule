require "luci.sys"
require "luci.http"

local m, s, o
m = Map("taskschedule", translate("General Settings"))


-- g = m:section(TypedSection, "taskschedule", "taskschedule")
-- g.anonymous = true
-- log_path = g:option(Value, "log_dir", translate("日志目录路径"))
-- log_path.rmempty = true
-- log_path.placeholder = "日志目录路径"
-- log_path.default = "/var/log/taskschedule/log/"


s = m:section(TypedSection, "tasks", translate("任务列表")
  , translate("任务列表."))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

name = s:option(Value, "name", translate("名称【英文】"))
name.rmempty = false
name.placeholder = "任务名称[英文]"


dm = s:option(Value, "shell", translate("命令"))
dm.rmempty = false
dm.placeholder = "shell命令"

remark = s:option(Value, "remark", translate("备注"))
remark.rmempty = true
remark.placeholder = "备注"

exec = s:option(Button, "exec_task", translate("执行"))
exec.inputstyle = "apply"
exec.write = function(self, section)
	ne = m.uci:get("taskschedule", section, "name")
	sl = m.uci:get("taskschedule", section, "shell")
	-- ld = m.uci:get("taskschedule", "@taskschedule[0]","log_dir")
	log_file = "/var/log/taskschedule-"..ne
	command="nohup "..sl..">"..log_file..".txt 2>&1 &"
	luci.sys.exec(command)
end

show_log = s:option(Button, "show_log", translate("日志"))
show_log.inputstyle = "apply"
show_log.write = function(self, section)
	ne = m.uci:get("taskschedule", section, "name")
	--luci.http.redirect(luci.dispatcher.build_url("admin", "services", "taskschedule", "log",ne))
	luci.http.redirect(luci.dispatcher.build_url("admin/services/taskschedule/log/"..ne))
end

return m
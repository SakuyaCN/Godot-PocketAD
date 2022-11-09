tool
extends Control

export(String) var version = "1.0.0"

onready var out = $Label2
#onready var editor_node = get_node("/root/EditorNode")
var interface:EditorInterface
var dialog
var exportNode
var export_manager
var is_need_reload = false

func _ready():
	pass
	#dialog = getExportDiaolog()
	#exportNode = getExportNode()
	#export_manager = getBaseNode("ExportTemplateManager")

func putMsg(msg,is_ok):
	out.newline()
	if is_ok:
		out.append_bbcode("[color=green]【成功】[/color]")
	else:
		out.append_bbcode("[color=red]【失败】[/color]")
	out.append_bbcode(msg)

func putWaring(msg):
	out.newline()
	out.append_bbcode("[color=grey]【警告】[/color]")
	out.append_bbcode(msg)

#检测模板
func _on_Button_pressed():
	is_need_reload = false
	putMsg("正在检测导出模板",true)
	var files = Directory.new()
	if files.open("res://android/build") == OK:
		putMsg("已安装导出模板",true)
		$VBoxContainer/Button2.disabled = false
	else:
		putMsg("没有安装导出模板，请点击编辑器最上方的【项目】->【安装Android构建模板】，安装完成后重新检测。",false)
		#export_template_manager->install_android_template();

#安装插件
func _on_Button2_pressed():
	var files = Directory.new()
	if files.open("res://addons/pocket_ad/asset") == OK:
		var err = files.copy("res://addons/pocket_ad/asset/GodotPocketAD.%s.release.aar" %version,"res://android/plugins/GodotPocketAD.%s.release.aar" %version)
		if err == OK:
			putMsg("安装aar成功！",true)
		else:
			putMsg("文件复制出错，错误代码%s" %str(err),true)
	else:
		putMsg("无法找到插件中的aar包，请确保是否将插件所以文件复制到addons中。",false)
	if files.open("res://addons/pocket_ad/asset") == OK:
		var err = files.copy("res://addons/pocket_ad/asset/GodotPocketAD.gdap","res://android/plugins/GodotPocketAD.gdap")
		if err == OK:
			putMsg("安装gdap成功！",true)
		else:
			putMsg("文件复制出错，错误代码%s" %str(err),true)
	else:
		putMsg("无法找到插件中的gdap文件，请确保是否将插件所以文件复制到addons中。",false)
	putMsg("插件安装成功",true)
	$VBoxContainer/Button3.disabled = false


func _on_Button3_pressed():
	var export_file = File.new()
	if export_file.open("res://export_presets.cfg",File.READ) == OK:
		export_file.close()
	else:
		var files = Directory.new()
		var err = files.copy("res://addons/pocket_ad/asset/export_presets.cfg","res://export_presets.cfg")
		if err == OK:
			putMsg("未发现导出配置，自动添加导出配置成功",true)
			is_need_reload = true
		else:
			putMsg("文件复制出错，错误代码%s" %str(err),true)
		#putMsg("未发现导出模板，请点击项目最上方[项目]->[导出]->[添加]，选择Android。",true)
	checkExportConfig()


var choose_index = 0
var choose_name = "preset.%s" %choose_index

func checkAndroid(config):
	if config.get_value(choose_name,"platform") != "Android":
		choose_index += 1
		choose_name = "preset.%s" %choose_index
		checkAndroid(config)
	return true

func checkExportConfig():
	var config = ConfigFile.new()
	config.load("res://export_presets.cfg")
	putMsg("开始检测导出配置...",true)
	if checkAndroid(config):
		choose_name += ".options"
		putMsg("检测到第%s栏导出项目为Android，检测参数中..." %str(choose_index+1),true)
		var use_custom_build = config.get_value(choose_name,"custom_build/use_custom_build")
		putMsg("	检测是否为自定义构建：%s" %use_custom_build,use_custom_build)
		if !use_custom_build:
			config.set_value(choose_name,"custom_build/use_custom_build",true)
			putMsg("		修改成功",true)
			is_need_reload = true
		var is_active_plugins = config.get_value(choose_name,"plugins/GodotPocketAD")
		putMsg("	检测是否启动插件[GodotPocketAD]：%s" %is_active_plugins,is_active_plugins)
		if !is_active_plugins:
			config.set_value(choose_name,"plugins/GodotPocketAD",true)
			putMsg("		修改成功",true)
			is_need_reload = true
		config.set_value(choose_name,"custom_build/min_sdk","21")
		putMsg("[min sdk]已调整值21",true)
		if config.get_value(choose_name,"keystore/debug") == "":
			putWaring("建议添加导出密钥[debug]")
		if config.get_value(choose_name,"keystore/release") == "":
			putWaring("建议添加导出密钥[release]")
		if config.get_value(choose_name,"package/unique_name") == "org.godotengine.$genname":
			putWaring("建议修改包名，在申请口袋工厂SDK的时候填写的，不要使用Godot自带的")
		var is_net = config.get_value(choose_name,"permissions/internet")
		putMsg("	检测是否为打开网络权限：%s" %is_net,is_net)
		if !is_net:
			config.set_value(choose_name,"permissions/internet",true)
			putMsg("		修改成功",true)
			is_need_reload = true
	config.save("res://export_presets.cfg")
	putMsg("请手动输入左侧渠道与口袋工厂插件的APPID",true)
	putMsg("	渠道可以任意填写，比如taptap，小米之类的",true)
	putMsg("	APPID则是你在口袋工厂申请后给的",true)
	$VBoxContainer/Control/LineEdit.editable = true
	$VBoxContainer/Control/LineEdit2.editable = true
	$VBoxContainer/Control/Button4.disabled = false
	#exportNode.get_child(0).start()
	#exportNode.call_deferred("update_export_presets")
	#dialog._tab_changed(1)
	#dialog.popup_export()
	#print(dialog.get_current_preset())
	
	
	#dialog.update_export_all()
	#for item in dialog.get_method_list():
	#	if item.name != null && item.name != "" && item.flags == METHOD_FLAG_NORMAL:
	#		print(item)
	#print(dialog.get_method_list())

func editKt(channel,appid):
	putMsg("正在配置你的Application",true)
	var files = Directory.new()
	if files.file_exists("res://android/build/src/com/godot/game/App.kt"):
		files.remove("res://android/build/src/com/godot/game/App.kt")
	var content = readFile("res://addons/pocket_ad/asset/App.kt")
	var _new = content.replace("{channel}",channel)
	var _new2 = _new.replace("{id}",appid)
	saveFile("res://android/build/src/com/godot/game/App.kt",_new2)
	putMsg("写入Applocation成功",true)
	
	putMsg("正在修改Manifest文件",true)
	var fest :String = readFile("res://android/build/AndroidManifest.xml")
	if fest.find("android:name=\".App\"") == -1:
		var app_index = fest.find("<application")
		if app_index != -1:
			fest = fest.insert(app_index+13,"android:name=\".App\" ")
			files.remove("res://android/build/AndroidManifest.xml")
			saveFile("res://android/build/AndroidManifest.xml",fest)
			putMsg("Manifest文件 修改成功",true)
	else:
		putMsg("Manifest文件已经配置无需修改",true)
	if is_need_reload:
		putMsg("请手动重新打开Godot编辑器",true)
		putMsg("请手动重新打开Godot编辑器",true)

func readFile(_path) ->String:
	var file = File.new()
	file.open(_path,File.READ)
	var content = file.get_as_text()
	file.close()
	return content

func saveFile(_path,content):
	var file = File.new()
	file.open(_path,File.WRITE)
	file.store_string(content)
	file.close()

func getExportDiaolog():
	for child in interface.get_base_control().get_children():
		if child.get_class() == "ProjectExportDialog":
			return child

func getExportNode():
	for child in interface.get_base_control().get_parent().get_parent().get_children():
		if child.get_class() == "EditorExport":
			return child

func getBaseNode(_name):
	for child in interface.get_base_control().get_children():
		if child.get_class() == "ExportTemplateManager":
			return child


func _on_Button4_pressed():
	if $VBoxContainer/Control/LineEdit.text.empty() || $VBoxContainer/Control/LineEdit2.text.empty():
		putMsg("请填写渠道与ID",false)
	else:
		var channel = $VBoxContainer/Control/LineEdit.text
		var appid = $VBoxContainer/Control/LineEdit2.text 
		putMsg("渠道：%s" %channel ,true)
		putMsg("APPID：%s" %appid,true)
		editKt(channel,appid)

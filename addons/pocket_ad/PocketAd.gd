extends Node

signal onRewardVideoADrResult(type)
signal onInterstitialADrResult(type)
signal onFullscreenVideoADResult(type)
	#type的返回值如下
	#loadAD() 调用加载广告
	#showAD() 展示广告
	#onFailed 广告加载失败
	#onSuccess() 广告加载成功
	#onADLoad() 广告加载成功，可在此回调后进行广告展示
	#onVideoCached() 视频素材缓存成功，可在此回调后进行广告展示
	#onADShow() 激励视频广告页面展示
	#onADExposure() 广告曝光时调用
	#onReward() 广告激励发放
	#onADClicked() 广告被点击时调用
	#onADClosed() 广告关闭时调用
	#onVideoComplete() 广告视频素材播放完毕
	#onSkippedVideo() 广告被跳过
	#onADLoaded() 广告预加载成功
	#onSkippedVideo() 广告被跳过
	#onPreload() 广告预加载加载成功
var ad_plugins = null

func _init():
	if OS.get_name() == "Android" && Engine.has_singleton("GodotPocketAD"):
		ad_plugins = Engine.get_singleton("GodotPocketAD")
		ad_plugins.connect("RewardVideoADListener",self,"RewardVideoADListener")
		ad_plugins.connect("InterstitialADListener",self,"InterstitialADListener")
		ad_plugins.connect("FullscreenVideoADListener",self,"FullscreenVideoADListener")
	else:
		print("无法初始化插件")

#激励广告监听
func RewardVideoADListener(type):
	emit_signal("onRewardVideoADrResult",type)

#插屏广告监听
func InterstitialADListener(type):
	emit_signal("onInterstitialADrResult",type)

#全屏视频监听
func FullscreenVideoADListener(type):
	emit_signal("onFullscreenVideoADResult",type)

#初始化sdk
func initPocketAD(channel:String,id:String) -> void:
	if ad_plugins != null:
		ad_plugins.initPocketAD(channel,id)

#展示激励广告
func preloadRewardVideoAD(id:String) -> void:
	if ad_plugins != null:
		ad_plugins.preloadRewardVideoAD(id)

#展示激励广告
func showRewardVideoAD() -> void:
	if ad_plugins != null:
		ad_plugins.showRewardVideoAD()

#预加载插屏广告
func preloadInterstitialAD(id:String) -> void:
	if ad_plugins != null:
		ad_plugins.preloadInterstitialAD(id)

#展示插屏广告
func showInterstitialAD() -> void:
	if ad_plugins != null:
		ad_plugins.showInterstitialAD()

#预加载全屏视频广告
func preloadFullscreenVideoAD(id:String):
	if ad_plugins != null:
		ad_plugins.preloadFullscreenVideoAD(id)

#全屏视频广告
func showFullscreenVideoAD() -> void:
	if ad_plugins != null:
		ad_plugins.showFullscreenVideoAD()

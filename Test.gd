extends Control


func _ready():
	PocketAd.connect("onRewardVideoADrResult",self,"onRewardVideoADrResult")
	PocketAd.connect("onInterstitialADrResult",self,"onInterstitialADrResult")
	PocketAd.connect("onFullscreenVideoADResult",self,"onFullscreenVideoADResult")

func onRewardVideoADrResult(type):
	print(type)

func onInterstitialADrResult(type):
	print(type)

func onFullscreenVideoADResult(type):
	print(type)

func _on_Button_pressed():
	PocketAd.preloadInterstitialAD("55345")

func _on_Button2_pressed():
	PocketAd.showInterstitialAD()


func _on_Button3_pressed():
	PocketAd.preloadFullscreenVideoAD("55337")

func _on_Button4_pressed():
	PocketAd.showFullscreenVideoAD()

func _on_Button5_pressed():
	PocketAd.preloadRewardVideoAD("55339")

func _on_Button6_pressed():
	PocketAd.showRewardVideoAD()

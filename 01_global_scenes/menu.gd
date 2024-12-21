extends Control

# ボタンのノードをkey、対応するシーンをvalueにしてDictionaryを作る。
@onready var scenes := {
	$Games/ClickGame: "res://10_click_pon/click_pon.tscn",
	$Games/DragGame: "res://11_drag_pon/drag_pon.tscn",
	$Games/ArrowGame: "res://12_yazirusi_pon/yazirusi_pon.tscn",
	$Games/WallGame: "res://13_kabe_pon/kabe_pon.tscn",
	$Games/WaniGame: "res://14_wani_pon/wani_pon.tscn",
	$Games/TimeGame: "res://15_tokei_pon/tokei_pon.tscn",
	$Games/DVD: "res://20_logo_pon/logo_pon.tscn",
	$Games/Color: "res://21_color_pon/color_pon.tscn",
}

func _ready() -> void:
	Global.hide() # メニュー画面では、もどるボタンを消す。

	# 各ボタンのButton.pressedシグナルを接続。
	# scenesの各valueをbindして、移動先のシーンへのパスも一緒に渡す。
	for key in scenes:
		key.pressed.connect(_on_button_click.bind(scenes[key]))

func _on_button_click(scene_path: String):
	Global.show() # もどるボタン復活
	# シーン移動。
	get_tree().change_scene_to_file(scene_path) 
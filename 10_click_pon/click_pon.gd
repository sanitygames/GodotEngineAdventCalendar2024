extends Node2D

var score := 0 # スコアの変数

func _ready() -> void:
	set_physics_process(false) #physics_process止める

# メインループ
func _physics_process(_delta: float) -> void:
	$Score.text = "あと%dびょう %dてん" % [$Timer.time_left, score] # スコア表示の更新

	if Input.is_action_just_pressed("left_click"): # 左クリックした?

		# 現在のマウス座標をget_global_mouse_position()で取得する。
		var mouse_position = get_global_mouse_position()

		# Gobotノード(TextureRect)の内側にmouse_positionがある?
		if $Gobot.get_global_rect().has_point(mouse_position):
			score += 1 # スコア加算
			move_gobot() # Gobotノード動かす

# Gobotノードを動かす関数
func move_gobot() -> void:
	# randf()関数で、0.0 ~ 1.0のランダムな値を得る。
	# 0.0なら画面左端、1.0なら画面右端みたいな線形補完をlerp(from, to, weight)でやる。
	# (GobotノードのRect基準が左上なので、右端,下端はRect.sizeでオフセットしてます)
	$Gobot.position.x = lerp(0.0, get_viewport_rect().end.x - $Gobot.size.x, randf())
	$Gobot.position.y = lerp(100.0, get_viewport_rect().end.y - $Gobot.size.y, randf())

# スタートボタンが押された時のアクション
func _on_start_button_pressed() -> void:
	$Title.hide() # タイトル隠す
	$Timer.start() # タイマースタート
	set_physics_process(true) # physics_process動かす

# タイマーがタイムアウトした時のアクション
func _on_timer_timeout() -> void:
	set_physics_process(false) # physics_process止める
	$Ending.show() # 終了画面表示

# リトライボタンが押された時のアクション
func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene() # 現在のシーンをリロード

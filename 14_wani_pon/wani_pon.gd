extends Node2D

# ワニのy座標がこれを超えたらゲームオーバー
const WANI_GAMEOVER_POSITION = -30
# ワニの動きにつかうノイズのリソースをエクスポート
@export var noise: Noise

var score := 0 # スコア
var level := 0.0 # ゲームレベル

@onready var wanis: Array = $Wanis.get_children() #ワニのノードを集める
var offsets = [-1.0, -1.0, -1.0, -1.0, -1.0] # ワニの位置のオフセット値の配列

func _ready() -> void:
	set_physics_process(false)
	noise.seed = randi() # ノイズのシード値を設定(ランダム)

# メインループ
func _physics_process(delta: float) -> void:
	level += delta * (score + 1) * 0.2 # 謎のレベル計算式
	
	$Score.text = "%dてん" % [score] # スコア表示の更新

	# 各ワニに対する処理
	for i in wanis.size():

		# ワニ位置のオフセット値の更新
		offsets[i] = min(offsets[i] + delta * 0.1, 0.0)

		# ノイズから得た数値にオフセット値を足す。
		# ノイズを走査する速度はレベルで速くなるため、だんだん動きが激しくなる。
		# valueは-1.0~1.0が入る。
		var value = (noise.get_noise_2d(i * 5.0, level) + 1.0) * 0.5 + offsets[i]

		# ノイズからの値(0.0 ~ 1.0) にオフセット値(-1.0 ~ 0.0)を足した数値でワニ位置が決まる。
		# 叩かれた直後はオフセットが-1。そこから時間経過でオフセットは最大0になる。
		# なので、時間の経過でだんだんとワニの位置がゲームオーバー位置に近づきやすくなる。
		
		# lerp(min, max, value)から各ワニのy座標を得る。
		# valueは-1から1で、0のときワニは画面上端。-1~0の間はワニが画面に出ないことになる。
		wanis[i].global_position.y = lerp(-800.0, 200.0, value)

		# ワニのy座標が閾値を超えたらゲームオーバー 
		if wanis[i].global_position.y > WANI_GAMEOVER_POSITION:
			game_over()

	# クリックされた時の処理
	if Input.is_action_just_pressed("left_click"):
		# 各ワニについて、クリック時のマウスカーソル座標がRectに含まれるか調べる。
		# 含まれていたら叩かれたと判定。オフセットを-1.0にしてスコアを加算
		for i in wanis.size():
			if wanis[i].get_global_rect().has_point(get_global_mouse_position()):
				offsets[i] = -1.0
				score += 1
	
# ここらへんは他といっしょ
func game_over() -> void:
	set_physics_process(false)
	$Ending.show()

func _on_start_button_pressed() -> void:
	$Title.hide()
	set_physics_process(true)

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
extends Node2D

const SPEEDUP_RATE = 20 # 壁のスピードの上昇率
const MAX_SPEED = 1400 # 壁の最高速
const MOVE_LIMIT = 200

var score := 0 # スコア
var speed := 200 # 壁の動くスピード
var wall: TextureRect = null # 壁への参照が入る変数

# 動く壁のノードの元になるノードが画面外に置いてあるので、それらへの参照を集める
@onready var wall_source := [$WallL, $WallR]

func _ready() -> void:
	set_physics_process(false)

# メインループ
func _physics_process(delta: float) -> void:
	$Score.text = "%dてん" % [score] # スコア表示の更新

	# wallがnullなら壁を生成する。その時スピードも1段上昇
	# min(speed, MAX_SPEED)で、設定した最高速は超えないようにする。
	if wall == null:
		wall = get_wall()
		speed = min(speed + SPEEDUP_RATE, MAX_SPEED)

	# 壁を動かす。
	wall.position.y += speed * delta

	# プレイヤーを動かす。
	# マウスのx位置と同期、でも画面端を超えちゃダメなのでclampを使う。
	# (画面端までいく必要もないので、更にオフセットしてる)
	$Player.global_position.x = clamp(get_global_mouse_position().x, MOVE_LIMIT, get_viewport_rect().end.x - MOVE_LIMIT)

	# 壁のRect内に、プレイヤーの中心が含まれていたら接触とみなし、ゲームオーバー
	if wall.get_global_rect().has_point($Player.global_position):
		game_over()
		return

	# 壁が画面外に出たら、壁をqueue_free()して消す。スコア加算
	# wall変数はnullになるので、次のphysics_processで壁の生成がされる。
	if wall.global_position.y > get_viewport_rect().end.y:
		wall.queue_free()
		score += 1

# wall_sourceのどちらかをランダムに選んで複製。
# add_child()してノードツリーに配置。参照を返す。
func get_wall() -> TextureRect:
	var w = wall_source.pick_random().duplicate()
	add_child(w)
	move_child(w, 0)
	return w

# あとは他とだいたい一緒
func game_over() -> void:
	set_physics_process(false)
	$Ending.show()

func _on_start_button_pressed() -> void:
	$Title.hide()
	set_physics_process(true)

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

extends Node2D

var score := 0 # スコアの変数

# 上下左右のキーワードをenum Directionとして定義
enum Direction {UP, LEFT, DOWN, RIGHT} 

var gobot_direction := Direction.UP # 光るgodot(正解)の位置が入る変数
var input_direction := Direction.UP # キー入力の状態が入る変数

# 各gobotノードへの参照をコレクション
@onready var gobots := {
	Direction.UP: $GobotUp,
	Direction.LEFT: $GobotLeft,
	Direction.DOWN: $GobotDown,
	Direction.RIGHT: $GobotRight,
}

func _ready() -> void:
	set_physics_process(false)

# メインループ
func _physics_process(_delta: float) -> void:
	$Score.text = "あと%dびょう %dてん" % [$Timer.time_left, score] # スコア表示の更新

	# 各方向キーが入力されたら、input_directionを更新
	if Input.is_action_pressed("up"):
		input_direction = Direction.UP
	elif Input.is_action_pressed("left"):
		input_direction = Direction.LEFT
	elif Input.is_action_pressed("down"):
		input_direction = Direction.DOWN
	elif Input.is_action_pressed("right"):
		input_direction = Direction.RIGHT

	# デバッグ用ラベルの更新。enumはDictionary.keys()とか使えます。
	$DebugGobot.text = "Gobot is " + Direction.keys()[gobot_direction] 
	$DebugInput.text = "Input is " + Direction.keys()[input_direction]

	# 正しいキーが押されたらスコア加算、問題の更新
	if gobot_direction == input_direction: 
		score += 1 # スコア加算
		# 次に光るgobotを決める
		# (次は違う場所を正解にしたいので余りとかあれこれする。
		# あと、Directionにintを代入するwarningが多分出ますが、まぁ。)
		gobot_direction = (gobot_direction + 1 + (randi() % (Direction.size() - 1))) % Direction.size()

		# gobotsのキーと比較して、該当のノードを点灯、それ以外は消灯
		for key in gobots:
			gobots[key].modulate.a = 1.0 if key == gobot_direction else 0.3

# スタートボタン または リトライボタンが押された時のアクション
func _on_start_button_pressed() -> void:
	$Title.hide() # タイトル隠す
	$Ending.hide() # 終了画面隠す
	$Timer.start() # タイマースタート
	score = 0 # スコアリセット
	set_physics_process(true) # physics_process動かす

# タイマーがタイムアウトした時のアクション
func _on_timer_timeout() -> void:
	set_physics_process(false) # physics_process止める
	$Ending.show() # 終了画面表示

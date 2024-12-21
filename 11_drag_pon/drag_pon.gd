extends Node2D

var score := 0 # スコアの変数
var enemy_count := 1 #敵(赤いGobot)の数
var select_rect: Rect2 = Rect2() #範囲選択のRect用変数

@onready var gobots = $Gobots.get_children() #Gobots以下の子ノードが全部入った配列

func _ready() -> void:
	set_physics_process(false) # いったんphysics_process止める

# メインループ
func _physics_process(_delta: float) -> void:
	$Score.text = "あと%dびょう %dてん" % [$Timer.time_left, score] # スコア表示の更新

	# 左クリックが始まったら、範囲選択Rectの原点をクリック位置にする
	if Input.is_action_just_pressed("left_click"):
		select_rect.position = get_global_mouse_position()

	# 左マウスボタンが押されている間、範囲選択Rectの原点対角を更新
	elif Input.is_action_pressed("left_click"):
		select_rect.end = get_global_mouse_position()

	# 左マウスボタンを離したら、いろいろやる
	elif Input.is_action_just_released("left_click"):
		# Rect2同士の重なりを調べる際、sizeが正じゃないとダメなので、Rect2.abs()をする。
		# (Rect2の右下がposition、左上がendの場合、sizeは負になるです。abs()で良い感じになる)
		select_rect = select_rect.abs()

		# 範囲選択と、各Gobotの重なりをRect2.intersection(other: Rect2)で調べる
		# (敵と味方の区別はmodulateを使って判定しています)
		for gobot in gobots: 
			if select_rect.intersection(gobot.get_global_rect()): 
				# gobotが普通の色(modulateが白)なら1点
				if gobot.modulate == Color.WHITE:
					score += 1
				# それ以外のgobotが範囲選択に含まれていたらゲームオーバーへ
				else:
					game_over() 
					return # 即ループを抜け
		# ステージの更新
		# 敵の数を更新(プラス5ずつ増える。min()で1個は味方gobotがあるようにする)
		enemy_count = min(enemy_count + 5, gobots.size() - 1)
		change_gobots_modulate(enemy_count) # 各gobotの色を変えるサブルーチンへ
		select_rect = Rect2() # 範囲選択をクリア

	# 範囲選択の四角形の描画を更新
	queue_redraw()

# 各gobotsの色分けをする
func change_gobots_modulate(_enemy_count: int) -> void:
	# 各gobotノードへの参照が入っているgobots配列をシャッフル
	# [$Gobot1, $Gobot2, $Gobot3, ..., $GobotN]が、[$Gobot42, $Gobot3, $Gobot99, ...]とかになる。
	# gobotノードへの参照のコレクションの並びが変わるだけで、ノードツリーの構造が変わるわけではないです。
	gobots.shuffle()
	for i in gobots.size():
		# gobots配列のインデックスが_enemy_count未満ならmodulateを赤に、それ以外なら白
		gobots[i].modulate = Color.RED if i < _enemy_count else Color.WHITE

# queue_redraw()等々のタイミングで_draw()が呼ばれる。
func _draw() -> void:
	draw_rect(select_rect, Color(Color.YELLOW, 0.3)) # 半透明黄色の四角をselect_rectの大きさで描く
	draw_rect(select_rect, Color.WHITE, false, 1.0) # 白の外形線も描く

# ゲームオーバー時の処理
func game_over():
	set_physics_process(false) # physics_process止める
	$Timer.stop() # Timer止める
	$Ending.show() # 終了画面表示

# スタートボタン または リトライボタンが押された時のアクション
func _on_start_button_pressed() -> void:
	$Title.hide() # タイトル隠す
	$Timer.start() # タイマースタート
	change_gobots_modulate(enemy_count) # 敵と味方のgobotを設定する
	set_physics_process(true) # physics_process動かす

# タイマーがタイムアウトした時のアクション
func _on_timer_timeout() -> void:
	game_over() # ゲームオーバーへ

# リトライボタンが押された時のアクション
func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene() # 現在のシーンをリロード
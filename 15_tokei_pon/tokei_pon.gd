extends Node2D

const TARGET = 3.14 # ターゲットとなる秒数

var score := 0 # スコア
var time := 0.0 # 経過時間
var message_alpha := 0.0 # 評価ラベルの透明度
var target_time := TARGET # 次のターゲット秒数

# スコア評価用の配列
var time_delta_thresholds := [0.01, 0.1, 0.2, 0.4, 0.8, 1.0]
var messages := ["Perfect", "Cool", "Great", "Good", "OK", "Danger"]

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	time += delta # delta時間を加算
	message_alpha -= delta # 評価ラベルの透明度をdeltaで減算(good! とかがだんだん消える)
	# 各Label.textの更新
	$Score.text = "%dてん" % [score]
	$Time.text = "%03.2f" % time
	$Target.text = "もくひょう%sびょう" % [target_time]

	# 各Labelの透明度の更新
	# inverse_lerp()することで、timeが15.0のとき0.0、0のとき1.0を得る
	$Time.modulate.a = inverse_lerp(15.0, 0.0, time)
	$Rank.modulate.a = message_alpha
	$Target.modulate.a = $Time.modulate.a

	# クリックした時の処理
	if Input.is_action_just_pressed("left_click"):
		# ターゲットの秒数と実際の秒数の差の絶対値で、time_delta_thresholdsをbinary_searchする。
		# 差が0.0秒なら0, 0.79秒なら4 1秒以上なら6が戻ってくる。
		var idx = time_delta_thresholds.bsearch(abs(target_time - time))
		# そのままだと使いづらいので、6 - idxする。
		# 0~6点がscore_powに入る。
		var score_pow = time_delta_thresholds.size() - idx

		# 0点ならゲームオーバー
		if score_pow <= 0:
			game_over()
		else:
			# 1点以上ならスコア加算、ターゲット時間更新
			score += 2 ** score_pow 
			target_time += TARGET
			# 評価のラベルも内容を更新、アルファも1.0にして表示
			message_alpha = 1.0
			$Rank.text = messages[idx]

# 他とだいだい一緒
func game_over():
	set_process(false)
	$Ending.show()

func _on_start_button_pressed() -> void:
	$Title.hide()
	set_process(true)

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()


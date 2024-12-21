extends Node2D

const SPEED = 120.0 # 移動スピード
var direction := Vector2.ONE # 移動方向の単位ベクトル

func _physics_process(_delta: float) -> void:
	var logo_global_rect = $Logo.get_global_rect() # GodotLogoのRectを取得
	var viewport_rect = get_viewport_rect() #ViewportのRectを取得

	# ロゴが画面外に出たら移動方向を反射させる。色も変える
	if logo_global_rect.position.x < 0 || logo_global_rect.end.x > viewport_rect.end.x:
		change_logo_color()
		direction.x *= -1
	if logo_global_rect.position.y < 0 || logo_global_rect.end.y > viewport_rect.end.y:
		change_logo_color()
		direction.y *= -1
	
	# ロゴの位置 = 現在の位置 + (方向の単位ベクトル * 速度 * デルタ時間)
	$Logo.global_position += direction * SPEED * _delta

# 色を変える
func change_logo_color() -> void:
	$Logo.modulate.h = randf()
	$Logo.modulate.s = randf()

# スタートボタンが押された時のアクション
func _on_start_button_pressed() -> void:
	$Title.hide()

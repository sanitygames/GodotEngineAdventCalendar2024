extends CanvasLayer

# グローバルって名前が変。
# もどるボタンを表示するために、他のシーンにオーバーラップするCanvasLayer
# グローバルノードにしているので、基本的にどのシーンでも表示されることになる。

# hide(hキー)で、表示非表示の切り替え
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hide"):
		visible = !visible

# もどるボタンが押されたらメニューシーンにいく。
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://01_global_scenes/menu.tscn")

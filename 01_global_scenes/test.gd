extends Node2D

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_rect($Player.get_rect(), Color(Color.YELLOW, 0.5))
	draw_rect($Player.transform * $Player.get_rect(), Color(Color.RED, 0.5))
extends Node2D

func _ready() -> void:
    # jsonファイルからDictionaryを生成
    # 内容についてはpathから参照してください。
    # 最終的にgodotのColorクラスが定数として持っている色情報の配列(color_data_array)を得る。
    var json_file_path = "res://00_resource/godot_color.json"
    var color_data_dict = load_json(json_file_path)
    var color_data_array = color_data_dict.godot_colors

    for cd in color_data_array:
        # 画面外に置いてあるGodotMasterノード(TextureRect)を複製
        var gobot = $GobotMaster.duplicate()
        # cd(Dictionary)から色名と色値をもってきて、ノード名とself_modulationに使う
        gobot.name = cd.name
        gobot.self_modulate = Color(cd.r, cd.g, cd.b, cd.a)
        # gobot(TextureRectノード)が持っている、mouse_entered, mouse_exitedシグナルを
        # 使いたいのでconnectする。その時に「シグナルを発したノード自身への参照」も欲しいので、
        # bind(gobot)する。
        gobot.mouse_entered.connect(_on_gobot_mouse_entered.bind(gobot))
        gobot.mouse_exited.connect(_on_gobot_mouse_exited.bind(gobot))
        $Gobots.add_child(gobot)

# gobotにマウスカーソルが乗ったときのアクション
func _on_gobot_mouse_entered(gobot: TextureRect) -> void:
    # Labelの内容を更新。gobotのノード名と、self_modulateの値を出力します。
    $ColorName.text = "Color.\n" + gobot.name
    $ColorCode.text = "Color%s" % [gobot.self_modulate]
    gobot.scale = Vector2.ONE * 1.5 # gobotのスケールも大きくする。

# gobotからマウスカーソルが外れたときのアクション
func _on_gobot_mouse_exited(gobot: TextureRect) -> void:
    # ラベルの内容をクリア。 
    $ColorName.text = ""
    $ColorCode.text = ""
    gobot.scale = Vector2.ONE # gobotのスケールも元に戻す

# 各ボタンが押された時のアクション
func _on_hsv_button_pressed() -> void:
    sort_gobots(sort_by_hsv) 
func _on_rgb_button_pressed() -> void:
    sort_gobots(sort_by_rgb)
func _on_name_button_pressed() -> void:
    sort_gobots(sort_by_name)

# gobotちゃんを並べかえるサブルーチン。引数にソート用の関数を取る
func sort_gobots(sorter: Callable) -> void:
    var gobots = $Gobots.get_children() # Gobotsノードの子ノードを集める
    gobots.sort_custom(sorter) # sorterを使ってソートする
    # move_child(child_node, to_index)で、ノードの並べ順を変える。
    # $GobotsノードはGridContainerなので、子ノードの並べ順を変えると位置が自動的に変わる。
    for i in gobots.size():
        $Gobots.move_child(gobots[i], i)

# hsvでソートする用のソーター関数
# hが同値ならs,sも同値ならvの2値を比較して、boolを返す
func sort_by_hsv(a, b) -> bool:
    if a.self_modulate.h == b.self_modulate.h:
        if a.self_modulate.s == b.self_modulate.s:
            return a.self_modulate.v > b.self_modulate.v
        else:
            return a.self_modulate.s > b.self_modulate.s
    else:
        return a.self_modulate.h > b.self_modulate.h

# rgbでソート、上とほぼいっしょ
func sort_by_rgb(a, b) -> bool:
    if a.self_modulate.r == b.self_modulate.r:
        if a.self_modulate.g == b.self_modulate.g:
            return a.self_modulate.b > b.self_modulate.b
        else:
            return a.self_modulate.g > b.self_modulate.g
    else:
        return a.self_modulate.r > b.self_modulate.r

# ノードの名前で。
func sort_by_name(a, b) -> bool:
    return a.name < b.name

# jsonをDictionaryにして返すやつ。
func load_json(file_path: String) -> Dictionary:
    var file = FileAccess.open(file_path, FileAccess.READ)
    if file:
        var content = file.get_as_text()
        file.close()
        var json = JSON.new()
        var _e = json.parse(content)
        if _e == OK:
            return json.data
    assert(false, "JSON Load Error")
    return {}

# スタートボタンが押された時のアクション
func _on_start_button_pressed() -> void:
    $Title.hide() # タイトル画面を隠す

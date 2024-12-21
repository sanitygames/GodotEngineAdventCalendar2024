extends Node

func _ready() -> void:
    var file_path = "res://00_resource/godot_color.txt"
    var master_text = read_file(file_path)
    var data_array = []
    if master_text != null:
        data_array = master_text.split("\n")
    print(master_text)
    var master_array = []

    for t in data_array:
        var ta = t.split(" = ")
        var color_name = ta[0]
        var color_rgba = ta[1]
        var rgba = color_rgba.split(",")
        print(rgba)
        var r = float(rgba[0].split("(")[1])
        var g = float(rgba[1])
        var b = float(rgba[2])
        var a = float(rgba[3].split(")")[0])
        var color_dict = {}
        color_dict.color = "Color." + color_name
        color_dict.name = color_name
        color_dict.r = r
        color_dict.g = g
        color_dict.b = b
        color_dict.a = a
        master_array.push_back(color_dict)

    var master_dict = {
        "godot_colors": master_array,
    }

    var save_file_path = "res://00_resource/godot_color.json"
    var success = save_json(save_file_path, master_dict)
    print(success)




func save_json(fp: String, data: Dictionary) -> bool:
    var file = FileAccess.open(fp, FileAccess.WRITE)
    if file:
        var json_string = JSON.stringify(data, "\t")
        file.store_string(json_string)
        file.close()
        return true
    else:
        return false



func read_file(fp: String):
    var file = FileAccess.open(fp, FileAccess.READ)
    if file:
        var content = file.get_as_text()
        file.close()
        return content
    else:
        return null

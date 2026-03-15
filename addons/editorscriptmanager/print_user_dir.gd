@tool
extends EditorScript

func _run():
    var dir = OS.get_data_dir()
    print(dir)
    OS.alert(dir)
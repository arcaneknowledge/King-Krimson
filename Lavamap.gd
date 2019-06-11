extends TileMap


var invert = false
var tile_list = [0,1,2,3,4,]
var tile_list_rev = [5,4,3,2,1,]

func _ready():
	$TimeAnim.start()


func _on_TimeAnim_timeout():
	if invert == false:
		change_tile(tile_list)
	if invert == true:
		change_tile(tile_list_rev)
	
	invert = !invert
	$TimeAnim.start()


func change_tile(t):
	for i in t:
		var all_id = get_used_cells_by_id(i)
		for j in all_id:
			if invert == false:
				set_cell(j.x, j.y, i+1)
			else:
				set_cell(j.x, j.y, i-1)
	
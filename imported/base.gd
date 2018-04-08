extends Node

var b_id = null
var b_gfx = null
var b_kind = null
var b_size = Vector2(0, 0)
var b_rotate = null
var b_anim_add = null
var b_can_be_built = false

var b_position = Vector2(0, 0)

var config = null

func init(settings):
	config = settings

func located_at(tile_pos):
	return b_position.x <= tile_pos.x and tile_pos.x < b_position.x + b_size.x and \
		   b_position.y <= tile_pos.y and tile_pos.y < b_position.y + b_size.y

func draw_field(map, pos, rotation, animation_step):
	var sx = b_size.x if rotation % 2 == 0 else b_size.y
	var sy = b_size.y if rotation % 2 == 0 else b_size.x
	for y in range(sy):
		for x in range(sx):
			map.set_cellv(pos + Vector2(x, y), get_tile_id(x, y, rotation, animation_step))

func get_tile_id(x, y, rotation, animation_step):
	var tile_id = 1 + b_gfx
	if b_rotate > 0:
		tile_id += rotation * b_size.x * b_size.y # Rotate?
	tile_id += animation_step * b_anim_add
	
	if rotation == 0:
		tile_id += y * b_size.x + x
	elif rotation == 1:
		tile_id += b_size.x * b_size.y - 1 - (x * b_size.x + (b_size.x - 1 - y))
	elif rotation == 2:
		tile_id += (b_size.y - 1 - y) * b_size.x + (b_size.x - 1 - x)
	elif rotation == 3:
		tile_id += x * b_size.x + (b_size.x - 1 - y)
	else:
		assert(false)
	return tile_id

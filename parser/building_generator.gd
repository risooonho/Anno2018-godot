extends Node

const BUILDING_PATH = "user://imported/buildings"

func generate_buildings(object_data):
	var output_dir = Directory.new()
	if output_dir.dir_exists(BUILDING_PATH):
		return
	assert(output_dir.make_dir_recursive(BUILDING_PATH) == OK)
	
	for item in object_data['objects']['HAUS']['items'].values():
		assert(item.has("Kind"))
		assert(item.has('Gfx'))
		assert(item.has('Id'))
		assert(item.has("Size"))
		assert(item.has("Rotate"))
		#assert(item['Size']['x'] * item['Size']['y'] == item['Rotate'])
	
		if item['Kind'] in [
				'GEBAEUDE', 'HQ', 
				'STRASSE', 'BRUECKE', 'PLATZ', 
				'WMUEHLE', 
				'MINE', 
				'MAUER', 'MAUERSTRAND', 'TOR', 'TURM', 'TURMSTRAND',
			]:
			dump_building(item)
		elif item['Kind'] in [
			'BODEN', 
			'FLUSS', 'FLUSSECK',
			'HANG', 'HANGQUELL', 'HANGECK',
			'STRAND', 'STRANDMUND', 'STRANDRUINE', 'STRANDECKI', 'STRANDECKA', 'STRANDVARI',
			'BRANDUNG', 'BRANDECK',
			'PIER',
			'MEER', 'WALD', 'RUINE',  'STRANDHAUS', 
			'HAFEN', 'FELS',
			'MUENDUNG']:
			dump_land(item)
		else:
			print(item['Kind'])
			assert(false)

func dump_land(item):
	var output_dir = Directory.new()
	assert(output_dir.open(BUILDING_PATH) == OK)

	var id = item['Id']
	var gfx = item['Gfx']
	var kind = item['Kind']
	var size = Vector2(item['Size']['x'], item['Size']['y'])
	var rotate = item['Rotate']
	var anim_add = item['AnimAdd']
	
	dump_file(output_dir, id, "gd", """#
# This file has been GENERATED. DO NOT EDIT THIS FILE.
#

extends "res://imported/base.gd"
func init(config, rauch_animations):
	b_id = %s
	b_gfx = %s
	b_kind = "%s"
	b_size = Vector2(%s, %s)
	b_rotate = %s
	b_anim_add = %s
	
	.init(config, rauch_animations)""" % [id, gfx, kind, size.x, size.y, rotate, anim_add])

	dump_tscn(output_dir, id)

func dump_building(item):
	var output_dir = Directory.new()
	assert(output_dir.open(BUILDING_PATH) == OK)

	var id = item['Id']
	var gfx = item['Gfx']
	var kind = item['Kind']
	var size = Vector2(item['Size']['x'], item['Size']['y'])
	var rotate = item['Rotate']
	var anim_add = item['AnimAdd']
	var gfx_menu = 154 # TODO
	
	var can_be_built = null
	var gfx_bau = null
	if item.has('Baugfx'):
		gfx_bau = item['Baugfx']
		can_be_built = "true"
	else:
		gfx_bau = "null"
		can_be_built = "false"
		
	dump_file(output_dir, id, "gd", """#
# This file has been GENERATED. DO NOT EDIT THIS FILE.
#

extends "res://imported/base_building.gd"
func init(config, rauch_animations):
	b_id = %s
	b_name = "%s"
	b_gfx = %s
	b_kind = "%s"
	b_size = Vector2(%s, %s)
	b_rotate = %s
	b_anim_add = %s
	b_gfx_menu = %s
	b_gfx_bau = %s
	b_can_be_built = %s
	
	.init(config, rauch_animations)""" % [id, gfx, gfx, kind, size.x, size.y, rotate, anim_add, gfx_menu, gfx_bau, can_be_built])
	
	dump_tscn(output_dir, id)

func dump_tscn(output_dir, id):
	dump_file(output_dir, id, "tscn", """[gd_scene load_steps=2 format=2]

[ext_resource path="%s/%s/%s.gd" type="Script" id=1]

[node name="%s" type="Node"]

script = ExtResource( 1 )


""" % [output_dir.get_current_dir(), id, id, id])

func dump_file(output_dir, id, extension, content):
	if not output_dir.dir_exists(str(id)):
		assert(output_dir.make_dir(str(id)) == OK)
	
	var file = File.new()
	assert(file.open(output_dir.get_current_dir() + "/" + str(id) + "/" + str(id) + "." + extension, File.WRITE) == OK)
	file.store_string(content)
	file.close()

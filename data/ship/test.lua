return {
	ship_name = "test", 
	grade = 5,
	scale = 30,
	matt = 2000,
	struct_max = 200,
	energy_max = 100,
	energy_generate_effect = 5,
	verts = {0,-1,1,1,0,0.5,-1,1},
	slot = {
		{socket = "universal",offx = 0.3, offy = -0.3, rot = 1/12,enabled = true},
		{socket = "universal",offx = -0.3, offy = -0.3, rot = -1/12,enabled = true},
		{socket = "universal",offx = 0, offy = -0.8, rot = 0,enabled = true},
		{socket = "universal",offx = -0.2, offy = 0.5, rot = 1,enabled = true},
		{socket = "universal",offx = 0.2, offy = 0.5, rot = 1,enabled = true},
		{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
		{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
		{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
		{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},
		{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},	
		{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},	
		{socket = "universal",offx = 0,offy = 0,rot = 0,enabled = true},	
		},
	mod_conf = {
		obj.module.weapon.laser,
		--obj.module.weapon.weapon,
		--obj.module.weapon.weapon,
		obj.module.engine.engine,
		obj.module.engine.engine,
		obj.module.cockpit.base,
		obj.module.hud.base,
		obj.module.radar.visible_radar,
		obj.module.system.teleport,
		obj.module.radar.energy_radar,
		obj.module.radar.fire_control,
		obj.module.system.shield,
		obj.module.radar.analyser
	},
	stock = {

	},
	price = {r = 100,g = 200,b = 300,p = 50,y = 30}

}
return {
	obj_name = "test", 
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
		cls.mod.weapon["激光"],
		--obj.module.weapon.weapon,
		--obj.module.weapon.weapon,
		cls.mod.engine["灰熊"],
		cls.mod.engine["灰熊"],
		cls.mod.system["驾驶舱"],
		cls.mod.system["视图"],
		cls.mod.radar["雄鹰"],
		cls.mod.system["短距传送"],
        cls.mod.radar["蝰蛇"],
		cls.mod.radar["蟾蜍"],
		cls.mod.system["护盾"],
		cls.mod.radar["分析"]
	},
	stock = {

	},
	price = {r = 100,g = 200,b = 300,p = 50,y = 30}

}
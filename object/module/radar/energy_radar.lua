local radar = class("energy_radar",obj.module.radar.base)
radar.heat = 1
radar.mod_name = "energy_radar"
radar.radius = 5000
radar.detect_type = "energy"

return radar
local radar = class("visible_radar",obj.module.radar.base)
radar.heat = 1
radar.mod_name = "base_radar"
radar.socket = "radar"
radar.radius = 5000
radar.detect_type = "analyse"

return radar
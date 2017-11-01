local radar = class("ana_radar",obj.module.radar.base)
radar.heat = 1
radar.mod_name = "analyser"
radar.socket = "radar"
radar.radius = 3000
radar.detect_type = "analyse"

return radar
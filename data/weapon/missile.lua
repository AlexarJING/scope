return {
socket = "weapon",
mod_name = "导弹",
heat_radiating = 40,
heat_volume = 100,
heat_per_sec = 0,


cool_down = 1, --发射间隔
chargeTime = 0, --充能时间
heat_per_shot = 3, --单次发射的热量
heat_radiating = 5,
fire_count = 1, --单次发射的子弹量
fire_offset = 0, --子弹的旋转偏移（可模拟子弹不精确，或随机子弹角度）

autoFire = false, --自动开火
autoFireRange =  1300, --自动开火范围

autoTarget = true, --自动寻的(武器自转)
target_type = "ship", --寻的类型 ship/bullet/all
rotSpeed = Pi,--旋转速度 弧度/s
rotLimit = Pi/4, --单侧旋转角度限制


bullet = obj.others.bullet, --放出子弹类型 bullet/missile/decoy(分散放出型，诱使武器自爆)
struct = 0.01,
scale = 20 ,--子弹碰撞大小
activeTime = 10, --子弹存活时间
activeRange = 2500, --有效射程
tracing = true, --跟踪能力
initVelocity = 0, --发射初速度
pushPower = 10, --自带推力
turnPower = 50, --自带扭力
linearDamping = 1, --线性速度衰减
angularDamping = 3, --旋转速度限制，提高力量的同时提高限制，提升灵敏程度，不至于跳
damage_type = "struct",--伤害类型 structure/energy/quantum(量子伤害，真实伤害，无差别的伤害)
bullet_tag = "missile",
damage_point = 50,
explosion_range = 0, --碰撞后伤害半径如为0则单体伤害
through = 0, --碰撞后穿透 层数3 0为不穿透
verts = {0,-0.5,0.3,0.3,-0.3,0.3},
bullet_heat_generate = 50
}
local buff = {}
buff.time_last = 0
buff.count_last = 0
buff.tag = ""
buff.erease = 0 -- 1 主动祛除/被动祛除/无法祛除
buff.grade = 0 --级别 用于祛除/叠加替换/目标差异
buff.pile = 0 -- 直接叠加、高级替换低级、效果叠加
buff.caster = nil --释放者信息（如吸取能量等buff）
buff.share = {} --共享状态列表，同一buff的复数影响（光环）

function buff.apply()
    
    
end



return buff


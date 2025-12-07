local toolkits = require("treeToolkit/toolkits1314")

local redmod = {}

----------------------------------------------------------------
function redmod:TableCheck(CheckValue, CheckTable)
    for index, value in ipairs(CheckTable) do
        if CheckValue == value then
            return true
        end
    end
    return false
end

function redmod:checkWeaponOn()
    local player = toolkits:getMasterPlayerUtils().masterPlayer
    return player:isWeaponOn() -------------------纳刀也算收起武器，难绷
end

function redmod:getJumpFlag() -- 0 为站立，1 为蹲，2 为起跳，3 为下落？，4 为无
    local playerAction = toolkits:getMasterPlayerUtils().masterPlayer:call("get_RefPlayerAction()")
    local JumoFlag = playerAction:get_field("PlayerStatus")
    return JumoFlag
end
function redmod:nothing(retval)
    return retval
end

function redmod:getModeType() --武器模式，例如盾斧的不同形态就有不同的值，其他武器同理。
    local GUIMANAGER = sdk.get_managed_singleton("snow.gui.GuiManager")
    if not GUIMANAGER then
        return
    end
    local GuiHud_Training = GUIMANAGER:call("get_refGuiHud_TrainingInfo()")
    if not GuiHud_Training then
        return
    end
    local ModeType = GuiHud_Training:call("get__ActionTipsType()")
    return ModeType
end

function redmod:checkMotIdof(minId, maxId)
    local player = toolkits:getMasterPlayerUtils().masterPlayer
    if not player then
        return false
    end
    local Fsm = player:get_field("_RefMotionFsm2")
    local motId = player:call('getMotionID_Layer(System.Int32)', 0)

    return (motId >= minId) and (motId <= maxId)
end

function redmod:checkMotId(Id)
    local player = toolkits:getMasterPlayerUtils().masterPlayer
    if not player then
        return false
    end
    local motId = player:call('getMotionID_Layer(System.Int32)', 0)
    return motId == Id
end

function redmod:checkMotId_tb(Id_tb)
    local player = toolkits:getMasterPlayerUtils().masterPlayer
    if not player then
        return false
    end
    local motId = player:call('getMotionID_Layer(System.Int32)', 0)
    for i = 1, #Id_tb do
        if motId == Id_tb[i] then
            return true
        end
    end
    return false
end

function redmod:setMotionID(actionIndex, value)
    local motion = toolkits:getActionObject(actionIndex)
    motion:set_MotionID(value)
end

function redmod:getMotId()
    local player = toolkits:getMasterPlayerUtils().masterPlayer
    if not player then
        return false
    end
    return player:call("getMotionID_Layer(System.Int32)", 0)
end

function redmod:getMotBank()
    local player = toolkits:getMasterPlayerUtils().masterPlayer
    if not player then
        return false
    end
    return player:call("getMotionBankID_Layer(System.Int32)", 0)
end
function redmod:get_player_component(playerbase, component_type)
    return playerbase:call("get_GameObject"):call("getComponent(System.Type)", sdk.typeof(component_type))
end
function redmod:setDamageReduce(rate, time)

    local PlayerQuestBase = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer,
        "snow.player.PlayerQuestBase")
    local DamageReduceRate = PlayerQuestBase:set_field("_DamageReduceRate", rate)
    local DamageReducetime = PlayerQuestBase:set_field("_DamageReduceTimer", time * 60)

end

function redmod:getDamageReduce()

    local PlayerQuestBase = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer,
        "snow.player.PlayerQuestBase")
    local Rata = PlayerQuestBase:get_field("_DamageReduceRate")
    local Timer = PlayerQuestBase:get_field("_DamageReduceTimer")
    return {Rata, Timer}

end
function redmod:setHyperArmor(time)

    local PlayerQuestBase = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer,
        "snow.player.PlayerQuestBase")

    local HyperArmor = PlayerQuestBase:set_field("_HyperArmorTimer", time * 60)

end
-- 斩斧

function redmod:setAwakeTime(value)

    local chuizi = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer, "snow.player.SlashAxe")
    local chuizibuff = chuizi:set_field("_BottleAwakeDurationTimer", value)

end

function redmod:getAwakeTime()

    local chuizi = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer, "snow.player.SlashAxe")
    return chuizi:get_field("_BottleAwakeDurationTimer")

end

function redmod:getBottleGaugeLow()

    local chuizi = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer, "snow.player.SlashAxe")
    return chuizi:get_field("_BottleGaugeLow")

end

function redmod:setBottleGauge(value)

    local chuizi1 = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer, "snow.player.SlashAxe")
    chuizi1:set_field("_BottleGauge", value)

end
function redmod:getBottleGauge()

    local chuizi1 = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer, "snow.player.SlashAxe")
    if chuizi1 == nil then
        return 0
    end
    return chuizi1:get_field("_BottleGauge")

end
function redmod:setBottleRecoverValue(value)

    local chuizi1 = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer, "snow.player.SlashAxe")
    if not chuizi then
        return
    end
    chuizi1:set_field("_BottleRecoverValue", value)

end

function redmod:checkAwake()

    local SlashAXE = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer, "snow.player.SlashAxe")
    if not SlashAXE then
        return
    end
    local Awakebuff = SlashAXE:get_field("_BottleAwakeDurationTimer")
    if Awakebuff == 0 then
        return false
    else
        return true
    end

end

function redmod:setRepeatedly(value)

    local SlashAXE = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer, "snow.player.SlashAxe")
    SlashAXE:set_field("<HitButtonRepeatedly>k__BackingField", value)

end

function redmod:setDamage(value, res, req)
    local tb = {
        ["_BaseDamage"] = value
    }
    toolkits:modifyColliderTab(tb, res, req)
end
-------------------------锤子
function redmod:getChargeType()
    local PlayerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not PlayerManager then
        return
    end
    local masterPlayer = PlayerManager:call("findMasterPlayer")
    local gaugelv = masterPlayer:get_field("<NowChargeType>k__BackingField")
    if not gaugelv then
        return
    end
    return gaugelv
end

------太刀
function redmod:getGaugeLv()
    local PlayerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not PlayerManager then
        return
    end
    local masterPlayer = PlayerManager:call("findMasterPlayer")
    local gaugelv = masterPlayer:call("get_LongSwordGaugeLv")
    return gaugelv
end

function redmod:setGaugeLv(lv)
    local PlayerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not PlayerManager then
        return
    end
    local masterPlayer = PlayerManager:call("findMasterPlayer")
    local gaugelv = masterPlayer:call("set_LongSwordGaugeLv", lv)
    return gaugelv
end

function redmod:getGauge()
    local getGauge = toolkits:getMasterPlayerUtils().masterPlayer:get_field("_LongSwordGauge")
    return getGauge
end
function redmod:setGauge(value)
    local getGauge = toolkits:getMasterPlayerUtils().masterPlayer:set_field("_LongSwordGauge", value)
end

function redmod:setKijinPowerUp(value)
    local getGauge = toolkits:getMasterPlayerUtils().masterPlayer:set_field("_LongSwordGaugePowerUpTime", value)
end

function redmod:setMotionSpeed(actionIndex, speed)
    local motion = toolkits:getActionObject(actionIndex)
    motion:set_Speed(speed)
end

function redmod:CheckBookType() -- 0为红书，1为蓝书
    local gui_manager = sdk.get_managed_singleton("snow.gui.GuiManager");
    local guiHud_weaponTechniqueMySet = gui_manager:call("get_refGuiHud_WeaponTechniqueMySet");
    if not guiHud_weaponTechniqueMySet then
        return
    end
    local pnl_scrollicon = guiHud_weaponTechniqueMySet:get_field("pnl_scrollicon");
    local PlayerState = pnl_scrollicon:call("get_PlayState()")
    if PlayerState == "DEFAULT_RED" then
        return 0
    elseif PlayerState == "DEFAULT_BLUE" then
        return 1
    end
end
------------------------------------------
function redmod:getvital()
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    local health = masterPlayer:call("get_PlayerData"):get_field("_r_Vital")
    return health
end

function redmod:setvital(value)
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    value = value * 1.0
    local health = masterPlayer:call("get_PlayerData"):set_field("_r_Vital", value)

end
function redmod:getvitalMAX() -- 测试
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    local refplayerdata = masterPlayer:get_field("_refPlayerData")
    if not refplayerdata then
        return
    end
    local vitalMax = refplayerdata:get_field("_vitalMax")
    return vitalMax
end

function redmod:setgreenvital(value) -- 测试
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    value = value * 1.0
    local refplayerdata = masterPlayer:call("get_PlayerData")
    if not refplayerdata then
        return
    end
    refplayerdata:call("setVital(System.Single)", value)
end

function redmod:AddGreenVital(value)
    if value > redmod:getvitalMAX() - redmod:getvital() then
        value = redmod:getvitalMAX() - redmod:getvital()
    end
    local vital = redmod:getvital()
    redmod:setvital(vital + value)
    -- setgreenvital(vital+value)
end

function redmod:getstamina()
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    local stamina = masterPlayer:call("get_PlayerData"):get_field("_stamina")
    return stamina
end

function redmod:getstaminaMAX()
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    local staminaMax = masterPlayer:call("get_PlayerData"):get_field("_staminaMax")
    return staminaMax
end

function redmod:setstamina(value)
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    masterPlayer:call("get_PlayerData"):set_field("_stamina", value)
end


function redmod:SendMessage(text)
    sdk.get_managed_singleton("snow.gui.ChatManager"):call("reqAddChatInfomation", text, 2289944406)
end

function redmod:checkNode(nodeid)
    local Parent_tb = {}
    Parent_tb = toolkits:getCurrentNodeID_Parent_tb()
    for i = 1, #Parent_tb do
        if Parent_tb[i] == nodeid then
            return true
        end
    end
    return false
end

function redmod:checkNode_tb(nodeid_tb)
    local Parent_tb = {}
    Parent_tb = toolkits:getCurrentNodeID_Parent_tb()
    for j = 1, #nodeid_tb do
        for i = 1, #Parent_tb do
            if Parent_tb[i] == nodeid_tb[j] then
                return true
            end
        end
    end
    return false
end
function redmod:Current_StartFrame(Station, FieldName)
    local Parent_tb = {}
    Parent_tb = toolkits:getCurrentNodeID_Parent_tb()
    for i = 1, #Parent_tb do
        if toolkits:checkConditionField(Parent_tb[i], Station, FieldName) ~= false then
            return toolkits:checkConditionField(Parent_tb[i], Station, FieldName)
        end
    end
    return 999
end

function redmod:wire_Usable_Num()
    local playerBase = toolkits:getMasterPlayerUtils().masterPlayer
    local wire_ready_num = playerBase:call("getUsableHunterWireNum()")
    return wire_ready_num
end

function redmod:use_Wire_Num(num, value)
    local playerBase = toolkits:getMasterPlayerUtils().masterPlayer
    playerBase:call("useHunterWireGauge(System.Int32, System.Single)", num, value)
end

function redmod:getGaugeLvTime()
    local getGaugeLvTime = toolkits:getMasterPlayerUtils().masterPlayer:get_field("_LongSwordGaugeLvTimer")
    return getGaugeLvTime
end
function redmod:setGaugeLvTime(value)
    local getGaugeLvTime = toolkits:getMasterPlayerUtils().masterPlayer:set_field("_LongSwordGaugeLvTimer", value)
end

function redmod:addSkill228Accumulator(value)

    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    masterPlayer:call("subEquipSkill228Accumulator", value * 1.0)
end

function redmod:ls_gaugelv_time(MaxTime, Dipvalue) ----气刃时间调整 MaxTime是气刃调整的最大时间，也是白刃时间，Dipvalue是每级减少的时间，单位s
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    local longsword_gaugelv_time = masterPlayer:get_field("_LongSwordGaugeLvTime")
    local value = sdk.create_instance("System.Single")
    for i = 1, 3, 1 do
        value:set_field("mValue", MaxTime * 60.0 - Dipvalue * 60.0 * (i - 1))
        longsword_gaugelv_time:call("SetValue", value, i)
    end
end

function redmod:Skill218DataSet(extralv) -- 对拔刀术力的技能调整（效果待定
    local EnemyManager = sdk.get_managed_singleton("snow.enemy.EnemyManager")
    local SkillData = EnemyManager:call("get_SkillData()")
    if extralv >= 4 then
        extralv = 3
    end
    SkillData:get_field("_EquipSkill218_Rate"):set_field("_Lv1", 1.100 + 0.025 * (extralv - 1))
    SkillData:get_field("_EquipSkill218_Rate"):set_field("_Lv2", 1.100 + 0.025 * (extralv - 1))
    SkillData:get_field("_EquipSkill218_Rate"):set_field("_Lv3", 1.100 + 0.025 * (extralv - 1))
end

---@param value number
function redmod:modifySkill(value, ...)
    local player_manager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not player_manager then
        return
    end
    local skill_param_method = player_manager:call("get_RefSkillParameter")
    local skill_param_field = skill_param_method:get_field("_EquipSkillParameter")
    local data = skill_param_field

    local field_name = {...} ---把输入的field名称先打包成table
    if #field_name == 1 then -- 只有一层,直接set
        data:set_field(field_name[1], value)
    elseif #field_name == 2 then -- 两层,先get再set
        local var = data:get_field(field_name[1])
        var:set_field(field_name[2], value)
    elseif #field_name > 2 then -- 三层以上,中间的get使用迭代
        local var = data:get_field(field_name[1])
        for i = 2, #field_name - 1 do
            var = var:get_field(field_name[i])
        end
        var:set_field(field_name[#field_name], value)
    end
end

function redmod:modifyColliderTab(damage, res_id, req_id)
    local tb = {
        ["_BaseDamage"] = damage
    }
    toolkits:modifyColliderTab(tb, res_id, req_id)
end

----------------------------------------

function redmod:getTreeComponentCore()
    local layer = nil
    local tree = nil
    local playercomp = (toolkits:getMasterPlayerUtils()).playerGameObj
    local motion_fsm2 = playercomp:call("getComponent(System.Type)", sdk.typeof("via.motion.MotionFsm2"))
    if playercomp == nil then
        return
    end
    if motion_fsm2 == nil then
        return
    end

    layer = motion_fsm2:call("getLayer", 0)
    if layer == nil then
        return
    end

    tree = layer:get_tree_object()
    return tree
end

function redmod:getNodeByNodeID(NodeID)
    local tree = redmod:getTreeComponentCore()
    if tree == nil then
        return
    end
    return tree:get_node_by_id(NodeID)
end

function redmod:GetNodeIndexByID(nodeID)
    local tree = redmod:getTreeComponentCore()
    local NodeIDCache = {}
    if NodeIDCache[nodeID] == nil then
        local nodes = tree:get_nodes()
        for i = 0, nodes:size() - 1 do
            NodeIDCache[nodes[i]:get_id()] = i
        end
    end
    return tonumber(NodeIDCache[nodeID])
end

function redmod:GetIndexByID_tb(nodeID_tb)
    local tree = redmod:getTreeComponentCore()
    local NodeIDCache = {}
    local NodeIndex = {}
    for j = 1, #nodeID_tb do
        if NodeIDCache[nodeID_tb[j]] == nil then
            local nodes = tree:get_nodes()
            for i = 0, nodes:size() - 1 do
                NodeIDCache[nodes[i]:get_id()] = i
            end
        end
        table.insert(NodeIndex, tonumber(NodeIDCache[nodeID_tb[j]]))
    end
    return NodeIndex

end

function redmod:N(NodeID, i) -- get_info_NodeID
    local node = redmod:getNodeByNodeID(NodeID)
    local tree = redmod:getTreeComponentCore()

    if node == nil then
        return
    end
    local index = redmod:GetNodeIndexByID(tree, NodeID)
    if i == nil then
        return index
    end
    local node_data = node:get_data()
    local actions = node_data:get_actions()
    local transition_array = node_data:get_transition_conditions()
    local node_array = node_data:get_states()

    local info_tb = {
        index,
        stata = tonumber(node_array[i]),
        action = tonumber(actions[i]),
        cond = tonumber(transition_array[i])
    }
    return info_tb
end

function redmod:wireTimeAdjust(time) ---输入调整的时间，正数增加，复数减少。后面是触发条件节点

    local wireGuages = toolkits:getMasterPlayerUtils().masterPlayer:get_field("_HunterWireGauge")
    local currentid = toolkits:getCurrentNodeID()

    local wire0 = wireGuages:get_element(0)
    local wire1 = wireGuages:get_element(1)
    local wire2 = wireGuages:get_element(2)
    local wire3 = wireGuages:get_element(3)

    local wire0nowMax = wire0:get_field("_RecastTimerMax")
    local wire0now = wire0:get_field("_RecastTimer")
    local wire1nowMax = wire1:get_field("_RecastTimerMax")
    local wire1now = wire1:get_field("_RecastTimer")
    local wire2nowMax = wire2:get_field("_RecastTimerMax")
    local wire2now = wire2:get_field("_RecastTimer")
    local wire3nowMax = wire3:get_field("_RecastTimerMax")
    local wire3now = wire3:get_field("_RecastTimer")

    if wire0now ~= 0 then
        wire0:set_field("_RecastTimer", wire0now + time * 60)

    elseif wire1now ~= 0 then

        wire1:set_field("_RecastTimer", wire1now + time * 60)

    elseif wire2now ~= 0 then

        wire2:set_field("_RecastTimer", wire2now + time * 60)

    elseif wire3now ~= 0 then

        wire3:set_field("_RecastTimer", wire3now + time * 60)

    elseif wire0now == 0 and wire1now == 0 and wire2now == 0 and wire3now == 0 then
        return
    end
end

function redmod:getMutekiTimerbyEvadeLevel() ---自定义闪避等级对应帧数，暂时无用
    local player = toolkits:getMasterPlayerUtils().masterPlayer
    if not player then
        return false
    end
    local id = player:get_field("_PlayerIndex")
    local PlayerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    local EvadeLevel = PlayerManager:call("getHasPlayerSkillLvInQuestAndTrainingArea", id, 65)
    if EvadeLevel == nil then
        return 0
    end
    local RefQuest = player:call("get_RefQuestUserData()")
    local Frames = {1, 1.1, 1.3, 1.6, 1.9, 2.1}
    return 8 * Frames[EvadeLevel + 1]
end

---根据Action的name在NODE找到对应的实例
--- @type fun(NodeID:number, ActionName:string):ActionLocalIndex|nil
function redmod:getActionByName(NodeID, ActionName)
    local tree = redmod:getTreeComponentCore()
    if tree == nil then
        return
    end
    local node = tree:get_node_by_id(NodeID)
    local data = node:get_data()
    local actionsInNode = data:get_actions()

    for i = 0, actionsInNode:size() - 1 do
        local name = tree:get_action(actionsInNode[i]):get_type_definition():get_full_name()
        if name:find(ActionName) then
            return tree:get_action(actionsInNode[i])
        end
    end
    return false
end

---根据Station的name在所有NODE找到对应的实例
function redmod:getAllStationByName(NODEName)
    local tree = redmod:getTreeComponentCore()
    local ActionTb = {}
    if tree == nil then
        return
    end
    local nodes = tree:get_nodes()
    for i = 0, nodes:size() - 1 do
        local name = nodes[i]:get_full_name()
        if name:find(NODEName) then
            table.insert(ActionTb, i)
        end
    end
    return ActionTb
end

---根据conditionName在所有NODE找到对应的实例

function redmod:getConditionByName(conditionName)
    local tree = redmod:getTreeComponentCore()
    local condition_array = tree:get_conditions()
    local conditionTb = {}
    if tree == nil then
        return
    end

    for i = 0, tree:get_condition_count() - 1 do
        local condition = tree:get_condition(i)

        if condition then
            local name = condition:get_type_definition():get_full_name():lower()
            local search_name = conditionName:lower()

            if name:find(search_name) then
                table.insert(conditionTb, i)
            end
        end
    end
    return conditionTb
end


function redmod:setAtkUpBuff(value, time) -- 测试
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    masterPlayer:call("setAtkUpBuffSecond", value, time * 60.0)
end

function redmod:setStaminaUpBuff(time) -- 测试
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    masterPlayer:call("setStaminaUpBuffSecond(System.Single)", time * 60.0)
end

function redmod:setDefUpBuff(value, time) -- 测试
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    masterPlayer:call("setDefUpBuffSecond(System.Int32, System.Single)", value, time * 60.0)
end
------------------------------------------------------------------时间流速
function redmod:checkEffectAction(Node_tb)
    for i = 1, #Node_tb do
        local effectActionObject = redmod:getActionByName(Node_tb[i], "snow.player.fsm.PlayerFsm2ActionSetEffect")
        if effectActionObject and effectActionObject:get_Enabled() then
            local containerID = effectActionObject:get_field("containerID")
            local ElementID = effectActionObject:get_field("_ElementID")
            if containerID == 150.0 then
                return true
            end
        end
    end
    return false
end

function redmod:SetTimeScale(value)
    local scene_manager = sdk.get_native_singleton("via.SceneManager")
    local scene_manager_type = sdk.find_type_definition("via.SceneManager")
    local scene = sdk.call_native_func(scene_manager, scene_manager_type, "get_CurrentScene")

    scene:call("set_TimeScale", value)
    local TimeScaleManager = sdk.get_managed_singleton('snow.TimeScaleManager')
    TimeScaleManager:call("set_TimeScale", value)

end

function redmod:SetObjectTimeScale(value)
    local masterPlayerObj = toolkits:getMasterPlayerUtils().masterPlayer
    masterPlayerObj:call("set_TimeScale", value)
end

function redmod:modifyConditionField(conditionIndex, fieldname, value)
    local conditon = toolkits:getConditionObj(conditionIndex)
    if conditon:get_field(fieldname) ~= nil then
        conditon:set_field(fieldname, value)
    end
end

function redmod:GetHitData(reqSetId, resourceId, PresetTable)

    local requestSet = PresetTable[reqSetId]
    if requestSet == nil then
        return nil
    end
    local AttackData = requestSet[resourceId]
    if AttackData == nil then
        return nil
    end
    return AttackData

end

function redmod:getPlayerActive()
    local PlayerQuestBase = redmod:get_player_component(toolkits:getMasterPlayerUtils().masterPlayer,
        "snow.player.PlayerQuestBase")
    local Sleeptimer = PlayerQuestBase:get_field("_SleepDurationTimer")
    local Stuntimer = PlayerQuestBase:get_field("_StunDurationTimer")

    if Sleeptimer ~= 0 or Stuntimer ~= 0 then
        return false
    end
    return true
end


function redmod:setDefineEffect(cid, efx)
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    if not masterPlayer then
        return
    end
    masterPlayer:call("setEffect", cid, efx)
end

function redmod:set150Effect(container_id, element_id)
    local masterPlayer = toolkits:getMasterPlayerUtils().masterPlayer
    if not masterPlayer then
        return
    end
    masterPlayer:call("setItemEffect", container_id, element_id)
end

---# 跳帧
---### 这个函数需要控制仅执行一次，否则你的动作将定格在你设定的帧数
---跳转到当前动作的某一帧，随后向后播放，参数必须为**浮点型**(40.0)
---@param frame number
function redmod:jumpFrame(frame)
    local playerBase = toolkits.getMasterPlayerUtils().masterPlayer
    if not playerBase then
        return
    end
    local treeLayer = playerBase:call("getMotionLayer", 0)
    treeLayer:call("set_Frame", frame)
end

local open_box_ok = true
local tent_end = true
function redmod:checkBoxAndTent() -- 检测人物开箱动作和进帐篷结束动作节点，以此来解决MAIN函数换武器失效的问题
    local box_node = 2922044148
    local tent_node = 70028570
    local currentID = toolkits:getCurrentNodeID()
    if currentID ~= box_node then
        open_box_ok = true
    end
    if currentID == box_node and open_box_ok then
        open_box_ok = false
        return true
    end
    if currentID ~= tent_node then
        tent_end = true
    end
    if currentID == tent_node and tent_end then
        tent_end = false
        return true
    end

end

-- 古法添加受击派生
function redmod:addatuoEscape(autoescapedNobleID, damageReflxAction, escapeActionNobeIndex, BaseDamagecondition) -- 添加节点NODEID--闪避动作判定ACTION--受击派生的目的节点NobeIndex--受击判断CONDITION
    toolkits:modifyActionField(damageReflxAction, "_Type", 9)
    toolkits:addAction(autoescapedNobleID, damageReflxAction) -- 添加闪避动作判定
    toolkits:addConditionPairs(autoescapedNobleID, BaseDamagecondition, escapeActionNobeIndex, true) -- 添加受伤前闪避判断
end

-- 直接派生的转向轮子  需要重置配合使用，需要单次执行 --AngleLimit*2=实际角度 AngelType很多种，自己尝试出最满意的那种
function redmod:jumpToNodeWithAngle(NodeIndex, AngelEvent, AngelType, AngleLimit) -- NodeIndex,AngelEvent必填，转向限制，转向方式选填，转向EVENT：snow.player.fsm.PlayerFsm2EventStateInitOption，最好是不常用的。
    toolkits:addConditionPairs(1731229352, -1, NodeIndex, true) --1731229352是持刀翻滚的节点，实际上它并不特殊，只是起到了催化剂的作用。
    local AngelEventObj = toolkits:getEventObject(AngelEvent)
    if AngleLimit then
        AngelEventObj:set_field("_LimitAngle", AngleLimit)
    end
    if AngelType then
        AngelEventObj:set_field("_AngleSetType", AngelType)
    end

    toolkits:addTransitionEvent(1731229352, -1, AngelEvent)

    toolkits:jumpToNode(1731229352)
end

function redmod:resetNodeWithAngle(NodeIndex, AngelEvent, OriginAngelType, OriginAngleLimit) -- 需要循环执行，并且与上面的函数NodeIndex对应为一组,NodeIndex必填，后面附带还原EVENT的功能，选填。
    if redmod:GetNodeIndexByID(toolkits:getCurrentNodeID()) == NodeIndex then
        local AngelEventObj = toolkits:getEventObject(AngelEvent)
        if OriginAngleLimit then
            AngelEventObj:set_field("_LimitAngle", OriginAngleLimit)
        end
        if OriginAngelType then
            AngelEventObj:set_field("_AngleSetType", OriginAngelType)
        end
        toolkits:replaceCondition(1731229352, -1, 34)
        toolkits:eraseConditionPairs(1731229352, 34, NodeIndex, true)
    end
end

return redmod

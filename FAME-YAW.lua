-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
-- BY PAT https://discord.gg/dVwtVhuqW3
local ffi = require("ffi")
local clientEntityList = Utils.CreateInterface("client.dll", "VClientEntityList003")
local engineClient = Utils.CreateInterface("engine.dll", "VEngineClient014")
local function ReadUInt(address)
    return ffi.cast("unsigned int*", address)[0]
end

local function GetItemIndex(targetTable, item)
    for i=1,table.getn(targetTable) do
        if targetTable[i] == item then
            return i
        end
    end
end
ffi.cdef[[
    struct Vector
    {
        float r, g, b;
    };

    struct CAllocator_GlowObjectDefinition_t 
    {
        struct GlowObjectDefinition_t *m_pMemory;
        int m_nAllocationCount;
        int m_nGrowSize;
    };

    struct CUtlVector_GlowObjectDefinition_t
    {
        struct CAllocator_GlowObjectDefinition_t m_Memory;
        int m_Size;
        struct GlowObjectDefinition_t *m_pElements;
    };

    struct GlowObjectDefinition_t
    {
        int m_nNextFreeSlot;
        void *m_pEntity;
        struct Vector m_vGlowColor;
        float m_flGlowAlpha;
        char pad01[16];
        bool m_bRenderWhenOccluded;
        bool m_bRenderWhenUnoccluded;
        bool m_bFullBloomRender;
        char pad02;
        int m_nFullBloomStencilTestValue;
        int m_nRenderStyle;
        int m_nSplitScreenSlot;
        //Total size: 0x38 bytes
    };

    struct CGlowObjectManager
    {
        struct CUtlVector_GlowObjectDefinition_t m_GlowObjectDefinitions;
        int m_nFirstFreeSlot;
    };
]]
local GetGlowObjectManager_t = "struct CGlowObjectManager*(__cdecl*)()"
local RegisterGlowObject_t = "int(__thiscall*)(struct CGlowObjectManager*, void*, const struct Vector&, bool, bool, int)"
local GetClientEntity_t = "void*(__thiscall*)(void*, int)"
local IsInGame_t = "bool(__thiscall*)(void*)"

local RegisterGlowObject = ffi.cast("unsigned int", Utils.PatternScan("client.dll", "E8 ? ? ? ? 89 03 EB 02"))
RegisterGlowObject = ffi.cast(RegisterGlowObject_t, RegisterGlowObject + 5 + ReadUInt (RegisterGlowObject + 1))
local GetGlowObjectManager = ffi.cast(GetGlowObjectManager_t, Utils.PatternScan("client.dll", "A1 ? ? ? ? A8 01 75 4B"))
local GetClientEntityRaw = ffi.cast(GetClientEntity_t, ReadUInt(ReadUInt(ffi.cast("unsigned int", clientEntityList)) + 3 * 4))
local IsInGameRaw = ffi.cast(IsInGame_t, ReadUInt(ReadUInt(ffi.cast("unsigned int", engineClient)) + 26 * 4))
print("------------------------------------------------------------------------------------")
print("FAME-YAW | https://discord.gg/dVwtVhuqW3")
print("FAME-YAW | https://discord.gg/dVwtVhuqW3")
print("FAME-YAW | https://discord.gg/dVwtVhuqW3")
print("FAME-YAW | https://discord.gg/dVwtVhuqW3")
print("------------------------------------------------------------------------------------")
local glowObjectIndexes = { }
Menu.Text("         PAT | FAME-YAW", "             https://discord.gg/dVwtVhuqW3")
local GLOW_STYLES = { "Default", "Edge | Pulse", "Edge | Classic", "Glow | 3D" }
local cfgGlowToggle = Menu.SwitchColor("Local Player Glow", "Enable", false, Color.new(1.0, 1.0, 1.0, 1.0))
local cfgGlowStyle = Menu.Combo("Local Player Glow", "Style", GLOW_STYLES, 0)
local oldColor = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
local function GetClientEntity(index)
    return GetClientEntityRaw(clientEntityList, index)
end
local function IsInGame()
    return IsInGameRaw(engineClient)
end
local function CreateGlowObject(ent, color, alpha, style)
    local glowObjectManager = GetGlowObjectManager()
    local index = RegisterGlowObject(glowObjectManager, ffi.cast("void*", ent), ffi.new("struct Vector", color), true, true, -1)
    glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[index].m_vGlowColor = color
    glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[index].m_flGlowAlpha = alpha
    glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[index].m_nRenderStyle = style
    glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[index].m_bRenderWhenOccluded = true
    glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[index].m_bRenderWhenUnoccluded = true
    table.insert(glowObjectIndexes, index)
end
local function SetGlowObjectColor(index, color, alpha)
    local glowObjectManager = GetGlowObjectManager()
    glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[index].m_vGlowColor = color
    glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[index].m_flGlowAlpha = alpha
end
local function SetGlowObjectRender(index, status)
    local glowObjectManager = GetGlowObjectManager()
    glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[index].m_bRenderWhenOccluded = status
    glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[index].m_bRenderWhenUnoccluded = status
end
local function InitGlowObjects()
    local localPlayer = GetClientEntity(EngineClient.GetLocalPlayer())
    local style = cfgGlowStyle:Get()
    CreateGlowObject(localPlayer, { 1.0, 0.0, 0.0 }, 1.0, 0)
    CreateGlowObject(localPlayer, { 0.0, 0.0, 0.0 }, 0.0, 3)
    CreateGlowObject(localPlayer, { 0.0, 0.0, 0.0 }, 0.0, 2)
    CreateGlowObject(localPlayer, { 0.0, 0.0, 0.0 }, 0.0, 1)
    for i=1, table.getn(glowObjectIndexes) do
        local color = cfgGlowToggle:GetColor()
        if not cfgGlowToggle:GetBool() or style + 1 ~= i then
            SetGlowObjectRender(glowObjectIndexes[i], false)
        else
            SetGlowObjectRender(glowObjectIndexes[i], true)
        end
        SetGlowObjectColor(glowObjectIndexes[i], { color.r, color.g, color.b }, color.a)
    end
end
local function RemoveGlowObjects()
    local glowObjectManager = GetGlowObjectManager()
    for i=1, table.getn(glowObjectIndexes) do
        glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[glowObjectIndexes[i]].m_nNextFreeSlot = glowObjectManager.m_nFirstFreeSlot
        glowObjectManager.m_GlowObjectDefinitions.m_Memory.m_pMemory[glowObjectIndexes[i]].m_pEntity = ffi.cast("void*", 0)
        glowObjectManager.m_nFirstFreeSlot = glowObjectIndexes[i]
    end
    glowObjectIndexes = { }
end
local function HandleEvents(event)
    if event:GetName() == "player_connect_full"  then
        local localIndex = EngineClient.GetLocalPlayer()
        local connectedIndex = EntityList.GetPlayerForUserID(event:GetInt("userid", 0)):EntIndex()

        if localIndex == connectedIndex then
            InitGlowObjects()
        end
    end
end
local function OnPaintUI()
    if IsInGame() then
        local color = cfgGlowToggle:GetColor()
        if color.r ~= oldColor.r or color.g ~= oldColor.g or color.b ~= oldColor.b or color.a ~= oldColor.a then
            for i=1, table.getn(glowObjectIndexes) do
                SetGlowObjectColor(glowObjectIndexes[i], { color.r, color.g, color.b }, color.a)
            end

            oldColor = {r = color.r, g = color.g, b = color.b, a = color.a}
        end
    elseif glowObjectIndexes[1] ~= nil then
        RemoveGlowObjects()
    end
end
local function OnUIRenderElementChanged(value)
    local style = cfgGlowStyle:Get()

    for i=1, table.getn(glowObjectIndexes) do
        if not cfgGlowToggle:GetBool() or style + 1 ~= i then
            SetGlowObjectRender(glowObjectIndexes[i], false)
        else
            SetGlowObjectRender(glowObjectIndexes[i], true)
        end
    end
end
if IsInGame() then
    InitGlowObjects()
end
local checksky = Menu.Switch("CUSTOM SKYBOX", "Enable", false)
local namesky = Menu.TextBox("CUSTOM SKYBOX", "SkyBox Name", 64, "blue1", "csgo/materials/skybox")

function customskybox()
    if checksky:GetBool() == false then
        namesky:SetVisible(false)
    end
    if checksky:GetBool() then
        nlsb    = Menu.FindVar("Visuals", "World", "Main", "SkyBox"):SetInt(0)
        namesky:SetVisible(true)
        skyboxname = namesky:GetString()        
        cvar = CVar.FindVar("sv_skyname")
        cvar:SetString(skyboxname)    
    end
end
local g_entity_list = Utils.CreateInterface("client.dll", "VClientEntityList003")
local g_model_infot = Utils.CreateInterface("engine.dll", "VModelInfoClient004")
local g_client_string = Utils.CreateInterface("engine.dll","VEngineClientStringTable001")
local FRAME_NET_UPDATE_POSTDATAUPDATE_START = 2
local FRAME_RENDER_START = 5
ffi.cdef[[
  
    typedef struct _class
    {
        void** this;
    }aclass;

    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef void(__thiscall* find_or_load_model_fn_t)(void*, const char*);
    typedef const int(__thiscall* get_model_index_fn_t)(void*, const char*);
    typedef const int(__thiscall* add_string_fn_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* full_update_t)();
    typedef int(__thiscall* get_player_idx_t)();
    typedef void*(__thiscall* get_client_networkable_t)(void*, int);
    typedef void(__thiscall* pre_data_update_t)(void*, int);
]]
local ientitylist = ffi.cast(ffi.typeof("void***"), g_entity_list) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)
local g_model_info = ffi.cast(ffi.typeof("void***"), g_model_infot) or error("model info is nil", 2)
local get_model_index_fn = ffi.cast("get_model_index_fn_t", g_model_info[0][2]) or error("Getmodelindex is nil", 2)
local find_or_load_model_fn = ffi.cast("find_or_load_model_fn_t", g_model_info[0][43]) or error("findmodel is nil", 2)
local clientstring = ffi.cast(ffi.typeof("void***"), g_client_string) or error("clientstring is nil", 2)
local find_table = ffi.cast("find_table_t", clientstring[0][3]) or error("find table is nil", 2)
local get_client_networkable = ffi.cast("get_client_networkable_t", ientitylist[0][0]) or error("get networkable is nil", 2)
local custom_models = Menu.Switch("agent", "Enable", false)
local custom_path = Menu.TextBox("agent", "Custom Model", 128, "MODEL")
local ui_text = Menu.Text('agent', 'Custom Model Path: /csgo/sound/hitsounds')
local function precache(path)
    local precachetable = ffi.cast(ffi.typeof("void***"), find_table(clientstring, "modelprecache"))
    if precachetable~= nil then
        find_or_load_model_fn(g_model_info, path)
        local addstring = ffi.cast("add_string_fn_t", precachetable[0][8]) or error("addstring nil", 2)
        local add_string_to_path = addstring(precachetable, false, path, -1, nil)
        if add_string_to_path == -1 then print("failed")
            return false
        end
    end
    return true
end
local paths = {
"models/player/custom_player/legacy/tm_leet_variantf.mdl",
"models/player/custom_player/legacy/tm_leet_varianti.mdl",
"models/player/custom_player/legacy/tm_leet_varianth.mdl",
"models/player/custom_player/legacy/tm_leet_variantg.mdl",
"models/player/custom_player/legacy/ctm_fbi_variantb.mdl",
"models/player/custom_player/legacy/ctm_fbi_varianth.mdl",
"models/player/custom_player/legacy/ctm_fbi_variantg.mdl",
"models/player/custom_player/legacy/ctm_fbi_variantf.mdl",
"models/player/custom_player/legacy/ctm_st6_variante.mdl",
"models/player/custom_player/legacy/ctm_st6_variantm.mdl",
"models/player/custom_player/legacy/ctm_st6_variantg.mdl",
"models/player/custom_player/legacy/ctm_st6_variantk.mdl",
"models/player/custom_player/legacy/ctm_st6_varianti.mdl",
"models/player/custom_player/legacy/ctm_st6_variantj.mdl",
"models/player/custom_player/legacy/ctm_st6_variantl.mdl",
"models/player/custom_player/legacy/ctm_swat_variante.mdl",
"models/player/custom_player/legacy/ctm_swat_variantf.mdl",
"models/player/custom_player/legacy/ctm_swat_variantg.mdl" ,
"models/player/custom_player/legacy/ctm_swat_varianth.mdl",
"models/player/custom_player/legacy/ctm_swat_varianti.mdl",
"models/player/custom_player/legacy/ctm_swat_variantj.mdl",
"models/player/custom_player/legacy/tm_balkan_varianti.mdl",
"models/player/custom_player/legacy/tm_balkan_variantf.mdl",
"models/player/custom_player/legacy/tm_balkan_varianth.mdl",
"models/player/custom_player/legacy/tm_balkan_variantg.mdl",
"models/player/custom_player/legacy/tm_balkan_variantj.mdl",
"models/player/custom_player/legacy/tm_balkan_variantk.mdl",
"models/player/custom_player/legacy/tm_balkan_variantl.mdl",
"models/player/custom_player/legacy/ctm_sas_variantf.mdl",
"models/player/custom_player/legacy/tm_phoenix_varianth.mdl",
"models/player/custom_player/legacy/tm_phoenix_variantf.mdl",
"models/player/custom_player/legacy/tm_phoenix_variantg.mdl",
"models/player/custom_player/legacy/tm_phoenix_varianti.mdl",
"models/player/custom_player/legacy/tm_professional_varf.mdl",
"models/player/custom_player/legacy/tm_professional_varf1.mdl",
"models/player/custom_player/legacy/tm_professional_varf2.mdl",
"models/player/custom_player/legacy/tm_professional_varf3.mdl",
"models/player/custom_player/legacy/tm_professional_varf4.mdl",
"models/player/custom_player/legacy/tm_professional_varg.mdl",
"models/player/custom_player/legacy/tm_professional_varh.mdl",
"models/player/custom_player/legacy/tm_professional_vari.mdl",
"models/player/custom_player/legacy/tm_professional_varj.mdl",
}



local names = {
"The Elite Mr. Muhlik | Elite Crew",
"Prof. Shahmat | Elite Crew",
"Osiris | Elite Crew",
"Ground Rebel | Elite Crew",
"Special Agent Ava | FBI",
"Michael Syfers | FBI Sniper",
"Markus Delrow | FBI HRT",
"Operator | FBI SWAT",
"Seal Team 6 Soldier | NSWC SEAL",
"'Two Times' McCoy | USAF TACP",
"Buckshot | NSWC SEAL",
"3rd Commando Company | KSK",
"Lt. Commander Ricksaw | NSWC SEAL",
"'Blueberries' Buckshot | NSWC SEAL",
"'Two Times' McCoy | TACP Cavalry",
"Cmdr. Mae 'Dead Cold' Jamison | SWAT",
"1st Lieutenant Farlow | SWAT",
"John 'Van Healen' Kask | SWAT",
"Bio-Haz Specialist | SWAT",
"Sergeant Bombson | SWAT",
"Chem-Haz Specialist | SWAT",
"Maximus | Sabre",
"Dragomir | Sabre",
"'The Doctor' Romanov | Sabre",
"Rezan The Ready | Sabre",
"Blackwolf | Sabre",
"Rezan the Redshirt | Sabre",
"Dragomir | Sabre Footsoldier",
"B Squadron Officer | SAS",
"Soldier | Phoenix",
"Enforcer | Phoenix",
"Slingshot | Phoenix",
"Street Soldier | Phoenix",
"Sir Bloody Miami Darryl | The Professionals",
"Sir Bloody Silent Darryl | The Professionals",
"Sir Bloody Skullhead Darryl | The Professionals",
"Sir Bloody Darryl Royale | The Professionals",
"Sir Bloody Loudmouth Darryl | The Professionals",
"Safecracker Voltzmann | The Professionals",
"Little Kev | The Professionals",
"Number K | The Professionals",
"Getaway Sally | The Professionals",
}
local agent_menu = Menu.Combo("agent", "Agent", names, 0)
Cheat.RegisterCallback("frame_stage", function(stage)
    local local_player = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
    if local_player == nil
        then return
    end
    local player_address = get_client_entity(ientitylist, EngineClient.GetLocalPlayer())
    local index = local_player:GetProp("DT_BaseEntity", "m_nModelIndex")
    local newpath = string.gsub(custom_path:GetString(), [[\]], [[/]])
    if custom_models:GetBool() then
        if precache(newpath) then
            local model_idx = get_model_index_fn(g_model_info, newpath)
            if model_idx ~= -1 and model_idx ~= index then
                local_player:SetModelIndex(model_idx)
            end
        end

    else
        local model_idx = get_model_index_fn(g_model_info, paths[agent_menu:GetInt() + 1])
        if model_idx ~= index then
        local_player:SetModelIndex(model_idx)
        end
    end
end)
local Enable = Menu.Switch("DT IN AIR", "Enable", false)
local Teleport_Weapons = Menu.MultiCombo("DT IN AIR", "Weapons", {"Scout", "AWP", "Pistols", "Zeus", "Knife", "Nades", "Other"}, 0)
local DoubleTap = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Double Tap")
function C_BasePlayer:CanHit()
    local Localplayer = EntityList.GetLocalPlayer()
    local TraceInfo = Cheat.FireBullet(self, self:GetEyePosition(), Localplayer:GetEyePosition())
    if (TraceInfo.damage > 0 and ((TraceInfo.trace.hit_entity and TraceInfo.trace.hit_entity:GetPlayer() == Localplayer) or false)) then
        return true
    end
    return false
end
function C_BasePlayer:GetFlag(shift)
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1, shift)) ~= 0
end
function GetEnemies()
    local Enemies = {}
    for _, Player in pairs(EntityList.GetPlayers()) do
        if (not Player:IsTeamMate() and Player:IsAlive()) then
            table.insert(Enemies, Player:GetPlayer())
        end
    end
    return Enemies
end
Cheat.RegisterCallback("prediction", function()
    if (Enable:Get() and Teleport_Weapons:Get() ~= 0 and DoubleTap:Get()) then
        local Allow_Work = false
        local Need_Teleport = false
        local Localplayer = EntityList.GetLocalPlayer()
        local Weapon = Localplayer:GetActiveWeapon()
        local WeaponID = Weapon:GetWeaponID()
        local IsScout = WeaponID == 40
        local IsAWP = WeaponID == 9
        local IsPistols = Weapon:IsPistol()
        local IsZeus = WeaponID == 31
        local IsKnife = Weapon:IsKnife()
        local IsNades = Weapon:IsGrenade()
        for i, Weapons in pairs({
            IsScout,
            IsAWP,
            IsPistols,
            IsZeus,
            IsKnife,
            IsNades,
            not (IsScout or IsAWP or IsPistols or IsZeus or IsKnife or IsNades)
        }) do
            if (Teleport_Weapons:Get(i) and Weapons) then
                Allow_Work = true
            end
        end

        if (Allow_Work) then
            for _, Enemy in pairs(GetEnemies()) do
                if (not Enemy:IsDormant() and Enemy:CanHit()) then
                    Need_Teleport = true
                end
            end
        end

        if (Need_Teleport and not Localplayer:GetFlag(0)) then
            Exploits.ForceTeleport()
        end
    end
end)

Cheat.RegisterCallback("draw", function()
    Teleport_Weapons:SetVisible(Enable:Get())
end)
Cheat.RegisterCallback("draw", customskybox)
cfgGlowToggle:RegisterCallback(OnUIRenderElementChanged)
cfgGlowStyle:RegisterCallback(OnUIRenderElementChanged)
Cheat.RegisterCallback("destroy", RemoveGlowObjects)
Cheat.RegisterCallback("draw", OnPaintUI)
Cheat.RegisterCallback("events", HandleEvents)
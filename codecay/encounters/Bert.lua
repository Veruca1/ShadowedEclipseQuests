--[[  
  Codecay – Bertoxxulous Event (Public & Instance Compatible)  
  Original by Drogerin · Revised for both public & DZ usage  
--]]

-- Debug toggle
local DBG = false
local function dprint(msg)
  if DBG then
    local inst = eq.get_zone_instance_id() or 0
    eq.debug(string.format("[BertEvent inst=%d] %s", inst, tostring(msg)))
  end
end

-- Encounter state (per run)
local trash_dead          = 0
local raddi_spawned       = false
local wavadozzik_spawned  = false
local zandal_spawned      = false
local akkapan_spawned     = false
local bhaly_spawned       = false
local pzo_spawned         = false
local meedo_spawned       = false
local qezzin_spawned      = false
local bert_spawned        = false
local darwol_spawned      = false
local feig_spawned        = false
local xhut_spawned        = false
local kavillis_spawned    = false

-- Helper: Are any “king” NPCs alive?
local function kings_alive()
  local el = eq.get_entity_list()
  return el:IsMobSpawnedByNpcTypeID(200046) or -- Darwol
         el:IsMobSpawnedByNpcTypeID(200045) or -- Feig
         el:IsMobSpawnedByNpcTypeID(200044) or -- Xhut
         el:IsMobSpawnedByNpcTypeID(200047) or -- Kavilis
         el:IsMobSpawnedByNpcTypeID(200049) or -- Raddi
         el:IsMobSpawnedByNpcTypeID(200048) or -- Wavadozzik
         el:IsMobSpawnedByNpcTypeID(200050) or -- Zandal
         el:IsMobSpawnedByNpcTypeID(200051) or -- Akkapan
         el:IsMobSpawnedByNpcTypeID(200054) or -- Bhaly
         el:IsMobSpawnedByNpcTypeID(200053) or -- Meedo
         el:IsMobSpawnedByNpcTypeID(200052) or -- Qezzin
         el:IsMobSpawnedByNpcTypeID(200022)    -- Pzo
end

-- Reset function to start fresh
local function reset_state()
  trash_dead          = 0
  raddi_spawned       = false
  wavadozzik_spawned  = false
  zandal_spawned      = false
  akkapan_spawned     = false
  bhaly_spawned       = false
  pzo_spawned         = false
  meedo_spawned       = false
  qezzin_spawned      = false
  bert_spawned        = false
  darwol_spawned      = false
  feig_spawned        = false
  xhut_spawned        = false
  kavillis_spawned    = false
  dprint("State reset: trash_dead=0; flags cleared")
end

-- =========================
-- Handler: Spectre death (trigger)
-- =========================
function Spectre_Death(e)
  local el = eq.get_entity_list()
  if not el:IsMobSpawnedByNpcTypeID(200016) then
    reset_state()
    eq.zone_emote(MT.NPCQuestSay,
      "Crazed laughter is heard as you notice a foul creature standing before you. The creature then speaks saying, " ..
      "'Violaters of the depths of Lxanvom shall pay with your lives!'  The foul minion of decay then begins chanting a dark ritual.  " ..
      "Deeper within the depths of the crypt more chanting can be heard.")
    dprint("Spectre death triggered event start")

    -- ✅ Instance-safe signal
    local summoner = el:GetNPCByNPCTypeID(200056)
    if summoner then
      summoner:Signal(1)
      dprint("Signaled Summoner_of_Bertoxxulous (200056) within current instance.")
    else
      dprint("ERROR: Summoner_of_Bertoxxulous (200056) not found in this instance.")
    end
  end
end

-- =========================
-- Handler: Trash kills threshold logic
-- =========================
function Trash_Death(e)
  trash_dead = trash_dead + 1
  dprint("Trash Dead count = " .. trash_dead)

  local el = eq.get_entity_list()

  -- 42: Darwol Adan
  if trash_dead == 42 and not darwol_spawned then
    eq.zone_emote(MT.NPCQuestSay,
      "An unsettling feeling of fear passes through you as you hear the summoners finish a dark incantation then cry out saying, " ..
      "'We call to you corrupted King of Lxanvom, Darwol Adan, your master has need of you!' A bestial squeak thunders through the crypt " ..
      "as a foul fiend of Bertoxxulous is summoned forth.")
    eq.spawn2(200046, 0, 0, -3.09, 280.74, -245.20, 255.5) -- #Darwol_Adan
    darwol_spawned = true
    return
  end

  -- 46: Feig Adan
  if trash_dead == 46 and not feig_spawned then
    eq.spawn2(200045, 0, 0, -203.46, 0.68, -275.82, 128.8)
    eq.zone_emote(MT.NPCQuestSay,
      "An unsettling feeling of fear passes through you as you hear the summoners finish a dark incantation then cry out saying, " ..
      "'We call to you corrupted King of Lxanvom, Feig Adan, your master has need of you!' A bestial squeak thunders through the crypt " ..
      "as a foul fiend of Bertoxxulous is summoned forth.")
    feig_spawned = true
    return
  end

  -- 50: Xhut Adan
  if trash_dead == 50 and not xhut_spawned then
    eq.spawn2(200044, 0, 0, -1.24, -280.37, -245.82, 511.2)
    eq.zone_emote(MT.NPCQuestSay,
      "An unsettling feeling of fear passes through you as you hear the summoners finish a dark incantation then cry out saying, " ..
      "'We call to you corrupted King of Lxanvom, Xhut Adan, your master has need of you!' A dark vision flashes through the crypt " ..
      "as a foul fiend of Bertoxxulous is summoned forth.")
    xhut_spawned = true
    return
  end

  -- 54: Kavilis Adan
  if trash_dead == 54 and not kavillis_spawned then
    eq.spawn2(200047, 0, 0, 203.03, 1.63, -275.82, 381.8)
    eq.zone_emote(MT.NPCQuestSay,
      "An unsettling feeling of fear passes through you as you hear the summoners finish a dark incantation then cry out saying, " ..
      "'We call to you corrupted King of Lxanvom, Kavilis Adan, your master has need of you!' A faint buzzing is heard through the crypt " ..
      "as a foul fiend of Bertoxxulous is summoned forth.")
    kavillis_spawned = true
    return
  end

  -- Determine if first4 kings are up
  local first4_up = el:IsMobSpawnedByNpcTypeID(200046)
                   or el:IsMobSpawnedByNpcTypeID(200045)
                   or el:IsMobSpawnedByNpcTypeID(200044)
                   or el:IsMobSpawnedByNpcTypeID(200047)

  -- 108: Raddi Adan
  if (not first4_up) and trash_dead >= 108 and not raddi_spawned then
    eq.spawn2(200049, 0, 0, -2.79, 278.72, -245.82, 259.5)
    eq.zone_emote(MT.NPCQuestSay,
      "An unsettling feeling of fear passes through you as you hear the summoners finish a dark incantation then cry out saying, " ..
      "'We call to you corrupted King of Lxanvom, Raddi Adan, your master has need of you!' A wailing cry echoes through the crypt " ..
      "as a foul fiend of Bertoxxulous is summoned forth.")
    raddi_spawned = true
    return
  end

  -- 112: Wavadozzik Adan
  if (not first4_up) and trash_dead >= 112 and not wavadozzik_spawned then
    eq.spawn2(200048, 0, 0, -203.46, 0.68, -275.82, 128.8)
    eq.zone_emote(MT.NPCQuestSay,
      "An unsettling feeling of fear passes through you as you hear the summoners finish a dark incantation then cry out saying, " ..
      "'We call to you corrupted King of Lxanvom, Wavadozzik Adan, your master has need of you!' Chittering is heard through the crypt " ..
      "as a foul fiend of Bertoxxulous is summoned forth.")
    wavadozzik_spawned = true
    return
  end

  -- 116: Zandal Adan
  if (not first4_up) and trash_dead >= 116 and not zandal_spawned then
    eq.spawn2(200050, 0, 0, -1.24, -280.37, -245.82, 511.2)
    eq.zone_emote(MT.NPCQuestSay,
      "An unsettling feeling of fear passes through you as you hear the summoners finish a dark incantation then cry out saying, " ..
      "'We call to you corrupted King of Lxanvom, Zandal Adan, your master has need of you!' Chittering is heard through the crypt " ..
      "as a foul fiend of Bertoxxulous is summoned forth.")
    zandal_spawned = true
    return
  end

  -- 120: Akkapan Adan
  if (not first4_up) and trash_dead >= 120 and not akkapan_spawned then
    eq.spawn2(200051, 0, 0, 203.03, 1.63, -275.82, 381.8)
    eq.zone_emote(MT.NPCQuestSay,
      "An unsettling feeling of fear passes through you as you hear the summoners finish a dark incantation then cry out saying, " ..
      "'We call to you corrupted King of Lxanvom, Akkapan Adan, your master has need of you!' A maddened whispering is heard through the crypt " ..
      "as a foul fiend of Bertoxxulous is summoned forth.")
    akkapan_spawned = true
    return
  end

  -- 125: Final four kings (only when no mid/earlier kings up)
  local any_mid_up = el:IsMobSpawnedByNpcTypeID(200049)
                   or el:IsMobSpawnedByNpcTypeID(200048)
                   or el:IsMobSpawnedByNpcTypeID(200050)
                   or el:IsMobSpawnedByNpcTypeID(200051)
  if (not any_mid_up) and (not first4_up) and trash_dead >= 125
     and (not bhaly_spawned) and (not pzo_spawned)
     and (not qezzin_spawned) and (not meedo_spawned) then

    eq.spawn2(200054, 0, 0, 203.03, 1.63, -275.82, 381.8)   -- Bhaly West
    eq.spawn2(200053, 0, 0, -2.79, 278.72, -245.82, 259.5)  -- Meedo North
    eq.spawn2(200052, 0, 0, -203.46, 0.68, -275.82, 128.8)  -- Qezzin East
    eq.spawn2(200022, 0, 0, -1.24, -280.37, -245.82, 511.2) -- Pzo South
    eq.zone_emote(MT.NPCQuestSay,
      "An unsettling feeling of fear passes through you as you hear the summoners finish a dark incantation then cry out saying, " ..
      "'We call to you the last corrupted Kings of Lxanvom. Meedo Adan! Qezzin Adan! Pzo Adan! Bhaly Adan! Your master has need of you!' " ..
      "Four separate howls of rage and despair echo throughout the lower depths of the crypt as four foul fiends of Bertoxxulous are summoned forth.")
    qezzin_spawned = true
    meedo_spawned  = true
    pzo_spawned    = true
    bhaly_spawned  = true
    return
  end

  -- 125+: Bertoxxulous spawn (only when all kings are cleared)
  if (not kings_alive()) and trash_dead >= 125
     and bhaly_spawned and pzo_spawned and qezzin_spawned and meedo_spawned
     and (not bert_spawned) then

    eq.spawn2(200055, 0, 0, -61.75, -0.22, -288.5, 384.8) -- Bertoxxulous
    eq.zone_emote(MT.NPCQuestSay,
      "A sinister vision enters your mind of a faceless one handsome yet dead and decaying. " ..
      "The vision then shifts to that of a torn bestial creature and a loud shout is heard, " ..
      "'Defilers death comes for you today!'")
    bert_spawned = true
    dprint("Bertoxxulous spawned")
    return
  end
end

-- =========================
-- Handler: Bert death — cleanup
-- =========================
function Bert_Death(e)
  local el = eq.get_entity_list()
  if not el:IsMobSpawnedByNpcTypeID(200055) then
    eq.zone_emote(MT.NPCQuestSay,
      "A nimbus of light floods through the crypt in one magnificent wave as an earth shattering howl is heard. " ..
      "The bringer of plagues, lord of all disease and decay, Bertoxxulous has been defeated. " ..
      "Suddenly an urgent whisper fills your head simply saying, 'The Torch of Lxanvom shall burn bright again. " ..
      "Freedom is now ours, for that we thank you.'")

    -- Despawn everything
    eq.depop_all(200043)
    eq.depop_all(200042)
    eq.depop_all(200062)
    eq.depop_all(200063)
    eq.depop_all(200064)
    eq.depop_all(200065)
    eq.depop_all(200046)
    eq.depop_all(200045)
    eq.depop_all(200044)
    eq.depop_all(200047)
    eq.depop_all(200049)
    eq.depop_all(200048)
    eq.depop_all(200050)
    eq.depop_all(200051)
    eq.depop_all(200054)
    eq.depop_all(200053)
    eq.depop_all(200052)
    eq.depop_all(200022)
    eq.depop_all(200055)
    eq.depop_all(200056)
    eq.depop_all(200024)

    -- ✅ Corrected spawn_condition call
    local zone = eq.get_zone_short_name() or "codecay"
    local inst = eq.get_zone_instance_id() or 0
    eq.spawn_condition(zone, inst, 1, 0)

    eq.spawn2(218068, 0, 0, -61.75, -0.22, -288.5, 384.8) -- A_Planar_Projection

    reset_state()
    dprint("Bert death cleanup done")
  end
end

-- =========================
-- Encounter registration
-- =========================
function event_encounter_load(e)
  eq.register_npc_event('Bert', Event.death_complete, 200016, Spectre_Death)

  eq.register_npc_event('Bert', Event.death_complete, 200042, Trash_Death)
  eq.register_npc_event('Bert', Event.death_complete, 200043, Trash_Death)
  eq.register_npc_event('Bert', Event.death_complete, 200062, Trash_Death)
  eq.register_npc_event('Bert', Event.death_complete, 200063, Trash_Death)
  eq.register_npc_event('Bert', Event.death_complete, 200064, Trash_Death)
  eq.register_npc_event('Bert', Event.death_complete, 200065, Trash_Death)

  eq.register_npc_event('Bert', Event.death_complete, 200055, Bert_Death)

  dprint("Encounter loaded for public & instance")
end
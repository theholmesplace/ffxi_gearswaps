-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ CTRL+` ]          Cycle Treasure Hunter Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ ALT+` ]           Flee
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad8 ]    Mandalic Stab
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob (either melee,
--
--             SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
--             Fulltime - Will keep TH gear equipped fulltime

---------------------------------------------------------------------------------------------------
    -- Start of the setup, sets, and functions.
---------------------------------------------------------------------------------------------------

require('vectors')

function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')

    -- Optional 
    include('Treasurehider-Globals.lua') -- I list all my Augmented gears in a sidecar file since it's shared across many jobs.
	
	windower.register_event('zone change', function()
	classes.CustomIdleGroups:clear()
	handle_equipping_gear(player.status)	
end)
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring",
			  "Reraise Earring", "Reraise Hairpin", "Airmid's Gorget",
              "Warp Ring", "Maat's Cap"}

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    state.Ambush = M(false, 'Ambush')
    -- state.CP = M(false, "Capacity Points Mode")

    lockstyleset = 199
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'HighAcc', 'Subtle', 'Crits')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'RAcc')
    state.WeaponskillMode:options('Normal', 'Acc', 'LowBuff')
    state.IdleMode:options('Normal', 'DT', 'Refresh')

    send_command('bind ^` gs c cycle treasuremode')
    send_command('bind !` input /ja "Flee" <me>')
    send_command('bind numpad0 gs c toggle Ambush')

    -- send_command('bind @c gs c toggle CP')

    send_command('bind ^numlock input /ja "Assassin\'s Charge" <me>')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>')
    end

    send_command('bind ^numpad7 input /ws "Exenterator" <t>')
    send_command('bind ^numpad8 input /ws "Mandalic Stab" <t>')
    send_command('bind ^numpad4 input /ws "Evisceration" <t>')
    send_command('bind ^numpad5 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')
    send_command('bind ^numpad2 input /ws "Wasp Sting" <t>')
    send_command('bind ^numpad3 input /ws "Gust Slash" <t>')

    send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
    send_command('bind ^numpad. input /ja "Trick Attack" <me>')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind numpad0')
    -- send_command('unbind @c')
    send_command('unbind @r')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    -- JSE
    AF = {}         -- leave this empty
    RELIC = {}      -- leave this empty
    EMPY = {}       -- leave this empty


    --Pillager's
    AF.Head		=	"Pill. Bonnet +3"
    AF.Body		=	"Pillager's Vest +3"
    AF.Hands	=	"Rog. Armlets +1"
    AF.Legs		=	"Pill. Culottes +3"
    AF.Feet		=	"Pill. Poulaines +3"

    --Plunderer's
    RELIC.Head		=	"Plun. Bonnet +3"
    RELIC.Body		=	"Plunderer's Vest +3"
    RELIC.Hands 	=	"Plun. Armlets +3"
    RELIC.Legs		=	"Plun. Culottes +3"
    RELIC.Feet		=	"Plun. Poulaines +4"

    --Skulker's
    EMPY.Head		=	"Skulker's Bonnet +3"
    EMPY.Body		=	"Skulker's Vest +3"
    EMPY.Hands		=	"Skulk. Armlets +3"
    EMPY.Legs		=	"Skulk. Culottes +3"
    EMPY.Feet		=	"Skulk. Poulaines +3"
	EMPY.Ear		=	"Skulk. Earring +1"

    -- Capes:
    -- Toutatis's and such
    THFCape = {}
	THFCape.TP		=	{ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
	THFCape.WS		=	{ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}
	
	------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.TreasureHunter = {
        --hands=RELIC.Hands, --4
        feet=EMPY.Feet, --5
        --waist="Chaac Belt", --1
        }

    sets.buff['Sneak Attack'] = {}
    sets.buff['Trick Attack'] = {}

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter

    -- Precast sets to enhance JAs
    sets.precast.JA['Accomplice'] = {head=EMPY.Head}
    sets.precast.JA['Collaborator'] = {head=EMPY.Head}
    sets.precast.JA['Aura Steal'] = {head=RELIC.Head}
    sets.precast.JA['Flee'] = {feet=AF.Feet}
    sets.precast.JA['Hide'] = {body=AF.Body}
    sets.precast.JA['Conspirator'] = {body=EMPY.Body}
    sets.precast.JA['Perfect Dodge'] = {body=RELIC.Hands}
    sets.precast.JA['Feint'] = {legs=RELIC.Legs}
    sets.precast.JA['Despoil'] = {ammo="Barathrum", legs=EMPY.Legs, feet=EMPY.Feet}

    sets.precast.JA['Steal'] = { -- 30 steal total
        ammo="Barathrum", -- 3 steal
        head="Rogue's. Bonnet", -- 1 steal
        hands="Thief's Kote", -- 3 steal
		legs="Assassin's Culottes", -- 5 steal
        feet=AF.Feet, -- 15 steal
		neck="Pentalagus Charm", -- 2 steal
		waist="Key ring belt", -- 1 steal
        }

    sets.precast.Waltz = {
        ammo="Yamarang",
		head="Mummu bonnet +2",
        body="Gleti's Cuirass",
        legs="Dashing Subligar",
        ring1="Asklepian Ring",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        ammo="Sapience Orb", -- 2
         head={ name="Herculean Helm", augments={'CHR+5','Weapon skill damage +2%','Mag. Acc.+19 "Mag.Atk.Bns."+19',}}, --7
        body={ name="Taeon Tabard", augments={'Accuracy+20 Attack+20','Spell interruption rate down -9%','Phalanx +3',}}, --4
        hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}}, --7
        ear1="Etiolation Earring", --1
		ring1="Prolix Ring", -- enhances
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        --body="Passion Jacket",
        ring1="Lebeche Ring",
        })

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo="Aurgelmir Orb +1",
        head=AF.Head,
		body=EMPY.Body,
        hands="Meg. Gloves +2",
        legs=RELIC.Legs,
        feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Odr Earring",
        right_ear="Moonshade Earring",
        left_ring="Regal Ring",
        right_ring="Epaminondas's Ring",
        back=THFCape.WS
        } -- default set


    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1"
        })

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head="Blistering Sallet +1",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Gleti's Gauntlets",
		legs=EMPY.Legs,
        feet="Gleti's Boots",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		right_ear="Sherida Earring",
		right_ring="Ilabrat Ring",
        })

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet=gear.Herc_MAB_feet,
        neck="Baetyl Pendant",
		left_ear="Friomisi Earring",
		left_ring="Acumen Ring",
		back="Argocham. Mantle",
        waist="Orpheus's Sash",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Staunch Tathlum +1", --11
		head={ name="Taeon Chapeau", augments={'Evasion+25','Spell interruption rate down -8%','HP+45',}}, --8
		body={ name="Taeon Tabard", augments={'Accuracy+20 Attack+20','Spell interruption rate down -9%','Phalanx +3',}}, -- 9
		hands={ name="Rawhide Gloves", augments={'HP+50','Accuracy+15','Evasion+20',}}, --15
		feet={ name="Taeon Boots", augments={'Accuracy+18 Attack+18','Spell interruption rate down -9%','Phalanx +3',}}, --9
		ear1="Halasz Earring", --5
        ring1="Evanescence Ring", --5
        ring2="Murky Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Turms Cap +1",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet=AF.Feet,
        neck="Bathy Choker +1",
		waist="Plat. Mog. Belt", -- 3/3
		back="Moonlight Cape",
        ring1={name="Moonlight Ring", bag="wardrobe3"},
        ring2={name="Murky Ring"}
        }

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1", --3/3
        head="Nyame Helm", --7/7
		body="Nyame Mail", --9/9
        hands="Nyame Gauntlets", --7/7
        legs="Nyame Flanchard", --8/8
        feet="Nyame Sollerets", --7/7
        neck="Warder's Charm +1",
        ear1="Eabani Earring",
        ear2="Sanare Earring",
        })

    sets.idle.Town = set_combine(sets.idle, {
        ammo="Barathrum",
		head="Turms Cap +1",
		body="Tidal Talisman",
		hands="Turms Mittens +1",
        neck="Bathy Choker +1",
		ring1="Trizek Ring",
		ring2="Sheltered Ring",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet=AF.Feet}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        ammo="Aurgelmir Orb +1",
		head=EMPY.Head,
        body=AF.Body,
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet=RELIC.Feet,
        neck="Asn. Gorget +2",
        left_ear="Sherida Earring",
        right_ear="Dedition Earring", -- REPLACE WITH THF EARRING
        ring1="Hetairoi Ring", -- REPLACE WITH VORGANCE QUEST RING
        ring2="Gere Ring",
        back=THFCape.TP,
        waist="Reiki Yotai",
        }

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        ear2="Telos Earring",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ear1="Cessance Earring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        ammo="C. Palug Stone",
        legs=AF.Legs,
        left_ring="Regal Ring",
        right_ring={name="Chirich Ring +1", bag="wardrobe5"}
        })

    sets.engaged.Subtle = set_combine(sets.engaged, {
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Rawhide Vest", augments={'HP+50','"Subtle Blow"+7','"Triple Atk."+2',}},
		hands={ name="Herculean Gloves", augments={'Accuracy+23','"Triple Atk."+2','DEX+5','Attack+15',}},
		legs="Ighwa Trousers",
		feet={ name="Herculean Boots", augments={'Accuracy+23','"Triple Atk."+4','Attack+10',}},
		neck="Bathy Choker +1",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
        left_ring={name="Chirich Ring +1", bag="wardrobe3"},
        right_ring={name="Chirich Ring +1", bag="wardrobe5"}
        })

    sets.engaged.Crits = set_combine(sets.engaged, {
		ammo="Yetshila +1",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		left_ring="Hetairoi Ring",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Nyame Helm",
        --head="Malignance Chapeau", --6/6
		body="Nyame Mail", --6/0
        --body="Malignance Tabard", --9/9
		hands="Nyame Gauntlets",
        --hands="Malignance Gloves", --5/5
		legs="Nyame Flanchard", --6/0
        --legs="Malignance Tights", --7/7
		feet="Nyame Sollerets",
        --feet="Malignance Boots", --4/4
        ring2="Murky Ring", --10/10
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.Crits.DT = set_combine(sets.engaged.Crits, sets.engaged.Hybrid)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff['Ambush'] = {body=RELIC.Body}

    sets.buff.Doom = {
        --neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe5"}, --20
        waist="Gishdubar Sash", --10
        }

    --sets.Reive = {neck="Ygnas's Resolve +1"}
    -- sets.CP = {back="Mecisto. Mantle"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
    if spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
    end
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Aeolian Edge' then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doom! Ahh!')
             disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

    if not midaction() then
        handle_equipping_gear(player.status)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MidAcc' or state.OffenseMode.value == 'HighAcc' then
        wsmode = 'Acc'
    end

    --if state.Buff['Sneak Attack'] then
    --    wsmode = 'SA'
    --end
    --if state.Buff['Trick Attack'] then
    --    wsmode = (wsmode or '') .. 'TA'
    --end

    return wsmode
end

function customize_idle_set(idleSet)
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

function customize_melee_set(meleeSet)
    if state.Ambush.value == true then
        meleeSet = set_combine(meleeSet, sets.buff['Ambush'])
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value ~= 'None' then
        msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 6 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 6 and DW_needed <= 22 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 22 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 26 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']

        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('input /ja "Presto" <me>')
        end
    end
end

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(5, 8)
    elseif player.sub_job == 'WAR' then
        set_macro_page(4, 8)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 8)
    else
        set_macro_page(3, 8)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end

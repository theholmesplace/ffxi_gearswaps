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
--              [ F12 ]             Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+F ]           Toggle Closed Position (Facing) Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--              [ CTRL+T ]          Toggle Treasure Hunter Mode--removed
--
--  Abilities:  [ CTRL+- ]          Primary step element cycle forward.
--              [ CTRL+= ]          Primary step element cycle backward.
--              [ ALT+- ]           Secondary step element cycle forward.
--              [ ALT+= ]           Secondary step element cycle backward.
--              [ CTRL+[ ]          Toggle step target type.
--              [ CTRL+] ]          Toggle use secondary step.
--              [ Numpad0 ]         Perform Current Step
--
--              [ CTRL+` ]          Saber Dance
--              [ ALT+` ]           Chocobo Jig II
--              [ ALT+[ ]           Contradance
--              [ CTRL+Numlock ]    Reverse Flourish
--              [ CTRL+Numpad/ ]    Berserk/Meditate
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki
--              [ CTRL+Numpad- ]    Aggressor/Third Eye
--              [ CTRL+Numpad+ ]    Climactic Flourish
--              [ CTRL+NumpadEnter ]Building Flourish
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad6 ]    Pyrrhic Kleos
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c step                       Uses the currently configured step on the target, with either <t> or
--                                  <stnpc> depending on setting.
--  gs c step t                     Uses the currently configured step on the target, but forces use of <t>.
--
--  gs c cycle mainstep             Cycles through the available steps to use as the primary step when using
--                                  one of the above commands.
--  gs c cycle altstep              Cycles through the available steps to use for alternating with the
--                                  configured main step.
--  gs c toggle usealtstep          Toggles whether or not to use an alternate step.
--  gs c toggle selectsteptarget    Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
	state.Buff['Striking Flourish'] =  buffactive['striking flourish'] or false

    state.MainStep = M{['description']='Main Step', 'Box Step', 'Feather Step', 'Quickstep', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Feather Step', 'Quickstep', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')

    state.ClosedPosition = M(false, 'Closed Position')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
--  state.SkillchainPending = M(false, 'Skillchain Pending')

    state.CP = M(false, "Capacity Points Mode")
	
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}	

include('Mote-TreasureHunter')
	
    lockstyleset = 4
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'STP', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'Crit', 'Counter', 'Subtle', 'Karambit')
    state.WeaponskillMode:options('Normal', 'Acc', 'Subtle', 'PDL')
	state.PhysicalDefenseMode:options('PDT', 'Regal')
    state.IdleMode:options('Normal', 'Regain')

    -- Additional local binds
    send_command('lua l gearinfo')
	send_command('lua l DNC-hud')

     send_command('bind ^T gs c cycle treasuremode')
    send_command('bind ^- gs c cycleback mainstep')
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind !- gs c cycleback altstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind !p gs c toggle usealtstep')
    send_command('bind ![ input /ja "Contradance" <me>')
    send_command('bind ^` input /ja "Presto" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')
    send_command('bind @f gs c toggle ClosedPosition')
    send_command('bind @c gs c toggle CP')

    send_command('bind ^numlock input /ja "Reverse Flourish" <me>')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>')
    elseif player.sub_job == 'THF' then
        send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
        send_command('bind ^numpad. input /ja "Trick Attack" <me>')
    end

    send_command('bind ^numpad+ input /ja "Climactic Flourish" <me>')
    send_command('bind ^numpadenter input /ja "Building Flourish" <me>')

    send_command('bind ^numpad7 input /ws "Exenterator" <t>')
    send_command('bind ^numpad4 input /ws "Evisceration" <t>')
    send_command('bind ^numpad5 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad6 input /ws "Pyrrhic Kleos" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')

    --send_command('bind numpad0 gs c step')

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
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind !p')
    send_command('unbind ^[')
    send_command('unbind ^]')
    send_command('unbind ![')
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind @f')
    send_command('unbind @c')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad+')
    send_command('unbind ^numpadenter')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')
    send_command('unbind numpad0')
    --send_command('unbind ^numpad0')
	 send_command('unbind ^T')
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
	send_command('lua u gearinfo')
	send_command('lua u DNC-hud')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity set
    sets.Enmity = {ammo="Sapience Orb",
    head="Halitus Helm",
    body={ name="Emet Harness +1", augments={'Path: A',}},
    hands={ name="Horos Bangles +3", augments={'Enhances "Fan Dance" effect',}},
    legs="Obatala Subligar",
    feet="Ahosi Leggings",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Kasiri Belt",
    left_ear="Cryptic Earring",
    right_ear="Trux Earring",
    left_ring="Provocare Ring",
    right_ring="Pernicious Ring",
    back={ name="Senuna's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},
}

    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast.JA['No Foot Rise'] = {body="Horos Casaque +3"}
    sets.precast.JA['Trance'] = {head="Horos Tiara +3"}
	
	sets.precast.JA['Jump'] = {    ammo="Aurgelmir Orb +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet="Malignance Boots",
    neck="Anu Torque",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Sherida Earring",
    right_ear="Telos Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
}
	sets.precast.JA['High Jump'] = sets.precast.JA['Jump']

    sets.precast.Waltz = {ammo="Yamarang",
    head="Anwig Salade",
    body="Maxixi Casaque +3",
    hands="Maxixi Bangles +3",
    legs="Dashing Subligar",
    feet="Maxixi Toe Shoes +3",
    neck="Etoile gorget +2",
    left_ear="Enchntr. Earring +1",
    right_ear="Handler's Earring +1",
    left_ring="Carb. Ring",
    right_ring="Carb. Ring",
    back={ name="Toetapper Mantle", augments={'"Store TP"+4','"Dual Wield"+1','"Rev. Flourish"+30',}},
} -- Waltz Potency/CHR

    sets.precast.WaltzSelf = set_combine(sets.precast.Waltz, {
        head="Mummu Bonnet +2", --8
        }) -- Waltz effects received

    sets.precast.Waltz['Healing Waltz'] = {}
    sets.precast.Samba = {head="Maxixi Tiara +3", back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},}
    sets.precast.Jig = {legs="Horos Tights +3", feet="Maxixi Toe Shoes +3"}

    sets.precast.Step = {ammo="Yamarang",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Macu. Bangles +3",
    legs="Malignance Tights",
    feet="Macu. Toe Sh. +3",
    neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    waist="Eschan Stone",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
    right_ring="Moonlight Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
}

    sets.precast.Step['Feather Step'] = set_combine(sets.precast.Step, {feet="Macu. Toe Sh. +3"})
    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Animated Flourish'] = sets.Enmity

    sets.precast.Flourish1['Violent Flourish'] = {ammo="Yamarang",
    head="Maculele Tiara +3",
    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    hands="Macu. Bangles +3",
    legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
    feet="Macu. Toe Sh. +3",
    neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    waist="Eschan Stone",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Stikini Ring +1",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','System: 1 ID: 640 Val: 4',}},
} -- Magic Accuracy

    sets.precast.Flourish1['Desperate Flourish'] = {ammo="Yamarang",
    head="Maxixi Tiara +3",
    body="Maxixi Casaque +3",
    hands="Maxixi Bangles +3",
    legs="Meg. Chausses +2",
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck="Etoile Gorget +2",
    waist="Eschan Stone",
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Ramuh Ring +1",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},
} -- Accuracy

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {hands="Maculele bangles +3",back="Toetapper Mantle", augments={'"Store TP"+3','"Rev. Flourish"+27',}}
    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {body="Macu. Casaque +3"}
    sets.precast.Flourish3['Climactic Flourish'] = {head="Maculele Tiara +3",}

    sets.precast.FC = {ammo="Sapience Orb",
    head={ name="Herculean Helm", augments={'Accuracy+14','"Fast Cast"+5','Mag. Acc.+1','"Mag.Atk.Bns."+1',}},
    body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs={ name="Herculean Trousers", augments={'"Mag.Atk.Bns."+14','"Fast Cast"+6','STR+3','Mag. Acc.+14',}},
    feet={ name="Herculean Boots", augments={'Mag. Acc.+22','"Fast Cast"+6','STR+7','"Mag.Atk.Bns."+4',}},
    neck="Orunmila's Torque",
    waist="Engraved Belt",
    left_ear="Enchntr. Earring +1",
    right_ear="Loquac. Earring",
    left_ring="Lebeche Ring",
    right_ring="Rahab Ring",
}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        body="Passion Jacket",
        neck="Magoraga Beads",
        })


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
    ammo="Aurgelmir Orb +1",
    head="Nyame Helm",
    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    hands="Maxixi Bangles +3",
    legs="Gleti's Breeches",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
} -- default set

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        head="Dampening Tam",
        legs="Meg. Chausses +2",
        feet="Meg. Jam. +2",
        ear2="Telos Earring",
        })

	sets.precast.WS.Subtle = set_combine(sets.precast.WS, {
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe4"},
		})
		
	sets.precast.WS.PDL = set_combine(sets.precast.WS, {
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
})

    sets.precast.WS.Critical = {body="Meg. Cuirie +2"}

    sets.precast.WS['Exenterator'] = {
    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    { name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    hands="Maxixi Bangles +3",
    legs="Meg. Chausses +2",
    feet="Meg. Jam. +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear="Telos Earring",
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
}

    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {
        head="Dampening Tam",
        })

    sets.precast.WS['Exenterator'].Subtle = set_combine(sets.precast.WS['Exenterator'], {
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe4"},
		})

	sets.precast.WS['Exenterator'].PDL = set_combine(sets.precast.WS['Exenterator'], {
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
})

    sets.precast.WS['Pyrrhic Kleos'] = {ammo={ name="Coiste Bodhar", augments={'Path: A',}},
    head="Maculele Tiara +3",
    body={ name="Gleti's Cuirass", augments={'Path: A',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Lustra. Leggings +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
    neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear="Mache Earring +1",
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}

    sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS['Pyrrhic Kleos'], {
        head="Dampening Tam",
        ear2="Telos Earring",
		legs="Meg. Chausses +2",
        ring1="Ramuh Ring +1",
        })

    sets.precast.WS['Pyrrhic Kleos'].Subtle = set_combine(sets.precast.WS['Pyrrhic Kleos'], {
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe4"},
		})

	sets.precast.WS['Pyrrhic Kleos'].PDL = set_combine(sets.precast.WS['Pyrrhic Kleos'], {
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
	left_ring="Defending Ring",
    right_ring="Moonlight Ring",	
})	

    sets.precast.WS['Evisceration'] = {ammo="Charis Feather",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Gleti's Cuirass", augments={'Path: A',}},
    hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear="Odr Earring",
    left_ring="Regal Ring",
    right_ring="Lehko's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
}

    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
        ammo="Aurgelmir Orb +1",
        head="Dampening Tam",
		body="Adhemar Jacket +1",
        legs="Meg. Chausses +2",
        feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
        ear2="Telos Earring",
        ring2="Regal Ring",
        })

    sets.precast.WS['Evisceration'].Subtle = set_combine(sets.precast.WS['Evisceration'], {
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe4"},
		})

	sets.precast.WS['Evisceration'].PDL = set_combine(sets.precast.WS['Evisceration'], {
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
	left_ring="Defending Ring",
    right_ring="Moonlight Ring",
})	

    sets.precast.WS['Rudra\'s Storm'] = {ammo="Aurgelmir Orb +1",
    head="Maculele Tiara +3",
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear="Sherida Earring",
    right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    left_ring="Epaminondas's Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
}

    sets.precast.WS['Rudra\'s Storm'].Acc = set_combine(sets.precast.WS['Rudra\'s Storm'], {
        head="Dampening tam",
        ear2="Telos Earring",
        })

    sets.precast.WS['Rudra\'s Storm'].Subtle = set_combine(sets.precast.WS['Rudra\'s Storm'], {
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe4"},
		})

	sets.precast.WS['Rudra\'s Storm'].PDL = set_combine(sets.precast.WS['Rudra\'s Storm'], {
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
	left_ring="Defending Ring",
    right_ring="Moonlight Ring",
})	

    sets.precast.WS['Shark Bite'] = {ammo="Aurgelmir Orb +1",
    head="Maculele Tiara +3",
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Epaminondas's Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
}

    sets.precast.WS['Shark Bite'].Acc = set_combine(sets.precast.WS['Rudra\'s Storm'], {
        head="Dampening tam",
        ear2="Telos Earring",
        })

    sets.precast.WS['Shark Bite'].Subtle = set_combine(sets.precast.WS['Rudra\'s Storm'], {
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe4"},
		})

	sets.precast.WS['Shark Bite'].PDL = set_combine(sets.precast.WS['Rudra\'s Storm'], {
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
	left_ring="Defending Ring",
    right_ring="Moonlight Ring",
})

    sets.precast.WS['Aeolian Edge'] = {
    ammo="Pemphredo Tathlum",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame sollerets",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Friomisi Earring",
    right_ear="Crematio Earring",
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
}
	sets.precast.WS['Asuran Fists'] = {ammo="Aurgelmir Orb +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear="Balder Earring +1",
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}

	sets.precast.WS['Tornado Kick'] = {ammo={ name="Coiste Bodhar", augments={'Path: A',}},
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Balder Earring +1",
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}

	sets.precast.WS['Raging Fists'] = sets.precast.WS['Pyrrhic Kleos']
	
    --sets.precast.Skillchain = {
    --    hands="Macu. Bangles +1",
    --    }


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        ring1="Evanescence Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt
	
	sets.midcast.Flash = sets.Enmity
	sets.TreasureHunter = {
    head="Volte Cap",
    hands="Volte Bracers",
    legs="Volte Hose",
    feet="Volte Boots",
}
	

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Warder's Charm +1",
    waist="Engraved Belt",
    left_ear="Sanare Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring="Moonlight Ring",
    back={ name="Senuna's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},
}

    sets.idle.Regain = set_combine(sets.idle, {
	head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
})	

    sets.idle.Town = sets.idle

    sets.idle.Weak = sets.idle.DT


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle
	

	sets.defense.Regal = {ammo="Staunch Tathlum +1",
    head="Meghanada Visor +2",
    body="Ashera Harness",
    hands="Regal Gloves",
    legs="Meg. Chausses +2",
    feet="Ahosi Leggings",
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear="Odnowa Earring +1",
    left_ring="Defending Ring",
    right_ring="Moonlight Ring",
    back="Moonlight Cape",
}


    sets.defense.MDT = {ammo="Staunch Tathlum +1",
    head="Turms Cap +1",
    body="Tu. Harness +1",
    hands="Turms Mittens +1",
    legs="Volte Tights",
    feet="Turms Leggings +1",
    neck="Loricate Torque +1",
    waist="Windbuffet Belt +1",
    left_ear="Sanare Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring="Moonlight Ring",
    back={ name="Senuna's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},
}


    sets.Kiting = {feet="Tandava Crackows"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck="Etoile Gorget +2",
    waist="Windbuffet Belt +1",
    left_ear="Sherida Earring",
    right_ear="Eabani Earring",
    left_ring="Gere ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Mag. Evasion+15',}},
}
		
    sets.engaged.STP = set_combine(sets.engaged, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
	right_ring="Moonlight Ring",
})

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        head="Dampening Tam",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        legs="Meg. Chausses +2",
		head="Maxixi Tiara +3",
		waist="Kentarch Belt +1",})

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        body="Maxixi Casaque +3",
        ring2="Regal Ring",
		})



    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW
    -- --Twashtar Sets

	-- sets.engaged.Twashtar = {ammo="Aurgelmir Orb +1",
    -- head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    -- body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    -- hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    -- legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    -- feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    -- neck="Etoile Gorget +2",
    -- waist="Gerdr Belt +1",
    -- left_ear="Sherida Earring",
    -- right_ear="Balder Earring +1",
    -- left_ring="Gere ring",
    -- right_ring="Epona's Ring",
    -- back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Mag. Evasion+15',}},
-- }
	-- sets.engaged.Twashtar.SW = sets.engaged.Twashtar

	-- sets.engaged.Twashtar.SW.STP = set_combine(sets.engaged.Twashtar, {
    -- head="Malignance Chapeau",
    -- body="Malignance Tabard",
    -- hands="Malignance Gloves",
    -- legs="Malignance Tights",
    -- feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    -- left_ear="Dedition Earring",
    -- right_ear="Telos Earring",
    -- left_ring="Chirich Ring +1",
    -- right_ring="Chirich Ring +1",
-- })
	-- sets.engaged.Twashtar.SW.LowAcc = set_combine(sets.engaged.Twashtar, {
        -- ear2="Telos earring",
		-- ring2="Regal Ring",
		-- body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        -- })

	-- sets.engaged.Twashtar.SW.MidAcc = set_combine(sets.engaged.Twashtar.LowAcc, {
        -- head="Maxixi Tiara +3", --8
        -- body="Horos Casaque +3",
        -- ring1="Ramuh ring +1",
        -- waist="Kentarch Belt +1",
        -- })
	-- sets.engaged.Twashtar.SW.HighAcc = set_combine(sets.engaged.Twashtar.MidAcc, {
        -- body="Maxixi Casaque +3",
        -- hands="Maxixi Bangles +3",
        -- })
	
	

    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW	
    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {ammo="Aurgelmir Orb +1",
    head="Maxixi Tiara +3",
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    waist="Reiki Yotai",
    left_ear="Suppanomimi",
    right_ear="Eabani Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
} -- 40/41%

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
	right_ring="Moonlight Ring",
})

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {
        ear2="Telos earring",
		ring2="Regal Ring",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {
        head="Maxixi Tiara +3", --8
        body="Horos Casaque +3",
        ring1="Ramuh ring +1",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        body="Maxixi Casaque +3",
        hands="Maxixi Bangles +3",
        })



    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    waist="Reiki Yotai",
    left_ear="Suppanomimi",
    right_ear="Eabani Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
} -- 32/32%

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
	right_ring="Moonlight Ring",
})

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
		head="Dampening Tam",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		ear2="Telos earring",})

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
        body="Horos Casaque +3",
        ring2="Moonlight ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        ring2="Regal Ring",
		head="Maxixi Tiara +3",
		body="Maxixi Casaque +3",
		hands="Maxixi Bangles +3",
        })



    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    hands="Adhemar Wristbands +1",
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck="Etoile Gorget +2",
    waist="Reiki Yotai",
    left_ear="Sherida Earring",
    right_ear="Eabani Earring",
    left_ring="Gere ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
} -- 21%

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
	right_ring="Moonlight Ring",
})

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        head="Dampening Tam",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		ear2="Telos earring",
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
        legs="Meg. Chausses +2",
		head="Maxixi Tiara +3",
		waist="Kentarch Belt +1",
		})

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        body="Maxixi Casaque +3",
        ring2="Regal Ring",
		})



    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck="Etoile Gorget +2",
    waist="Windbuffet Belt +1",
    left_ear="Sherida Earring",
    right_ear="Balder earring +1",
    left_ring="Gere ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
} -- 10% Gear

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
	right_ring="Moonlight Ring",
})

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        head="Dampening Tam",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        })

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
        legs="Meg. Chausses +2",
		head="Maxixi Tiara +3",
		waist="Kentarch Belt +1",
		})

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        body="Maxixi Casaque +3",
        ring2="Regal Ring",
		})



    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
    head="Malignance Chapeau",
    body={ name="Gleti's Cuirass", augments={'Path: A',}},
    hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
    legs="Malignance Tights",
    feet="Macu. Toe Sh. +3",
    neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Sherida Earring",
    right_ear="Dedition Earring",
    left_ring="Gere Ring",
    right_ring="Lehko's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
}
	
	-- {ammo={ name="Coiste Bodhar", augments={'Path: A',}},
    -- head="Malignance Chapeau",
    -- body={ name="Gleti's Cuirass", augments={'Path: A',}},
    -- hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
    -- legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    -- feet="Macu. Toe Sh. +3",
    -- neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    -- waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    -- left_ear="Sherida Earring",
    -- right_ear="Telos Earring",
    -- left_ring="Gere Ring",
    -- right_ring="Epona's Ring",
    -- back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
-- } -- 0%

    -- sets.engaged.DW.MaxHaste = {ammo="Aurgelmir Orb +1",
    -- head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    -- body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    -- hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    -- legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    -- feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    -- neck="Etoile Gorget +2",
    -- waist="Windbuffet Belt +1",
    -- left_ear="Sherida Earring",
    -- right_ear="Balder earring +1",
    -- left_ring="Gere ring",
    -- right_ring="Epona's Ring",
    -- back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
-- } -- 0%

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
	right_ring="Moonlight Ring",
})

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        head="Dampening Tam",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        })

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
        legs="Meg. Chausses +2",
		head="Maxixi Tiara +3",
		waist="Kentarch Belt +1",})

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        body="Maxixi Casaque +3",
        ring2="Regal Ring",
		})



    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------
	
    sets.engaged.Hybrid = {ammo="Staunch Tathlum +1",
    left_ring="Defending Ring",
	right_ring="Moonlight Ring",
}

	sets.engaged.Karambit = {ammo={ name="Coiste Bodhar", augments={'Path: A',}},
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body={ name="Gleti's Cuirass", augments={'Path: A',}},
    hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
    legs="Volte Tights",
    feet="Macu. Toe Sh. +3",
    neck={ name="Etoile Gorget +2", augments={'Path: A',}},
    waist="Gerdr Belt +1",
    left_ear="Mache earring +1",
    right_ear="Mache earring +1",
    -- left_ear="Sherida Earring",
    -- right_ear="Odr Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
}

	sets.engaged.MeleeCrit = {ammo="Charis Feather",
    body="Mummu Jacket +2",
	head="Blistering Sallet +1",
    legs="Mummu Kecks +2",
    feet="Mummu Gamash. +2",
    neck="Etoile Gorget +2",
    waist="Gerdr Belt +1",
    left_ring="Mummu Ring",
    right_ring="Hetairoi Ring",
	right_ear="Odr Earring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Mag. Evasion+15',}},
}
	
	sets.engaged.CounterSet = {ammo="Amar Cluster",
    hands={ name="Horos Bangles +3", augments={'Enhances "Fan Dance" effect',}},
	neck="Bathy Choker +1",
    legs={ name="Ta'lab Trousers", augments={'Accuracy+15','Mag. Evasion+15','Enmity-7','Crit.hit rate+3',}},
    left_ear="Cryptic Earring",
    right_ear="Genmei Earring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','System: 1 ID: 640 Val: 4',}},
}

	sets.engaged.SubtleSet = {
	left_ring={name="Chirich Ring +1", bag="wardrobe2"},
	right_ring={name="Chirich Ring +1", bag="wardrobe4"},
	}
	
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)
	
    sets.engaged.Crit = set_combine(sets.engaged, sets.engaged.MeleeCrit)
    sets.engaged.LowAcc.Crit = set_combine(sets.engaged.LowAcc, sets.engaged.MeleeCrit)
    sets.engaged.MidAcc.Crit = set_combine(sets.engaged.MidAcc, sets.engaged.MeleeCrit)
    sets.engaged.HighAcc.Crit = set_combine(sets.engaged.HighAcc, sets.engaged.MeleeCrit)
    sets.engaged.STP.Crit = set_combine(sets.engaged.STP, sets.engaged.MeleeCrit)	
	
    sets.engaged.Counter = set_combine(sets.engaged, sets.engaged.CounterSet)
    sets.engaged.LowAcc.Counter = set_combine(sets.engaged.LowAcc, sets.engaged.CounterSet)
    sets.engaged.MidAcc.Counter = set_combine(sets.engaged.MidAcc, sets.engaged.CounterSet)
    sets.engaged.HighAcc.Counter = set_combine(sets.engaged.HighAcc, sets.engaged.CounterSet)
    sets.engaged.STP.Counter = set_combine(sets.engaged.STP, sets.engaged.CounterSet)

    sets.engaged.Subtle = set_combine(sets.engaged, sets.engaged.SubtleSet)
    sets.engaged.LowAcc.Subtle = set_combine(sets.engaged.LowAcc, sets.engaged.SubtleSet)
    sets.engaged.MidAcc.Subtle = set_combine(sets.engaged.MidAcc, sets.engaged.SubtleSet)
    sets.engaged.HighAcc.Subtle = set_combine(sets.engaged.HighAcc, sets.engaged.SubtleSet)
    sets.engaged.STP.Subtle = set_combine(sets.engaged.STP, sets.engaged.SubtleSet)	

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)
	
    sets.engaged.DW.Crit = set_combine(sets.engaged.DW, sets.engaged.MeleeCrit)
    sets.engaged.DW.LowAcc.Crit = set_combine(sets.engaged.DW.LowAcc, sets.engaged.MeleeCrit)
    sets.engaged.DW.MidAcc.Crit = set_combine(sets.engaged.DW.MidAcc, sets.engaged.MeleeCrit)
    sets.engaged.DW.HighAcc.Crit = set_combine(sets.engaged.DW.HighAcc, sets.engaged.MeleeCrit)
    sets.engaged.DW.STP.Crit = set_combine(sets.engaged.DW.STP, sets.engaged.MeleeCrit)	

    sets.engaged.DW.Counter = set_combine(sets.engaged.DW, sets.engaged.CounterSet)
    sets.engaged.DW.LowAcc.Counter = set_combine(sets.engaged.DW.LowAcc, sets.engaged.CounterSet)
    sets.engaged.DW.MidAcc.Counter = set_combine(sets.engaged.DW.MidAcc, sets.engaged.CounterSet)
    sets.engaged.DW.HighAcc.Counter = set_combine(sets.engaged.DW.HighAcc, sets.engaged.CounterSet)
    sets.engaged.DW.STP.Counter = set_combine(sets.engaged.DW.STP, sets.engaged.CounterSet)	

    sets.engaged.DW.Subtle = set_combine(sets.engaged.DW, sets.engaged.SubtleSet)
    sets.engaged.DW.LowAcc.Subtle = set_combine(sets.engaged.DW.LowAcc, sets.engaged.SubtleSet)
    sets.engaged.DW.MidAcc.Subtle = set_combine(sets.engaged.DW.MidAcc, sets.engaged.SubtleSet)
    sets.engaged.DW.HighAcc.Subtle = set_combine(sets.engaged.DW.HighAcc, sets.engaged.SubtleSet)
    sets.engaged.DW.STP.Subtle = set_combine(sets.engaged.DW.STP, sets.engaged.SubtleSet)	

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)
	
    sets.engaged.DW.Crit.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.LowAcc.Crit.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.MidAcc.Crit.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.HighAcc.Crit.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.STP.Crit.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.MeleeCrit)

    sets.engaged.DW.Counter.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.CounterSet)
    sets.engaged.DW.LowAcc.Counter.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.CounterSet)
    sets.engaged.DW.MidAcc.Counter.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.CounterSet)
    sets.engaged.DW.HighAcc.Counter.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.CounterSet)
    sets.engaged.DW.STP.Counter.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.CounterSet)
	
    sets.engaged.DW.Subtle.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.LowAcc.Subtle.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.MidAcc.Subtle.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.HighAcc.Subtle.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.STP.Subtle.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.SubtleSet)		

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.Crit.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.LowAcc.Crit.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.MidAcc.Crit.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.HighAcc.Crit.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.STP.Crit.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.MeleeCrit)	

    sets.engaged.DW.Counter.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.CounterSet)
    sets.engaged.DW.LowAcc.Counter.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.CounterSet)
    sets.engaged.DW.MidAcc.Counter.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.CounterSet)
    sets.engaged.DW.HighAcc.Counter.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.CounterSet)
    sets.engaged.DW.STP.Counter.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.CounterSet)
	
    sets.engaged.DW.Subtle.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.LowAcc.Subtle.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.MidAcc.Subtle.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.HighAcc.Subtle.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.STP.Subtle.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.SubtleSet)	

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)
	
    sets.engaged.DW.Crit.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.LowAcc.Crit.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.MidAcc.Crit.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.HighAcc.Crit.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.STP.Crit.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.MeleeCrit)

    sets.engaged.DW.Counter.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.CounterSet)
    sets.engaged.DW.LowAcc.Counter.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.CounterSet)
    sets.engaged.DW.MidAcc.Counter.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.CounterSet)
    sets.engaged.DW.HighAcc.Counter.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.CounterSet)
    sets.engaged.DW.STP.Counter.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.CounterSet)

    sets.engaged.DW.Subtle.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.LowAcc.Subtle.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.MidAcc.Subtle.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.HighAcc.Subtle.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.STP.Subtle.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.SubtleSet)			

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)
	
    sets.engaged.DW.Crit.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.LowAcc.Crit.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.MidAcc.Crit.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.HighAcc.Crit.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.MeleeCrit)
    sets.engaged.DW.STP.Crit.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.MeleeCrit)
	
    sets.engaged.DW.Counter.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.CounterSet)
    sets.engaged.DW.LowAcc.Counter.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.CounterSet)
    sets.engaged.DW.MidAcc.Counter.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.CounterSet)
    sets.engaged.DW.HighAcc.Counter.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.CounterSet)
    sets.engaged.DW.STP.Counter.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.CounterSet)
	
    sets.engaged.DW.Subtle.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.LowAcc.Subtle.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.MidAcc.Subtle.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.HighAcc.Subtle.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.SubtleSet)
    sets.engaged.DW.STP.Subtle.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.SubtleSet)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff['Saber Dance'] = {legs="Horos Tights +3"}
    sets.buff['Fan Dance'] = {body="Horos Bangles +3"}
    sets.buff['Climactic Flourish'] = {head="Maculele Tiara +3", ammo="Charis Feather"} --body="Meg. Cuirie +2"}
    sets.buff['Closed Position'] = {feet="Horos T. Shoes +3"}
	sets.buff['Striking Flourish'] = {body="Macu. Casaque +3"}

    sets.buff.Doom = {neck="Nicander's necklace",
	waist="Gishdubar Sash"}
    sets.CP = {back="Mecisto. Mantle"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
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
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
		if state.Buff['Striking Flourish'] then
			equip(sets.buff['Striking Flourish'])
		end	
    end
    if spell.type=='Waltz' and spell.target.type == 'SELF' then
        equip(sets.precast.WaltzSelf)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    if buff == 'Saber Dance' or buff == 'Climactic Flourish' or buff == 'Fan Dance' or buff == 'Striking Flourish' then
        handle_equipping_gear(player.status)
    end
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed. I will miss you.')
             disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
--    end
--    if buff =="sleep" then
--        if gain then
--            send_command('@input /p zZZzZZzZzz')
--        end
--    end
--    if buff =="paralysis" then
--        if gain then
--            send_command('@input /p Paralyzed...')
--        end
--    end
--    if buff =="slow" then
--        if gain then
--            send_command('@input /p Sloooooooooooowed....')
--        end
--    end
--    if buff =="blindness" then
--        if gain then
--            send_command('@input /p Blind..')
--        end
--    end
--	if buff =="petrification" then
--        if gain then
--            send_command('@input /p Petrified..')
--        end
    end

end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end



function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()	
end	

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end

    return wsmode
end

function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end
    return idleSet
end

function customize_melee_set(meleeSet)
   if buffactive['Saber Dance'] then
       meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
   end
    -- if state.Buff['Climactic Flourish'] then
        -- meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
    -- end
	-- if state.Buff['Striking Flourish'] then
        -- meleeSet = set_combine(meleeSet, sets.buff['Striking Flourish'])
    -- end
    if state.ClosedPosition.value == true then
        meleeSet = set_combine(meleeSet, sets.buff['Closed Position'])
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
	
    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end

        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = '[ Melee'

    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end

    msg = msg .. ': '

    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ' ][ WS: ' .. state.WeaponskillMode.value .. ' ]'

    if state.DefenseMode.value ~= 'None' then
        msg = msg .. '[ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ' ]'
    end

    if state.ClosedPosition.value then
        msg = msg .. '[ Closed Position: ON ]'
    end

    if state.Kiting.value then
        msg = msg .. '[ Kiting Mode: ON ]'
    end
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
    msg = msg .. '[ *'..state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/'..state.AltStep.current
    end

    msg = msg .. '* ]'

    add_to_chat(060, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end

        send_command('@input /ja "'..doStep..'" <t>')
    end
	gearinfo(cmdParams, eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
      if DW_needed <= 1 then
	    classes.CustomMeleeGroups:append('MaxHaste')
	  elseif DW_needed > 1 and DW_needed < 10 then
        classes.CustomMeleeGroups:append('MaxHaste')
      elseif DW_needed >= 10 and DW_needed < 21 then
        classes.CustomMeleeGroups:append('HighHaste')
      elseif DW_needed >= 21 and DW_needed < 32 then
        classes.CustomMeleeGroups:append('MidHaste')
      elseif DW_needed >= 32 and DW_needed < 39 then
        classes.CustomMeleeGroups:append('LowHaste')
      elseif DW_needed >= 39 then
        classes.CustomMeleeGroups:append('')
      end
    end
end
--none 40
--low 32
--mid 21
--high 10
--max 0

--function job_self_command(cmdParams, eventArgs)
--    gearinfo(cmdParams, eventArgs)
--end

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
        if type(tonumber(cmdParams[5])) == 'number' then
            if tonumber(cmdParams[5]) ~= MA_needed then
                MA_needed = tonumber(cmdParams[5])
                H2H = true
            end
        elseif type(cmdParams[5]) == 'string' then
            if cmdParams[5] == 'false' then
                MA_needed = 0
                H2H = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
--function job_pretarget(spell, action, spellMap, eventArgs)
--    if spell.type == 'Step' then
--        local allRecasts = windower.ffxi.get_ability_recasts()
--        local prestoCooldown = allRecasts[236]
--        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
--
--        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
--            cast_delay(1.1)
--            send_command('input /ja "Presto" <me>')
--        end
--    end
--end

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
    -- Default macro set/book: (set, book)
    if player.sub_job == 'WAR' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 4)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'RUN' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'SAM' then
        set_macro_page(1, 3)
    else
        set_macro_page(1, 3)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end

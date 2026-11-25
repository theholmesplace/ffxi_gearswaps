-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Mode
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Composure
--              [ CTRL+- ]          Light Arts/Addendum: White
--              [ CTRL+= ]          Dark Arts/Addendum: Black
--              [ CTRL+; ]          Celerity/Alacrity
--              [ ALT+[ ]           Accesion/Manifestation
--              [ ALT+; ]           Penury/Parsimony
--
--  Spells:     [ CTRL+` ]          Stun
--              [ ALT+Q ]           Temper
--              [ ALT+W ]           Flurry II
--              [ ALT+E ]           Haste II
--              [ ALT+R ]           Refresh II
--              [ ALT+Y ]           Phalanx
--              [ ALT+O ]           Regen II
--              [ ALT+P ]           Shock Spikes
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad9 ]    Chant Du Cygne
--              [ CTRL+Numpad4 ]    Requiescat
--              [ CTRL+Numpad1 ]    Sanguine Blade
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--              Addendum Commands:
--              Shorthand versions for each strategem type that uses the version appropriate for
--              the current Arts.
--                                          Light Arts                  Dark Arts
--                                          ----------                  ---------
--              gs c scholar light          Light Arts/Addendum
--              gs c scholar dark                                       Dark Arts/Addendum
--              gs c scholar cost           Penury                      Parsimony
--              gs c scholar speed          Celerity                    Alacrity
--              gs c scholar aoe            Accession                   Manifestation
--              gs c scholar addendum       Addendum: White             Addendum: Black


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

    state.CP = M(false, "Capacity Points Mode")
    state.Buff.Saboteur = buffactive.Saboteur or false
	
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
    "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}	

	elemental_ws = S{"Sanguine Blade", "Red Lotus Blade", "Burning Blade", "Aeolian Edge", "Flash Nova", "Seraph Strike"}--ringo

    enfeebling_magic_acc = S{'Bind', 'Break', 'Dispel',  'Gravity', 'Gravity II', 'Sleep', 'Sleep II', 'Sleepga'}--silence,distract 1-2, frazzle 1-2
    enfeebling_magic_skill = S{}--poison,distract3,frazzle3
    enfeebling_magic_effect = S{'Dia II', 'Dia III'}--Dia, Diaga

    skill_spells = S{
        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',
        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}

    lockstyleset = 34
	
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Enspells', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'Almace', 'SwordEnh', 'Subtle', 'Crit')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal','Resistant')
    state.IdleMode:options('Normal', 'DTidle', 'HP')
	state.PhysicalDefenseMode:options('DualWield','Shield')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.CP = M(false, "Capacity Points Mode")
    state.RingLock = M(false, 'Ring Lock')

    -- Additional local binds
--    include('Global-Binds.lua') -- OK to remove this line
--    include('Global-GEO-Binds.lua') -- OK to remove this line
	send_command('lua l gearinfo')
    send_command('bind ^` input /ja "Composure" <me>')
--    send_command('bind !` gs c toggle MagicBurst')


    if player.sub_job == 'SCH' then
        send_command('bind ^- gs c scholar light')
        send_command('bind ^= gs c scholar dark')
        send_command('bind !- input /ja "Addendum: White" <me>')
        send_command('bind != input /ja "Addendum: Black" <me>')
        send_command('bind ![ gs c scholar aoe')
    end

    send_command('bind !q input /ma "Temper II" <me>')
    send_command('bind !w input /ma "Flurry II" <stpc>')
    send_command('bind !e input /ma "Haste II" <stpc>')
    send_command('bind !r input /ma "Refresh III" <stpc>')
    send_command('bind !y input /ma "Phalanx II" <stpc>')
    send_command('bind !o input /ma "Regen II" <stpc>')
    send_command('bind !p gs c toggle MagicBurst')

    send_command('bind @c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')

    send_command('bind ^numpad7 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad9 input /ws "Chant du Cygne" <t>')
    send_command('bind ^numpad4 input /ws "Requiescat" <t>')
    send_command('bind ^numpad1 input /ws "Sanguine Blade" <t>')
    send_command('bind ^numpad2 input /ws "Red Lotus Blade" <t>')
    send_command('bind ^numpad3 input /ws "Flat Blade" <t>')

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
--    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ![')
    send_command('unbind !q')
    send_command('unbind !w')
    send_command('bind !e input /ma "Haste" <stpc>')
    send_command('bind !r input /ma "Refresh" <stpc>')
    send_command('bind !y input /ma "Phalanx" <me>')
    send_command('unbind !o')
    send_command('unbind !p')
    send_command('unbind @c')
    send_command('unbind @w')
    send_command('unbind @r')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')

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
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Viti. Tabard +3"}
	sets.precast.JA['Convert'] = {main="Murgleis"}

    -- Fast cast sets for spells

    -- Fast cast sets for spells
    sets.precast.FC = {
    main="Crocea Mors",
    sub="Sacro Bulwark",
    ammo="Sapience Orb",
    head="Atrophy Chapeau +3",
    body="Viti. Tabard +3",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs="Aya. Cosciales +2",
    feet={ name="Carmine Greaves +1", augments={'Accuracy+12','DEX+12','MND+20',}},
    neck="Orunmila's Torque",
    waist="Embla sash",
	left_ear="Malignance Earring",
    right_ear="Enchntr. Earring +1",
    left_ring="Kishar Ring",
    right_ring="Rahab Ring",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}--traits 30

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ammo="Impatiens", 
        ring21="Lebeche Ring", 
        waist="Witful Belt", 
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC['Healing Magic'] = sets.precast.FC.Cure
    sets.precast.FC['Elemental Magic'] = sets.precast.FC
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
    sets.precast.Storm = sets.precast.FC
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak"})

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        neck="Magoraga Beads",
        ring1="Lebeche Ring",
        waist="Witful Belt",
		back="Perimede cape",
        })

	sets.precast.RA = {head="Volte Tiara",
    hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
    legs="Volte Tights",
    feet="Volte Spats",
    waist="Yemaya Belt",
    left_ring="Crepuscular Ring",
    back={ name="Sucellos's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Snapshot"+10',}},
}
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
    ammo="Coiste Bodhar",
    head="Nyame helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Rufescent Ring",
    right_ring="Shukuyu Ring",
    back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
}

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
		ring2="Chirich Ring +1",})

		
    sets.precast.WS['Chant du Cygne'] = {ammo="Yetshila +1",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Ayanmo Corazza +2",
    hands="Bunzi's Gloves",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Thereoid Greaves",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear="Balder Earring +1",
    left_ring="Ilabrat Ring",
    right_ring="Begrudging Ring",
    back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
}

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
		ring2="Chirich Ring +1",})

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc
	

    sets.precast.WS['Savage Blade'] = {ammo="Coiste Bodhar",
    head="Nyame helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame flanchard",
    feet="Nyame sollerets",
    neck="Republican platinum medal",
    waist="Sailfi belt +1",
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Balder Earring +1",
    left_ring="Epaminondas's Ring",
    right_ring="Metamorph ring +1",
    back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
}
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
		ring2="Chirich Ring +1",
        })
	sets.precast.WS['Knights of Round'] = set_combine(sets.precast.WS['Savage Blade'], {
		ear1="Ishvara earring",
		})
	
	sets.precast.WS['Circle Blade'] = set_combine(sets.precast.WS['Savage Blade'], {
		ear2="Ishvara earring",
		})
		
    sets.precast.WS['Death Blossom'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Death Blossom'].Acc = sets.precast.WS['Savage Blade'].Acc

    sets.precast.WS['Requiescat'] = {
    ammo="Coiste Bodhar",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame flanchard",
    feet="Nyame sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    left_ring="Rufescent Ring",
    right_ring="Metamorph ring +1",
    back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
}

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
		ring2="Chirich Ring +1",
        })

	sets.precast.WS['Burning Blade'] = {
	ammo="Ghastly Tathlum +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Jhakri Cuffs +2",
    legs="Nyame flanchard",
    feet="Nyame sollerets",
    neck="Sibyl scarf",
    waist="Orpheus's Sash",
    left_ear="Malignance earring",
    right_ear="Regal Earring",
    left_ring="Freke Ring",
    right_ring="Epaminondas's Ring",
    back={ name="Sucellos's Cape", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},
}
	sets.precast.WS['Red Lotus Blade'] = sets.precast.WS['Burning Blade']
	
	sets.precast.WS['Aeolian Edge'] = sets.precast.WS['Burning Blade']
	
	sets.precast.WS['Seraph Blade'] = {
    ammo="Regal Gem",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Jhakri Cuffs +2",
    legs="Nyame flanchard",
    feet="Nyame sollerets",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Malignance earring",
    right_ear="Regal Earring",
    left_ring="Metamorph ring +1",
    right_ring="Epaminondas's Ring",
    back={ name="Sucellos's Cape", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},
}
	sets.precast.WS['Seraph Blade'].Acc = {}
	
    sets.precast.WS['Sanguine Blade'] = {
    ammo="Ghastly Tathlum +1",
    head="Pixie Hairpin +1",
    body="Nyame Mail",
    hands="Jhakri Cuffs +2",
    legs="Nyame flanchard",
    feet="Nyame sollerets",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Malignance earring",
    right_ear="Regal Earring",
    left_ring="Epaminondas's Ring",
    right_ring="Archon Ring",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},
}

    sets.precast.WS['Black Halo'] = {ammo="Coiste Bodhar",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame flanchard",
    feet="Nyame sollerets",
    neck="Dls. Torque +2",
    waist="Sailfi belt +1",
    left_ear="Sherida Earring",
    right_ear="Balder Earring +1",
    left_ring="Epaminondas's Ring",
    right_ring="Rufescent Ring",
    back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
}
	sets.precast.WS['Empyreal Arrow'] = {head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Combatant's Torque",
    waist="Yemaya Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Epaminondas's Ring",
    right_ring="Hajduk Ring +1",
    back={ name="Sucellos's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Mag. Evasion+15',}},
}

	sets.precast.WS['Flaming Arrow'] = {ammo="Demon Arrow",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sanctity Necklace",
    waist="Orpheus's Sash",
    left_ear="Telos Earring",
    right_ear="Malignance Earring",
    left_ring="Freke Ring",
    right_ring="Epaminondas's Ring",
    back={ name="Sucellos's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Mag. Evasion+15',}},
}
	
	sets.precast.WS['Evisceration'] = sets.precast.WS['Chant du Cygne']
	
	sets.precast.WS['Asuran Fists'] = {ammo="Aurgelmir Orb +1",
    head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
    body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
    hands="Atrophy Gloves +3",
    legs={ name="Viti. Tights +3", augments={'Enspell Damage','Accuracy',}},
    feet="Atro. Boots +3",
    neck="Combatant's Torque",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Mache Earring +1",
    right_ear="Mache Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Rufescent Ring",
    back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
}

	sets.precast.WS['Flash Nova'] = sets.precast.WS['Seraph Blade']
	
	sets.precast.WS['Mercy Stroke'] = {ammo="Coiste Bodhar",
    head="Nyame Helm",
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands="Nyame Gauntlets",
    legs="Nyame flanchard",
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Republican platinum medal",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Sherida Earring",
    right_ear="Balder Earring +1",
    left_ring="Epaminondas's Ring",
    right_ring="Shukuyu Ring",
    back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
}
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        legs="Carmine Cuisses +1", --20
        ring1="Evanescence Ring", --5
        waist="Rumination Sash", --10
        }

    sets.midcast.Cure = {
    main="Daybreak",
    sub="Ammurapi Shield",
    ammo="Regal Gem",
    head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
    body={ name="Kaykaus Bliaut +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
    neck="Incanter's Torque",
    waist="Luminary Sash",
    left_ear="Meili Earring",
    right_ear="Beatific Earring",
    left_ring="Menelaus's Ring",
    right_ring="Stikini Ring +1",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        main="Chatoyant Staff",
		sub="Enki Strap",
        waist="Hachirin-no-Obi",
        })

    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {
        waist="Gishdubar Sash", -- (10)
		hands="Buremte Gloves",
        })

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.StatusRemoval = sets.precast.FC

    sets.midcast.Cursna = {
    ammo="Sapience Orb",
    head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
    body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs="Atrophy Tights +3",
    feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    neck="Incanter's Torque",
    waist="Embla sash",
    left_ear="Meili earring",
    right_ear="Beatific Earring",
    left_ring="Menelaus's Ring",
    right_ring="Haoma's Ring",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}

    sets.midcast['Enhancing Magic'] = {main="Pukulatmuj +1",
    sub="Forfend +1",
    ammo="Staunch Tathlum +1",
    head="Befouled Crown",
    body="Viti. Tabard +3",
    hands="Viti. Gloves +3", 
    legs="Atrophy Tights +3",
    feet="Leth. Houseaux +1",
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Mimir earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back="Ghostfyre Cape",
}

    sets.midcast.EnhancingDuration = {
    main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','MND+4','Mag. Acc.+17','"Mag.Atk.Bns."+8',}},
    sub="Ammurapi Shield",
    head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}},
    body="Viti. Tabard +3",
    hands="Atrophy Gloves +3",
    legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}},
    feet="Leth. Houseaux +1",
	waist="Embla sash",
    neck="Dls. Torque +2",
    back="Ghostfyre Cape",
}

    sets.midcast.EnhancingSkill = sets.midcast['Enhancing Magic']
	
	sets.midcast.EnhancingSkillDW = {
    main="Pukulatmuj +1",
    sub="Forfend +1",
    ammo="Staunch Tathlum +1",
    head="Befouled Crown",
    body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
    hands={ name="Viti. Gloves +3", augments={'Enhancing Magic duration',}},
    legs="Atrophy Tights +3",
    feet="Leth. Houseaux +1",
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Mimir earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +6','Enha.mag. skill +10','Mag. Acc.+7','Enh. Mag. eff. dur. +20',}},
}

    sets.midcast.GainSpell = sets.midcast['Enhancing Magic']


    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        -- main="Bolelabunga",
        -- sub="Ammurapi Shield",
        })

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
    head="Amalric Coif +1",
    body="Atrophy Tabard +3",
    legs="Leth. Fuseau +1",
	waist="Embla sash",
    })

    sets.midcast.RefreshSelf = {
        waist="Gishdubar Sash",
        }

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
		head="Umuthi hat",
        neck="Nodens Gorget",
        waist="Siegel Sash",
		legs="Shedir seraweels",
        })

    sets.midcast['Phalanx'] = {ammo="Staunch Tathlum +1",
	main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','MND+4','Mag. Acc.+17','"Mag.Atk.Bns."+8',}},
    sub="Ammurapi Shield",
    head={ name="Taeon Chapeau", augments={'Phalanx +3',}},
    body={ name="Taeon Tabard", augments={'Spell interruption rate down -10%','Phalanx +3',}},
    hands={ name="Taeon Gloves", augments={'Spell interruption rate down -10%','Phalanx +3',}},
    legs={ name="Taeon Tights", augments={'Accuracy+18 Attack+18','Spell interruption rate down -9%','Phalanx +3',}},
    feet={ name="Taeon Boots", augments={'Spell interruption rate down -10%','Phalanx +3',}},
    neck="Dls. Torque +2",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Mimir earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +6','Enha.mag. skill +10','Mag. Acc.+7','Enh. Mag. eff. dur. +20',}},}

sets.midcast['Phalanx II'] = {ammo="Staunch Tathlum +1",
	main="Sakpata's sword",
    sub="Ammurapi Shield",
    head={ name="Taeon Chapeau", augments={'Phalanx +3',}},
    body={ name="Taeon Tabard", augments={'Spell interruption rate down -10%','Phalanx +3',}},
    hands={ name="Taeon Gloves", augments={'Spell interruption rate down -10%','Phalanx +3',}},
    legs={ name="Taeon Tights", augments={'Accuracy+18 Attack+18','Spell interruption rate down -9%','Phalanx +3',}},
    feet={ name="Taeon Boots", augments={'Spell interruption rate down -10%','Phalanx +3',}},
    neck="Dls. Torque +2",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Mimir earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +6','Enha.mag. skill +10','Mag. Acc.+7','Enh. Mag. eff. dur. +20',}},}

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif +1",
		hands="Regal Cuffs",
		legs="Shedir seraweels",
        waist="Emphatikos Rope",
        })

    sets.midcast.Storm = sets.midcast.EnhancingDuration

    sets.midcast.Protect = sets.midcast.EnhancingDuration
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell
	
	sets.midcast.Barfire = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barblizzard = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Baraero = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barstone = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barthunder = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barwater = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barsleep = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barpoison = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barparalyze = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barblind = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barsilence = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barpetrify = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barvirus = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Baramnesia = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barfira = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barblizzara = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Baraera = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barstonra = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barthundra = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barwatera = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barsleepra = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barpoisonra = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barparalyzra = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barblindra = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barsilencera = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barpetra = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})
	sets.midcast.Barvira = set_combine(sets.midcast['Enhancing Magic'],{legs="Shedir seraweels"})

     -- Custom spell classes
    sets.midcast.MndEnfeebles = {
    main={ name="Grioavolr", augments={'Enfb.mag. skill +13','MND+13','Mag. Acc.+21','"Mag.Atk.Bns."+3',}},
    sub="Enki Strap",
    ammo="Regal Gem",
    head="Atrophy Chapeau +3",
    body="Lethargy Sayon +1",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs={ name="Chironic Hose", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','"Cure" potency +3%','MND+8','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
    feet="Vitiation Boots +3",
    neck="Dls. Torque +2",
    waist="Luminary Sash",
    left_ear="Snotra earring",
    right_ear="Regal Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}

    sets.midcast.MndEnfeeblesAcc = set_combine(sets.midcast.MndEnfeebles, {
        head="Atrophy Chapeau +3",
        body="Atrophy Tabard +3",
        ring1="Stikini Ring +1",
        })
	sets.midcast.Silence = {
    main="Murgleis",
    sub="Ammurapi Shield",
	ammo="Regal Gem",
    head="Atrophy Chapeau +3",
    body="Atrophy Tabard +3",
    hands="Regal Cuffs",
    legs={ name="Chironic Hose", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','"Cure" potency +3%','MND+8','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
    feet="Vitiation Boots +3",
    neck="Dls. Torque +2",
    waist="Obstinate Sash",
    left_ear="Snotra earring",
    right_ear="Regal Earring",
    left_ring="Kishar Ring",
    right_ring="Stikini Ring +1",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		-- main="Malevolence",
		-- sub="Ammurapi Shield",
        -- ring1="Stikini Ring +1",
})

    sets.midcast.IntEnfeeblesAcc = set_combine(sets.midcast.IntEnfeebles, {
        body="Atrophy Tabard +3",
        })

    sets.midcast.SkillEnfeebles = {
    main={ name="Grioavolr", augments={'Enfb.mag. skill +13','MND+13','Mag. Acc.+21','"Mag.Atk.Bns."+3',}},
    sub="Enki Strap",
    ammo="Regal Gem",
    head="Viti. Chapeau +3",
    body="Atrophy Tabard +3",
    hands="Leth. Gantherots +1",
    legs={ name="Chironic Hose", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','"Cure" potency +3%','MND+8','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
    feet="Vitiation Boots +3",
    neck="Dls. Torque +2",
    waist="Rumination Sash",
    left_ear="Snotra earring",
    right_ear="Regal Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}
	
    sets.midcast.EffectEnfeebles = {
        ammo="Regal Gem",
		neck="Dls. Torque +2",
        body="Lethargy Sayon +1",
        feet="Vitiation Boots +3",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
        }

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

	sets.midcast.Sleep = {
    main="Murgleis",
    sub="Ammurapi Shield",
	ammo="Regal Gem",
    head="Atrophy Chapeau +3",
    body="Atrophy Tabard +3",
    hands="Regal Cuffs",
    legs={ name="Chironic Hose", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','"Cure" potency +3%','MND+8','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
    feet="Vitiation Boots +3",
    neck="Dls. Torque +2",
    waist="Obstinate Sash",
    left_ear="Snotra earring",
    right_ear="Regal Earring",
    left_ring="Kishar Ring",
    right_ring="Stikini Ring +1",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}
	sets.midcast['Sleep II'] = sets.midcast['Sleep']
	sets.midcast['Sleepga'] = sets.midcast['Sleep']
	sets.midcast['Distract II'] = sets.midcast['Sleep']
	sets.midcast['Frazzle II'] = sets.midcast['Sleep']
	sets.midcast['Dia'] = {head="Volte Cap", hands="Volte Bracers", feet="Volte Boots", legs="Volte Hose"}
	
    sets.midcast['Dia III'] = {
    main="Daybreak",
    sub="Ammurapi Shield",
    ammo="Regal Gem",
    head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
    body="Lethargy Sayon +1",
    hands="Regal Cuffs",
--    legs={ name="Augury Cuisses +1", augments={'Path: A',}},
    legs="Amalric Slops +1",
	feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
    neck={ name="Dls. Torque +2", augments={'Path: A',}},
    waist="Obstinate Sash",
    left_ear="Snotra Earring",
    right_ear="Malignance Earring",
    left_ring="Kishar Ring",
    right_ring="Rahab Ring",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}
    sets.midcast['Diaga'] = sets.midcast['Dia']
	
	sets.midcast['Paralyze II'] = {
    main="Grioavolr",
    sub="Enki Strap",
    ammo="Regal Gem",
    head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
    body="Lethargy Sayon +1",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs={ name="Chironic Hose", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','"Cure" potency +3%','MND+8','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
    feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
    neck={ name="Dls. Torque +2", augments={'Path: A',}},
    waist="Luminary Sash",
    left_ear="Snotra Earring",
    right_ear="Regal Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Stikini Ring +1",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}
	
    sets.midcast['Slow II'] = {
    main="Grioavolr",
    sub="Enki Strap",
    ammo="Regal Gem",
    head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
    body="Lethargy Sayon +1",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs={ name="Chironic Hose", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','"Cure" potency +3%','MND+8','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
    feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
    neck={ name="Dls. Torque +2", augments={'Path: A',}},
    waist="Luminary Sash",
    left_ear="Snotra Earring",
    right_ear="Regal Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Stikini Ring +1",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}
	sets.midcast['Addle II'] = {
    main="Grioavolr",
    sub="Enki Strap",
    ammo="Regal Gem",
    head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
    body="Lethargy Sayon +1",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs={ name="Chironic Hose", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','"Cure" potency +3%','MND+8','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
    feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
    neck={ name="Dls. Torque +2", augments={'Path: A',}},
    waist="Luminary Sash",
    left_ear="Snotra Earring",
    right_ear="Regal Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Stikini Ring +1",
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}
	
	sets.midcast['Inundation'] = sets.midcast['Sleep']
	
	sets.midcast['Poison II'] = {
    main={ name="Contemplator +1", augments={'Path: A',}},
    sub="Mephitis Grip",
    ammo="Regal Gem",
    head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
    body="Lethargy Sayon +1",
    hands="Leth. Gantherots +1",
    legs={ name="Psycloth Lappas", augments={'Mag. Acc.+10','Spell interruption rate down +15%','MND+7',}},
    feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
    neck={ name="Dls. Torque +2", augments={'Path: A',}},
    waist="Rumination Sash",
    left_ear="Snotra Earring",
    right_ear="Vor Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}

	sets.midcast.Blind = sets.midcast.Sleep
	sets.midcast.Break = sets.midcast.Sleep
	sets.midcast.Bind = sets.midcast.Sleep
	sets.midcast.Dispel = sets.midcast.Sleep
	sets.midcast.Gravity = sets.midcast.Sleep
	sets.midcast['Gravity II'] = sets.midcast.Sleep
	
    sets.midcast['Distract III'] = {
    main={ name="Contemplator +1", augments={'Path: A',}},
    sub="Mephitis Grip",
    ammo="Regal Gem",
    head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
    body="Lethargy Sayon +1",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs={ name="Psycloth Lappas", augments={'Mag. Acc.+10','Spell interruption rate down +15%','MND+7',}},
    feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
    neck={ name="Dls. Torque +2", augments={'Path: A',}},
    waist="Obstinate Sash",
    left_ear="Snotra Earring",
    right_ear="Vor Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}	
	
    sets.midcast['Frazzle III'] = {
    main={ name="Contemplator +1", augments={'Path: A',}},
    sub="Mephitis Grip",
    ammo="Regal Gem",
    head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
    body="Atrophy Tabard +3",
    hands={ name="Viti. Gloves +3", augments={'Enhancing Magic duration',}},
    legs={ name="Psycloth Lappas", augments={'Mag. Acc.+10','Spell interruption rate down +15%','MND+7',}},
    feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
    neck="Incanter's Torque",
    waist="Obstinate Sash",
    left_ear="Snotra Earring",
    right_ear="Vor Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}

	sets.midcast['Bio III'] = {ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Amalric Doublet", augments={'INT+10','Elem. magic skill +15','Dark magic skill +15',}},
--    hands={ name="Amalric Gages", augments={'INT+10','Elem. magic skill +15','Dark magic skill +15',}},
    legs="Viti. Tights +3",
    feet="Vitiation Boots +3",
    neck="Incanter's Torque",
    waist="Sacro Cord",
    left_ear="Crematio Earring",
    right_ear="Regal Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
}
	
    sets.midcast['Dark Magic'] = {
    main={ name="Grioavolr", augments={'Enfb.mag. skill +13','MND+13','Mag. Acc.+21','"Mag.Atk.Bns."+3',}},
    sub="Enki Strap",
    ammo="Regal Gem",
    head="Atrophy Chapeau +3",
    body="Atrophy Tabard +3",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs={ name="Chironic Hose", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','"Cure" potency +3%','MND+8','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
    feet="Vitiation Boots +3",
    neck="Dls. Torque +2",
    waist="Luminary Sash",
    left_ear="Snotra earring",
    right_ear="Regal Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1",
        ring2="Archon Ring",
--		hands="Amalric Gages",
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain
    sets.midcast.Stun = sets.midcast.Sleep

    sets.midcast['Elemental Magic'] = {
    main="Bunzi's Rod",
    sub="Ammurapi Shield",
    ammo="Sroda Tathlum",
    head="Cath Palug crown",
    body={ name="Amalric Doublet +1", augments={'MP+80','"Mag.Atk.Bns."+25','"Fast Cast"+4',}},
    hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
    legs={ name="Amalric Slops +1", augments={'MP+80','"Mag.Atk.Bns."+25','Enmity-6',}},
    feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
    neck="Baetyl Pendant",
    waist="Sacro Cord",
    left_ear="Malignance earring",
    right_ear="Regal Earring",
    left_ring="Freke Ring",
    right_ring="Metamorph ring +1",
    back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
}

	sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        ammo="Ghastly Tathlum +1",})

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
        body="Seidr Cotehardie",})


    sets.midcast.Impact = {
    main="Murgleis",
    sub="Ammurapi Shield",
    ammo="Regal Gem",
	head=empty,
    body="Twilight Cloak",
    hands="Atrophy Gloves +3",
    legs="Atrophy Tights +3",
    feet="Atro. Boots +3",
    neck={ name="Dls. Torque +2", augments={'Path: A',}},
    waist="Luminary Sash",
    left_ear="Snotra Earring",
    right_ear="Regal Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}
	sets.midcast.Dispelga = set_combine(sets.midcast.Sleep, {main="Daybreak"})	

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    -- Job-specific buff sets
    sets.buff.ComposureOther = {
    main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','MND+4','Mag. Acc.+17','"Mag.Atk.Bns."+8',}},
    sub="Ammurapi Shield",
    ammo="Staunch Tathlum +1",
    head="Lethargy Chappel +1",
    body="Viti. Tabard +3",
    hands="Atrophy Gloves +3",
    legs="Leth. Fuseau +1",
    feet="Leth. Houseaux +1",
    neck="Dls. Torque +2",
    waist="Embla sash",
    left_ear="Eabani Earring",
    right_ear="Genmei Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +6','Enha.mag. skill +10','Mag. Acc.+7','Enh. Mag. eff. dur. +20',}},
}

    sets.buff.Saboteur = {hands="Leth. Gantherots +1"}

	sets.midcast.RA = {head="Malignance Chapeau",
    body="Malignance Tabard",
    --hands="Raetic Bangles +1",
    hands="Malignance Gloves",
	legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Combatant's Torque",
    waist="Yemaya Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Crepuscular ring",
    right_ring="Hajduk Ring +1",
    back={ name="Sucellos's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Snapshot"+10',}},
}

	sets.midcast.Enmity = {ammo="Sapience Orb",
    head="Halitus Helm",
    body="Emet Harness +1",
    hands="Malignance Gloves",
    legs="Zoar Subligar +1",
    feet="Malignance Boots",
    neck="Unmoving Collar +1",
    waist="Kasiri Belt",
    left_ear="Trux Earring",
    right_ear="Cryptic Earring",
    left_ring="Eihwaz Ring",
    right_ring="Provocare Ring",
    back={ name="Sucellos's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Mag. Evasion+15',}},
}
	sets.precast.JA['Provoke'] = sets.midcast.Enmity
	sets.midcast.Flash = sets.midcast.Enmity
	sets.midcast['Blank Gaze'] = sets.midcast.Enmity
	sets.midcast['Geist Wall'] = sets.midcast.Enmity
	sets.midcast['Jettatura'] = sets.midcast.Enmity
	sets.midcast['Jubaku: Ichi'] = sets.midcast.Enmity
	sets.midcast['Hojo: Ichi'] = sets.midcast.Enmity
	sets.midcast['Hojo: Ni'] = sets.midcast.Enmity
	sets.midcast['Kurayami: Ichi'] = sets.midcast.Enmity
	sets.midcast['Kurayami: Ni'] = sets.midcast.Enmity
	sets.midcast['Magic Finale'] = sets.midcast.Sleep
	
	sets.midcast['Healing Breeze'] = sets.midcast.Cure
	sets.midcast['Pollen'] = sets.midcast.Cure
	sets.midcast['Awful Eye'] = sets.midcast['Sleep']
	sets.midcast['Blank Gaze'] = sets.midcast['Sleep']
	sets.midcast['Sheep Song'] = sets.midcast['Sleep']
	sets.midcast['Soporific'] = sets.midcast['Sleep']
	
	sets.midcast['Auspice'] = {
    main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','MND+4','Mag. Acc.+17','"Mag.Atk.Bns."+8',}},
    sub="Ammurapi Shield",
    head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}},
    body="Viti. Tabard +3",
    hands="Atrophy Gloves +3",
    legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}},
    feet="Leth. Houseaux +1",
	waist="Embla sash",
    neck="Dls. Torque +2",
    back="Ghostfyre Cape",
}
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {main="Daybreak",
    sub="Sacro Bulwark",
    ammo="Homiliary",
    head="Viti. Chapeau +3",
    body="Shamash Robe",
    hands="Volte gloves",
    legs="Volte Brais",
    feet="Volte Gaiters",
    neck="Sibyl Scarf",
    waist="Fucho-no-Obi",
    left_ear="Eabani Earring",
    right_ear="Sanare Earring",
    ring1={name="Stikini Ring +1", bag="wardrobe3"},
	ring2={name="Stikini Ring +1", bag="wardrobe4"},
    back={ name="Sucellos's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Mag. Evasion+15',}},
}

    sets.idle.DTidle = {
	main="Daybreak",
    sub="Sacro Bulwark",
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Shamash Robe",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Eabani Earring",
    right_ear="Sanare Earring",
    left_ring="Defending Ring",
    right_ring="Vocane Ring +1",
    back={ name="Sucellos's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Mag. Evasion+15',}},
}

    sets.idle.Town = sets.idle

    sets.idle.Weak = sets.idle
	
	sets.idle.HP = {ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Shamash Robe",
    hands="Nyame Gauntlets",
    legs="Volte Tights",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Kasiri Belt",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring="Eihwaz Ring",
    right_ring="Ilabrat Ring",
    back="Moonlight Cape",
}

    sets.resting = sets.idle

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = {ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Atro. Boots +3",
    neck="Combatant's Torque",
    waist="Kentarch Belt +1",
    left_ear="Sherida Earring",
    right_ear="Thureous Earring",
    left_ring="Vengeful Ring",
    right_ring="Vocane Ring +1",
    back="Moonlight Cape",
}


	sets.defense.DualWield = {ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Combatant's Torque",
    waist="Reiki Yotai",
    left_ear="Sherida Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring="Vocane Ring +1",
    back={ name="Sucellos's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Mag. Evasion+15',}},
}

	sets.defense.Shield = {ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Atro. Boots +3",
    neck="Combatant's Torque",
    waist="Flume Belt +1",
    left_ear="Sherida Earring",
    right_ear="Thureous Earring",
    left_ring="Vengeful Ring",
    right_ring="Vocane Ring +1",
    back={ name="Sucellos's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Mag. Evasion+15',}},
}


    sets.defense.MDT = {
    sub="Sacro Bulwark",
    ammo="Staunch Tathlum +1",
    head="Ea Hat +1",
    body="Atrophy Tabard +3",
    hands="Aya. Manopolas +2",
    legs="Viti. Tights +3",
    feet="",
    neck="Loricate Torque +1",
    waist="Fucho-no-Obi",
    left_ear="Eabani Earring",
    right_ear="Sanare Earring",
    left_ring="Defending Ring",
    right_ring="Vocane Ring +1",
    back="Moonlight Cape",
}

    sets.magic_burst = {
	head="Ea Hat +1",
	body="Ea Houppe. +1",
	legs="Ea Slops +1",
    neck="Mizu. Kubikazari",
    left_ring="Mujin Band",
    --right_ring="Locus Ring",
}

    sets.Kiting = {legs="Carmine Cuisses +1"}
    sets.latent_refresh = {waist="Fucho-no-obi"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {ammo="Aurgelmir Orb +1",
    head="Malignance chapeau",
    body="Malignance Tabard",
    hands="Malignance gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Sherida Earring",
    right_ear="Balder Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Mag. Evasion+15',}},
}

    sets.engaged.MidAcc = set_combine(sets.engaged, {
		neck="Combatant's Torque",
		ear1="Telos Earring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        waist="Kentarch Belt +1",		
        })
		
	sets.engaged.Enspells = set_combine(sets.engaged, {
		hands="Aya. Manopolas +2",
		waist="Orpheus's Sash",})

    -- No Magic Haste (49 DW Needed)
    sets.engaged.DW = {ammo="Aurgelmir Orb +1",
    head="Malignance chapeau",
    body="Malignance Tabard",
    hands="Malignance gloves",
    legs="Carmine Cuisses +1",
    feet="Malignance Boots",
    neck="Anu Torque",
    waist="Reiki Yotai",
    left_ear="Eabani Earring",
    right_ear="Suppanomimi",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Mag. Evasion+15',}},
}

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW, {
        neck="Combatant's Torque",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        head="Carmine Mask +1",
        ring1="Ramuh Ring +1",
        })

	sets.engaged.DW.Enspells = set_combine(sets.engaged.DW, {
		hands="Aya. Manopolas +2",
		waist="Orpheus's Sash",})

		
    -- 15% Magic Haste (42 DW Needed)
    sets.engaged.DW.LowHaste = sets.engaged.DW

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        neck="Combatant's Torque",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        head="Carmine Mask +1",
        ring1="Ramuh Ring +1",
        })

	sets.engaged.DW.Enspells.LowHaste = set_combine(sets.engaged.DW, {
		hands="Aya. Manopolas +2",
		waist="Orpheus's Sash",})

    -- 30% Magic Haste (31 DW Needed)
    sets.engaged.DW.MidHaste = sets.engaged.DW

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        neck="Combatant's Torque",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        head="Carmine Mask +1",
        ring1="Ramuh Ring +1",
        })

	sets.engaged.DW.Enspells.MidHaste = set_combine(sets.engaged.DW, {
		hands="Aya. Manopolas +2",
		waist="Orpheus's Sash",})

    -- 35% Magic Haste (26 DW Needed)
    sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW, {
        legs="Malignance tights",
        }) --26

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        neck="Combatant's Torque",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        head="Carmine Mask +1",
        ring1="Ramuh Ring +1",
        })

	sets.engaged.DW.Enspells.HighHaste = set_combine(sets.engaged.DW, {
		hands="Aya. Manopolas +2",
		waist="Orpheus's Sash",
		legs="Carmine Cuisses +1"})

    -- 45% Magic Haste (11 DW Needed)
    sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW, {
	ammo="Aurgelmir Orb +1",
    head="Malignance chapeau",
    body="Malignance Tabard",
    hands="Malignance gloves",
    legs="Malignance tights",
    feet="Malignance Boots",
    neck="Anu Torque",
    waist="Windbuffet belt +1",
    left_ear="Sherida Earring",
    right_ear="Balder Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Mag. Evasion+15',}},
})

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
		neck="Combatant's Torque",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        ring1="Ramuh Ring +1",
		right_ear="Telos Earring",
        })

	sets.engaged.DW.Enspells.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
		hands="Aya. Manopolas +2",
		waist="Orpheus's Sash",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Mag. Evasion+15',}},
})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {ammo="Yetshila +1",
    head="Blistering Sallet +1",
	hands="Raetic Bangles +1",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Aya. Gambieras +2",
    right_ring="Hetairoi Ring",
    back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
}

	sets.engaged.Enspell = {ammo="Hasty Pinion +1",
    head="Umuthi Hat",
    body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
    hands="Aya. Manopolas +2",
    legs="Atrophy Tights +3",
    feet="Malignance Boots",
    neck="Bathy Choker +1",
    waist="Orpheus's Sash",
    left_ear="Sherida Earring",
    right_ear="Digni. Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +6','Enha.mag. skill +10','Mag. Acc.+7','Enh. Mag. eff. dur. +20',}},
}
	sets.engaged.SubtleBlow = {head="Volte Tiara",
    hands="Volte Mittens",
    legs="Volte Tights",
	feet="Volte Spats",
}

	sets.engaged.TA = {
    waist="Gerdr belt +1",
    right_ring="Hetairoi Ring",
	left_ear="Suppanomimi",
	back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
}

	sets.engaged.TA.SW = {
    waist="Gerdr belt +1",
    right_ring="Hetairoi Ring",
	back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
}

    sets.engaged.Crit = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.MidAcc.Crit = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.Crit = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
	
	sets.engaged.SwordEnh = set_combine(sets.engaged, sets.engaged.Enspell)
    sets.engaged.MidAcc.SwordEnh = set_combine(sets.engaged.MidAcc, sets.engaged.Enspell)
    sets.engaged.HighAcc.SwordEnh = set_combine(sets.engaged.HighAcc, sets.engaged.Enspell)
	
	sets.engaged.Subtle = set_combine(sets.engaged, sets.engaged.SubtleBlow)
    sets.engaged.MidAcc.Subtle = set_combine(sets.engaged.MidAcc, sets.engaged.SubtleBlow)
    sets.engaged.HighAcc.Subtle = set_combine(sets.engaged.HighAcc, sets.engaged.SubtleBlow)
	
	sets.engaged.Almace = set_combine(sets.engaged, sets.engaged.TA.SW)
    sets.engaged.MidAcc.Almace = set_combine(sets.engaged.MidAcc, sets.engaged.TA.SW)
    sets.engaged.HighAcc.Almace = set_combine(sets.engaged.HighAcc, sets.engaged.TA.SW)

    sets.engaged.DW.Crit = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.Crit = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.Crit = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)

	sets.engaged.DW.SwordEnh = set_combine(sets.engaged.DW, sets.engaged.Enspell)
    sets.engaged.DW.MidAcc.SwordEnh = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Enspell)
    sets.engaged.DW.HighAcc.SwordEnh = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Enspell)
	
	sets.engaged.DW.Subtle = set_combine(sets.engaged.DW, sets.engaged.SubtleBlow)
    sets.engaged.DW.MidAcc.Subtle = set_combine(sets.engaged.DW.MidAcc, sets.engaged.SubtleBlow)
    sets.engaged.DW.HighAcc.Subtle = set_combine(sets.engaged.DW.HighAcc, sets.engaged.SubtleBlow)	
	
	sets.engaged.DW.Almace = set_combine(sets.engaged.DW, sets.engaged.TA)
    sets.engaged.DW.MidAcc.Almace = set_combine(sets.engaged.DW.MidAcc, sets.engaged.TA)
    sets.engaged.DW.HighAcc.Almace = set_combine(sets.engaged.DW.HighAcc, sets.engaged.TA)		

    sets.engaged.DW.Crit.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.Crit.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.Crit.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)

	sets.engaged.DW.SwordEnh.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Enspell)
    sets.engaged.DW.MidAcc.SwordEnh.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Enspell)
    sets.engaged.DW.HighAcc.SwordEnh.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Enspell)
	
	sets.engaged.DW.Subtle.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.SubtleBlow)
    sets.engaged.DW.MidAcc.Subtle.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.SubtleBlow)
    sets.engaged.DW.HighAcc.Subtle.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.SubtleBlow)

	sets.engaged.DW.Almace.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.TA)
    sets.engaged.DW.MidAcc.Almace.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.TA)
    sets.engaged.DW.HighAcc.Almace.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.TA)	

    sets.engaged.DW.Crit.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.Crit.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.Crit.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)

	sets.engaged.DW.SwordEnh.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Enspell)
    sets.engaged.DW.MidAcc.SwordEnh.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Enspell)
    sets.engaged.DW.HighAcc.SwordEnh.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Enspell)
	
	sets.engaged.DW.Subtle.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.SubtleBlow)
    sets.engaged.DW.MidAcc.Subtle.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.SubtleBlow)
    sets.engaged.DW.HighAcc.Subtle.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.SubtleBlow)
	
	sets.engaged.DW.Almace.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.TA)
    sets.engaged.DW.MidAcc.Almace.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.TA)
    sets.engaged.DW.HighAcc.Almace.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.TA)	

    sets.engaged.DW.Crit.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.Crit.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.Crit.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
	
	sets.engaged.DW.SwordEnh.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Enspell)
    sets.engaged.DW.MidAcc.SwordEnh.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Enspell)
    sets.engaged.DW.HighAcc.SwordEnh.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Enspell)
	
	sets.engaged.DW.Subtle.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.SubtleBlow)
    sets.engaged.DW.MidAcc.Subtle.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.SubtleBlow)
    sets.engaged.DW.HighAcc.Subtle.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.SubtleBlow)

	sets.engaged.DW.Almace.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.TA)
    sets.engaged.DW.MidAcc.Almace.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.TA)
    sets.engaged.DW.HighAcc.Almace.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.TA)		

    sets.engaged.DW.Crit.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.Crit.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.Crit.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
	
	sets.engaged.DW.SwordEnh.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Enspell)
    sets.engaged.DW.MidAcc.SwordEnh.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Enspell)
    sets.engaged.DW.HighAcc.SwordEnh.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Enspell)
	
	sets.engaged.DW.Subtle.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.SubtleBlow)
    sets.engaged.DW.MidAcc.Subtle.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.SubtleBlow)
    sets.engaged.DW.HighAcc.Subtle.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.SubtleBlow)
	
	sets.engaged.DW.Almace.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.TA)
    sets.engaged.DW.MidAcc.Almace.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.TA)
    sets.engaged.DW.HighAcc.Almace.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.TA)	


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
		neck="Nicander's necklace",
		waist="Gishdubar Sash",
		ring2="Sheltered Ring"
	}

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
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
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
    if spell.name == 'Dispelga' then
        equip(sets.precast.FC.Dispelga)
	end
	-- if spell.type == 'WeaponSkill' then
        -- if spell.english == 'Sanguine Blade' then
            -- if world.weather_element == 'Dark' or world.day_element == 'Dark' then
                -- equip(sets.Obi)
            -- end
		-- elseif spell.english == 'Burning Blade' and (world.weather_element == 'Fire' or world.day_element == 'Fire') then
            -- equip(sets.Obi)
		-- elseif spell.english == 'Red Lotus Blade' and (world.weather_element == 'Fire' or world.day_element == 'Fire') then
            -- equip(sets.Obi)
        -- end
	-- end
    if elemental_ws:contains(spell.name) then
    -- Matching double weather (w/o day conflict).
    if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
        equip(sets.Obi)
    -- Target distance under 1.7 yalms.
    elseif spell.target.distance < (1.7 + spell.target.model_size) then
		equip({waist="Orpheus's Sash"})
    -- Matching day and weather.
    elseif spell.element == world.day_element and spell.element == world.weather_element then
        equip(sets.Obi)
    -- Target distance under 8 yalms.
    elseif spell.target.distance < (8 + spell.target.model_size) then
        equip({waist="Orpheus's Sash"})
    -- Match day or weather.
    elseif spell.element == world.day_element or spell.element == world.weather_element then
        equip(sets.Obi)
    end
    end		
end	

function job_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' then
        if enfeebling_magic_skill:contains(spell.english) or enfeebling_magic_effect:contains(spell.english) then
            if spell.type == "WhiteMagic" then
                equip(sets.midcast.MndEnfeeblesAcc)
            else
                equip(sets.midcast.IntEnfeeblesAcc)
            end
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' then
        if enfeebling_magic_skill:contains(spell.english) then
            equip(sets.midcast.SkillEnfeebles)
        elseif enfeebling_magic_effect:contains(spell.english) then
            equip(sets.midcast.EffectEnfeebles)
        end
        if state.Buff.Saboteur then
            equip(sets.buff.Saboteur)
        end
    end
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
                if spell.target.type == 'SELF' then
                    equip (sets.midcast.RefreshSelf)
                end
            end
        elseif skill_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingSkill)
        elseif spell.english:startswith('Gain') then
            equip(sets.midcast.GainSpell)
        end
        if (spell.target.type == 'PLAYER' or spell.target.type == 'NPC') and buffactive.Composure then
            equip(sets.buff.ComposureOther)
			if spellMap == 'Refresh' then
				equip(sets.midcast.Refresh)	
			end
			if spell.english == 'Phalanx II' then
				equip(sets.buff.ComposureOther)	
			end			
		end
    end
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value and spell.english ~= 'Death' then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
    -- if (spell.element == world.day_element or spell.element == world.weather_element) then
            -- equip(sets.Obi)
    -- end
    if spell.skill == 'Elemental Magic' or spell.english == "Kaustra" then
        if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
            equip(sets.Obi)
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
        elseif spell.element == world.day_element and spell.element == world.weather_element then
            equip(sets.Obi)
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Match day or weather.
        elseif spell.element == world.day_element or spell.element == world.weather_element then
            equip(sets.Obi)
        end
    end	
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Break" then
            send_command('@timers c "Break ['..spell.target.name..']" 30 down spells/00255.png')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('neck','waist')
        else
            enable('neck','waist')
            handle_equipping_gear(player.status)
        end
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
    if state.RingLock.value == true then
        disable('ring1','ring2')
    else
        enable('ring1','ring2')
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
end	

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == "WhiteMagic" then
                if  enfeebling_magic_effect:contains(spell.english) then
                    return "EffectEnfeebles"
                elseif not enfeebling_magic_skill:contains(spell.english) then
                    if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                        return "MndEnfeeblesAcc"
                    else
                        return "MndEnfeebles"
                    end
                end
            elseif spell.type == "BlackMagic" then
                if  enfeebling_magic_effect:contains(spell.english) then
                    return "EffectEnfeebles"
                elseif not enfeebling_magic_skill:contains(spell.english) then
                    if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                        return "IntEnfeeblesAcc"
                    else
                        return "IntEnfeebles"
                    end
                end
            else
                return "MndEnfeebles"
            end
		end	
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
     elseif state.CP.current == 'on' then
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

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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

    if state.IdleMode.value ~= 'None' then
        msg = msg .. '[ Idle: ' .. state.IdleMode.value .. ' ]'
    end

    if state.Kiting.value then
        msg = msg .. '[ Kiting Mode: ON ]'
    end

    add_to_chat(060, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
--original function for haste:
--function determine_haste_group()
--    classes.CustomMeleeGroups:clear()
--    if DW == true then
--        if DW_needed <= 11 then
--            classes.CustomMeleeGroups:append('MaxHaste')
--       elseif DW_needed > 11 and DW_needed <= 26 then
--            classes.CustomMeleeGroups:append('HighHaste')
--        elseif DW_needed > 26 and DW_needed <= 31 then
--            classes.CustomMeleeGroups:append('MidHaste')
--        elseif DW_needed > 31 and DW_needed <= 42 then
--            classes.CustomMeleeGroups:append('LowHaste')
--        elseif DW_needed > 42 then
--            classes.CustomMeleeGroups:append('')
--        end
--    end
--end



function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 25 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 25 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 31 and DW_needed > 42 then
            classes.CustomMeleeGroups:append('LowHaste')
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end

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

-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>

function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
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

--windower.register_event('zone change', 
--    function()
--        send_command('gi ugs true')
--    end
--)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 13)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end

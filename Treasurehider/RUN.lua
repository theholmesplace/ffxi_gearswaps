-------------------------------------------------------------------------------------------------------------------
-- Treasurehider's RUN lua. Comment section below
-------------------------------------------------------------------------------------------------------------------

-- Updated base by Rikimarueye@pheonix
-- Original base lua created by Moten.

-- Version 1.0.1.0

--[[
	To do list:
	Optimize Battuta set for Critical Parry
]]

--[[
	Change log:
	
	1.0.1.0: Integrated many functions of old lua into this one
	1.0.0.9: Minor fix to positional function
	1.0.0.8: Added the a function to accurately use embolden during the post_midcast
	1.0.0.7: Prepping for item replacements and rework of BSV
	1.0.0.6: Changed DT set to add more MEVA
	1.0.0.5: Added Battuta state variability (BSV)
	1.0.0.4: Added weapon toggle
	1.0.0.3: Added CombatWeapon for the two weapons I only use
	1.0.0.2: Added extra functions to help with shadow cycling, status ailments and various other misc things
	1.0.0.0: Wrote the base lua from scratch using moten as a template
]]



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
	state.WarpMode:reset()
	classes.CustomIdleGroups:clear()
	handle_equipping_gear(player.status)	
end)
end


-- Setup vars that are user-independent.
function job_setup()
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')
	
	check_facing()
	get_combat_weapon()
	--get_combat_form()
	define_rune_info()
	
	state.Buff['Battuta'] = buffactive['Battuta'] or false
	
	--Buff ID 359 for doom
	state.Buff.doom = buffactive.doom or false
    state.Buff.sleep = buffactive.sleep or false
	state.Buff.Terror = buffactive.Terror or false
    state.Buff.Stun = buffactive.Stun or false
    state.Buff.Petrification = buffactive.Petrification or false
	
	state.Buff['Vallation'] = buffactive['Vallation'] or false
	state.Buff['Valiance'] = buffactive['Valiance'] or false
	state.Buff['Embolden'] = buffactive['Embolden'] or false

	rayke_duration = 35
	gambit_duration = 92
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'Hybrid', 'DD')
    state.WeaponskillMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT')
    state.IdleMode:options('Regen', 'Refresh')

	--Custom modes
    state.WarpMode = M{['description']='Transportation Ring is now', 'Off', 'Warp', 'Jima: Dem'}
	state.Charm = M(false, 'Charm')
	state.Knockback = M(false, 'Knockback')
	state.Death = M(false, "Death Resistance")
	state.CP = M(false, "Capacity Points Mode")

	--Weapon modes
	state.CombatWeapon = M{['description']='Weapon', 'Epeolatry', 'Lionheart'}

	--Rune modes
	state.Runes = M{['description']='Runes', "Ignis", "Gelus", "Flabra", "Tellus", "Sulpor", "Unda", "Lux", "Tenebrae"}
	state.Rune = M{['description']='which', 
        "Fire Dmg | Ice Resist: Paralyze, Bind, Frost", 
        "Ice Dmg | Wind Resist: Choke, Gravity, Silence", 
        "Wind dmg | Earth Resist: Slow, Petrify, Rasp", 
        "Earth dmg | Lightning Resist: Stun, Shock", 
        "Lightning Dmg | Water Resist: Poison, Drown", 
        "Water dmg | Fire Resist: Addle, Burn, Plague, Amnesia", 
        "Light Dmg | Dark Resist's: Blind, Bio, Sleep", 
        "Dark Dmg | Light Resist's: Repose, Dia, Charm"
    }

    -- Additional local binds
	send_command('bind ` input /ma "Flash" <t>')
	send_command('bind ^` input //gs c rune')
	send_command('bind !` input /ja "Vivacious Pulse" <me>')
	send_command('bind @` input /ma "Stun" <t>')
	send_command('bind !q input /ma "Temper" <me>')
	send_command('bind delete input /ws "Resolution" <t>')
	send_command('bind end input /ws "Dimidiation" <t>')
	send_command('bind ^f10 gs c cycle OffenseMode')
	send_command('bind ^f11 gs c cycle IdleMode')
	send_command('bind ^[ gs c toggle Knockback')
	send_command('bind ^] gs c toggle Death')
	send_command('bind ^\ gs c toggle Charm')
    send_command('bind ^z gs c cycle WarpMode')
    send_command('bind ^a gs c cycle CombatWeapon')
	send_command('bind ^- gs c cycleback Runes')
	send_command('bind ^= gs c cycle Runes')
	send_command('bind ^c gs c toggle CP')

	if player.sub_job == 'BLU' then
		send_command('bind home input /ma "Cocoon" <me>')
	elseif player.sub_job == 'WAR' then
		send_command('bind home input /ja "Berserk" <me>')
		send_command('bind != input /ja "Defender" <me>')
	elseif player.sub_job == 'DRK' then
		send_command('bind home input /ja "Last Resort" <me>')
		send_command('bind != input /ja "Souleater" <me>')
		send_command('bind !- input /ja "Weapon Bash" <me>')
	elseif player.sub_job == 'SAM' then
		send_command('bind home input /ja "Hasso" <me>')
		send_command('bind != input /ja "Sekkanoki" <me>')
		send_command('bind !- input /ja "Meditate" <me>')
	end

	select_default_macro_book()
	set_lockstyle()

	target_distance = 5.5 -- Set Default Distance Here --
end

function user_unload()
    
	send_command('unbind ^z')
	send_command('unbind ^a')
	send_command('unbind `')
    send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind @`')
	send_command('unbind ^f10')
	send_command('unbind ^f11')
    send_command('unbind ^-')
	send_command('unbind !-')
    send_command('unbind ^=')
    send_command('unbind !=')
	send_command('unbind delete')
	send_command('unbind end')
	send_command('unbind home')
	send_command('unbind !q')
	send_command('unbind ^c')
	send_command('unbind ^[')
	send_command('unbind ^]')
	send_command('unbind ^\\')
end


function init_gear_sets()

    -- JSE
    AF = {}         -- leave this empty
    RELIC = {}      -- leave this empty
    EMPY = {}       -- leave this empty


	-- Fill this with your own JSE. 
    --Runeist
    AF.Head		=	"Rune. Bandeau +3"
    AF.Body		=	"Runeist coat +3"
    AF.Hands	=	"Runeist mitons +3"
    AF.Legs		=	"Rune. Trousers +3"
    AF.Feet		=	"Runeist boots +3"

    --Futhark
    RELIC.Head		=	"Futhark Bandeau +3"
    RELIC.Body		=	"Futhark Coat +3"
    RELIC.Hands 	=	"Futhark Mitons +3"
    RELIC.Legs		=	"Futhark Trousers +3"
    RELIC.Feet		=	"Futhark Boots +3"

    --Erilaz
    EMPY.Head		=	"Erilaz Galea +3"
    EMPY.Body		=	"Erilaz Surcoat +3"
    EMPY.Hands		=	"Erilaz Gauntlets +3"
    EMPY.Legs		=	"Eri. Leg Guards +3"
    EMPY.Feet		=	"Erilaz Greaves +3"

    -- Capes:
    -- Ogma's and such, add your own.
    RUNCape = {}
    RUNCape.Tank	=	{ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}}
    RUNCape.FC		=	{ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}} -- DONT HAVE THIS
	RUNCape.SIR		=	{ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Spell interruption rate down-10%',}}
	RUNCape.TP		=	{ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}

---------------------------------------------------------------------------------------------------
    -- Custom sets and TH tagging
---------------------------------------------------------------------------------------------------
    
	--TH on first hit
	sets.TreasureHunter = {
		ammo="Perfect lucky egg",
		head="Volte Cap",
		body="Volte Jupon",
		hands="Volte Bracers",
		legs="Volte Hose",
		feet="Volte Boots",
		waist="Chaac Belt",
	    }
	
	sets.Warp = {ring2="Warp Ring"}
	sets.CP = {back="Mecisto. Mantle"}
  
    sets.Holla = {ring2="Dim. Ring (Holla)"}
	sets.Dem = {ring2="Dim. Ring (Dem)"}
	sets.Mea = {ring2="Dim. Ring (Mea)"}
	
	sets.Epeolatry = {main="Epeolatry"}
	sets.Lionheart = {main="Lionheart"}
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Enmity set
	----------------------------------------------------------------------------------------------------------------------------------
	
	-- 93 (+23 epo) enmity / 25 PDT - 26 DT / 2738 HP
    sets.enmity = {					--		-5 PDT from strap -25 PDT from Epeol
		ammo="Sapience Orb",		--2
		head="Halitus Helm",		--8
		body="Emet Harness +1",		--10	-6 PDT
		hands="Kurys Gloves",		--9		-2 DT
		legs=EMPY.Legs,				--13	-13 DT
		feet=EMPY.Feet,				--8		-11 DT
		neck="Moonlight Necklace",	--15
		--waist="Audumbla Sash",		--		-4 PDT
	    ear1="Cryptic Earring",		--4
        ear2="Trux Earring",		--5
	    ring1="Petrov Ring",		--4
		ring2="Eihwaz Ring",		--5
		back=RUNCape.Tank,			--10	-10 PDT
		} 

	----------------------------------------------------------------------------------------------------------------------------------
	-- SiRD set
	----------------------------------------------------------------------------------------------------------------------------------

	-- 94 (+10 merits) SiRD -- 27 DT / 16 PDT / 3046 HP
	sets.SIR = {					--		-PDT 5 (Strap) 
		ammo="Staunch Tathlum +1",	--11	-DT 3
	    head=EMPY.Head,				--20
		--body equipped normally	--		
		hands="Rawhide Gloves",		--15
		legs=EMPY.Legs,				--		-DT 13
		feet=EMPY.Feet,				--		-DT 11
		neck="Moonlight Necklace",	--15
		--waist="Audumbla Sash",		--10	-PDT 4
	    ear1="Tuisto Earring",
        ear2="Magnetic Earring",	--8
	    ring1="Gelatinous Ring +1",	--		-PDT 7
		ring2="Evanescence Ring",	--5
		back=RUNCape.SIR			--10
		}

	----------------------------------------------------------------------------------------------------------------------------------
	-- JA precast sets
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.precast.JA = {
		}
	
    sets.precast.JA['Vallation'] = set_combine(sets.enmity, {
		body=AF.Body,
		legs=RELIC.Legs,
		back=RUNCape.FC,
		})

    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
    sets.precast.JA['Pflug'] =  set_combine(sets.enmity, {feet=AF.Feet})
    sets.precast.JA['Battuta'] = set_combine(sets.enmity, {head=RELIC.Head})
    sets.precast.JA['Liement'] = set_combine(sets.enmity, {body=RELIC.Body})
	
    sets.precast.JA['Lunge'] = {
		ammo="Seething bomblet +1",
		head="Nyame Helm",
        body="Carmine Scale Mail +1",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet=gear.Herc_MAB_feet,
		back="Argocham. Mantle",
		neck="Baetyl Pendant",
		waist="Yamabuki-no-obi",
		ear1="Friomisi Earring",
		ear2="Hecate's Earring",
		ring1="Locus Ring",
		ring2="Acumen Ring",
		}
			
    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
    sets.precast.JA['Gambit'] = set_combine(sets.enmity, {hands=AF.Hands})
    sets.precast.JA['Rayke'] = set_combine(sets.enmity, {feet=RELIC.Feet})
    sets.precast.JA['Elemental Sforzo'] = set_combine(sets.enmity, {body=RELIC.Body})
	sets.precast.JA['Odyllic Subterfuge'] = sets.enmity
    sets.precast.JA['Swordplay'] = set_combine(sets.enmity, {hands=RELIC.Hands})
	sets.precast.JA['One For All'] = set_combine(sets.Enmity, {})

    sets.precast.JA['Embolden'] = set_combine(sets.enmity, {
		head=EMPY.Head,
		legs=RELIC.Legs,
		back="Evasionist's Cape"
		})
	
    sets.precast.JA['Vivacious Pulse'] = {
		head=EMPY.Head,
		neck="Incanter's Torque",
		legs=AF.Legs,
		ear1="Beatific Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe4"},
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
		back="Altruistic Cape"
		}

    sets.precast.JA['Provoke'] = sets.enmity
	sets.precast.JA['Souleater'] = sets.enmity
	sets.precast.JA['Last Resort'] = sets.enmity
	sets.precast.JA['Weapon Bash'] = sets.enmity
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- FC sets
	----------------------------------------------------------------------------------------------------------------------------------
	
	-- 48 FC - 2716 HP
    sets.precast.FC = {
        ammo="Sapience Orb", --2
		head=AF.Head, --14
		ear1="Etiolation Earring", --1
		body=EMPY.Body, --14
		hands="Leyline Gloves", --7
		legs="Ayanmo Cosciales +2", --6
		ring1="Kishar Ring", --4
		back=RUNCape.FC
		}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash", legs=RELIC.Legs})
	sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {neck='Magoraga beads'})
	sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {})

	----------------------------------------------------------------------------------------------------------------------------------
	-- WeaponSkill
	----------------------------------------------------------------------------------------------------------------------------------

	-- 38 DT 15 PDT 2796 HP for all WSs
    sets.precast.WS['Resolution'] = {
		ammo="Aurgelmir orb +1",
		head="Nyame helm",
		body="Nyame mail",
        hands="Nyame gauntlets",
        legs="Nyame flanchard",
        feet="Nyame sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		ear1="Moonshade Earring",
		ear2="Sherida Earring",
		ring1="Epona's Ring",
		ring2="Niqmaddu Ring",
		back=RUNCape.TP,
		}

    sets.precast.WS['Dimidiation'] = {
		ammo="Coiste Bodhar",
		head="Nyame helm",
		body="Nyame mail",
        hands="Nyame gauntlets",
        legs="Nyame flanchard",
        feet="Nyame sollerets",
		neck="Fotia gorget",
		waist="Kentarch belt +1",
        ear1="Moonshade Earring",
		ear2="Sherida Earring",
		ring1="Regal ring",
		ring2="Niqmaddu ring",
		back=RUNCape.TP,
		}

	sets.precast.WS['Herculean Slash'] = set_combine(sets.precast['Lunge'], {})

	----------------------------------------------------------------------------------------------------------------------------------
	-- Midcasts
	----------------------------------------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.SIR
	sets.midcast.Utsusemi = sets.SIR

	----------------------------------------------------------------------------------------------------------------------------------
	-- Experimental Voodoo dark magic sets
	----------------------------------------------------------------------------------------------------------------------------------

	sets.midcast['Dark Magic'] = {}
	sets.midcast.Absorb = {
		head=RELIC.Head,
		neck="Sanctity Necklace",
		body=RELIC.Body,
		ear1="Enchanter Earring +1",
		ear2="Dignitary's Earring",
		hands=RELIC.Hands,
		ring1="Stikini Ring +1",
		ring2="Defending Ring",
		legs=RELIC.Legs,
		waist="Eschan Stone",
		back=RUNCape.FC,
		feet={ name="Herculean Boots", augments={'Accuracy+23','"Triple Atk."+4','Attack+10',}},
		}

	----------------------------------------------------------------------------------------------------------------------------------
	-- Blue magics for h8 and stuff and stuff
	----------------------------------------------------------------------------------------------------------------------------------

	sets.midcast['Blue Magic'] = {}
	sets.midcast['Jettatura'] = sets.enmity
	sets.midcast['Blank Gaze'] = sets.SIR
	sets.midcast['Wild Carrot'] = sets.enmity
	sets.midcast['Healing Breeze'] = sets.SIR
	sets.midcast['Cocoon'] = sets.SIR
	sets.midcast['Refueling'] = sets.SIR

	----------------------------------------------------------------------------------------------------------------------------------
	-- Midcast for h8 spells and buffing. Enhancing is in alphabetical order
	----------------------------------------------------------------------------------------------------------------------------------

	sets.midcast['Aquaveil'] = sets.SIR
	sets.midcast['Flash'] = sets.enmity
	sets.midcast['Foil'] = sets.enmity
	sets.midcast['Phalanx'] = sets.SIR
	sets.midcast['Stun'] = sets.enmity
	sets.midcast['Poisonga'] = sets.enmity

    sets.midcast['Enhancing Magic'] = {
		ammo="Staunch Tathlum +1",
		head=EMPY.Head,
		neck="Incanter's Torque",
		ear1="Odnowa Earring +1",
		ear2="Mimir Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe4"},
		ring2={name="Stikini Ring +1", bag="wardrobe5"},
		hands=AF.Hands,
		waist="Olympus Sash",
		legs=RELIC.Legs,
		back=RUNCape.FC
	}

	sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {
		head=EMPY.Head,
		hands="Regal Gauntlets",})

	sets.midcast.Shell = set_combine(sets.midcast['Enhancing Magic'], {
		head=EMPY.Head,
		hands="Regal Gauntlets",})

	-- sets.midcast['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'], {
		-- head="Carmine Mask +1",
		-- hands="Regal Gauntlets",
		-- legs={ name="Carmine Cuisses +1", augments={'Accuracy+12','DEX+12','MND+20',}},
		-- back="Merciful Cape"
		-- })

	sets.midcast['Crusade'] = set_combine(sets.midcast['Enhancing Magic'], {
		head=EMPY.Head,
		hands="Regal Gauntlets",
		})

	-- +19 Phalanx/ 440 skill/ 2411 HP
	sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {
	    head=RELIC.Head, --7
        body=gear.Taeon_Phalanx_body, --3
		hands=gear.Taeon_Phalanx_hands, --3
		legs=gear.Taeon_Phalanx_legs, --3
		feet=gear.Taeon_Phalanx_feet, --3
        ring1="Gelatinous ring +1",
		})
   
	sets.midcast['Refresh'] = set_combine(sets.midcast['Enhancing Magic'], {
		head=EMPY.Head,
		waist="Gishdubar Sash"})

	sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
		head=AF.Head,
		legs=RELIC.Legs,
		})

	sets.midcast['Stoneskin'] = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Stone Gorget",
		hands="Regal Gauntlets",
		ear2="Earthcry Earring",
		waist="Siegel Sash",
		ring2="Defending Ring",
		back=RUNCape.FC})

	sets.midcast['Temper'] = set_combine(sets.midcast['Enhancing Magic'], {
		head=EMPY.Head, 
		back="Merciful Cape"
		})

	sets.midcast.Cure = {feet=RELIC.Feet}

	sets.midcast['Yoran-Oran (UC)'] = set_combine(sets.midcast.FastRecast, {body="Yoran Unity Shirt"})
	--sets.midcast['Sylvie (UC)'] = set_combine(sets.midcast.FastRecast, {body="Sylvie Unity Shirt"})

	----------------------------------------------------------------------------------------------------------------------------------
	-- Idle/Defense/Resist sets
	----------------------------------------------------------------------------------------------------------------------------------

    sets.idle = {					-- DT 49 PDT 8 MDT 2 HP 3458
		sub="Mensch strap +1",		-- PDT 5
		ammo="Yamarang",
		head="Nyame helm",			-- DT 7
		body=EMPY.Body,
		hands="Nyame Gauntlets",	-- DT 7
		legs=EMPY.Legs,				-- DT 12 (EMPY 3 is 13)
		feet=EMPY.Feet,				-- DT 11
		neck="Loricate Torque +1",	-- DT 6
		waist="Flume belt +1",		-- PDT 4
		--waist="Engraved Belt", --Waking the Beast II (Full Moon Fountain - Use in engaged sets below too)
		ear1="Tuisto earring",
		ear2="Odnowa Earring +1",	-- DT 3 MDT 2
		ring1="Paguroidea Ring",
		ring2="Gelatinous Ring +1",	-- PDT 7
		back=RUNCape.Tank,			-- Parry 5
		}

	sets.idle.Town = set_combine(sets.idle, {
		sub="Mensch Strap +1",
		ammo="Homiliary",
		head="Turms Cap +1",
		body=AF.Body,
		legs="Carmine Cuisses +1",
		neck="Bathy Choker +1",
		waist="Isa Belt",
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
		})

	sets.idle.Weak = sets.idle
	sets.Kiting = {legs="Carmine Cuisses +1"}
	sets.idle.Refresh = set_combine(sets.idle, {
		ammo="Homiliary",
		body=AF.Body,
		waist="Fucho-no-obi",
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
		})

	sets.defense.PDT = {
		ammo="Staunch Tathlum +1", --3/3
		head=RELIC.Head, --6/0
		body="Nyame Mail", --9/9
		hands="Kurys Gloves", --2/0
		legs=EMPY.Legs, --12/12
		feet="Turms Leggings +1", --
		neck="Loricate Torque +1", --6/6
		waist="Flume Belt +1", --4/0
		ear1="Genmei Earring", --2/0
		ear2="Odnowa Earring +1", --3/5
		ring1="Defending Ring", --10/10
		ring2="Gelatinous Ring +1", --7/-1
		back=RUNCape.Tank, --10/0
		}

	sets.defense.MDT = {
		ammo="Staunch Tathlum +1",
		head="Turms Cap +1",
		body="Nyame Mail",
		hands="Turms Mittens +1",
		legs="Nyame Flanchard",
		feet="Turms Leggings +1",
		neck="Moonlight Necklace",
		waist="Flume Belt +1",
		ear1="Tuisto Earring",
		ear2="Odnowa Earring +1",
		ring1="Defending Ring",
		ring2="Moonlight Ring",
		back=RUNCape.Tank,
		}

	-- 3205~ HP/ 54 DT/ 62 PDT/ 53 MDT
	sets.defense.DT = {
		ammo="Staunch Tathlum +1", --3/3
		head="Nyame Helm", --7/7
		body="Nyame Mail", --9/9
		hands="Turms Mittens +1",
		legs="Nyame Flanchard", --8/8
		feet="Turms Leggings +1",
		neck="Loricate Torque +1", --6/6
		waist="Flume Belt +1", --4/0
		ear1="Tuisto Earring",
		ear2="Odnowa Earring +1", --3/5
		ring1="Defending Ring", --10/10
		ring2="Moonlight Ring", --5/5
		back=RUNCape.Tank, --10/0
		}

	-- GOALS for replacing engaged and unengaged set
	sets.defense.Parry = { -- parry based
		main="Epeolatry",
		sub="Refined Grip +1",
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		neck="Loricate Torque +1",
		ear1="Erilaz Earring +2",
		ear2="Tuisto Earring",
		body="Erilaz Surcoat +3",
		hands="Turms Mittens +1",
		ring1="Moonlight Ring",
		ring2="Defending Ring",
		back="Ogma's Cape",
		waist="Engraved Belt",
		legs="Eri. Leg Guards +3",
		feet="Turms Leggings +1"
		}
	sets.defense.unengaged = { -- evasion based
		main="Epeolatry",
		sub="Refined Grip +1",
		ammo="Yamarang",
		head="Nyame Helm",
		neck="Loricate Torque +1",
		ear1="Erilaz Earring +2",
		ear2="Tuisto Earring",
		body="Nyame Mail",
		hands="Turms Mittens +1",
		ring1="Moonlight Ring",
		ring2="Defending Ring",
		back="Ogma's Cape",
		waist="Engraved Belt",
		legs="Eri. Leg Guards +3",
		feet="Turms Leggings +1"
		}

	-- 2639HP/ 24 DT/ 35 PDT/ 28 MDT/ 522+40+15 MEVA/ 118 INT/ 133 MND
	sets.defense.Resist = set_combine(sets.defense.DT, {
		ammo="Yamarang",
		neck="Warder's Charm +1",
		ring1="Purity Ring",
		ear1="Hearty Earring",})

----------------------------------------------------------------------------------------------------------------------------------
	-- Melee sets
----------------------------------------------------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------------------------------------------------
	-- Lionheart sets. Tanking, hybrid and DD sets.
	----------------------------------------------------------------------------------------------------------------------------------

    sets.engaged.Lionheart = {
		sub="Utu Grip",
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Turms Mittens +1",
		legs="Nyame Flanchard",
		feet="Turms Leggings +1",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		ear1="Tuisto Earring",
		ear2="Odnowa Earring +1",
		ring1="Defending Ring",
		ring2="Moonlight Ring",
		back=RUNCape.Tank,
		}

	-- 51 PDT/ 37 MDT
	sets.engaged.Lionheart.Hybrid = set_combine(sets.engaged.Lionheart, {
		ammo="Yamarang",
		neck="Combatant's Torque",
		waist="Kentarch Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring2="Ilabrat Ring",
		back=RUNCape.TP,
		})

	sets.engaged.Lionheart.DD = {
		ammo="Yamarang",
		head=gear.Adhemar_B_head,
		hands=gear.Adhemar_A_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Combatant's Torque",
		waist="Kentarch Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring1="Epona's Ring",
		ring2="Niqmaddu Ring",
		back=RUNCape.TP,
		}		

	----------------------------------------------------------------------------------------------------------------------------------
	-- Epo sets. Tanking, hybrid and DD sets.
	----------------------------------------------------------------------------------------------------------------------------------

	sets.engaged.Epeolatry = {		-- DT 49 PDT 22 MDT 2 HP 3458
		sub="Mensch strap +1",		-- PDT 5
		ammo="Yamarang",
		head="Nyame helm",			-- DT 7
		body=EMPY.Body,
		hands="Turms Mittens +1",	-- DT 7
		legs=EMPY.Legs,				-- DT 12 (EMPY 3 is 13)
		feet=EMPY.Feet,				-- DT 11
		neck="Loricate Torque +1",	-- DT 6
		waist="Flume Belt +1",		-- PDT 4
		--waist="Engraved Belt", --Waking the Beast II (Full Moon Fountain - Use in engaged sets below too)
		ear1="Tuisto earring",
		ear2="Odnowa Earring +1",	-- DT 3 MDT 2
		ring1="Paguroidea Ring",
		ring2="Gelatinous Ring +1",	-- PDT 7
		back=RUNCape.Tank,			-- PDT 10
		}

	sets.engaged.Epeolatry.Hybrid = set_combine(sets.engaged.Epeolatry, {
		ammo="Yamarang",
		neck="Combatant's Torque",
		waist="Kentarch Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring2="Ilabrat Ring",
		back=RUNCape.TP
		})

	sets.engaged.Epeolatry.DD = set_combine(sets.engaged.Epeolatry, {
		ammo="Yamarang",
		head=gear.Adhemar_B_head,
		body=gear.Taeon_Phalanx_body,
		hands=gear.Adhemar_A_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring1="Epona's Ring",
		ring2="Niqmaddu Ring",
		back=RUNCape.TP,
		})

	-- 51 PDT	
    sets.engaged.PDT = sets.engaged.Lionheart

	----------------------------------------------------------------------------------------------------------------------------------
	-- Additional sets
	----------------------------------------------------------------------------------------------------------------------------------

	sets.buff['Battuta'] = {
		hands="Turms Mittens +1",
		legs=EMPY.Legs,
		feet="Turms Leggings +1",
		}

	sets.buff['Battuta'].Melee = {
		feet="Turms Leggings +1",
		}

	sets.buff['Battuta'].Facing = {feet=RELIC.Feet,}

	sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Purity Ring", bag="wardrobe"}, --7
        ring2={name="Eshmun's Ring", bag="wardrobe5"}, --20
        waist="Gishdubar Sash", --10
        }

	sets.buff.sleep = {head="Frenzy Sallet"}

	sets.buff['Embolden'] = {
		hands="Regal Gauntlets",
		legs=RELIC.Legs,
		back="Evasionist's Cape",
		}
end

----------------------------------------------------------------------------------------------------------------------------------
	-- Function land
----------------------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
     cancel_conflicting_buffs(spell, action, spellMap, eventArgs)
	 custom_aftermath_timers_precast(spell, action, spellMap, eventArgs)

	 -------------------------------------------------------------------------------------------------------------------
     -- Cancel WS when not in range.
     -------------------------------------------------------------------------------------------------------------------

	 if spell.type == "WeaponSkill" then
		if player.status == 'Engaged' then
			if player.tp >= 1000 then
				if spell.target.distance <= 7 then
					if sets.precast.WS[spell.name] then
						equip(sets.precast.WS[spell.name])
					else
						equip(sets.precast.WS)
					end
				else
					cancel_spell()
					windower.add_to_chat(121, 'Canceled '..spell.name..'.'..spell.target.name..' is Too Far')
				end
			end
		else
			cancel_spell()
			windower.add_to_chat(121, 'You must be Engaged to WS')
        end
    end

	if spell.english == 'Lunge' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Swipe" <t>')
            add_to_chat(122, '***Lunge Aborted: Timer on Cooldown -- Downgrading to Swipe.***')
            eventArgs.cancel = true
            return
        end
    end
	if spell.english == 'Valiance' then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		if abil_recasts[spell.recast_id] > 0 then
			send_command('input /jobability "Vallation" <me>')
			add_to_chat(122, '***Valiance Aborted: Timer on Cooldown -- Downgrading to Vallation.***')
			eventArgs.cancel = true
			return
		end
	end
	if spell.english == 'Berserk' then 
	    if buffactive.Berserk then -- Change Berserk To Aggressor If Berserk Is On --
		cancel_spell()
		send_command('input /ja Aggressor <me>')
	    end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
    -- Shadow cycling
-------------------------------------------------------------------------------------------------------------------

function job_midcast(spell, action, spellMap, eventArgs)
	--Cancels Ni shadows
	if spell.name == 'Utsusemi: Ichi' and overwrite then
        send_command('cancel Copy Image|Copy Image (2)')
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Blue Magic' then
		if spell.english == 'Geist Wall' or spell.english == 'Sheep Song' then
			if buffactive['Vallation'] or buffactive['Valiance'] then
				equip(sets.midcast.FastRecast)
			else
				add_to_chat(8, '*** Use Vallation or Valiance. ***')
				equip(sets.midcast.FastRecast)
			end
		else
			equip(sets.enmity)
		end
	end

	if buffactive['Embolden'] then 
		if spell.skill == 'Enhancing Magic' then
			equip(sets.buff['Embolden'])
		end
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
   custom_aftermath_timers_aftercast(spell, action, spellMap, eventArgs)
   
   if not spell.interrupted then
        if spell.name == 'Utsusemi: Ichi' then
            overwrite = false
        elseif spell.name == 'Utsusemi: Ni' then
            overwrite = true
        end
    end
	if spell.type == 'Rune' and not spell.interrupted then
        display_rune_info(spell)
    end
	if spell.name == 'Rayke' and not spell.interrupted then
		send_command('@timers c "Rayke ['..spell.target.name..']" '..rayke_duration..' down spells/00136.png')
		send_command('wait '..rayke_duration..';input /p Rayke: OFF <call21>;')
	elseif spell.name == 'Gambit' and not spell.interrupted then
		send_command('@timers c "Gambit ['..spell.target.name..']" '..gambit_duration..' down spells/00136.png')
		send_command('wait '..gambit_duration..';input /p Gambit: OFF <call21>;')
	end
end

function job_buff_change(buff,gain, eventArgs)

    ---------------------------------------------------------------------------------------------------
    -- Equipment for debuffs.
	---------------------------------------------------------------------------------------------------	

	if buff:lower()=='sleep' then
        if gain and player.hp > 100 then 
            equip(sets.buff.sleep)
			--add_to_chat(8, 'Nap time!!!')
			if buffactive.stoneskin then
				send_command('cancel Stoneskin')
			end
        elseif not gain then 
            handle_equipping_gear(player.status)
		end
	elseif buff:lower()=='terror' then
        if gain and player.status == "Engaged" then 
            equip(sets.defense.DT)
			disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
        elseif not gain then 
		    enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
            handle_equipping_gear(player.status)
		end
	elseif buff:lower()=='petrification' then
        if gain and player.status == "Engaged" then 
            equip(sets.defense.DT)
			disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
        elseif not gain then 
		    enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
            handle_equipping_gear(player.status)
		end
	elseif buff:lower()=='stun'  then
        if gain and player.status == "Engaged" then 
            equip(sets.defense.DT)
			disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
        elseif not gain then 
		    enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
            handle_equipping_gear(player.status)
		end
	elseif buff:lower()=='doom' then
        if gain then 
            equip(sets.buff.doom)
			send_command('@input /p Doom! Ahh!')
			disable('ring1' , 'ring2' , 'waist')
			--add_to_chat(123, 'Doomed!!! Use Holy Waters!!!')
        elseif not gain then 
		    enable('ring1' , 'ring2' , 'waist')
            handle_equipping_gear(player.status)
		end
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
	elseif buff == 'Battuta' then
        handle_equipping_gear(player.status)
	elseif buff == 'Souleater' then
        send_command('cancel Souleater')
	elseif buff == 'Vallation' or 'Valiance' then
        handle_equipping_gear(player.status)
	elseif buff == 'Embolden' then
		handle_equipping_gear(player.status)
    end

	----------------------------------------------------------------------------------------------------------------------------------
	-- Runes autotimer
	----------------------------------------------------------------------------------------------------------------------------------

    info.max_runes = {['RUN']=3}
 
    if runes:contains(buff) then
        if not areas.Cities:contains(world.area) then
            if not buffactive[buff] or buffactive[buff] < info.max_runes[player.main_job] then
                local delay = gain and 5.1 or 1.1
                send_command('wait ' .. tostring(delay) .. ';input /ja "' .. buff .. '" <me>')
            end
        end
    end

	----------------------------------------------------------------------------------------------------------------------------------
	-- Aftermath timer
	----------------------------------------------------------------------------------------------------------------------------------

	if player.equipment.main == 'Lionheart' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}

        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
        else
            send_command('timers d "'..buff..'"')
        end
	elseif player.equipment.main == 'Epeolatry' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}

        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
        else
            send_command('timers d "'..buff..'"')
        end
	end
end

---------------------------------------------------------------------------------------------------
-- CombatWeapon to take into account AM. Always update here.
---------------------------------------------------------------------------------------------------	
function get_combat_weapon()
    if player.equipment.type == 'Great Sword' then
		if state.CombatWeapon.value == 'Lionheart' then
			state.CombatWeapon:set('Lionheart')
        elseif state.CombatWeapon.value == 'Epeolatry' then
			state.CombatWeapon:set('Epeolatry') 
        end
    else
		state.CombatForm:reset()
    end
end

---------------------------------------------------------------------------------------------------
-- CombatForm to take into account TP type
---------------------------------------------------------------------------------------------------	
--[[function get_combat_form()
    if player.equipment.type == 'Great Sword' then
		if state.CombatWeapon.value == 'Lionheart' then
			state.CombatForm:set('Lionheart')
        elseif state.CombatWeapon.value == 'Epeolatry' then
			state.CombatForm:set('Epeolatry') 
        end
    else
			state.CombatForm:reset()
		
    end
end]]

function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
		check_facing()
		get_combat_weapon()
		--get_combat_form()
    end          
end

function job_update(cmdParams, eventArgs)
	gearmode()
	check_facing()
	get_combat_weapon()
	--get_combat_form()
end

----------------------------------------------------------------------------------------------------------------------------------
	-- Set combine for melee
----------------------------------------------------------------------------------------------------------------------------------

function customize_melee_set(meleeSet)
	-- When Lionheart is in tanking mode, I have heavy protection.
	if state.CombatWeapon.value == 'Lionheart' then
		if state.OffenseMode.value == 'Normal' then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'])
			end
		-- When Lionheart is in hybrid mode, I have light protection.
		elseif state.OffenseMode.value == 'Hybrid' then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'].Melee)
			end
		-- When Lionheart is in DD mode, I have light protection.
		elseif state.OffenseMode.value == 'DD' and check_facing() == true then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'].Facing)
			end
		end
	-- When Epo is in tanking mode, I have heavy protection.
	elseif state.CombatWeapon.value == 'Epeolatry' then
		if state.OffenseMode.value == 'Normal' then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'])
			end
		-- When Epo is in hybrid, I have light protection.
		elseif state.OffenseMode.value == 'Hybrid' then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'].Melee)
			end
		-- When Epo is in DD mode, I have light protection.
		elseif state.OffenseMode.value == 'DD' and check_facing() == true then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'].Facing)
			end
		end
	end

	if state.Knockback.value == true then
		meleeSet = set_combine(meleeSet, sets.defense.Knockback)
	end
	if state.Death.value == true then
		meleeSet = set_combine(meleeSet, sets.defense.Death)
	end
	if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

function customize_defense_set(defenseSet)
	if state.Knockback.value == true then
		defenseSet = set_combine(defenseSet, sets.defense.Knockback)
	end
	if state.Death.value == true then
		defenseSet = set_combine(defenseSet, sets.defense.Death)
	end

	return defenseSet
end

----------------------------------------------------------------------------------------------------------------------------------
	-- Custom Warp rings
----------------------------------------------------------------------------------------------------------------------------------
	
function customize_idle_set(idleSet)
	if player.mpp < 51 then
		idleSet = set_combine(idleSet, sets.latent_refresh)
	end
	if state.Knockback.value == true then
		idleSet = set_combine(idleSet, sets.defense.Knockback)
	end
	if state.Death.value == true then
		idleSet = set_combine(idleSet, sets.defense.Death)
	end
	if state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
	end
	if state.WarpMode.value == 'Warp' then
		idleSet = set_combine(idleSet, sets.Warp)
	elseif state.WarpMode.value == 'Jima: Holla' then
        idleSet = set_combine(idleSet, sets.Holla)
	elseif state.WarpMode.value == 'Jima: Dem' then
        idleSet = set_combine(idleSet, sets.Dem)
    elseif state.WarpMode.value == 'Off' then
		idleSet = set_combine(idleSet)	
	end

    return idleSet
end

-- Special thanks to the ppl on the FFXIAH forums for coming up with this working bit of code!
function define_rune_info()
    rune_info = {
        ["Ignis"]   = {damage="Fire", resistance="Ice"},
        ["Gelus"]   = {damage="Ice", resistance="Wind"},
        ["Flabra"]  = {damage="Wind", resistance="Earth"},
        ["Tellus"]  = {damage="Earth", resistance="Lightning"},
        ["Sulpor"]  = {damage="Lightning", resistance="Water"},
        ["Unda"]    = {damage="Water", resistance="Fire"},
        ["Lux"]     = {damage="Light", resistance="Darkness"},
        ["Tenebrae"]= {damage="Darkness", resistance="Light"},
    }
end

function display_rune_info(spell)
    runeinfo = rune_info[spell.english]
    if runeinfo then
        add_to_chat(158, '***'..spell.english..' : '..runeinfo.damage..' damage and '..runeinfo.resistance..' resistance.***')
    end
end

function job_self_command(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'rune' then
		send_command('@input /ja '..state.Runes.value..' <me>')
	end
end

----------------------------------------------------------------------------------------------------------------------------------
	-- Weapon changing
----------------------------------------------------------------------------------------------------------------------------------

function gearmode()
  if state.CombatWeapon.value == 'Lionheart' then
		equip(sets.Lionheart)
		handle_equipping_gear(player.status)
	elseif state.CombatWeapon.value == 'Epeolatry' then
		equip(sets.Epeolatry)
		handle_equipping_gear(player.status)
  end
end

---------------------------------------------------------------------------------------------------
-- Voodoo magic that makes my relic boots equip under radial conditions. Credit: Whoever made the Gaze addon.
---------------------------------------------------------------------------------------------------

function check_facing()
	if player.target.type == 'MONSTER' then
		local target = windower.ffxi.get_mob_by_target('t')
		local player = windower.ffxi.get_mob_by_target('me')
		local dir_target = V{player.x, player.y} - V{target.x, target.y}
		local dir_player = V{target.x, target.y} - V{player.x, player.y}
		local player_heading = V{}.from_radian(player.facing)
		local target_heading = V{}.from_radian(target.facing)
		local player_angle = V{}.angle(dir_player, player_heading):degree():abs()
		local target_angle = V{}.angle(dir_target, target_heading):degree():abs()
		if player_angle < 90 and target_angle < 90 then
			return true
		else 
			return false
		end
	end	
		return false
end

function getAngle(index)
    local P = windower.ffxi.get_mob_by_target('me') --get player
    local M = index and windower.ffxi.get_mob_by_id(index) or windower.ffxi.get_mob_by_target('t') --get target
    local delta = {Y = (P.y - M.y),X = (P.x - M.x)} --subtracts target pos from player pos
    local angleInDegrees = (math.atan2( delta.Y, delta.X) * 180 / math.pi)*-1 
    local mult = 10^0
    return math.floor(angleInDegrees * mult + 0.5) / mult
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book: (set, book)
	if player.sub_job == 'BLU' then
		set_macro_page(10, 1)
	else
		set_macro_page(9, 1)
	end
end

function set_lockstyle()
	send_command('wait 6;input /lockstyleset 191')
end

--[[
        Custom commands:
    
        Toggle Function: 
        gs c toggle melee               Toggle Melee mode on / off and locking of weapons
        gs c toggle mb                  Toggles Magic Burst Mode on / off.
        gs c toggle runspeed            Toggles locking on / off Geomancy Sandals +3
        gs c toggle idlemode            Toggles between Refresh and DT idle mode. Activating Sublimation JA will auto replace refresh set for sublimation set. DT set will superceed both.        
        gs c toggle regenmode           Toggles between Hybrid, Duration and Potency mode for regen set  
        gs c toggle nukemode            Toggles between Normal and Accuracy mode for midcast Nuking sets (MB included)  
        gs c toggle matchsc             Toggles auto swapping element to match the last SC that just happenned.
		
        Casting functions:
        these are to set fewer macros (2 cycle, 5 cast) to save macro space when playing lazily with controler
        
        gs c nuke cycle              	Cycles element type for nuking & SC
		gs c nuke cycledown				Cycles element type for nuking & SC	in reverse order
        gs c nuke t1                    Cast tier 1 nuke of saved element 
        gs c nuke t2                    Cast tier 2 nuke of saved element 
        gs c nuke t3                    Cast tier 3 nuke of saved element 
        gs c nuke t4                    Cast tier 4 nuke of saved element 
        gs c nuke t5                    Cast tier 5 nuke of saved element 
        gs c nuke ra1                   Cast tier 1 -ra nuke of saved element 
        gs c nuke ra2                   Cast tier 2 -ra nuke of saved element 
        gs c nuke ra3                   Cast tier 3 -ra nuke of saved element 	
		
		gs c geo geocycle				Cycles Geomancy Spell
		gs c geo geocycledown			Cycles Geomancy Spell in reverse order
		gs c geo indicycle				Cycles IndiColure Spell
		gs c geo indicycledown			Cycles IndiColure Spell in reverse order
		gs c geo geo					Cast saved Geo Spell
		gs c geo indi					Cast saved Indi Spell

        HUD Functions:
        gs c hud hide                   Toggles the Hud entirely on or off
        gs c hud hidemode               Toggles the Modes section of the HUD on or off
        gs c hud hidejob                Toggles the job section of the HUD on or off
        gs c hud hidebattle             Toggles the Battle section of the HUD on or off
        gs c hud lite                   Toggles the HUD in lightweight style for less screen estate usage. Also on ALT-END
        gs c hud keybinds               Toggles Display of the HUD keybindings (my defaults) You can change just under the binds in the Gearsets file.

        // OPTIONAL IF YOU WANT / NEED to skip the cycles...  
        gs c nuke Ice                   Set Element Type to Ice DO NOTE the Element needs a Capital letter. 
        gs c nuke Air                   Set Element Type to Air DO NOTE the Element needs a Capital letter. 
        gs c nuke Dark                  Set Element Type to Dark DO NOTE the Element needs a Capital letter. 
        gs c nuke Light                 Set Element Type to Light DO NOTE the Element needs a Capital letter. 
        gs c nuke Earth                 Set Element Type to Earth DO NOTE the Element needs a Capital letter. 
        gs c nuke Lightning             Set Element Type to Lightning DO NOTE the Element needs a Capital letter. 
        gs c nuke Water                 Set Element Type to Water DO NOTE the Element needs a Capital letter. 
        gs c nuke Fire                  Set Element Type to Fire DO NOTE the Element needs a Capital letter. 
--]]


include('organizer-lib') -- Remove if you dont use Organizer

--------------------------------------------------------------------------------------------------------------
res = require('resources')      -- leave this as is    
texts = require('texts')        -- leave this as is    
include('Modes.lua')            -- leave this as is      
--------------------------------------------------------------------------------------------------------------

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- to define sets for regen if you add more modes, name them: sets.midcast.regen.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('normal', 'dt')
-- To add a new mode to nuking, you need to define both sets: sets.midcast.nuking.mynewmode as well as sets.midcast.MB.mynewmode
nukeModes = M('normal', 'acc')

-- Setting this to true will stop the text spam, and instead display modes in a UI.
-- Currently in construction.
use_UI = true
hud_x_pos = 1027    --important to update these if you have a smaller screen
hud_y_pos = 50     --important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 10
hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
hud_font = 'Impact'

-- Setup your Key Bindings here:  
    windower.send_command('bind insert gs c nuke cycle')            -- insert Cycles Nuke element
    windower.send_command('bind delete gs c nuke cycledown')        -- delete Cycles Nuke element in reverse order   
    windower.send_command('bind home gs c geo geocycle') 			-- home Cycles Geomancy Spell
    windower.send_command('bind PAGEUP gs c geo geocycledown') 		-- end Cycles Geomancy Spell in reverse order	
    windower.send_command('bind PAGEDOWN gs c geo indicycle') 		-- PgUP Cycles IndiColure Spell
    windower.send_command('bind end gs c geo indicycledown') 	    -- PgDown Cycles IndiColure Spell in reverse order	
    windower.send_command('bind !f9 gs c toggle runspeed') 			-- Alt-F9 toggles locking on / off Herald's Gaiters
	windower.send_command('bind f10 gs c toggle mb')				-- F10 toggles Magic Burst Mode on / off.
    windower.send_command('bind !f10 gs c toggle nukemode')         -- Alt-F10 to change Nuking Mode
    windower.send_command('bind ^F10 gs c toggle matchsc')          -- CTRL-F10 to change Match SC Mode         
    windower.send_command('bind f12 gs c toggle melee')				-- F12 Toggle Melee mode on / off and locking of weapons
	windower.send_command('bind f9 gs c toggle idlemode')			-- F9 Toggles between MasterRefresh or MasterDT when no luopan is out
--[[
    This gets passed in when the Keybinds is turned on.
    Each one matches to a given variable within the text object
    IF you changed the Default Keybind above, Edit the ones below so it can be reflected in the hud using "//gs c hud keybinds" command
]]																	-- or between Full Pet Regen+DT or Hybrid PetDT and MasterDT when a Luopan is out
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_regen'] = '(END)'
keybinds_on['key_bind_casting'] = '(ALT-F10)'
keybinds_on['key_bind_mburst'] = '(F10)'
keybinds_on['key_bind_matchsc'] = '(CTRL-F10)'

keybinds_on['key_bind_element_cycle'] = '(INS + DEL)'
keybinds_on['key_bind_geo_cycle'] = '(HOME + PgUP)'
keybinds_on['key_bind_indi_cycle'] = '(End + PgDOWN)'
keybinds_on['key_bind_lock_weapon'] = '(F12)'
keybinds_on['key_bind_movespeed_lock'] = '(ALT-F9)'


-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind insert')
    send_command('unbind delete')
    send_command('unbind home')
    send_command('unbind PAGEUP')
    send_command('unbind PAGEDOWN')
    send_command('unbind end')
    send_command('unbind f10')
    send_command('unbind f12')
    send_command('unbind f9')
    send_command('unbind !f9')
end

--------------------------------------------------------------------------------------------------------------
include('GEO_Lib.lua')          -- leave this as is     
--------------------------------------------------------------------------------------------------------------

geomancy:set('Geo-Frailty')     -- Geo Spell Default      (when you first load lua / change jobs the saved spells is this one)
indicolure:set('Indi-Refresh')  -- Indi Spell Default     (when you first load lua / change jobs the saved spells is this one)
validateTextInformation()

-- Optional. Swap to your geo macro sheet / book
set_macros(5,18) -- Sheet, Book   
windower.send_command('wait 6;input /lockstyleset 181')

-- Optional 
include('Treasurehider-Globals.lua') -- I list all my Augmented gears in a sidecar file since it's shared across many jobs. 

-- Setup your Gear Sets below:
function get_sets()
  
    -- My formatting is very easy to follow. All sets that pertain to my character doing things are under 'me'.
    -- All sets that are equipped to faciliate my.pan's behaviour or abilities are under .pan', eg, Perpetuation, Blood Pacts, etc
      
    sets.me = {}        -- leave this empty
    sets.pan = {}       -- leave this empty
	sets.me.idle = {}	-- leave this empty    
	sets.pan.idle = {}	-- leave this empty 

	-- sets starting with sets.me means you DONT have a luopan currently out.
	-- sets starting with sets.pan means you DO have a luopan currently out.

    -- Your idle set when you DON'T have a luopan out
    sets.me.idle.normal = {
        main="Idris",
        sub="Genmei Shield",
        ammo="Staunch Tathlum +1",
        body="Shamash Robe",
		hands="Bugua Mitaines +4",
        legs="Volte Brais",
		neck="Bagua Charm +2",
		ring1="Murky Ring",
		ring2="Gelatinous Ring +1",
        ear1="Etiolation Earring",
        ear2="Azimuth Earring +1",
        back="Moonlight Cape",
        waist="Isa Belt"
    }
	
	-- This or herald gaiters or +1 +2 +3... 
	sets.me.movespeed = {feet="Geomancy Sandals +3"}	
	
    -- Your idle MasterDT set (Notice the sets.me, means no Luopan is out)
    sets.me.idle.dt = set_combine(sets.me.idle.normal,{
        head="Azimuth Hood +3",
        body="Shamash Robe",
		hands="Bagua mitaines +4",
        legs="Nyame Flanchard",
        feet="Geomancy Sandals +3",
        ring1={name="Stikini Ring +1", bag="wardrobe4"},
        ring2={name="Murky Ring"},
    })

    -- Your MP Recovered Whilst Resting Set
    sets.me.resting = { 
		main="Chatoyant Staff",
    }
	
	sets.me.latent_refresh = {waist="Fucho-no-obi"}
	
	
    -----------------------
    -- Luopan Perpetuation
    -----------------------
      
    -- Luopan's Out --  notice sets.pan 
    -- This is the base for all perpetuation scenarios, as seen below
    sets.pan.idle.normal = {
        main="Idris",
        sub="Genmei Shield",
        range="Dunna",
        head="Azimuth Hood +3",
        neck="Bagua Charm +2",
        ear1="Sanare Earring",
        ear2="Azimuth Earring +1",
		body="Shamash Robe",
        hands="Geomancy Mitaines +3",
		ring1="Murky Ring",
		ring2="Gelatinous Ring +1",
        back="Nantosuelta's Cape",
        waist="Isa Belt",
        legs="Nyame Flanchard",
        feet="Bagua Sandals +3",
    }
	
	-- This is when you have a Luopan out but want to sacrifice some slot for master DT, put those slots in.
    sets.pan.idle.dt = set_combine(sets.pan.idle.normal,{
        head="Nyame helm",
        body="Nyame Mail",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
    })

    -- Combat Related Sets
      
    -- Melee
    -- Anything you equip here will overwrite the perpetuation/refresh in that slot.
	-- No Luopan out
	-- they end in [idleMode] so it will derive from either the normal or the dt set depending in which mode you are then add the pieces filled in below.
    sets.me.melee = set_combine(sets.me.idle[idleMode],{
		main="Maxentius",
		sub="Genmei Shield",
		ammo="Crepuscular",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Combatant's Torque",
        ear1="Dignitary's Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe5"},
        waist="Olseni Belt",
    })
	
    -- Luopan is out
	sets.pan.melee = set_combine(sets.pan.idle[idleMode],{
		main="Maxentius",
		sub="Genmei Shield",
		range="Dunna",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Combatant's Torque",
        ear1="Dignitary's Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe5"},
        waist="Olseni Belt",
    }) 
    
    -- Weapon Skill sets
	-- Example:
    sets.me["Flash Nova"] = {
        main="Bunzi's Rod",
		sub="Daybreak",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Baetyl Pendant",
        ear1="Regal Earring",
        ear2="Malignance Earring",
        ring1="Karieyh Ring +1",
        ring2="Freke Ring",
        waist="Fotia Belt",
    }

    sets.me["Black Halo"] = {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Caro Necklace",
        ear1="Moonshade Earring",
        ear2="Brutal Earring",
        ring1="Apate Ring",
		ring2="Epaminondas's Ring",
        waist="Grunfeld Rope",
		back="Nantosuelta's Cape"
    }

    sets.me["Realmrazer"] = {
        main="Idris",
        ammo="Pemphredo Tathlum",
        head="Bagua Galero +3",
        body="Bagua Tunic +3",
        hands="Jhakri Cuffs +2",
        legs="Bagua Pants +3",
        feet="Bagua Sandals +3",
        neck="Fotia Gorget",
        ear1="Regal Earring",
        ear2="Ishvara Earring",
        ring2="Karieyh Ring +1",
        waist="Fotia Belt",
    }
	
    sets.me["Exudation"] = {
        main="Idris",
        ammo="Pemphredo Tathlum",
        head="Bagua Galero +3",
        body="Bagua Tunic +3",
        hands="Jhakri Cuffs +2",
        legs="Bagua Pants +3",
        feet="Bagua Sandals +3",
        neck="Fotia Gorget",
        ear1="Regal Earring",
        ear2="Ishvara Earring",
        ring2="Karieyh Ring +1",
        waist="Fotia Belt",
    } 
    -- Feel free to add new weapon skills, make sure you spell it the same as in game.
  
    ---------------
    -- Casting Sets
    ---------------
      
    sets.precast = {}               -- leave this empty    
    sets.midcast = {}               -- leave this empty    
    sets.aftercast = {}             -- leave this empty    
    sets.midcast.nuking = {}        -- leave this empty
    sets.midcast.MB = {}            -- leave this empty    
    ----------
    -- Precast
    ----------
      
    -- Generic Casting Set that all others take off of. Here you should add all your fast cast  
    sets.precast.casting = {
    --  /RDM --15
		main="Malevolence", --5
        range="Dunna", --3
        head="Amalric Coif +1", --11
        body="Jhakri Robe +2", --2
        hands="Jhakri Cuffs +2", --2
        legs="Geo. Pants +3", --15
        feet="Jhakri Pigaches +2", --1
        neck="Incanter's Torque",
        ear1="Etiolation Earring", --1
		ear2="Azimuth Earring +1", --0
        ring1="Kishar Ring", --4
		ring2="Prolix Ring", --2
        back="Lifestream Cape", --7
    }   

    sets.precast.geomancy = set_combine(sets.precast.casting,{
        
    })
    -- Enhancing Magic, eg. Siegal Sash, etc
    sets.precast.enhancing = set_combine(sets.precast.casting,{

    })
  
    -- Stoneskin casting time -, works off of enhancing -
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{

    })
      
    -- Curing Precast, Cure Spell Casting time -
    sets.precast.cure = set_combine(sets.precast.casting,{
		main="Gada",
		sub="Sors Shield",
		ammo="Esper Stone +1",
        head="Amalric Coif +1",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Geomancy Pants +3",
        feet="Medium's Sabots",
        neck="Incanter's Torque",
        ear1="Regal Earring",
        ear2="Mendicant's Earring",
        ring1="Lebeche Ring",
        ring2="Prolix Ring",
        waist="Luminary Sash",
		back="Tempered Cape +1",
    })
    sets.precast.regen = set_combine(sets.precast.casting,{

    })     
    ---------------------
    -- Ability Precasting
    ---------------------
	
	-- Fill up with your JSE! 
    sets.precast["Life Cycle"] = {
    	body = "Geomancy Tunic +3",
    }
    sets.precast["Bolster"] = {
    	body = "Bagua Tunic +3",
    }
    sets.precast["Primeval Zeal"] = {
    	head = "Bagua Galero +3",
    }  
    sets.precast["Cardinal Chant"] = {
    	head = "Geomancy Galero +3",
    }  
    sets.precast["Full Circle"] = {
    	head = "Azimuth Hood +3",
    }  
    sets.precast["Curative Recantation"] = {
    	hands = "Bagua mitaines +4",
    }  
    sets.precast["Mending Halation"] = {
    	legs = "Bagua Pants +3",
    }
    sets.precast["Radial Arcana"] = {
    	feet = "Bagua Sandals +3",
    }

    ----------
    -- Midcast
    ----------
            
    -- Whatever you want to equip mid-cast as a catch all for all spells, and we'll overwrite later for individual spells
    sets.midcast.casting = {
		main="Wizard's rod",
		sub="Ammurapi Shield",
		--ammo="Pemphredo Tathlum",
		ammo="Ghastly Tathlum +1",
        head="Bagua Galero +3",
        body="Amalric Doublet +1",
        hands="Amalric Gages +1",
        legs="Geomancy Pants +3",
        feet="Bagua Sandals +3",
        neck="Incanter's Torque",
        ear1="Barkarole Earring",
		ear2="Azimuth Earring +1",
        ring1="Locus Ring",
        ring2="Freke Ring",
        waist="Yamabuki-no-obi",
		back="Nantosuelta's Cape",
    }
	
	-- +skill for Geo spells /
    sets.midcast.geo = set_combine(sets.midcast.casting,{
		--447geo + 412hand = 839 Base
		main="Idris", --10
        range="Dunna", --5
        head="Azimuth Hood +3", --20
        body="Bagua Tunic +3", --16
        hands="Geomancy Mitaines +3", --19
        feet="Medium's Sabots", --handbell 5
        neck="Bagua Charm +2", --7
        back="Lifestream Cape", --15
		--929
    })
	-- For Indi Spells
    sets.midcast.indi = set_combine(sets.midcast.geo,{
		legs="Bagua Pants +3",
		feet="Azimuth Gaiters +1",
        back="Nantosuelta's Cape", --20
    })

	sets.midcast.Obi = {
	    waist="Hachirin-no-Obi",
	}
	
	-- Nuking
    sets.midcast.nuking.normal = set_combine(sets.midcast.casting,{
		main="Bunzi's Rod"
    })
	sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {
		head="Ea Hat +1",
		body="Ea Houppe. +1",
		legs="Ea Slops +1",
		ring1="Mujin Band"
	})
    sets.midcast.nuking.acc = set_combine(sets.midcast.nuking.normal,{

    })
    sets.midcast.MB.acc = set_combine(sets.midcast.MB.normal, {

    })

	-- Enfeebling
	sets.midcast.IntEnfeebling = set_combine(sets.midcast.casting,{
		main="Contemplator +1",
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
        head="Geomancy Galero +3",
        body="Geomancy Tunic +3",
        hands="Geomancy Mitaines +3",
        legs="Geomancy Pants +3",
        feet="Geomancy Sandals +3",
        neck="Bagua Charm +2",
		ear1="Barkarole Earring",
		ear2="Azimuth Earring +1",
        ring1={name="Stikini Ring +1", bag="wardrobe4"},
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
        waist="Luminary Sash",
		back="Altruistic Cape",
    })
	sets.midcast.MndEnfeebling = set_combine(sets.midcast.casting,{
		main="Idris",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
        head="Geomancy Galero +3",
        body="Geomancy Tunic +3",
        hands="Geomancy Mitaines +3",
        legs="Geomancy Pants +3",
        feet="Geomancy Sandals +3",
        neck="Erra Pendant",
        ear1="Regal Earring",
		ear2="Azimuth Earring +1",
        ring1={name="Stikini Ring +1", bag="wardrobe4"},
        ring2="Kishar Ring",
        waist="Luminary Sash",
		back="Altruistic Cape",
    })
	
    -- Enhancing
    sets.midcast.enhancing = set_combine(sets.midcast.casting,{
        ring1={name="Stikini Ring +1", bag="wardrobe4"},
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
    })
	
    -- Stoneskin
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing,{

    })
    sets.midcast.refresh = set_combine(sets.midcast.enhancing,{
    })
    sets.midcast.aquaveil = sets.midcast.refresh
	
	sets.midcast["Drain"] = set_combine(sets.midcast.IntEnfeebling, {
		main="Rubicundity",
		sub="Ammurapi Shield",
		Ranged="Dunna",
        head="Bagua Galero +3",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Geomancy Pants +3",
        feet="Jhakri Pigaches +2",
        neck="Erra Pendant",
        ear1="Hirudinea Earring",
		ear2="Azimuth Earring +1",
        ring1="Metamor. Ring +1",
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
        waist="Austerity Belt +1",
		back="Nantosuelta's Cape",
	})

	sets.midcast["Aspir"] = sets.midcast["Drain"]
     
    sets.midcast.cure = {} -- Leave This Empty
    -- Cure Potency
    sets.midcast.cure.normal = set_combine(sets.midcast.casting,{

    })
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{

    })    
    sets.midcast.regen = set_combine(sets.midcast.enhancing,{

    }) 
   
    ------------
    -- Aftercast
    ------------
      
    -- I don't use aftercast sets, as we handle what to equip later depending on conditions using a function, eg, do we have a Luopan pan out?
  
end

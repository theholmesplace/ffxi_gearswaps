
--[[
        Custom commands:
    
        Toggle Function: 
        gs c toggle melee               Toggle Melee mode on / off and locking of weapons
        gs c toggle mb                  Toggles Magic Burst Mode on / off.
        gs c toggle runspeed            Toggles locking on / off Herald's Gaiters
        gs c toggle idlemode            Toggles between Idle and DT idle mode. Activating Sublimation JA will auto replace refresh set for sublimation set. DT set will superceed both.        
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
        gs c nuke t6                    Cast tier 6 nuke of saved element
        gs c nuke ga1                   Cast tier 1 -ga nuke of saved element 
        gs c nuke ga2                   Cast tier 2 -ga nuke of saved element 
        gs c nuke ga3                   Cast tier 3 -ga nuke of saved element

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

-- Optional 
include('Treasurehider-Globals.lua') -- I list all my Augmented gears in a sidecar file since it's shared across many jobs. 

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
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
    windower.send_command('bind !f9 gs c toggle runspeed') 			-- Alt-F9 toggles locking on / off Herald's Gaiters
	windower.send_command('bind f10 gs c toggle mb')				-- F10 toggles Magic Burst Mode on / off.
    windower.send_command('bind !f10 gs c toggle nukemode')         -- Alt-F10 to change Nuking Mode
    windower.send_command('bind ^F10 gs c toggle matchsc')          -- CTRL-F10 to change Match SC Mode
    windower.send_command('bind !` input /ma Stun <t>')				-- Alt-` Quick Stun Shortcut.
    windower.send_command('bind f12 gs c toggle melee')				-- F12 Toggle Melee mode on / off and locking of weapons
	windower.send_command('bind f9 gs c toggle idlemode')			-- F9 Toggles between MasterRefresh or MasterDT when no luopan is out
    windower.send_command('bind !end gs c hud lite')				-- Alt-End to toggle light hud version   

--[[
    This gets passed in when the Keybinds is turned on.
    Each one matches to a given variable within the text object
    IF you changed the Default Keybind above, Edit the ones below so it can be reflected in the hud using "//gs c hud keybinds" command
]]
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_casting'] = '(ALT-F10)'
keybinds_on['key_bind_mburst'] = '(F10)'
keybinds_on['key_bind_matchsc'] = '(CTRL-F10)'

keybinds_on['key_bind_element_cycle'] = '(INS + DEL)'
keybinds_on['key_bind_lock_weapon'] = '(F12)'
keybinds_on['key_bind_movespeed_lock'] = '(ALT-F9)'


-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind insert')
    send_command('unbind delete')
    send_command('unbind home')
    send_command('unbind end')
    send_command('unbind !`')
    send_command('unbind f10')
    send_command('unbind f12')
    send_command('unbind f9')
    send_command('unbind !f9')
    send_command('unbind !end')
end

--------------------------------------------------------------------------------------------------------------
include('BLM_Lib.lua')          -- leave this as is
refreshType = idleModes[1]      -- leave this as is
--------------------------------------------------------------------------------------------------------------

-- Optional. Swap to your geo macro sheet / book
set_macros(1,14) -- Sheet, Book   
windower.send_command('wait 6;input /lockstyleset 182')

-- Setup your Gear Sets below:
function get_sets()

    -- My formatting is very easy to follow. All sets that pertain to my character doing things are under 'me'.
    -- All sets that are equipped to faciliate my.pan's behaviour or abilities are under .pan', eg, Perpetuation, Blood Pacts, etc

    -- JSE
    AF = {}         -- leave this empty
    RELIC = {}      -- leave this empty
    EMPY = {}       -- leave this empty


    --Spaekona's
    AF.Head		=	"Spae. Petasos +3"
    AF.Body		=	"Spaekona's Coat +3"
    AF.Hands	=	"Spae. Gloves +3"
    AF.Legs		=	"Spae. Tonban +3"
    AF.Feet		=	"Spae. Sabots +2"

    --Archmage's
    RELIC.Head		=	"Arch. Petasos +3"
    RELIC.Body		=	"Arch. Coat +3"
    RELIC.Hands 	=	"Arch. Gloves +3"
    RELIC.Legs		=	"Arch. Tonban +3"
    RELIC.Feet		=	"Arch. Sabots +3"

    --Wicce's
    EMPY.Head		=	"Wicce Petasos"
    EMPY.Body		=	"Wicce Coat"
    EMPY.Hands		=	"Wicce Gloves"
    EMPY.Legs		=	"Goetia's Chausses +2"
    EMPY.Feet		=	"Goet. Sabots +2"

    -- Capes:
    -- Toutatis's and such
    BLMCape = {}
	BLMCape.IDLE		=	{ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
	BLMCape.NUKE		=	{ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}

    sets.me = {}        		-- leave this empty
    sets.buff = {} 				-- leave this empty
    sets.me.idle = {}			-- leave this empty

    -- Your idle set
    sets.me.idle.normal = {
        main="Contemplator +1",
        sub="Mensch Strap +1",			--5/0
        ammo="Staunch Tathlum +1",		--3/3
        head="Volte Beret",
        body="Shamash Robe",			--10/0
        hands="Volte Gloves",
        legs="Volte Brais",
        feet="Herald's Gaiters",
        neck="Loricate Torque +1",		--6/6
        ear1="Odnowa Earring +1",		--3/5
        ear2="Etiolation Earring",		--0/3
        ring1={name="Stikini Ring +1", bag="wardrobe4"},
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
        back="Moonlight Cape",			--6/6
        waist="Platinum Moogle Belt"	--3/3
    }

    sets.me.idle.dt = set_combine(sets.me.idle.normal,{
        head="Nyame Helm",				--7/7
        hands="Nyame Gauntlets",		--7/7
        legs="Nyame Flanchard",			--7/7
        feet="Nyame Sollerets",
        ring1="Defending Ring"			--10/10
    })

	sets.me.idle.sublimation = set_combine(sets.me.idle.normal,{

    })

	-- Herald's Gaiters
	sets.me.movespeed = {feet="Herald's Gaiters"}

    -- Your MP Recovered Whilst Resting Set
    sets.me.resting = { 
		main="Contemplator +1",
    }
	
	sets.me.latent_refresh = {waist="Fucho-no-obi"}
	

    -- Combat Related Sets
      
    -- Melee
    -- Anything you equip here will overwrite the perpetuation/refresh in that slot.
	-- they end in [idleMode] so it will derive from either the normal or the dt set depending in which mode you are then add the pieces filled in below.
    sets.me.melee = {
		main="Maxentius",
		sub="Genmei shield",
		ammo="Staunch Tathlum +1",
        head="Blistering sallet +1",
        body="Volte Jupon",
        hands="Volte Bracers",
		legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Combatant's Torque",
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe5"},
        waist="Grunfeld Rope"
    }
    
    -- Weapon Skill sets
	sets.me["Myrkr"] = {
        main="Lathi",
		sub="Niobid Strap",
        ammo="Ghastly Tathlum +1",
        head="Amalric Coif +1",
        body="Spaekona's Coat +3",
        hands="Jhakri Cuffs +2",
        legs="Bagua Pants +3",
        feet="Bagua Sandals +3",
		back="Bane Cape",
        neck="Fotia Gorget",
        ear1="Regal Earring",
        ear2="Etiolation Earring",
        ring2="Karieyh Ring +1",
        waist="Fotia Belt",
    }

    sets.me["Gate of Tartarus"] = {
        main="Claustrum",
        sub="Enki Strap",
        ammo="Ghastly tathlum +1",
        head="Ea Hat +1",
        neck="Src. Stole +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Volte Brais",
        feet="Volte Gaiters",
        ear1="Regal Earring",
        ear2="Barkarole Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        back="Moonlight Cape",
        waist="Yamabuki-no-obi"
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
        ammo="Sapience Orb", --2
        head="Amalric Coif +1", --11
        body="Jhakri Robe +2", --2
        hands="Jhakri Cuffs +2", --2
        feet="Jhakri Pigaches +2", --1
        neck="Incanter's Torque",
        ear1="Etiolation Earring", --1
        ear2="Wicce Earring +2", --0
        ring1="Kishar Ring", --4
		ring2="Prolix Ring", --2
    }   

    -- Enhancing Magic, eg. Siegal Sash, etc
    sets.precast.enhancing = set_combine(sets.precast.casting,{
		waist="Siegel Sash"
    })

    -- Enfeebling Magic
    sets.precast.enfeebling = set_combine(sets.precast.casting,{
		neck="Sorcerer's Stole +2"
    })

    -- Elemental Magic
    sets.precast.elemental = set_combine(sets.precast.casting,{
		neck="Sorcerer's Stole +2",
		ear1="Barkarole earring",
        ear2="Wicce Earring +2"
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
    sets.precast["Manafont"] = {
    	body = "Archmage's Coat +3",
    }

    ----------
    -- Midcast
    ----------
            
    -- Whatever you want to equip mid-cast as a catch all for all spells, and we'll overwrite later for individual spells
    sets.midcast.casting = {

    }

    -- Just go make it, inventory will thank you and making rules for each is meh.
    sets.midcast.Obi = {
    	waist="Hachirin-no-Obi",
    }
	
	-- Nuking
    sets.midcast.nuking.normal = set_combine(sets.midcast.casting,{
		main="Septoptic +1",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
        head="Archmage's Petasos +3",
        body="Amalric Doublet +1",
        hands="Archmage's Gloves +3",
        legs="Archmage's Tonbon +3",
        feet="Spaekona's Sabots +2",
        neck="Incanter's Torque",
        ear1="Barkarole Earring",
        ear2="Wicce Earring +2",
        ring1="Freke Ring",
        ring2="Locus Ring",
        waist="Yamabuki-no-obi",
		back="Bane Cape",
    })
	sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {
		body="Ea Houppe. +1",
		legs="Ea Slops +1"
	})
    sets.midcast.nuking.acc = set_combine(sets.midcast.nuking.normal,{
        head="Spaekona's Petasos +3",
        body="Spaekona's Coat +3",
        hands="Spaekona's Gloves +3",
        legs="Spaekona's Tonbon +3",
        feet="Spaekona's Sabots +2",
    })
    sets.midcast.MB.acc = set_combine(sets.midcast.MB.normal, {

    })

	-- Enfeebling
	sets.midcast.IntEnfeebling = set_combine(sets.midcast.casting,{
		main="Gada",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
        head="Spaekona's Petasos +3",
        body="Spaekona's Coat +3",
        hands="Spaekona's Gloves +3",
        legs="Spaekona's Tonbon +3",
        feet="Spaekona's Sabots +2",
        neck="Incanter's Torque",
        ear1="Regal Earring",
        ear2="Barkarole Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe4"},
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
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
		ammo="Pemphredo Tathlum",
        head="Archmage's Petasos +3",
        body="Spaekona Coat +3",
        hands="Archmage's Gloves +3",
        legs="Spaekona's Tonbon +3",
        feet="Archmage's Sabots +3",
        neck="Erra Pendant",
        ear1="Hirudinea Earring",
        ear2="Wicce Earring +2",
        ring1="Archon Ring",
        ring2="Evanescance Ring",
        waist="Austerity Belt +1",
		back="Bane Cape",
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
  
end

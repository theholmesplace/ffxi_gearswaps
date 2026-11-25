--[[     
HB

//hb follow PERSON
//hb assist PERSON
//hb assist engage on
//hb buff Treasurehider Dread Spikes
//hb buff Treasurehider Endark II
//hb ws use Origin
//hb on

=== Features ===
If you want auto Reive detection for Ygnas Resolve+1, and Gavialis Helm for some of your WS, then you will need my User-Globals.lua
Otherwise, you might be able to get away without it.  (not tested)

If you don't use organizer, then remove the include('organizer-lib') in get_sets() and remove sets.Organizer

This lua has a few MODES you can toggle with hotkeys or macros, and there's a few situational RULES that activate without hotkeys

::MODES::

SouleaterMode 
Status: OFF by default.  this is old
Hotkey: Toggle this with @F9 (window key + F9). 
Macro: /console gs c togggle SouleaterMode

Notes: This mode makes it possible to use Souleater in situations where you would normally avoid using it. When SouleaterMode 
is ON, Souleater will be canceled automatically after the first Weaponskill used. CAVEAT -. If Bloodweapon 
is active, or if Drain's HP Boost buff is active, then Souleater will remain active until the next WS used after 
either buff wears off. 

CapacityMode
Status: OFF by default. 
Hotkey: with ALT + = 
Macro: /console cs c toggle CapacityMode

Notes: It will full-time whichever piece of gear you specify in sets.CapacityMantle 

Extra Info: You can change the default (true|false) status of any MODE by changing their values in job_setup()

::RULES::

Ygna's Resolve +1 
Status: enabled in Reive
Setting: n/a

Notes: Will automatically be used when you're in a reive. If you have my User-Globals.lua this will work
with all your jobs that use mote's includes. Not just this one! 

Moonshade earring
Status: Not used for WS's at 3000 TP. 
Setting: n/a

You can hit F12 to display custom MODE status as well as the default stuff. 

Single handed weapons are handled in the sets.engaged.SW set. (sword + shield, etc.)

::NOTES::

My sets have a specific order, or they will not function correctly. 
sets.engaged.[CombatForm][CombatWeapon][Offense or HybridMode][CustomMeleeGroups or CustomClass]

CombatForm = Haste, DW, SW
CombatWeapon = GreatSword, Scythe, Apocalypse, Ragnarok, Caladbolg, Liberator, Anguta
OffenseMode = Mid, Acc -- I got rid of this shit
HybridMode = PDT
CustomMeleeGroups = AM3, AM, Haste
CustomClass = OhShit 

CombatForm Haste is used when Last Resort + Hasso AND either Haste, March, Indi-Haste Geo-Haste is on you.

CombatForm DW will activate with /dnc or /nin AND a weapon listed in drk_sub_weapons equipped offhand. 
SW is active with an empty sub-slot, or a shield listed in the shields = S{} list.  

CombatWeapon GreatSword will activate when you equip a GS listed in gsList in job_setup(). 
CombatWeapon Scythe will activate when you equip a Scythe listed in scytheList in job_setup(). 
Weapons that do not fall into these groups, or have sets by weapon name, will use default sets.engaged

most gear sets derrive themselves from sets.engaged, so try to keep it updated. It's much smarter to derrive sets than to 
completely re-invent each gear set for every weapon. Let your gear inherit. Less code written means less errors. 

CustomMeleeGroups AM3 will activate when Aftermath lvl 3 is up, and CustomMeleeGroups AM will activate when relic Aftermath is up.
There are no empy AM sets for now.

--]]
--
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
end


-- Setup vars that are user-independent.
function job_setup()
    state.CapacityMode = M(false, 'Capacity Point Mantle')

    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')

    state.Buff.Souleater = buffactive.souleater or false
    state.Buff['Last Resort'] = buffactive['Last Resort'] or false
    -- Set the default to false if you'd rather SE always stay acitve
    state.SouleaterMode = M(true, 'Souleater Mode')
    state.SchereEarring = M(false, 'Schere Earring')
    -- Greatswords you use. 
    gsList = S{'Ragnarok', 'Caladbolg', 'Montante +1' }
    scytheList = S{'Foenaria', 'Liberator', 'Apocalypse', 'Anguta', 'Redemption' }
    remaWeapons = S{'Foenaria', 'Apocalypse', 'Anguta', 'Liberator', 'Caladbolg', 'Ragnarok', 'Redemption'}

    --shields = S{'Rinda Shield'}
    -- Mote has capitalization errors in the default Absorb mappings, so we use our own
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-ACC', 'Absorb-TP'}
    -- Offhand weapons used to activate DW mode
    swordList = S{"Naegling", "Sangarius +1", "Usonmunku", "Perun +1", "Tanmogayi"}

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)", "Maat's Cap",
              "Guide Beret", "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Tengu Shawl"}

    get_combat_form()
    get_combat_weapon()
    update_melee_groups()
end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal')--, 'Mid', 'Acc')
    state.HybridMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal')--, 'Mid', 'Acc')
    state.CastingMode:options('Normal')--, 'Acc')
    state.IdleMode:options('Normal')--, 'Sphere')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')
    state.MagicalDefenseMode:options('MDT')

    war_sj = player.sub_job == 'WAR' or false

    -- Additional local binds
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind @f9 gs c toggle SouleaterMode')
    send_command('bind !- gs equip sets.crafting')
    --send_command('bind ^` gs c toggle LastResortMode')

    state.Auto_Kite = M(false, 'Auto_Kite')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function file_unload()
    send_command('unbind ^`')
    send_command('unbind !=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind @f9')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    -- Optional 
    include('Treasurehider-Globals.lua') -- I list all my Augmented gears in a sidecar file since it's shared across many jobs. 

    -- JSE
    AF = {}         -- leave this empty
    RELIC = {}      -- leave this empty
    EMPY = {}       -- leave this empty

	-- Fill this with your own JSE. 
    --Ignominy
    AF.Head		=	"Ignominy Burgonet +3"
    AF.Body		=	"Ignominy Cuirass +4"
    AF.Hands	=	"Chaos Gauntlets +1"
    AF.Legs		=	"Ignominy Flanchard +4"
    AF.Feet		=	"Chaos Sollerets"

    --Fallen
    RELIC.Head		=	"Fallen's Burgeonet +3"
    RELIC.Body		=	"Fallen's Cuirass +3"
    RELIC.Hands 	=	"Fallen's Finger Gauntlets +4"
    RELIC.Legs		=	"Fallen's Flanchard +4"
    RELIC.Feet		=	"Fallen's Sollerets +4"

    --Heathen
    EMPY.Head		=	"Heathen's Burgeonet +3"
    EMPY.Body		=	"Heathen's Cuirass +3"
    EMPY.Hands		=	"Heathen's Gauntlets +3"
    EMPY.Legs		=	"Heathen's Flanchard +3"
    EMPY.Feet		=	"Heathen's Sollerets +3"
	EMPY.Ear2		=	"Heathen's Earring +1"

	-- Augmented gear
    Niht = {}
    Niht.DarkMagic = {name="Niht Mantle", augments={'Attack+12','Dark magic skill +9','"Drain" and "Aspir" potency +22','Weapon skill damage +4%'}}

    sets.TreasureHunter = { 
		ammo="Perfect lucky egg",
		head="Volte Cap",
		body="Volte Jupon",
		hands="Volte Bracers",
		legs="Volte Hose",
		feet="Volte Boots",
		waist="Chaac Belt",
     }
 
    sets.Organizer = {
        ear2="Reraise Earring",
        grip="Pearlsack",
        waist="Linkpearl",
        head="Caladbolg",
        hands="Liberator",
        feet="Apocalypse",
        back=Niht.DarkMagic,
    }

    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Diabolic Eye'] = {hands=RELIC.Hands}
    sets.precast.JA['Nether Void']  = {legs=EMPY.Legs}
    sets.precast.JA['Dark Seal']    = {head=RELIC.Head}
    sets.precast.JA['Souleater']    = {head=AF.Head}
    sets.precast.JA['Weapn Bash']   = {hands=AF.Hands}
    sets.precast.JA['Blood Weapon'] = {body=RELIC.Body}
    sets.precast.JA['Last Resort']  = {feet=RELIC.Feet,back=gear.DRK_WSD_Cape}
    sets.precast.JA['Jump'] = sets.Jump
    sets.precast.JA['High Jump'] = sets.Jump

    sets.Jump = { feet="Ostro Greaves" } -- Don't have

    sets.CapacityMantle  = { back="Mecistopins Mantle" }
    sets.WSDayBonus      = { head="Gavialis Helm" }
    sets.WSBack          = { back="Trepidity Mantle" }
    
    -- Earring considerations, given Lugra's day/night stats 
    sets.BrutalLugra     = { ear1="Brutal Earring", ear2="Lugra Earring +1" }
    sets.IshvaraLugra     = { ear1="Ishvara Earring", ear2="Lugra Earring +1" }
    sets.Lugra           = { ear1="Lugra Earring +1" }
    sets.Brutal          = { ear1="Brutal Earring" }
    sets.Ishvara         = { ear1="Ishvara Earring" }

    -- Waltz set (chr and vit) 
    sets.precast.Waltz = {
        legs="Dashing Subligar"
    }

    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Sapience Orb",
        head="Sapkata's Helm",
        body=RELIC.Body,
        ear1="Loquacious Earring", -- don't have
        ear2="Malignance Earring", -- don't have
        hands="Leyline Gloves",
        ring1="Kishar Ring",
        ring2="Weatherspoon Ring", -- don't have
        legs="Eschite Cuisses", -- don't have
        back=gear.DRK_FC_Cape, -- don't have
        feet="Odyssean Greaves"
    }

    -- Midcast Sets
    sets.midcast.FastRecast = {}
    sets.midcast.Trust =  {}
    sets.midcast["Apururu (UC)"] = set_combine(sets.midcast.Trust, {
        body="Apururu Unity shirt",
    })

    -- Specific spells
    sets.midcast.Utsusemi = {}

    sets.midcast['Dark Magic'] = {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2=EMPY.Ear2,
        body=EMPY.Body,
        hands=EMPY.Hands,
        ring1="Stikini Ring +1",
        ring2="Metamorph Ring +1",
        back=Niht.DarkMagic,
        waist="Eschan Stone",
        legs=EMPY.Legs,
        feet=EMPY.Feet
    }
    sets.midcast.Endark = set_combine(sets.midcast['Dark Magic'], {
        head=AF.Head,
        ear1="Mani Earring",
        ear2="Dark Earring",
        hands=RELIC.Hands,
        ring2="Evanescence Ring",
        waist="Casso Sash",
        feet="Ratri Sollerets +1"
    })

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Dark Magic'], {
        ring1="Kishar Ring"
    })

    sets.midcast['Elemental Magic'] = {
        neck="Sanctity Necklace",
        ear2="Friomisi Earring",
        body=RELIC.Body,
        hands=RELIC.Hands,
        ring1="Resonance Ring", -- don't have
        back="Aput Mantle", -- don't have - will keep Niht
        waist="Orpheus's Sash",
        legs="Nyame Flanchard"
    }

    -- Mix of HP boost, -Spell interruption%, and Dark Skill
    sets.midcast['Dread Spikes'] = set_combine(sets.midcast['Dark Magic'], {
        ammo="Egoist's Tathlum", -- don't have
        neck="Unmoving collar +1",
        head="Ratri Sallet +1",
        body=EMPY.Body,
        hands="Ratri Gadlings +1",
        legs="Ratri Cuisses +1",
        feet="Ratri Sollerets +1",
        back="Moonlight cape",
        waist="Platinum moogle belt",
        ear1="Odnowa earring +1",
        ear2="Tuisto earring",
        ring1="Moonlight ring",
        ring2="Gelatinous ring +1",
    })

    -- Drain spells 
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head=RELIC.Head,
        neck="Erra Pendant",
        ear1="Hirudinea Earring",
        hands=RELIC.Hands,
        ring1="Archon Ring",
        ring2="Evanescence Ring",
        back=Niht.DarkMagic,
        waist="Orpheus's Sash",
        legs=EMPY.Legs,
        feet=EMPY.Feet
    })
    sets.midcast.Aspir = sets.midcast.Drain

    -- Absorbs
    sets.midcast.Absorb = set_combine(sets.midcast.Endark, {
        back="Chuparrosa Mantle",
        hands="Pavor Gauntlets"
    })

    sets.midcast['Absorb-TP'] = set_combine(sets.midcast.Absorb, {})

    sets.midcast['Blue Magic'] = set_combine(sets.midcast['Dark Magic'], {})
    -- Ranged for xbow
    sets.precast.RA = {
        hands="Carmine Finger Gauntlets +1"
    }
    sets.midcast.RA = {
        ear2="Tripudio Earring",
        ring1="Cacoethic Ring +1",
        waist="Chaac Belt",
    }

    ------------------------
    --- WEAPONSKILL SETS ---
    ------------------------
    sets.precast.WS = {
        ammo="Knobkierrie",
        head=EMPY.Head,
        neck="Abyssal Bead Necklace +2",
        ear1="Moonshade Earring",
        ear2=EMPY.Ear2,
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        ring1="Sroda Ring",
        ring2="Epaminondas's Ring",
        back=gear.DRK_WSD_Cape,
        waist="Sailfi Belt +1",
        legs=RELIC.Legs,
        feet=EMPY.Feet
    }

    --* GREAT SWORD *--

    -- Resolution
    -- 73-85% STR - 5-hit WS
    sets.precast.WS.Resolution = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        ring2="Niqmaddu Ring",
        back=gear.DRK_DA_Cape,
        waist="Fotia Belt",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings"
    })

    -- Torcleaver 
    -- VIT 80% - Single Hit
    sets.precast.WS.Torcleaver = set_combine(sets.precast.WS, {
        waist="Fotia Belt",
        back=gear.DRK_VIT_Cape
    })

    -- Fimbulvetr 
    -- STR 60% / VIT 60% - Single Hit
    sets.precast.WS.Fimbulvetr = set_combine(sets.precast.WS, {
        body=AF.Body,
        Legs=RELIC.Legs
    })

    --* SCYTHE *--

    -- Cross Reaper
    -- 60% STR / 60% MND - 2-hit WS
    sets.precast.WS['Cross Reaper'] = set_combine(sets.precast.WS, {})

    -- Quietus
    -- 60% STR / MND 
    sets.precast.WS.Quietus = set_combine(sets.precast.WS, {
        ear1="Thrud Earring",
        waist="Fotia Belt"
    })

    -- Shadow of Death
    -- 	40% STR / 40% INT - Darkness Elemental
    sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS, {
        head="Pixie Hairpin +1",
        neck="Sanctity Necklace",
        ear1="Moonshade Earring",
        ear2="Friomisi Earring",
        body=RELIC.Body,
        hands=RELIC.Hands,
        ring1="Archon Ring",
        ring2="Metamorph Ring +1",
        back="Argochampsa Mantle",
        waist="Eschan Stone",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets"
    })

    -- Dark Harvest
    -- 40% STR / 40% INT - Darkness Elemental
    sets.precast.WS['Dark Harvest'] = sets.precast.WS['Shadow of Death']

    -- Spiral Hell
    -- 50% STR / 50% INT - Single Hit
    sets.precast.WS['Spiral Hell'] = sets.precast.WS['Shadow of Death']

    -- Infernal Scythe
    -- 70% INT / 30% STR - Darkness Elemental
    sets.precast.WS['Infernal Scythe'] = sets.precast.WS['Shadow of Death']

    -- Insurgency
    -- 20% STR / 20% INT - 4-hit WS
    -- Base set only used at 3000TP to put AM3 up
    sets.precast.WS.Insurgency = set_combine(sets.precast.WS, {
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses"
    })

    -- Catastrophe
    -- 40% STR / 40% INT - Single Hit
    sets.precast.WS.Catastrophe = set_combine(sets.precast.WS, {
        ear1="Thrud Earring",
        waist="Fotia Belt"
    })

    -- Origin
    -- 60% STR / 60% INT - Single Hit
    sets.precast.WS.Origin = set_combine(sets.precast.WS, {
        body=AF.Body
    })

    -- Entropy
    -- 73~85% INT - 4-hit WS
    sets.precast.WS.Entropy = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        ring1="Niqmaddu Ring",
        ring2="Metamorph Ring +1",
        back=gear.DRK_DA_Cape,
        waist="Fotia Belt",
        legs="Sakpata's Cuisses",
        feet="Nyame Sollerets"
    })

    --* SWORD *--

    -- Sanguine Blade
    -- 50% MND / 50% STR - Darkness Elemental
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
    	sub="Blurred Shield +1",
        head="Pixie Hairpin +1",
        neck="Sanctity Necklace",
        ear1="Malignance Earring",
        ear2="Friomisi Earring",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        ring1="Archon Ring",
        back=gear.DRK_WSD_Cape,
        waist="Orpheus's Sash",
        legs="Nyame Flanchard"
    })

    -- Requiescat
    -- 73~85% MND - 5-hit WS
    sets.precast.WS.Requiescat = set_combine(sets.precast.WS, {})

    -- Savage Blade
    -- 50% STR / 50% MND - 2-hit WS
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		sub="Blurred Shield +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Cuisses"
    })

    --* CLUB *--

    -- Judgment
    -- 50% STR / 50% MND - Single Hit
    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS, {
		sub="Blurred Shield +1",
		body=AF.Body,
    })

    -- Idle sets
    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        neck="Sanctity Necklace",
        ear1="Infused Earring",
        ear2="Alabaster Earring",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        ring1="Chirich Ring +1",
        ring2="Murky Ring",
        back="Solemnity Cape",
        waist="Gishdubar Sash",
        legs="Carmine Cuisses +1",
        feet="Sakpata's Leggings"
    }
    sets.idle.Town = set_combine(sets.idle, {})

    sets.idle.Sphere = set_combine(sets.idle, { body="Makora Meikogai"  })

    -- Defense sets
    sets.defense.PDT = {
        ammo="Seehing Bomblet +1",
        neck="Abyssal Bead Necklace +2",
        head="Sakpata's Helm", -- no haste
        body="Sakpata's Plate", -- 3% haste
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses", -- 5% haste
        feet="Sakpata's Leggings", -- 3% haste
        ring1="Niqmaddu Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe5"},
        waist="Sailfi Belt +1", -- 9% haste
    }
    sets.defense.MDT = set_combine(sets.defense.PDT, {})

    sets.idle.Weak = set_combine(sets.defense.PDT, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Volte Moufles",
        ring1="Paguroidea Ring",
        ring2="Murky Ring",
        back=gear.DRK_STP_Cape,
        waist="Platinum moogle belt",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets"
    })
    sets.defense.Reraise = sets.idle.Weak

    sets.Kiting = {
        legs="Carmine Cuisses +1",
    }

    sets.Reraise = {head="Crepuscular mail",body="Crepuscular helm"}

    -- Defensive sets to combine with various weapon-specific sets below
    -- These allow hybrid acc/pdt sets for difficult content
    -- do not specify a cape so that DA/STP capes are used appropriately
    sets.Defensive = {
        head="Sakpata's Helm",      -- 7% dt
        body="Sakpata's Plate",     -- 10% dt
        hands="Sakpata's Gauntlets",-- 8% dt
        legs="Sakpata's Cuisses",   -- 9% dt
        feet="Sakpata's Leggings",  -- 6% dt
        ring2="Murky Ring"          -- 10% dt
                                    -- = 50%
    }

    -- Base set (global catch-all set)
    sets.engaged = {
        sub="Utu Grip",
        ammo="Coiste Bodhar",
        head="Flamma Zucchetto +2",
        neck="Abyssal Bead Necklace +2",
        ear1="Brutal Earring",
        ear2="Cessance Earring",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        ring1="Niqmaddu Ring",
        ring2="Petrov Ring",
        back=gear.DRK_DA_Cape,
        waist="Ioskeha Belt +1",
        legs=AF.Legs,
        feet="Flamma Gambieras +2"
    }

    -- These only apply when delay is capped.
    sets.engaged.Haste = set_combine(sets.engaged, {
        waist="Sailfi Belt +1",
    })

    -- Hybrid
    sets.engaged.PDT = set_combine(sets.engaged, sets.Defensive)

    -- Hybrid with capped delay
    sets.engaged.Haste.PDT = set_combine(sets.engaged.PDT, sets.DefensiveHigh)

    -- Liberator
    sets.engaged.Liberator = set_combine(sets.engaged, {
    })

    -- Liberator AM3
    sets.engaged.Liberator.AM3 = set_combine(sets.engaged.Liberator, {
        ammo="Aurgelmir Orb +1",
        body="Hjarrandi Breastplate",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2="Moonlight Ring",
        ear1="Dedition Earring",
        back=gear.DRK_STP_Cape,
        waist="Sailfi Belt +1",
        legs="Volte Tights",
        feet="Carmine Greaves +1"
    })

    sets.engaged.Haste.Liberator = set_combine(sets.engaged.Liberator, {
        waist="Sailfi Belt +1",
    })

    sets.engaged.Haste.Liberator.AM3 = set_combine(sets.engaged.Liberator.AM3, {
        waist="Windbuffet Belt +1"
    })

    -- Hybrid
    sets.engaged.Liberator.PDT = set_combine(sets.engaged.Liberator, {
        ring1="Murky Ring",
        legs=EMPY.Legs
    })

    sets.engaged.Liberator.PDT.AM3 = set_combine(sets.engaged.Liberator.AM3, sets.Defensive)
    -- Hybrid with capped delay
    sets.engaged.Haste.Liberator.PDT = set_combine(sets.engaged.Liberator.PDT, sets.DefensiveHigh)
    -- Hybrid with capped delay + AM3 up
    sets.engaged.Haste.Liberator.PDT.AM3 = set_combine(sets.engaged.Liberator.PDT.AM3, sets.Defensive)

    -- Apocalypse
    sets.engaged.Apocalypse = set_combine(sets.engaged, {})

    
    -- sets.engaged.Apocalypse.AM = set_combine(sets.engaged.Apocalypse, {})

    sets.engaged.Haste.Apocalypse = set_combine(sets.engaged.Apocalypse, {
        waist="Sailfi Belt +1",
    })

    -- Hybrid
    sets.engaged.Apocalypse.PDT = set_combine(sets.engaged.Apocalypse, {})
    -- Hybrid with relic AM 
    -- sets.engaged.Apocalypse.PDT.AM = set_combine(sets.engaged.Apocalypse, sets.Defensive)
    -- Hybrid with capped delay
    sets.engaged.Haste.Apocalypse.PDT = set_combine(sets.engaged.Apocalypse.PDT, sets.DefensiveHigh)
    -- Hybrid with capped delay + AM3 up
    -- sets.engaged.Haste.Apocalypse.PDT.AM3 = set_combine(sets.engaged.Apocalypse.PDT.AM3, sets.DefensiveHigh)

    -- generic scythe
    sets.engaged.Scythe = set_combine(sets.engaged, {})

    sets.engaged.Scythe.PDT = set_combine(sets.engaged.Scythe, sets.Defensive)

    sets.engaged.Haste.Scythe = set_combine(sets.engaged.Haste, {})

    sets.engaged.Haste.Scythe.PDT = set_combine(sets.engaged.Scythe.PDT, sets.DefensiveHigh)

    -- generic great sword
    sets.engaged.GreatSword = set_combine(sets.engaged, {
    })

    sets.engaged.GreatSword.PDT = set_combine(sets.engaged.GreatSword, sets.Defensive)

    sets.engaged.Haste.GreatSword = set_combine(sets.engaged.Haste, {})

    sets.engaged.Haste.GreatSword.PDT = set_combine(sets.engaged.GreatSword.PDT, sets.DefensiveHigh)

    -- Ragnarok
    sets.engaged.Ragnarok = set_combine(sets.engaged.GreatSword, {})
    
    sets.engaged.Ragnarok.PDT = set_combine(sets.engaged.Ragnarok, sets.Defensive)
    
    -- Caladbolg
    sets.engaged.Caladbolg = set_combine(sets.engaged.GreatSword, {})

    sets.engaged.Caladbolg.PDT = set_combine(sets.engaged.Caladbolg, sets.Defensive)
    
    sets.engaged.Haste.Caladbolg = set_combine(sets.engaged.Caladbolg, { 
        waist="Windbuffet Belt +1"
    })

    sets.engaged.Haste.Caladbolg.PDT = set_combine(sets.engaged.Caladbolg.PDT, sets.DefensiveHigh)
    
    -- dual wield
    sets.engaged.DW = set_combine(sets.engaged, {
        ear1="Eabani Earring",
        ear2="Suppanomimi",
        hands="Emicho Gauntlets",
        waist="Patentia Sash",
        legs="Carmine Cuisses +1",
    })

    -- single wield (sword + shield possibly)
    sets.engaged.SW = set_combine(sets.engaged, {
        ammo="Yetshila",
    })

    sets.engaged.Reraise = set_combine(sets.engaged, {
        head="Nyame Helm",
        neck="Twilight Torque",
        body="Nyame Mail"
    })

    sets.buff.Souleater = { 
        head=AF.Head,
    }
    sets.MadrigalBonus = {
        hands="Composer's Mitts"
    }
    sets.buff['Last Resort'] = { 
         feet=RELIC.Feet 
    }

    sets.SchereEarring = {ear2="Schere Earring"}
end

function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    aw_custom_aftermath_timers_precast(spell)
end

function job_post_precast(spell, action, spellMap, eventArgs)
    local recast = windower.ffxi.get_ability_recasts()
    -- Make sure abilities using head gear don't swap 
    if spell.type:lower() == 'weaponskill' then
        -- handle Gavialis Helm
        -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end

        -- if spell.english == 'Entropy' and recast[95] == 0 then
        --     eventArgs.cancel = true
        --     send_command('@wait 4.0;input /ja "Consume Mana" <me>')
        --     --windower.chat.input:schedule(1, '/ws "Entropy" <t>')
        --     return
        -- end
        -- if spell.english == 'Insurgency' then
        --     if world.time >= (17*60) or world.time <= (7*60) then
        --         equip(sets.Lugra)
        --     end
        -- end

    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english:startswith('Drain') then
        if player.status == 'Engaged' and state.CastingMode.current == 'Normal' and player.hpp < 70 then
            classes.CustomClass = 'OhShit'
        end
    end

    if (state.HybridMode.current == 'PDT' and state.PhysicalDefenseMode.current == 'Reraise') then
        equip(sets.Reraise)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    aw_custom_aftermath_timers_aftercast(spell)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english]
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        --add_to_chat(8, '-WS USED- > SE ACTIVE: ' .. tostring(state.Buff.Souleater) .. ' SE MODE: ' .. tostring(state.SouleaterMode.value))
        if state.Buff.Souleater and state.SouleaterMode.value then
            add_to_chat(8, '------------CANCELLING SOULEATER-------------')
            send_command('@wait 1.0;cancel souleater')
            --enable("head")
        end
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
    check_gear()
    check_moving()
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.hpp < 50 then
        idleSet = set_combine(idleSet, sets.idle.Regen)
    elseif player.mpp < 50 then
        idleSet = set_combine(idleSet, sets.idle.Refresh)
    end
    if state.IdleMode.current == 'Sphere' then
        idleSet = set_combine(idleSet, sets.idle.Sphere)
    end
    -- if state.HybridMode.current == 'PDT' then
    --     idleSet = set_combine(idleSet, sets.defense.PDT)
    -- end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if state.Buff['Souleater'] then
        meleeSet = set_combine(meleeSet, sets.buff.Souleater)
    end
    if state.SchereEarring.value then
        meleeSet = set_combine(meleeSet, sets.SchereEarring)
    end
    return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == "Engaged" then
        if player.sub_job == 'SAM'  and not midaction() then
            send_command('@wait 1.0;input /ja "Hasso" <me>')
        end
        if player.sub_job == 'WAR'  and not midaction() then
            send_command('@wait 1.0;input /ja "Berserk" <me>')
        end

        -- handle weapon sets
        if remaWeapons:contains(player.equipment.main) then
            state.CombatWeapon:set(player.equipment.main)
        end
        -- if gsList:contains(player.equipment.main) then
        --     state.CombatWeapon:set("GreatSword")
        -- elseif scytheList:contains(player.equipment.main) then
        --     state.CombatWeapon:set("Scythe")
        -- elseif remaWeapons:contains(player.equipment.main) then
        --     state.CombatWeapon:set(player.equipment.main)
        -- else -- use regular set, which caters to Liberator
        --     state.CombatWeapon:reset()
        -- end
        --elseif newStatus == 'Idle' then
        --    determine_idle_group()
    end
end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)

    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end

    if S{'madrigal'}:contains(buff:lower()) then
        if buffactive.madrigal and state.OffenseMode.value == 'Acc' then
            equip(sets.MadrigalBonus)
        end
    end
    if S{'haste', 'march', 'embrava', 'geo-haste', 'indi-haste', 'last resort'}:contains(buff:lower()) then
        if (buffactive['Last Resort']) then
            if (buffactive.embrava or buffactive.haste) and buffactive.march then
                state.CombatForm:set("Haste")
                if not midaction() then
                    handle_equipping_gear(player.status)
                end
            end
        else
            if state.CombatForm.current ~= 'DW' and state.CombatForm.current ~= 'SW' then
                state.CombatForm:reset()
            end
            if not midaction() then
                handle_equipping_gear(player.status)
            end
        end
    end
    -- Drain II/III HP Boost. Set SE to stay on.
    if buff == "Max HP Boost" and state.SouleaterMode.value then
        if gain or buffactive['Max HP Boost'] then
            state.SouleaterMode:set(false)
        else
            state.SouleaterMode:set(true)
        end
    end
    -- Make sure SE stays on for BW
    if buff == 'Blood Weapon' and state.SouleaterMode.value then
        if gain or buffactive['Blood Weapon'] then
            state.SouleaterMode:set(false)
        else
            state.SouleaterMode:set(true)
        end
    end
    -- AM custom groups
    if buff:startswith('Aftermath') then
        if player.equipment.main == 'Liberator' then
            classes.CustomMeleeGroups:clear()

            if (buff == "Aftermath: Lv.3" and gain) or buffactive['Aftermath: Lv.3'] then
                classes.CustomMeleeGroups:append('AM3')
                add_to_chat(8, '-------------Mythic AM3 UP-------------')
            -- elseif (buff == "Aftermath: Lv.3" and not gain) then
            --     add_to_chat(8, '-------------Mythic AM3 DOWN-------------')
            end

            if not midaction() then
                handle_equipping_gear(player.status)
            end
        else
            classes.CustomMeleeGroups:clear()

            if buff == "Aftermath" and gain or buffactive.Aftermath then
                classes.CustomMeleeGroups:append('AM')
            end

            if not midaction() then
                handle_equipping_gear(player.status)
            end
        end
    end
    
    -- if  buff == "Samurai Roll" then
    --     classes.CustomRangedGroups:clear()
    --     if (buff == "Samurai Roll" and gain) or buffactive['Samurai Roll'] then
    --         classes.CustomRangedGroups:append('SamRoll')
    --     end
       
    -- end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('neck','ring1','ring2','waist')
        else
            enable('neck','ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    war_sj = player.sub_job == 'WAR' or false
    get_combat_form()
    get_combat_weapon()
    update_melee_groups()
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
--function th_action_check(category, param)
--    if category == 2 or -- any ranged attack
--        --category == 4 or -- any magic action
--        (category == 3 and param == 30) or -- Aeolian Edge
--        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
--        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
--        then 
--            return true
--    end
--end
-- function get_custom_wsmode(spell, spellMap, default_wsmode)
--     if state.OffenseMode.current == 'Mid' then
--         if buffactive['Aftermath: Lv.3'] then
--             return 'AM3Mid'
--         end
--     elseif state.OffenseMode.current == 'Acc' then
--         if buffactive['Aftermath: Lv.3'] then
--             return 'AM3Acc'
--         end
--     else
--         if buffactive['Aftermath: Lv.3'] then
--             return 'AM3'
--         end
--     end
-- end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function get_combat_form()

    if S{'NIN', 'DNC'}:contains(player.sub_job) and swordList:contains(player.equipment.main) then
        state.CombatForm:set("DW")
    --elseif player.equipment.sub == '' or shields:contains(player.equipment.sub) then
    elseif swordList:contains(player.equipment.main) then
        state.CombatForm:set("SW")
    elseif buffactive['Last Resort'] then
        if (buffactive.embrava or buffactive.haste) and buffactive.march then
            add_to_chat(8, '-------------Delay Capped-------------')
            state.CombatForm:set("Haste")
        else
            state.CombatForm:reset()
        end
    else
        state.CombatForm:reset()
    end
end

function get_combat_weapon()
    state.CombatWeapon:reset()
    if remaWeapons:contains(player.equipment.main) then
        state.CombatWeapon:set(player.equipment.main)
    end
    -- if remaWeapons:contains(player.equipment.main) then
    --     state.CombatWeapon:set(player.equipment.main)
    -- elseif gsList:contains(player.equipment.main) then
    --     state.CombatWeapon:set("GreatSword")
    -- elseif scytheList:contains(player.equipment.main) then
    --     state.CombatWeapon:set("Scythe")
    -- end
end

function aw_custom_aftermath_timers_precast(spell)
    if spell.type == 'WeaponSkill' then
        info.aftermath = {}

        local mythic_ws = "Insurgency"

        info.aftermath.weaponskill = mythic_ws
        info.aftermath.duration = 0

        info.aftermath.level = math.floor(player.tp / 1000)
        if info.aftermath.level == 0 then
            info.aftermath.level = 1
        end

        if spell.english == mythic_ws and player.equipment.main == 'Liberator' then
            -- nothing can overwrite lvl 3
            if buffactive['Aftermath: Lv.3'] then
                return
            end
            -- only lvl 3 can overwrite lvl 2
            if info.aftermath.level ~= 3 and buffactive['Aftermath: Lv.2'] then
                return
            end

            if info.aftermath.level == 1 then
                info.aftermath.duration = 90
            elseif info.aftermath.level == 2 then
                info.aftermath.duration = 120
            else
                info.aftermath.duration = 180
            end
        end
    end
end

-- Call from job_aftercast() to create the custom aftermath timer.
function aw_custom_aftermath_timers_aftercast(spell)
    if not spell.interrupted and spell.type == 'WeaponSkill' and
        info.aftermath and info.aftermath.weaponskill == spell.english and info.aftermath.duration > 0 then

        local aftermath_name = 'Aftermath: Lv.'..tostring(info.aftermath.level)
        send_command('timers d "Aftermath: Lv.1"')
        send_command('timers d "Aftermath: Lv.2"')
        send_command('timers d "Aftermath: Lv.3"')
        send_command('timers c "'..aftermath_name..'" '..tostring(info.aftermath.duration)..' down abilities/aftermath'..tostring(info.aftermath.level)..'.png')

        info.aftermath = {}
    end
end

function display_current_job_state(eventArgs)
    local msg = ''
    msg = msg .. 'Offense: '..state.OffenseMode.current
    msg = msg .. ', Hybrid: '..state.HybridMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    if state.CombatForm.current ~= '' then 
        msg = msg .. ', Form: ' .. state.CombatForm.current 
    end
    if state.CombatWeapon.current ~= '' then 
        msg = msg .. ', Weapon: ' .. state.CombatWeapon.current 
    end
    if state.CapacityMode.value then
        msg = msg .. ', Capacity: ON, '
    end
    if state.SouleaterMode.value then
        msg = msg .. ', SE Cancel, '
    end
    if state.SchereEarring.value then
        msg = msg .. ', Schere: ON'
    end
    -- if state.LastResortMode.value then
    --     msg = msg .. ', LR Defense, '
    -- end
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end
    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(123, msg)
    eventArgs.handled = true
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
end

-- Creating a custom spellMap, since Mote capitalized absorbs incorrectly
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Dark Magic' and absorbs:contains(spell.english) then
        return 'Absorb'
    end
    -- if spell.type == 'Trust' then
    --     return 'Trust'
    -- end
end

function update_melee_groups()

    classes.CustomMeleeGroups:clear()
    -- mythic AM	
    if player.equipment.main == 'Liberator' then
        if buffactive['Aftermath: Lv.3'] then
            classes.CustomMeleeGroups:append('AM3')
        end
    else
        -- relic AM
        if buffactive['Aftermath'] then
            classes.CustomMeleeGroups:append('AM')
        end
        -- if buffactive['Samurai Roll'] then
        --     classes.CustomRangedGroups:append('SamRoll')
        -- end
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

function select_default_macro_book()
    -- Default macro set/book
    if scytheList:contains(player.equipment.main) then
        set_macro_page(1, 5)
    elseif gsList:contains(player.equipment.main) then
        set_macro_page(1, 5)
    elseif player.sub_job == 'SAM' then
        set_macro_page(1, 5)
    else
        set_macro_page(1, 5)
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')

    -- Optional 
    include('Treasurehider-Globals.lua') -- I list all my Augmented gears in a sidecar file since it's shared across many jobs.
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Sentinel = buffactive.sentinel or false
    state.Buff.Cover = buffactive.cover or false
    state.Buff.Doom = buffactive.Doom or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Mid', 'DW')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'HP', 'Reraise', 'Charm')
    state.MagicalDefenseMode:options('MDT', 'HP', 'Reraise', 'Charm')

    state.ExtraDefenseMode = M{['description']='Extra Defense Mode', 'None', 'MP', 'Knockback', 'MP_Knockback'}
    state.EquipShield = M(true, 'Equip Shield w/Defense')

    update_defense_mode()

    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
    send_command('bind @f10 gs c toggle EquipShield')
    send_command('bind @f11 gs c toggle EquipShield')

    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = {legs="Caballarius Breeches +3"}
    sets.precast.JA['Holy Circle'] = {feet="Reverence Leggings +1"}
    sets.precast.JA['Shield Bash'] = {hands="Caballarius Gauntlets +3",ear2="Knightly Earring",ring1="Fenian Ring"}
    sets.precast.JA['Sentinel'] = {feet="Caballarius Leggings +3"}
	
    sets.precast.JA['Rampart'] = {
		ammo="Iron Gobbet",
	    head={ name="Cab. Coronet +3", augments={'Enhances "Iron Will" effect',}},
	    body="Hjarrandi Breast.",
	    hands={ name="Cab. Gauntlets +3", augments={'Enhances "Chivalry" effect',}},
	    legs="Sulev. Cuisses +2",
	    feet="Amm Greaves",
	    neck="Unmoving Collar +1",
	    waist="Latria Sash",
	    left_ear="Tuisto Earring",
	    right_ear="Handler's Earring +1",
	    left_ring="Regal Ring",
	    right_ring="Gelatinous Ring +1",
	    back="Weard Mantle",
	}
    sets.precast.JA['Fealty'] = {body="Caballarius Surcoat +3"}
    sets.precast.JA['Divine Emblem'] = {feet="Chevalier's sabatons +1"}
    sets.precast.JA['Cover'] = {head="Reverence Coronet +1"}
	
	sets.precast.JA['Provoke'] = {
		sub="Srivatsa",
		ammo="Sapience Orb",
        head="Loess Barbuta +1",
		neck="Moonlight Necklace",
        body="Reverence Surcoat +3",
		hands="Souv. Handsch. +1",
		ring1="Petrov Ring",
		ring2="Eihwaz Ring",
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Emnity+10','Occ. inc. resist. to stat. ailments+10'}},
		waist="Creed Baudrier",
		legs="Souv. Diechlings +1",
		feet="Souveran Schuhs +1"
		}
    

    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
        head="Caballarius Coronet +3",
        body="Reverence Surcoat +3",
		hands="Caballarius Gauntlets +3",
		ring1="Globidonta Ring",
        legs="Sulevia's Cuisses +2",
		feet="Caballarius Leggings +3"
		}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Reverence Coronet +1",
        body="Gorney Haubert +1",hands="Reverence Gauntlets +1",ring2="Asklepian Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Reverence Breeches +1",feet="Whirlpool Greaves"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {
	    body="Rev. Surcoat +3",
	    hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
	    right_ring="Kishar Ring",
		right_ear="Etiolation earring",
		Feet={ name="Odyssean Greaves", augments={'MND+1','Accuracy+12 Attack+12','Spell interruption rate down 11%',}},
	    back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','DEX+10','"Fast Cast"+10','Spell interruption rate down 10%',}},
	}
	
    --sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		ammo="Aurgelmir Orb +1",
	    head="Hjarrandi Helm",
	    body="Hjarrandi Breast.",
	    hands="Sulev. Gauntlets +2",
	    legs="Odyssean Cuisses",
	    feet="Sulev. Leggings +2",
	    neck="Fotia Gorget",
	    waist="Fotia Belt",
	    left_ear="Thrud Earring",
	    right_ear="Lugra Earring +1",
	    left_ring="Karieyh's Ring +1",
	    right_ring="Apate Ring",
	    back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
		}

    sets.precast.WS.Acc = {}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {ring1="Leviathan Ring",ring2="Aquasoul Ring"})
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS.Acc, {ring1="Leviathan Ring"})
	
    sets.precast.WS['Knights of Round'] = {
		ammo="Ginsen",
	    head="Hjarrandi Helm",
	    body="Hjarrandi Breast.",
	    hands="Valorous Mitts",
	    legs="Odyssean Cuisses",
	    feet="Sulev. Leggings +2",
	    neck="Knight's Bead Necklace +2",
	    waist="Sailfi Belt +1",
	    left_ear="Thrud Earring",
	    right_ear="Lugra Earring +1",
	    left_ring="Karieyh's Ring +1",
	    right_ring="Apate Ring",
	    back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
		}

	sets.precast.WS['Chant du Cygne'] = {
		ammo="Jukukik Feather",
	    head="Flamma Zucchetto +2",
	    body="Hjarrandi Breast.",
	    hands="Flamma Manopolas +2",
	    legs="Flamma Dirs +2",
	    feet="Flamma Gambieras +2",
	    neck="Fotia Gorget",
	    waist="Fotia Belt",
	    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
	    right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
	    left_ring="Apate Ring",
	    right_ring="Hetairoi Ring",
	    back={ name="Rudianos's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Double Attack"+10',}},
		}
    
	sets.precast.WS['Hexa Strike'] = sets.precast.WS['Chant du Cygne']
	
	sets.precast.WS['Savage Blade'] = {
		ammo="Floestone",
	    head={ name="Odyssean Helm", augments={'STR+10','MND+3','Weapon skill damage +8%','Accuracy+16 Attack+16',}},
	    body="Rev. Surcoat +3",
	    hands={ name="Odyssean Gauntlets", augments={'DEX+3','Accuracy+8','Attack+18','Weapon skill damage +4%',}},
	    legs="Souv. Diechlings +1",
	    feet="Sulev. Leggings +2",
	    neck="Fotia Gorget",
	    waist="Metalsinger Belt",
	    right_ear="Thrud Earring",
	    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
	    right_ring="Karieyh's Ring +1",
	    left_ring="Regal Ring",
	    back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	}
		
	sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
   
    })	
		
	sets.precast.WS['Impulse Drive'] = {
		ammo="Aurgelmir Orb +1",
	    head="Blistering Sallet +1",
	    body="Hjarrandi Breast.",
	    hands="Flamma Manopolas +2",
	    legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
	    feet="Thereoid Greaves",
	    neck="Fotia Gorget",
	    waist="Fotia Belt",
	    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
	    right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
	    left_ring="Begrudging Ring",
	    right_ring="Hetairoi Ring",
	    back={ name="Rudianos's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
		}
	
    sets.precast.WS['Atonement'] = set_combine(sets.precast.JA['Provoke'], {
		waist="Fotia Belt"
	})

		
	sets.precast.WS['Aeolian Edge'] = {
		ammo="Ginsen",
	    head="Jumalik Helm",
	    body="Sacro Breastplate",
	    hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
	    legs="Augury Cuisses +1",
	    feet={ name="Valorous Greaves", augments={'Weapon Skill Acc.+9','"Mag.Atk.Bns."+20','Accuracy+9 Attack+9','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
	    neck="Sanctity Necklace",
	    waist="Eschan Stone",
	    left_ear="Hecate's Earring",
	    right_ear="Moonshade Earring",
	    left_ring="Metamorph Ring",
	    right_ring="Epaminondas's Ring",
	    back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
		}
	

	sets.precast.WS['Sanguine Blade'] = {
		ammo="Ginsen",
	    head="Jumalik Helm",
	    body="Rev. Surcoat +3",
	    hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
	    legs="Augury Cuisses +1",
	    feet={ name="Valorous Greaves", augments={'Weapon Skill Acc.+9','"Mag.Atk.Bns."+20','Accuracy+9 Attack+9','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
	    neck="Sanctity Necklace",
	    waist="Eschan Stone",
	    left_ear="Hecate's Earring",
	    right_ear="Strophadic Earring",
	    left_ring="Sattva Ring",
	    right_ring="Karieyh's Ring +1",
	    back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
		}
	

	sets.precast.WS['Seraph Blade'] = sets.precast.WS['Sanguine Blade']
	sets.precast.WS['Shining Blade'] = sets.precast.WS['Sanguine Blade']
	sets.precast.WS['Red Lotus Blade'] = sets.precast.WS['Sanguine Blade']
	sets.precast.WS['Burning Blade'] = sets.precast.WS['Sanguine Blade']
	sets.precast.WS['Cataclysm'] = sets.precast.WS['Sanguine Blade']
    
	
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
		main="",
	    ammo="Staunch Tathlum +1", --s11
	    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}}, --s20
	    body="Rev. Surcoat +3",
	    hands="Leyline Gloves",
	    legs={ name="Founder's Hose", augments={'MND+10','Attack+15','Mag. Acc.+15','Breath dmg. taken -5%',}}, --s30
	    feet={ name="Odyssean Greaves", augments={'MND+1','Accuracy+12','Attack+12','Spell interruption rate down 11%',}}, --s20
	    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	    waist="Audumbla Sash", --s10
	    left_ring="Moonlight Ring",
	    right_ring="Kishar Ring",
	    back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','DEX+10','"Fast Cast"+10','Spell interruption rate down 10%',}},
		}
     
	sets.midcast.Crusade = sets.midcast.FastRecast
	   
    sets.midcast.Enmity = {
		sub="Srivatsa",
		ammo="Sapience Orb",
	    head="Loess Barbuta +1",
	    body="Rev. Surcoat +3",
	    hands={ name="Souv. Handschuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	    feet={ name="Souv. Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	    neck="Moonlight Necklace",
	    waist="Creed Baudrier",
	    ear1="Cryptic Earring",
        ear2="Trux Earring",
	    right_ring="Eihwaz Ring",
	    left_ring="Petrov Ring",
	    back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Occ. inc. resist. to stat. ailments +10',}}
		}
		
    sets.midcast.Flash = set_combine(sets.midcast.Enmity, {legs="Souv. Diechlings +1"})
    
    sets.midcast.Stun = sets.midcast.Enmity
	sets.midcast.Jettatura = sets.midcast.Enmity
	sets.midcast.Soporific = sets.midcast.Enmity
	
	sets.midcast['Geist Wall'] = sets.midcast.FastRecast
	sets.midcast['Blank Gaze'] = sets.midcast.FastRecast
	sets.midcast['Sheep Song'] = sets.midcast.FastRecast

	sets.midcast['Banish'] = {
		head="White rarab cap +1",
		legs="Valorous Hose",
		waist="Chaac Belt",
		feet={ name="Valorous Greaves", augments={'Chance of successful block +2','Weapon Skill Acc.+4','"Treasure Hunter"+1','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	sets.midcast['Banishga'] = {
		head="White rarab cap +1",
		legs="Valorous Hose",
		waist="Chaac Belt",
		feet={ name="Valorous Greaves", augments={'Chance of successful block +2','Weapon Skill Acc.+4','"Treasure Hunter"+1','Mag. Acc.+4 "Mag.Atk.Bns."+4'}}}
	
	
	sets.midcast['Phalanx'] = {
		sub="Priwen",
	    ammo="Staunch Tathlum +1",
	    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	    body={ name="Odyssean Chestplate", augments={'Accuracy+9','Attack+9','Mag. Acc.+5','"Mag. Atk. Bns."+5','"Counter"+3','"Phalanx" received +3','Pet: INT+7',}},
	    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	    legs={ name="Odyssean Cuisses", augments={'Critical hit damage +3%','"Phalanx" received +4','Pet: DEX+7',}},
	    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	    neck="Incanter's Torque",
	    waist="Audumbla Sash",
		left_ear="Andoaa Earring",
	    right_ear="Knightly Earring",
	    left_ring="Stikini Ring +1",
	    right_ring="Stikini Ring +1",
	    back={ name="Weard Mantle", augments={'VIT+3','Emnity+5','"Phalanx" received +4',}},
		}
	
	sets.midcast['Enlight II'] = {
		ammo="Staunch Tathlum +1",
	    head={ name="Jumalik Helm", augments={'MND+10','"Mag.Atk.Bns."+15','"Refresh"+1','Magic burst dmg. +10%',}},
	    body="Rev. Surcoat +3",
	    hands={ name="Eschite Gauntlets", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
	    neck="Incanter's Torque",
	    waist="Asklepian Belt",
	    right_ear="Beatific Earring",
	    left_ring="Stikini Ring +1",
	    right_ring="Stikini Ring +1",
	    back="Altrustic cape"
		}
		
	sets.midcast['Enlight'] = {
		ammo="Staunch Tathlum +1",
	    head={ name="Jumalik Helm", augments={'MND+10','"Mag.Atk.Bns."+15','"Refresh"+1','Magic burst dmg. +10%',}},
	    body="Rev. Surcoat +3",
	    hands={ name="Eschite Gauntlets", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
	    neck="Incanter's Torque",
	    waist="Asklepian Belt",
	    right_ear="Beatific Earring",
	    left_ring="Stikini Ring +1",
	    right_ring="Stikini Ring +1",
	    back="Altrustic cape"
		}	
	
	sets.midcast['Reprisal'] = {
		sub="Srivatsa", --because of HP, need to keep on shield to retain enhancement, but doing it for HP
		ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",
		neck="Unmoving Collar +1",
		ear1="Odnowa Earring +1",
		ear2="Tuisto Earring",
        body="Reverence Surcoat +3",
		hands="Regal Gauntlets",
		left_ring="Moonlight Ring",
    	right_ring="Gelatinous Ring +1",
        back="Moonlight Cape",
		waist="Gold Moogle Belt",
		legs="Souv. Diechlings +1",
		feet="Souveran Schuhs +1"
		}	

	
	sets.midcast.Poisonga = {ammo="Paeapua",
        head="Souv. Schaller +1",neck="Unmoving Collar +1",ear1="Cryptic Earring",ear2="Hades Earring +1",
        body="Souv. Cuirass +1",hands="Souv. Handsch. +1",ring1="Petrov Ring",ring2="Eihwaz Ring",
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Spell interruption rate down-10%',}},
		waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Souveran Schuhs +1"}
    
    sets.midcast.Cure = sets.midcast.FastRecast
    
    sets.midcast.Protect = {
		sub="Srivatsa",
		hands="Regal Gauntlets",
		legs="Carmine Cuisses +1",
		Ear2="Andoaa Earring",
		neck="Incanter's Torque"
	}
    sets.midcast.Shell = {Ear2="Brachyura Earring"}
    
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    sets.Reraise = {head="Twilight Helm", body="Twilight Mail"}
    
    sets.resting = {neck="Creed Collar",
        ring1="Sheltered Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe5"},
        waist="Austerity Belt"}
    

    -- Idle sets
		sets.idle = {
		main="Burtgang",
		sub="Aegis",
		ammo="Staunch Tathlum +1",
	    head="Souveran Schaller +1",
	    body="Reverence Surcoat +3",
	    hands="Souveran Handschuhs +1",
	    legs="Souveran Diechlings +1",
	    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	    neck="Loricate Torque +1",
	    waist="Asklepian Belt",
	    left_ear="Odnowa Earring +1",
	    right_ear="Tuisto Earring",
	    left_ring="Moonlight Ring",
		ring2="Gelatinous Ring +1",
	   	--right_ring={name="Moonlight Ring", bag="wardrobe3"},
	    back="Moonlight Cape",
	}
	
    
	sets.idle.Town = {
	    main="Burtgang",
	    sub="Aegis",
	    ammo="Staunch Tathlum +1",
	    head="Volte Salade",
	    body="Reverence Surcoat +3",
	    hands="Souveran Handschuhs +1",
	    legs={ name="Carmine Cuisses +1", augments={'Accuracy+12','DEX+12','MND+20',}},
	    feet="Souveran Schuhs +1",
	    neck="Moonlight Necklace",
	    waist="Gold Moogle Belt",
	    left_ear="Odnowa Earring +1",
	    right_ear="Tuisto Earring",
	    left_ring="Moonlight Ring",
	    right_ring="Murky Ring",
	    back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Emnity+10','Occ. inc. resist. to stat. ailments+10',}},}
    
    sets.idle.Weak = {ammo="Staunch Tathlum +1",
        head="Reverence Coronet +2",neck="Unmoving Collar +1",ear1="Creed Earring",ear2="Bloodgem Earring",
        body="Sacro Breastplate",hands="Reverence Gauntlets +1",ring1="Sheltered Ring",ring2="Meridian Ring",
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Emnity+10','Occ. inc. resist. to stat. ailments+10',}},
		waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Reverence Leggings +1"}
    
    sets.idle.Weak.Reraise = set_combine(sets.idle.Weak, sets.Reraise)
    
    sets.Kiting ={legs="Carmine Cuisses +1",waist="Fucho-no-obi",neck="Coatl Gorget +1",hands="Regal Gauntlets"}
 
	
    --sets.latent_refresh = {waist="Fucho-no-obi",neck="Coatl Gorget +1",hands="Regal Gauntlets"}


    --------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.Knockback = {back="Repulse Mantle"}
    sets.MP = {neck="Creed Collar",waist="Flume Belt +1"}
    sets.MP_Knockback = {neck="Creed Collar",waist="Flume Belt +1",back="Repulse Mantle"}
    
    -- If EquipShield toggle is on (Win+F10 or Win+F11), equip the weapon/shield combos here
    -- when activating or changing defense mode:
    sets.PhysicalShield = {main="Burtgang",sub="Ochain"} -- Ochain
    sets.MagicalShield = {main="Burtgang",sub="Aegis"} -- Aegis

    -- Basic defense sets.
        
    sets.defense.PDT = {
		sub="Ochain",
		ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",
		neck="Moonlight Necklace",
		ear1="Odnowa Earring +1",
		ear2="Tuisto Earring",
        body="Reverence Surcoat +3",
		hands="Souv. Handsch. +1",
		ring1="Eihwaz Ring",
		ring2="Murky Ring",
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Emnity+10','Occ. inc. resist. to stat. ailments+10',}},
		waist="Gold Moogle Belt",
		legs="Souveran Diechlings +1",
		feet="Souveran Schuhs +1"
	}
    sets.defense.HP = {
		sub="Srivatsa",
		ammo="Staunch Tathlum +1",
        head="Souv. Schaller +1",
		neck="Unmoving Collar +1",
		ear1="Odnowa Earring +1",
		ear2="Tuisto Earring",
        body="Rev. Surcoat +3",
		hands="Souv. Handsch. +1",
		ring1="Moonlight Ring",
		ring2="Moonlight Ring",
        back="Moonlight Cape",
		waist="Gold Moogle Belt",
		legs="Souv. Diechlings +1",
		feet="Souveran Schuhs +1"
	}
    sets.defense.Reraise = {
		ammo="Staunch Tathlum +1",
        head="Twilight Helm",
		neck="Loricate Torque +1",
		ear1="Odnowa Earring +1",
		ear2="Odnowa Earring",
        body="Twilight Mail",
		hands="Souv. Handschuhs +1",
		ring1="Moonlight Ring",
		ring2="Murky Ring",
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Emnity+10','Occ. inc. resist. to stat. ailments+10',}},
		waist="Flume Belt +1",
		legs="Souv. Diechlings +1",
		feet="Souv. Schuhs +1"
	}
    sets.defense.Charm = {
		ammo="Staunch Tathlum +1",
	    head="Volte Salade",
	    body="Rev. Surcoat +3",
	    hands="Macabre Gauntlets +1",
	    legs="Souveran Diechlings +1",
	    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	    neck="Unmoving Collar +1",
	    waist="Asklepian Belt",
	    left_ear="Odnowa Earring +1",
	    right_ear="Hearty Earring",
	    left_ring="Wuji Ring",
	    right_ring="Murky Ring",
	    back="Solemnity Cape",
		}
    -- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.MDT = {
		main="Burtgang",
	    sub="Aegis",
	    ammo="Staunch Tathlum +1",
	    head="Volte Salade",
	    body="Rev. Surcoat +3",
	    hands="Volte Moufles",
	    legs="Volte Brayettes",
	    feet="Souveran Schuhs +1",
	    neck="Loricate Torque +1",
	    waist="Asklepian Belt",
	    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
	    right_ear="Tuisto Earring",
	    left_ring="Moonlight Ring",
	    right_ring="Gelatinous Ring +1",
	    back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Emnity+10','Occ. inc. resist. to stat. ailments+10',}},
	}
	
    --------------------------------------
    -- Engaged sets
    --------------------------------------
    
    sets.engaged = {
		main="Burtgang",
		sub="Aegis",
		ammo="Staunch Tathlum +1",
	    head="Volte Salade",
	    body="Rev. Surcoat +3",
	    hands="Volte Moufles",
	    legs="Volte Brayettes",
	    feet="Souveran Schuhs +1",
	    neck="Loricate Torque +1",
	    waist="Asklepian Belt",
	    left_ear="Odnowa Earring +1",
	    right_ear="Tuisto Earring",
	    left_ring="Moonlight Ring",
	    right_ring="Gelatinous Ring +1",
	    back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Emnity+10','Occ. inc. resist. to stat. ailments+10',}},
	}

		
    sets.engaged.Acc = {
		ammo="Ginsen",
	    head="Hjarrandi Helm",
	    body="Valorous Mail",
	    hands="Sulev. Gauntlets +2",
	    legs={ name="Odyssean Cuisses", augments={'Accuracy+20','Attack+13','"Double Attack"+4%'}},
	    feet="Flam. Gambieras +2",
	    neck="Combatant's Torque",
	    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
	    right_ear="Telos Earring",
	    left_ear="Cessance Earring",
	    left_ring="Moonlight Ring",
	    right_ring="Flamma Ring",
	    back={ name="Rudianos's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','DEX+10'}},
	}


	sets.engaged.Mid = {

	}
	
	sets.engaged.DW = {}
    --sets.engaged.DW = {ammo="Ginsen",
       -- head="Valorous mask",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        --body="Gorney Haubert +1",hands="Cizin Mufflers",ring1="Rajas Ring",ring2="K'ayres Ring",
        --back="Atheling Mantle",waist="Cetl Belt",legs="Carmine Cuisses +1",feet="Whirlpool Greaves"}

    --sets.engaged.DW.Acc = {ammo="Ginsen",
        --head="Valorous mask",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
       -- body="Gorney Haubert +1",hands="Buremte Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        --back="Weard Mantle",waist="Zoran's Belt",legs="Carmine Cuisses +1",feet="Whirlpool Greaves"}

    sets.engaged.PDT = set_combine(sets.engaged, {body="Chev. Cuirass",feet="Cab. Leggings +3",neck="Loricate Torque +1",ring1="Murky Ring"})
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, {body="Chev. Cuirass",neck="Loricate Torque +1",ring1="Murky Ring"})
    sets.engaged.Reraise = set_combine(sets.engaged, sets.Reraise)
    sets.engaged.Acc.Reraise = set_combine(sets.engaged.Acc, sets.Reraise)

    --sets.engaged.DW.PDT = set_combine(sets.engaged.DW, {body="Reverence Surcoat +1",neck="Loricate Torque +1",ring1="Murky Ring"})
    --sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.DW.Acc, {body="Reverence Surcoat +1",neck="Loricate Torque +1",ring1="Murky Ring"})
    --sets.engaged.DW.Reraise = set_combine(sets.engaged.DW, sets.Reraise)
    --sets.engaged.DW.Acc.Reraise = set_combine(sets.engaged.DW.Acc, sets.Reraise)


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

	sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Purity Ring", bag="wardrobe"}, --7
        ring2={name="Eshmun's Ring", bag="wardrobe5"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.buff.Cover = {head="Reverence Coronet +1", body="Caballarius Surcoat +3"}
end


function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_midcast(spell, action, spellMap, eventArgs)
    -- If DefenseMode is active, apply that gear over midcast
    -- choices.  Precast is allowed through for fast cast on
    -- spells, but we want to return to def gear before there's
    -- time for anything to hit us.
    -- Exclude Job Abilities from this restriction, as we probably want
    -- the enhanced effect of whatever item of gear applies to them,
    -- and only one item should be swapped out.
    if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
        handle_equipping_gear(player.status)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.ExtraDefenseMode.current)
    if state.EquipShield.value == true then
        classes.CustomDefenseGroups:append(state.DefenseMode.current .. 'Shield')
    end

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.ExtraDefenseMode.current)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    
    return meleeSet
end

function job_buff_change(buff,gain)
	-- If we gain or lose any haste buffs, adjust which gear set we target.

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
 --       end
--    end

end

function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
    
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
    end
    
    if state.Buff.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
    
    return defenseSet
end


function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.ExtraDefenseMode.value ~= 'None' then
        msg = msg .. ', Extra: ' .. state.ExtraDefenseMode.value
    end
    
    if state.EquipShield.value == true then
        msg = msg .. ', Force Equip Shield'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_defense_mode()
    if player.equipment.main == 'Kheshig Blade' and not classes.CustomDefenseGroups:contains('Kheshig Blade') then
        classes.CustomDefenseGroups:append('Kheshig Blade')
    end
    
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        if player.equipment.sub and not player.equipment.sub:contains('Shield') and
           player.equipment.sub ~= 'Aegis' and player.equipment.sub ~= 'Ochain' then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
	if player.sub_job == 'BLU' then
        set_macro_page(1, 1)
	elseif player.sub_job == 'DRK' then
        set_macro_page(3, 1)
	elseif player.sub_job == 'WAR' then
        set_macro_page(2, 1)	
    else
        set_macro_page(5, 1)
    end

	send_command('wait 6;input /lockstyleset 98')
end


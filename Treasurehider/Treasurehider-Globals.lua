-------------------------------------------------------------------------------------------------------------------
-- Modify the sets table.  Any gear sets that are added to the sets table need to
-- be defined within this function, because sets isn't available until after the
-- include is complete.  It is called at the end of basic initialization in Mote-Include.
-------------------------------------------------------------------------------------------------------------------

function define_global_sets()

    -- Augmented Weapons
    gear.Colada_ENH = {name="Colada", augments={'Enh. Mag. eff. dur. +4','INT+5','Mag. Acc.+9',}}

    gear.Gada_ENF = {name="Gada", augments={'"Conserve MP"+2','MND+14','Mag. Acc.+20','"Mag.Atk.Bns."+2','DMG:+7',}}
    gear.Gada_ENH = {name="Gada", augments={'Enh. Mag. eff. dur. +6','MND+9','Mag. Acc.+9','"Mag.Atk.Bns."+1','DMG:+4',}}

    gear.Kali_Idle = {name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}}
    gear.Kali_Song = {name="Kali", augments={'DMG:+15','CHR+15','Mag. Acc.+15',}}

    gear.Lathi_MAB = {name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}}
    gear.Lathi_ENF = {name="Lathi", augments={'Mag. Acc.+20','Enfb.mag. skill +15','Dark magic skill +15',}}

    gear.Linos_TP = {name="Linos", augments={'Accuracy+15 Attack+15','"Dbl.Atk."+3','Quadruple Attack +3',}}
    gear.Linos_WS = {name="Linos", augments={'Accuracy+15 Attack+15','Weapon skill damage +3%','STR+6 CHR+6',}}

    gear.Grioavolr_MND = {name="Grioavolr", augments={'Enfb.mag. skill +10','MND+18','Mag. Acc.+20','"Mag.Atk.Bns."+11',}}
    gear.Grioavolr_MP = {name="Grioavolr", augments={'"Fast Cast"+5','MP+97','Mag. Acc.+28','"Mag.Atk.Bns."+29',}}
    gear.Grioavolr_MB = {name="Grioavolr", augments={'Magic burst dmg.+5%','INT+9','Mag. Acc.+27','"Mag.Atk.Bns."+27',}}

    -- Acro
    gear.Acro_STP_hands = {name="Acro Gauntlets", augments={'Accuracy+20 Attack+20','"Store TP"+6','STR+6 DEX+6',}}

    -- Adhemar
    gear.Adhemar_B_head = {name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}}

    gear.Adhemar_B_body = {name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}}

    gear.Adhemar_A_hands = {name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}}
    gear.Adhemar_B_hands = {name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}}

	-- Amalric	
	gear.Amalric_A_Body ={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}}

    -- Herculean
    gear.Herc_TA_body = {name="Herculean Vest", augments={'Accuracy+19 Attack+19','"Triple Atk."+3','STR+9','Accuracy+10',}}
    --gear.Herc_TA_feet = {name="Herculean Boots", augments={'Accuracy+23','"Triple Atk."+4','Attack+10',}} -- no longer have

    gear.Herc_STP_head = {name="Herculean Helm", augments={'Accuracy+16','"Store TP"+5','DEX+2','Mag. Acc.+14','"Mag.Atk.Bns."+14',}}

    -- TRY FOR THIS: gear.Herc_MAB_head = {name="Herculean Helm", augments={'AGI+6','"Mag.Atk.Bns."+25','Weapon skill damage +2%','Mag. Acc.+18 "Mag.Atk.Bns."+18',}}
    gear.Herc_MAB_head = {name="Herculean Helm", augments={'Accuracy+16','"Store TP"+5','DEX+2','Mag. Acc.+14','"Mag.Atk.Bns."+14',}}
    gear.Herc_MAB_legs = {name="Herculean Trousers", augments={'Mag. Acc.+8 "Mag.Atk.Bns."+8','Weapon skill damage +3%','"Mag.Atk.Bns."+15',}}
	gear.Herc_MAB_feet = { name="Herculean Boots", augments={'Pet: Haste+1','"Mag.Atk.Bns."+23','Accuracy+15 Attack+15','Mag. Acc.+20 "Mag.Atk.Bns."+20',}}


    --Don't have: gear.Herc_WSD_head = {name="Herculean Helm", augments={'Pet: VIT+7','Pet: "Regen"+3','Weapon skill damage +10%','Accuracy+2 Attack+2',}}
    -- TRY FOR THIS: gear.Herc_WSD_legs = {name="Herculean Trousers", augments={'"Repair" potency +1%','Magic dmg. taken -1%','Weapon skill damage +8%','Accuracy+11 Attack+11','Mag. Acc.+10 "Mag.Atk.Bns."+10',}}
    gear.Herc_WSD_body = {name="Herculean Vest", augments={'Weapon skill damage +5%',}}
	gear.Herc_WSD_legs = {name="Herculean Trousers", augments={'Mag. Acc.+8 "Mag.Atk.Bns."+8','Weapon skill damage +3%','"Mag.Atk.Bns."+15',}}
    --Don't have: gear.Herc_WSD_feet = {name="Herculean Boots", augments={'Pet: "Regen"+2','AGI+14','Weapon skill damage +7%','Accuracy+16 Attack+16','Mag. Acc.+15 "Mag.Atk.Bns."+15',}}

    gear.Herc_DT_head = {name="Herculean Helm", augments={'AGI+2','"Rapid Shot"+2','Damage taken-5%','Accuracy+2 Attack+2',}}
    gear.Herc_DT_hands = {name="Herculean Gloves", augments={'"Cure" potency +3%','INT+9','Damage taken-5%','Accuracy+19 Attack+19','Mag. Acc.+5 "Mag.Atk.Bns."+5',}}

    -- Merlinic
    gear.Merl_FC_body = {name="Merlinic Jubbah", augments={'"Mag.Atk.Bns."+13','"Fast Cast"+7',}}
    gear.Merl_MB_body = {name="Merlinic Jubbah", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+10%','VIT+5','"Mag.Atk.Bns."+12',}}

	-- Odyssean
    gear.Odyssean_TP_legs = { name="Odyssean Cuisses", augments={'Accuracy+20 Attack+13','"Double Attack"+4%',}}
    gear.Odyssean_WS_legs = { name="Odyssean Cuisses", augments={'Accuracy+25','DEX+1','Weapon skill damage +7%','Accuracy+10 Attack+10',}} -- Don't have
    
    gear.Odyssean_FC_feet = { name="Odyssean Greaves", augments={'Attack+20','"Fast Cast"+4','Accuracy+15',}} -- Don't have

    -- Taeon
    -- I DONT HAVE: gear.Taeon_DW_feet = {name="Taeon Boots", augments={'Accuracy+20 Attack+20','"Dual Wield"+5','STR+7 DEX+7',}}
	gear.Taeon_DW_feet = {name="Taeon Boots", augments={'Accuracy+18 Attack+18','Spell interruption rate down -9%','Phalanx +3',}}

    --gear.Taeon_FC_body = {name="Taeon Tabard", augments={'"Fast Cast"+5','HP+48',}}
	gear.Taeon_FC_body = {name="Taeon Tabard", augments={'Accuracy+20 Attack+20','Spell interruption rate down -9%','Phalanx +3',}}

    gear.Taeon_Phalanx_body = {name="Taeon Tabard", augments={'Accuracy+20 Attack+20','Spell interruption rate down -9%','Phalanx +3',}}
    gear.Taeon_Phalanx_hands = {name="Taeon Gloves", augments={'Mag. Evasion+19','Spell interruption rate down -10%','Phalanx +3',}}
    gear.Taeon_Phalanx_legs = {name="Taeon Tights", augments={'Accuracy+20 Attack+20','"Cure" potency +3%','Phalanx +3',}}
    gear.Taeon_Phalanx_feet = {name="Taeon Boots", augments={'Accuracy+18 Attack+18','Spell interruption rate down -9%','Phalanx +3',}}

	gear.Taeon_SIR_Head = { name="Taeon Chapeau", augments={'Evasion+25','Spell interruption rate down -8%','HP+45',}}
	gear.Taeon_SIR_Feet = {name="Taeon Boots", augments={'Accuracy+18 Attack+18','Spell interruption rate down -9%','Phalanx +3',}}

    -- Valorous

    gear.Valo_STP_legs = {name="Valor. Hose", augments={'Accuracy+21 Attack+21','"Store TP"+8','Accuracy+15','Attack+11',}}
	-- GET STP AUGMENT ON THESE - THIS IS USED FOR LIBERATOR AM3 v
    gear.Valo_STP_feet = { name="Valorous Greaves", augments={'DEX+5','Accuracy+29','Attack+11','"Double Attack"+3%',}}
    
    gear.Valo_DA_body = { name="Valorous Mail", augments={'Accuracy+20 Attack+20','"Dbl.Atk."+4','VIT+4','Attack+6',}}

    gear.Valo_TP_body = {name="Valorous Mail", augments={'DEX+5','Accuracy+18 Attack+15','"Dbl.Atk."+5',}}
    gear.Valo_TP_legs = {name="Valor. Hose", augments={'Accuracy+20','"Dbl.Atk."+5','Attack+13',}}

    gear.Valo_WSD_head = {name="Valorous Mask", augments={'Accuracy+18 Attack+18','Weapon skill damage +4%','STR+7','Attack+3',}}
    gear.Valo_WSD_body = {name="Valorous Mail", augments={'Accuracy+22 Attack+22','Weapon skill damage +4%','STR+1','Accuracy+15','Attack+15',}}
    gear.Valo_WSD_legs = {name="Valor. Hose", augments={'Accuracy+25 Attack+25','Weapon skill damage +4%','STR+12','Attack+6',}}
    gear.Valo_WSD_feet = {name="Valorous Greaves", augments={'VIT+5','"Store TP"+4','Weapon skill damage +4%','Accuracy+19 Attack+19','Mag. Acc.+15 "Mag.Atk.Bns."+15',}}

    -- Ambuscade Capes
    gear.BLM_Death_Cape = {name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Fast Cast"+10',}} --*
    gear.BLM_FC_Cape = {name="Taranus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}
    gear.BLM_MAB_Cape = {name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}} --*

    gear.BRD_DW_Cape = {name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}} --**
    gear.BRD_Song_Cape = {name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}} --*
    gear.BRD_STP_Cape = {name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}} --**
    gear.BRD_WS1_Cape = {name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}} --**
    gear.BRD_WS2_Cape = {name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}} --*

    gear.BLU_MAB_Cape = {name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}} --*
    gear.BLU_TP_Cape = {name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}} --**
    gear.BLU_WS1_Cape = {name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}} --*
    gear.BLU_WS2_Cape = {name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}} --*

    gear.COR_DW_Cape = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}} --**
    gear.COR_RA_Cape = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}} --*
    gear.COR_SNP_Cape = {name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Snapshot"+10',}} --*
    gear.COR_TP_Cape = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}} --**
    gear.COR_WS1_Cape = {name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}} --*
    gear.COR_WS2_Cape = {name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}} --*
    gear.COR_WS3_Cape = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}} --*
    gear.COR_WS4_Cape = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}} --*

    gear.DNC_TP_Cape = {name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}} --**
    gear.DNC_WTZ_Cape = {name="Senuna's Mantle", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','CHR+10','Enmity +10',}} --*
    gear.DNC_WS1_Cape = {name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}} --*
    gear.DNC_WS2_Cape = {name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}} --* -- Don't have, not sure I need.
    gear.DNC_WS3_Cape = {name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}} --* -- Don't have, not sure I need.

    gear.WAR_DA_Cape  = { name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    gear.WAR_WSD_Cape = { name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}

    gear.DRG_TP_Cape = {name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}} --**
    gear.DRG_JMP_Cape = {name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Store TP"+10',}} --*
    gear.DRG_WS1_Cape = {name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}} --*
    gear.DRG_WS2_Cape = {name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}} --*
    gear.DRG_WS3_Cape = {name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}} --*
    gear.DRG_WS4_Cape = {name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}} --*

    gear.DRK_FC_Cape  = { name="Ankou's Mantle", augments={'"Fast Cast"+10',}}
    gear.DRK_STP_Cape = { name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
    gear.DRK_DA_Cape  = { name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    gear.DRK_WSD_Cape = { name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
    gear.DRK_VIT_Cape = { name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}}

    gear.NIN_FC_Cape = {name="Andartia's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Spell interruption rate down-10%',}} --**
    gear.NIN_MAB_Cape = {name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}}
    gear.NIN_TP_Cape = {name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}} --**
    gear.NIN_WS1_Cape = {name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}} --**
    gear.NIN_WS2_Cape = {name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}} --**
    gear.NIN_WS3_Cape = {name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}} --**

    gear.RDM_DW_Cape = {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}} --**
    gear.RDM_INT_Cape = {name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}} --*
    gear.RDM_MND_Cape = {name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity -10',}} --*
    gear.RDM_WS1_Cape = {name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}} --*
    gear.RDM_WS2_Cape = {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}} --*

    gear.RNG_DW_Cape = {name="Belenus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}}
    gear.RNG_RA_Cape = {name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}} --*
    gear.RNG_SNP_Cape = {name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','"Snapshot"+10',}}
    gear.RNG_TP_Cape = {name="Belenus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}}
    gear.RNG_WS1_Cape = {name="Belenus's Cape", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}} --*
    gear.RNG_WS2_Cape = {name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}} --*

    gear.RUN_FC_Cape = {name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}} --**
    gear.RUN_HPD_Cape = {name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}} --**
    gear.RUN_HPP_Cape = {name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Parrying rate+5%',}} --**
    gear.RUN_TP_Cape = {name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}} --**
    gear.RUN_WS1_Cape = {name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}} --**
    gear.RUN_WS2_Cape = {name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}} --**

    gear.SCH_Cure_Cape = {name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%','Spell interruption rate down-10%',}} --**
    gear.SCH_MAB_Cape = {name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}} --*
    gear.SCH_FC_Cape = {name="Lugh's Cape", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Mag. Evasion+15',}} --**

    gear.THF_DW_Cape = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}} --**
    gear.THF_TP_Cape = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}} --**
    gear.THF_WS1_Cape = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}} --*
    gear.THF_WS2_Cape = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}} --*

    gear.WHM_Cure_Cape = {name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%','Mag. Evasion+15',}} --**
    gear.WHM_DA_Cape = {name="Alaunus's Cape", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10',}}
    gear.WHM_FC_Cape = {name="Alaunus's Cape", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Mag. Evasion+15',}} --**
    gear.WHM_MND_Cape = {name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}} --**
    gear.WHM_STP_Cape = {name="Alaunus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}} --**
    gear.WHM_WSD_Cape = {name="Alaunus's Cape", augments={'MND+20','Accuracy+20 Attack+20','MND+5','Weapon skill damage +10%',}}

end



laggy_zones = S{'Al Zahbi', 'Aht Urhgan Whitegate', 'Eastern Adoulin', 'Mhaura', 'Nashmau', 'Selbina', 'Western Adoulin'}

windower.register_event('zone change',
    function()
      -- Caps FPS to 30 via Config addon in certain problem zones
        --[[if laggy_zones:contains(world.zone) then
            send_command('config FrameRateDivisor 2')
        else
            send_command('config FrameRateDivisor 1')
        end]]--

        -- Auto load Omen add-on
        if world.zone == 'Reisenjima Henge' then
            send_command('lua l omen')
        end
    end
)

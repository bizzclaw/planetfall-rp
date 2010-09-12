/*----------------------------
 Declaring ma varibles.......|
 ---------------------------*/

cur_power = 10000 //starting power/current power
item = { ["power"] = 1, ["gen"] = 1, ["lift"] = 0, ["shield"] = 1 }
//shield_parts = { [1] = "Sld1_B1", [2] = "Sld1_B2", [3] = "Sld1_B3", [4] = "Sld1_B4", [5] = "Sld1_B5", [6] = "Sld1_B6", [7] = "Sld1_B7", [8] = "Sld1_B8" }
lockdown_doors = { [1] = "Brdg_D", [2] = "LQ_D2", [3] = "Holo_D", [4] = "LQ_D", [5] = "HSC_D2", [6] = "Utl_BD", [7] = "Civ_BD", [8] = "Med_D", [9] = "Cic_BD2", [10] = "H2_D2", [11] = "AS2_D2", [12] = "H2_D3", [13] = "Prn_D", [14] = "H1_D4", [15] = "H2_D1", [16] = "BS_D", [17] = "HSC_D", [18] = "Gen_D", [19] = "H1_D", [20] = "H1_D1" }
lift_power = 100 //the ammount of power the lift takes per clock
shield_power = 900 //read above, guess
power_generated = 1000 //the ammount of power generated per clock
max_storage = 10000 //the maximum ammount of power the battery can store
s_enabled = 0 // Silly boolean for the silly thing to enable/disable shields

print("Power Loaded!")

/*------------------------------------------------------------------
 The cycle that happens every second to caclulate the current power|
 -----------------------------------------------------------------*/
function Clock() 

	if item["power"] == 1 && item["gen"] == 1 then
		cur_power = cur_power + power_generated
		if cur_power > max_storage - power_generated then
			cur_power = max_storage
		end
	end
	
	if cur_power < lift_power then  item["lift"] = 0 end
	if cur_power < shield_power then item["shield"] = 0 end
	if item["power"] == 1 && item["lift"] == 1 then cur_power = cur_power - lift_power end
	if item["power"] == 1 && item["shield"] == 1 then cur_power = cur_power - shield_power end
	
	if item[ "shield" ] == 0 && s_enabled == 1 then 
			local cur_ents = ents.FindByName( "Sld1_B*" )
			table.sort ( cur_ents )
			for i,v in pairs ( cur_ents ) do
				v:Fire ( "Disable", "" , ( ( i / 10 ) - 0.1 ) )
			end
		 s_enabled = 0
	end

	if item[ "shield" ] == 1 && s_enabled == 0 then 
			local cur_ents = ents.FindByName( "Sld1_B*" )
			table.sort ( cur_ents )
			for i,v in pairs ( cur_ents ) do
				v:Fire ( "Enable", "" , ( 5 + ( (i / 10) - 0.1) ) )
			end
		s_enabled = 1
	end
end

/*---------------------------------------------------------------------------------
 Collection of switches to turn stuff on and off                                  |
 --------------------------------------------------------------------------------*/

function Switch(i)
	if item[i] == 1 then
		item[i] = 0
	else
		item[i] = 1
	end
end

/*--------------------------------------------------------------------------------------------
 These aren't switchs as such, more controls so that we can turn stuff on or off when we want|
 -------------------------------------------------------------------------------------------*/

function On(i)
	item[i] = 1
end

function Off(i)
	item[i] = 0
end

/*----------------------------------------------------------------------------------------------------
Pretty simple fucntion that Shadow asked for that will lockdown the ship for him without Hammer Logic, funny point actually, this makes the ship impossible to get though :P |
 ---------------------------------------------------------------------------------------------------*/

function Lockdown()

	if input_one == "Unlock" or input_one == nil then 
		input_one = "Close"
		input_two = "Lock"
	elseif input_one == "Close" then
		input_one = "Unlock"
	end

	for k,v in pairs(lockdown_doors) do
		for j,i in pairs( ents.FindByName(v) ) do
			i:Fire ( input_one , "" , 0 )
			if input_one == "Close" then
				i:Fire ( input_two , "" , 0 )
			end
		end
	end
end

/*------------------------------------------------------------------
 Dev fuction so I could easily tell whats going on, ignore it tbh  |
 -----------------------------------------------------------------*/

function Debug() 
	for _,v in pairs( player.GetAll() ) do
		v:PrintMessage ( HUD_PRINTTALK , "Current Power is " .. cur_power )
		v:PrintMessage ( HUD_PRINTTALK , "Gen is in position " .. item["gen"] )
		v:PrintMessage ( HUD_PRINTTALK , "Power is in position " .. item["power"] )
		v:PrintMessage ( HUD_PRINTTALK , "Lift is in position " .. item["lift"] )
		v:PrintMessage ( HUD_PRINTTALK , "Shield is in position " .. item["shield"] )
	end
end 
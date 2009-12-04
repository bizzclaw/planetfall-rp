/*-------------------------------
 Declaring ma varibles.......|
 -------------------------------*/

cur_power = 10000 //starting power/current power
item = { ["power"] = 1, ["gen"] = 1, ["lift"] = 0, ["shield"] = 0 }
shield_parts = { [1] = "Sld1_B1", [2] = "Sld1_B2", [3] = "Sld1_B3", [4] = "Sld1_B4", [5] = "Sld1_B5", [6] = "Sld1_B6", [7] = "Sld1_B7", [8] = "Sld1_B8" }

/*-----------------------------------------------------------------------------------
 The cycle that happens every second to caclulate the current power|
 -----------------------------------------------------------------------------------*/
function Clock() 
	//local section of doooooom!
	
	if declared == nil then
		local lift_power = 100 //the ammount of power the lift takes per clock
		local shield_power = 900 //read above, guess
		local power_generated = 1000 //the ammount of power generated per clock
		local max_storage = 10000 //the maximum ammount of power the battery can store
		local s_enabled = 0 // Silly boolean for the silly thing to enable/disable shields
		local declared = 1 
	end
	
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
	
	if item["shield"] == 0 then 
		if s_enabled == 1 then 
			for i = 1, 8 do
				cur_ent = ents.FindByName(shield_parts[i])
				cur_ent:Fire ("Disable",, ((i / 10) - 0.1 )
			end
			local s_enabled = 0
		end
	end
	
	if item["shield"] == 1 then
		if s_enabled == 0 then
			for i = 1, 8 do
				cur_ent = ents.FindByName(shield_parts[i])
				cur_ent:Fire ("Enable",, (5 + ((i / 10) - 0.1) )
			end
			local s_enabled = 1
		end
	end
end

/*-----------------------------------------------------------------------------------
 Collection of switches to turn stuff on and off                                  |
 -----------------------------------------------------------------------------------*/

function Switch(thingy)
	if item[thingy] == 1 then
		item[thingy] = 0
	else
		item[thingy] = 1
	end
end

/*--------------------------------------------------------------------------------------------------------------------
 These aren't switchs as such, more controls so that we can turn stuff on or off when we want|
 --------------------------------------------------------------------------------------------------------------------*/

function On(thingy)
	item[thingy] = 1
end

function Off(thingy)
	item[thingy] = 0
end


/*-----------------------------------------------------------------------------------
 Dev fuction so I could easily tell whats going on, ignore it tbh         |
 -----------------------------------------------------------------------------------*/

function Debug() 
	for _,v in pairs(player.GetAll()) do
		v:PrintMessage (HUD_PRINTTALK, "Current Power is " .. cur_power)
		v:PrintMessage (HUD_PRINTTALK, "Gen is in position " .. item["gen"])
		v:PrintMessage (HUD_PRINTTALK, "Power is in position " .. item["power"])
		v:PrintMessage (HUD_PRINTTALK, "Lift is in position " .. item["lift"])
		v:PrintMessage (HUD_PRINTTALK, "Shield is in position " .. item["shield"])
	end
end 
	//Dev section, used to test everything and make sure it worked!
/*if CLIENT then
	concommand.Add ("Clock", Clock)
	concommand.Add ("GenSwitch", function() Switch("gen") end)
	concommand.Add ("PowerSwitch", function() Switch("power") end)
	concommand.Add ("LiftSwitch", function() Switch("lift") end)
	concommand.Add ("ShieldSwitch", function() Switch("shield") end)
	concommand.Add ("Test", Debug)
	concommand.Add ("GenOn", function() On("gen") end)
	concommand.Add ("GenOff", function() Off("gen") end)
	concommand.Add ("PowerOn", function() On("power") end)
	concommand.Add ("PowerOff", function() Off("power") end)
	concommand.Add ("LiftOn", function() On("lift") end)
	concommand.Add ("LiftOff", function() Off("lift") end)
	concommand.Add ("ShieldOn", function() On("shield") end)
	concommand.Add ("ShieldOff", function() Off("shield") end)
end
*/
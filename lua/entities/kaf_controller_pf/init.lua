ENT.Base = "base_entity"
ENT.Type = "point"

include("PowerSystems.lua")

function ENT:Initialize()
end

function ENT:AcceptInput (name, f , g , data)
	if (name == "Clock") then Clock() end
	if (name == "GenSwitch") then Switch("gen") end
	if (name == "PowerSwitch") then Switch("power") end
	if (name == "LiftSwitch") then Switch("lift") end
	if (name == "ShieldSwitch") then Switch("shield") end
	if (name == "Lockdown") && (data == "true") then Lockdown() end
	
	if (name == "GenPower") && (data == "1") then On("gen")
		elseif (name == "GenPower") && (data == "0") then Off("gen")
	end
	if (name == "Power") && (data == "1") then On("power")
		elseif (name == "Power") && (data == "0") then Off("power")
	end
	if (name == "LiftPower") && (data == "1") then On("lift")
		elseif (name == "LiftPower") && (data == "0") then Off("lift")
	end
	if (name == "ShieldPower") && (data == "1") then On("shield")
		elseif (name == "ShieldPower") && (data == "0") then Off("shield")
	end
	if (name == "Test") then Debug() end
end
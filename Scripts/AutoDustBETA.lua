--<<AutoDust BETA>>
--[[

                                             ●▬▬▬▬ஜ۩۞۩ஜ▬▬▬▬●

 Welcome to one of my various DOTO scripts, if you enjoy it please leave a thanks on my thread :) 
   Automatically casts Dust of Appearence when an enemy is in range and fading to invisibility.

                                   And again, thanks for using my script!

                                             ●▬▬▬▬ஜ۩۞۩ஜ▬▬▬▬● 

]]--
--Libraries 
require("libs.Utils")

local registered	= false
local range 		= 1000 --The actual range of dust is 1050, 1000 allows you to hit targets moving out of range/delays
local target	        = nil


function onLoad()
	if PlayingGame() then
		registered = true
		script:RegisterEvent(EVENT_TICK,Main)
		script:UnregisterEvent(onLoad)
	end
end

function Main(tick)
	if not SleepCheck() then return end

	local me = entityList:GetMyHero()
	if not me then return end
	local dust = me:FindItem("item_dust")
	
        if dust and dust:CanBeCasted() then
        	FindTarget()
    	        if target and (target:DoesHaveModifier("modifier_bounty_hunter_wind_walk") 
    	        	      or target:DoesHaveModifier("modifier_riki_permanent_invisibility") 
    	        	      or target:DoesHaveModifier("modifier_mirana_moonlight_shadow") 
    	        	      or target:DoesHaveModifier("modifier_treant_natures_guise") 
    	        	      or target:DoesHaveModifier("modifier_weaver_shukuchi") 
    	        	      or target:DoesHaveModifier("modifier_broodmother_spin_web_invisible_applier") 
    	        	      or target:DoesHaveModifier("modifier_item_invisibility_edge_windwalk") 
    	        	      or target:DoesHaveModifier("modifier_rune_invis") 
    	        	      or target:DoesHaveModifier("modifier_clinkz_wind_walk") 
    	        	      or target:DoesHaveModifier("modifier_item_shadow_amulet_fade")) 
    	        	      and not (target:DoesHaveModifier("modifier_bounty_hunter_track") 
    	        	        	or target:DoesHaveModifier("modifier_bloodseeker_thirst_vision") 
    	        	        	or target:DoesHaveModifier("modifier_slardar_amplify_damage") 
    	        	        	or target:DoesHaveModifier("modifier_item_dustofappearance")) then
		        me:CastAbility(dust)
		        Sleep(30000)
			return
	        end
		
		if me and me:DoesHaveModifier("modifier_invoker_ghost_walk_enemy") then
		        me:CastAbility(dust)
		        Sleep(30000)
			return
		end
		
		if target and target.name == ("npc_dota_hero_templar_assassin") and (target.health/target.maxHealth < 0.3) then
		        me:CastAbility(dust)
		        Sleep(30000)
			return
		end
		
		if target and target.name == ("npc_dota_hero_sand_king") and (target.health/target.maxHealth < 0.3) then
		        me:CastAbility(dust)
		        Sleep(30000)
			return
		end
		
		if target and target.name == ("npc_dota_hero_nyx_assassin") and (target:GetAbility(4).CanBeCasted()) then
		        me:CastAbility(dust)
		        Sleep(30000)
			return
		end
     	end
	    
end

function FindTarget()
	local me = entityList:GetMyHero()
	local enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),alive=true,visible=true,illusion=false})
	local InvisTarget = nil
	for i,v in ipairs(enemies) do
		distance = GetDistance2D(v,me)
		if distance <= range then 
			if InvisTarget == nil then
		        InvisTarget = v
			elseif distance > range then
			    InvisTarget = nil
		    end
		end
	end
	target = InvisTarget
end


function onClose()
	collectgarbage("collect")
	if registered then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,onLoad)
		registered = false
	end
end

script:RegisterEvent(EVENT_CLOSE,onClose)
script:RegisterEvent(EVENT_TICK,onLoad)

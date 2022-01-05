
local _M = loadPrevious(...)


function _M:getTalentDesc(item)
	self.last_drawn_talent = item.talent
	local text = tstring{}

	if config.settings.cheat and item.talent then
 		text:add({"color", "GOLD"}, {"font", "bold"}, util.getval(item.rawname, item), " (", self.actor:getTalentFromId(item.talent).id,")", {"color", "LAST"}, {"font", "normal"})
	else
 		text:add({"color", "GOLD"}, {"font", "bold"}, util.getval(item.rawname, item), {"color", "LAST"}, {"font", "normal"})
 	end
	text:add(true, true)

	if item.type then
		text:add({"color",0x00,0xFF,0xFF}, _t"Talent Category", true)
		text:add({"color",0x00,0xFF,0xFF}, _t"A talent category contains talents you may learn. You gain a talent category point at level 10, 20 and 34. You may also find trainers or artifacts that allow you to learn more.\nA talent category point can be used either to learn a new category or increase the mastery of a known one.", true, true, {"color", "WHITE"})

		if self.actor.talents_types_def[item.type].generic then
			text:add({"color",0x00,0xFF,0xFF}, _t"Generic talent tree", true)
			text:add({"color",0x00,0xFF,0xFF}, _t"A generic talent allows you to perform various utility actions and improve your character. It represents a skill anybody can learn (should you find a trainer for it). You gain one point every level (except every 5th level). You may also find trainers or artifacts that allow you to learn more.", true, true, {"color", "WHITE"})
		else
			text:add({"color",0x00,0xFF,0xFF}, _t"Class talent tree", true)
			text:add({"color",0x00,0xFF,0xFF}, _t"A class talent allows you to perform new combat moves, cast spells, and improve your character. It represents the core function of your class. You gain one point every level and two every 5th level. You may also find trainers or artifacts that allow you to learn more.", true, true, {"color", "WHITE"})
		end

		text:add(self.actor:getTalentTypeFrom(item.type).description)

	else
		local t = self.actor:getTalentFromId(item.talent)

		local unlearnable, could_unlearn = self:isUnlearnable(t, true)
		if unlearnable then
			local max = tostring(self.actor:lastLearntTalentsMax(t.generic and "generic" or "class"))
			text:add({"color","LIGHT_BLUE"}, _t"This talent was recently learnt; you can still unlearn it.", true, ("The last %d %s talents you learnt are always unlearnable."):tformat(max, t.generic and _t" generic" or _t" class"), " ", {"color","LAST"}, true, true)
		elseif t.no_unlearn_last then
			text:add({"color","YELLOW"}, _t"This talent can alter the world in a permanent way; as such, you can never unlearn it once known.", {"color","LAST"}, true, true)
		elseif could_unlearn then
			local max = tostring(self.actor:lastLearntTalentsMax(t.generic and "generic" or "class"))
			text:add({"color","LIGHT_BLUE"}, _t"This talent was recently learnt; you can still unlearn it if you are out of combat or in a quiet area like a #{bold}#town#{normal}#.", true, ("The last %d %s talents you learnt are always unlearnable."):tformat(max, t.generic and _t" generic" or _t" class"), {"color","LAST"}, true, true)
		end

		local traw = self.actor:getTalentLevelRaw(t.id)
		local lvl_alt = self.actor:alterTalentLevelRaw(t, traw) - traw
		if config.settings.tome.show_detailed_talents_desc then
			local list = {}
			for i = 1, math.max(5, self:getMaxTPoints(t)) do -- the changes
				local d = self.actor:getTalentReqDesc(item.talent, i-traw):toTString():tokenize(" ()[]")
				d:merge(self.actor:getTalentFullDescription(t, i-traw))
				list[i] = d
				-- list[i] = d:tokenize(tokenize_number.decimal)
			end			
			text:add({"font", "bold"}, _t"Current talent level: "..traw)
			if lvl_alt ~= 0 then text:add((" (%+0.1f bonus level)"):tformat(lvl_alt)) end
			text:add({"font", "normal"}, true)
			text:merge(tstring:diffMulti(list, function(diffs, res)
				for i, d in ipairs(diffs) do
					if i ~= traw then
						res:add{"color", "YELLOW_GREEN"}
					else
						res:add{"color", "LIGHT_GREEN"}
						res:add{"font", "bold"}
					end
					res:add(d.str)
					if i == traw then
						res:add{"font", "normal"}
					end
					res:add{"color", "LAST"}
					if i < #list then res:add(", ") end
				end
			end))
			text:add(true, true, {"font", "italic"}, {"color", "GREY"}, _t"<Press 'x' to swap to simple display>", {"color", "LAST"}, {"font", "normal"})
		else
			local diff_full = function(i2, i1, res)
				res:add({"color", "LIGHT_GREEN"}, i1, {"color", "LAST"}, " [->", {"color", "YELLOW_GREEN"}, i2, {"color", "LAST"}, "]")
			end
			local diff_color = function(i2, i1, res)
				res:add({"color", "LIGHT_GREEN"}, i1, {"color", "LAST"})
			end
			if traw == 0 then
				local req = self.actor:getTalentReqDesc(item.talent, 1):toTString():tokenize(" ()[]")
				text:add{"color","WHITE"}
				text:add({"font", "bold"}, _t"First talent level: ", tostring(traw+1))
				if lvl_alt ~= 0 then text:add((" (%+0.1f bonus level)"):tformat(lvl_alt)) end
				text:add({"font", "normal"}, true)
				text:merge(req)
				text:merge(self.actor:getTalentFullDescription(t, 1000):diffWith(self.actor:getTalentFullDescription(t, 1), diff_color))
			elseif traw < self:getMaxTPoints(t) then
				local req = self.actor:getTalentReqDesc(item.talent):toTString():tokenize(" ()[]")
				local req2 = self.actor:getTalentReqDesc(item.talent, 1):toTString():tokenize(" ()[]")
				text:add{"color","WHITE"}
				text:add({"font", "bold"}, traw == 0 and _t"Next talent level" or _t"Current talent level: ", tostring(traw), " [-> ", tostring(traw + 1), "]")
				if lvl_alt ~= 0 then text:add((" (%+0.1f bonus level)"):tformat(lvl_alt)) end
				text:add({"font", "normal"}, true)
				text:merge(req2:diffWith(req, diff_full))
				text:merge(self.actor:getTalentFullDescription(t, 1):diffWith(self.actor:getTalentFullDescription(t), diff_full))
			else
				local req = self.actor:getTalentReqDesc(item.talent):toTString():tokenize(" ()[]")
				text:add({"font", "bold"}, _t"Current talent level: "..traw)
				if lvl_alt ~= 0 then text:add((" (%+0.1f bonus level)"):tformat(lvl_alt)) end
				text:add({"font", "normal"}, true)
				text:merge(req)
				text:merge(self.actor:getTalentFullDescription(t, 1000):diffWith(self.actor:getTalentFullDescription(t), diff_color))
			end
			text:add(true, true, {"font", "italic"}, {"color", "GREY"}, _t"<Press 'x' to swap to advanced display>", {"color", "LAST"}, {"font", "normal"})
		end
	end

	return text
end

return _M 

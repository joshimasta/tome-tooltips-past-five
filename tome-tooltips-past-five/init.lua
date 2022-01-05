-- ToME - Tales of Maj'Eyal:
-- Copyright (C) 2009, 2010, 2011 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

long_name = "Tooltips Past Level 5"
short_name = "tooltips_past_five"
for_module = "tome"
version = {1,7,3}
addon_version = {1, 0, 0}
weight = 100000
author = { "joshimasta" }
homepage = ""
description = [[If you can level up a talent past level 5, you can compare the new levels (literally 1 row changed, I think it is a bug).
Intended for Infinite Dungeon after level 50, when you can level up talents past 5. Should not change anything else in the base game.
Probably all addons with more than 5 talent levels (if any) already fix this.

Compatibilty: overrides _M:getTalentDesc at mod/dialogs/LevelupDialog.lua
Weight 100 000 (Intended to load before any other changes, that potentially change the function without completely overriding it.)]]
tags = {'infinite', "infinite dungeon", "talent"}
overload = false
superload = true
hooks = false
data = false

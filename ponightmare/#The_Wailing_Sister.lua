function event_say(e)
	if (e.message:findi("hail")) then
		e.self:Emote("cackles as she assaults you.");
		e.self:SetSpecialAbility(19, 0); -- Immune to melee off
		e.self:SetSpecialAbility(20, 0); -- Immune to magic off
		e.self:SetSpecialAbility(24, 0); -- Will not aggro off
		e.self:SetSpecialAbility(25, 0); -- Immune to aggro off
		e.self:SetSpecialAbility(35, 0); -- No harm from client off
		e.self:AddToHateList(e.other, 1); -- Attack player
	end
end

function event_trade(e)
	local item_lib = require("items");
	item_lib.return_items(e.self, e.other, e.trade);
end
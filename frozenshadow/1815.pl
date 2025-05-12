sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        # Cast the spell only if the buff is not already present
        $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);
    }
}

sub EVENT_HP { 
    if ($npc->GetHPRatio() <= 50) {
        quest::modifynpcstat("special_abilities", "46,1");
    }
}

sub EVENT_DEATH_COMPLETE {
    # 25% chance to spawn NPC 1818
    my $random_chance = int(rand(100)) + 1;
    if ($random_chance <= 25) {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $npc_heading = $npc->GetHeading();

        # Spawn NPC 1818 at the same location as the dead NPC
        quest::spawn2(1818, 0, 0, $npc_x, $npc_y, $npc_z, $npc_heading);
    }
}
sub EVENT_SPAWN {
    # Shout a message when NPC 1382 spawns
    quest::shout("Venril, my love! Now that we stand together once again, let us bathe in their blood and revel in their despair!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has entered combat, start the spell casting timer
        quest::settimer("cast_spells", 30);  # Set a timer to cast spells every 30 seconds
        
        # Immediately cast a spell on the player
        my $target = $npc->GetHateTop();  # Get the top target from the hate list
        if ($target) {
            my $spell_to_cast = int(rand(2)) == 0 ? 887 : 36870;  # Randomly select between spell 887 and 36870
            quest::castspell($spell_to_cast, $target->GetID());  # Cast the selected spell on the player
        }
    } elsif ($combat_state == 0) {
        # NPC has left combat, stop the spell casting timer
        quest::stoptimer("cast_spells");
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_spells") {
        # Randomly decide which spell to cast (887 or 36870)
        my $spell_to_cast = int(rand(2)) == 0 ? 887 : 36870;  # 50/50 chance

        # Find a target (the player engaged in combat)
        my $target = $npc->GetHateTop();  # Get the top target from hate list

        if ($target) {
            # Cast the selected spell on the target player
            quest::castspell($spell_to_cast, $target->GetID());  # Cast the spell on the player
        }
    }
}

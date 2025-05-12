# Life Drain Totem Script for NPC ID 1255

my $totem_blast_spell_id = 33638;  # Spell ID for Totem Blast
my $totem_heal_spell_id = 33639;   # Spell ID for Totem Heal
my $heal_amount = 100;             # Amount of healing for the boss
my $boss_id = 223003;              # NPC ID for the boss

sub EVENT_SPAWN {
    quest::settimer("cast", 30);  # Set timer to alternate casting every 30 seconds
}

sub EVENT_TIMER {
    if ($timer eq "aoe_cast") {
        # Cast Totem Blast on all players
        my @players = $entity_list->GetClientList();
        foreach my $player (@players) {
            quest::castspell(33638, $player->GetID());  # Totem Blast spell
        }
        # Schedule the next spell to be cast
        quest::settimer("aoe_cast", 20);
    }

    if ($timer eq "heal_cast") {
        # Heal the boss with Totem Heal
        quest::castspell(33639, $npc->GetID());  # Totem Heal spell
        # Schedule the next spell to be cast
        quest::settimer("heal_cast", 30);
    }
}

sub EVENT_DEATH_COMPLETE {
    # Cleanup on death
    quest::stoptimer("aoe_cast");
    quest::stoptimer("heal_cast");
}

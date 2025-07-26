# Life Drain Totem Script for NPC ID 1255

my $totem_blast_spell_id = 33638;  # Totem Blast
my $totem_heal_spell_id  = 33639;  # Totem Heal
my $boss_id = 223003;              # NPC ID of boss to heal
my $next_cast = "aoe";             # Start with AoE cast

sub EVENT_SPAWN {
    quest::settimer("cast_cycle", 30);
}

sub EVENT_TIMER {
    return unless $timer eq "cast_cycle";

    if ($next_cast eq "aoe") {
        my @players = $entity_list->GetClientList();
        foreach my $player (@players) {
            quest::castspell($totem_blast_spell_id, $player->GetID());
        }
        $next_cast = "heal";
    } else {
        my $boss = $entity_list->GetNPCByNPCTypeID($boss_id);
        if ($boss) {
            quest::castspell($totem_heal_spell_id, $boss->GetID());
        }
        $next_cast = "aoe";
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("cast_cycle");
}
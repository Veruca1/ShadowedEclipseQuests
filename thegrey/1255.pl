# Life Drain Totem Script for NPC ID 1255

my $totem_blast_spell_id = 40766;  # Spell ID for Totem Blast
my $totem_heal_spell_id = 40767;   # Spell ID for Totem Heal
my $boss_id = 2177;                # NPC ID for the boss
my $next_cast = "aoe";             # Track next cast type

sub EVENT_SPAWN {
    plugin::Debug("Totem spawned. Starting cast cycle timer.");
    quest::settimer("cast_cycle", 30);
}

sub EVENT_TIMER {
    return unless $timer eq "cast_cycle";

    if ($next_cast eq "aoe") {
        plugin::Debug("Casting Totem Blast on all players.");
        my @players = $entity_list->GetClientList();
        foreach my $player (@players) {
            quest::castspell($totem_blast_spell_id, $player->GetID());
            plugin::Debug("Casting Totem Blast on " . $player->GetCleanName());
        }
        $next_cast = "heal";
    } else {
        plugin::Debug("Casting Totem Heal on boss ID $boss_id.");
        my $boss = $entity_list->GetNPCByNPCTypeID($boss_id);
        if ($boss) {
            quest::castspell($totem_heal_spell_id, $boss->GetID());
            plugin::Debug("Totem Heal cast on " . $boss->GetCleanName());
        } else {
            plugin::Debug("Boss ID $boss_id not found.");
        }
        $next_cast = "aoe";
    }
}

sub EVENT_DEATH_COMPLETE {
    plugin::Debug("Totem died. Stopping cast cycle timer.");
    quest::stoptimer("cast_cycle");
}
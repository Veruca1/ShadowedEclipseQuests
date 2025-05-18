# A_burrower_parasite event outcome handler

# Define all spells here for easy modification
my @root_spells = (
    40731,  # Burrower Parasite Trance (current root spell)
    # Add more spell IDs here if needed
);

sub EVENT_SPAWN {
    quest::settimer("countdown", 1800); # 30-minute fail-safe timer
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::debug("Combat started, starting root spell timer");
        quest::settimer("apply_root", 60); # Cast root spell every 60 seconds
    } else {
        quest::debug("Combat ended, stopping root spell timer");
        quest::stoptimer("apply_root");
    }
}

sub EVENT_TIMER {
    if ($timer eq "countdown") {
        quest::debug("Countdown timer expired, signaling failure and despawning");
        quest::signalwith(164098, 101); # Signal failure
        quest::depop();
    }
    elsif ($timer eq "apply_root") {
        apply_root_spells();
    }
}

sub apply_root_spells {
    my $cx = $npc->GetX();
    my $cy = $npc->GetY();
    my $cz = $npc->GetZ();

    quest::debug("apply_root_spells: NPC location = ($cx, $cy, $cz)");

    my @clients = $entity_list->GetClientList();
    quest::debug("apply_root_spells: Found " . scalar(@clients) . " clients.");

    foreach my $client (@clients) {
        my $dist = $client->CalculateDistance($cx, $cy, $cz);
        quest::debug("Checking client " . $client->GetCleanName() . " (ID: " . $client->GetID() . ") at distance $dist");

        if ($dist <= 100) {
            foreach my $spell_id (@root_spells) {
                quest::debug(" -> In range. NPC casting spell $spell_id on " . $client->GetCleanName());
                $npc->CastSpell($spell_id, $client->GetID());
            }
        } else {
            quest::debug(" -> Out of range. No action on " . $client->GetCleanName());
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::debug("NPC died, signaling reset and stopping timers");
    quest::signalwith(164111, 101); # Immediate event reset
    quest::stoptimer("countdown");
    quest::stoptimer("apply_root");
}
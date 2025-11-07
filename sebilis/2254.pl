sub EVENT_SPAWN {
    return unless $npc;
    # Delay tint to ensure model loads before applying
    quest::settimer("init_effects", 1);
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");
        $npc->SetNPCTintIndex(30);  # Apply black tint
    }
}
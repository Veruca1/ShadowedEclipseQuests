# ===========================================================
# Nitram_Anizok — Plane of Innovation
# Shadowed Eclipse: The Reforging of Xanamech
# - Players collect seven corrupted machine components.
# - Hand them in to receive the Plane of Innovation flag.
# - Once flagged, players may say "READY" to summon Xanamech.
# - Only one Xanamech may exist at a time.
# ===========================================================

sub EVENT_SPAWN {

     # Explicit level set for tuning consistency
     $npc->SetLevel(70);

    # Remove any leftover real Xanamech to prevent duplication
    if ($entity_list->IsMobSpawnedByNpcTypeID(206067)) {
        quest::depop(206067);
    }
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        # Check if player has flag
        if (!defined $qglobals{pop_poi_dragon}) {
            quest::whisper("Ah, greetings, $name... I remember your kind — bright eyes dulled by purpose. If you wish to awaken the *Xanamech Dragon*, you must rebuild what was lost... though some pieces now whisper with another’s voice.");
            quest::whisper("Seek and bring me these seven components:");
            quest::whisper(" - Seared Gear Assembly");
            quest::whisper(" - Fractured Power Lattice");
            quest::whisper(" - Twisted Servo Array");
            quest::whisper(" - Corrupted Steam Core");
            quest::whisper(" - Null-Coded Conductor");
            quest::whisper(" - Screaming Resonance Coil");
            quest::whisper(" - Coven-Link Neural Shard");
            quest::whisper("Only when all seven lie before me will the heart of Xanamech beat once more... for better or worse.");
        } 
        else {
            quest::say("Ah, $name — your work is complete. The pieces are restless, humming beneath the floorboards. When you're ready, say [" 
                . quest::saylink("READY") . "] and we shall awaken it once more.");
        }
    }

    if ($text =~ /ready/i) {
        # Prevent multiple Xanamechs
        if ($entity_list->IsMobSpawnedByNpcTypeID(206067)) {
            $client->Message(13, "Nitram says, 'Patience, $name... the machine stirs already. One Xanamech at a time, lest it tear the factory apart.'");
            return;
        }

        # Spawn real Xanamech at the original coordinates
        quest::spawn2(206067, 0, 0, -735, 1580, -50, 251.6);
        $client->Message(15, "Nitram says, 'Brace yourself, $name... the factory remembers. The Xanamech has awakened once more.'");
    }
}

sub EVENT_ITEM {
    # === Hand-in: Items 1 through 7 ===
    if (plugin::check_handin(\%itemcount,
        67758 => 1,  # Seared Gear Assembly
        67759 => 1,  # Fractured Power Lattice
        67760 => 1,  # Twisted Servo Array
        67761 => 1,  # Corrupted Steam Core
        67762 => 1,  # Null-Coded Conductor
        67763 => 1,  # Screaming Resonance Coil
        67764 => 1   # Coven-Link Neural Shard
    )) {

        # === Give character flag ===
        quest::setglobal("pop_poi_dragon", 1, 5, "F");
        $client->Message(4, "You receive a character flag!");
        $client->Message(15, "Nitram says, 'Excellent... the machine's heart is whole again. When you're ready, say [" 
            . quest::saylink("READY") . "] and see what your creation truly remembers.'");
    }
    plugin::return_items(\%itemcount);
}
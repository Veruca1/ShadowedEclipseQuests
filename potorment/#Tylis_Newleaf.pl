# ===============================================================
# #Tylis_Newleaf.pl — Plane of Torment (potorment)
# Shadowed Eclipse: Post-Saryrn Flag NPC (DZ-Compatible)
# ---------------------------------------------------------------
# - Rewards Plane of Torment flag upon hail
# - Thanks players after Saryrn's defeat
# - Teleports them safely back within their instance
# ===============================================================

sub EVENT_SPAWN {
    quest::settimer(1, 300);
}

sub EVENT_TIMER {
    if ($timer eq "1") {
        quest::stoptimer(1);
        quest::depop();
    }
}

sub EVENT_SAY {
    my $ready_link = quest::saylink("ready", 1);

    if ($text =~ /hail/i) {
        quest::whisper("I must thank you for your kind efforts, friends. This place has laid claim to me for far too long. Please take care and offer the dark wench my best. I am off... and I suggest you not stray too far from that route yourselves. Please tell me when you are $ready_link to return, and may your blades strike true!");
    }

    elsif ($text =~ /ready/i) {
        my $instance_id = $client->GetInstanceID();
        $client->Message(4, "Your tormented visions have ended.");
        $client->MovePCInstance(207, $instance_id, -16, -49, 452, 0);
    }
}

# End of File — Zone: potorment — ID: 207066 — #Tylis_Newleaf
# Updated for Shadowed Eclipse Dynamic Zone Instance Support
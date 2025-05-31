sub EVENT_SPAWN {
    quest::settimer("cryptic_shout", 120);     # Every 2 minutes
    quest::settimer("moonrock_summon", 75);    # Every 1.25 minutes
    quest::shout("We meet again so soon!");
    $npc->AddNimbusEffect(611);
}

sub EVENT_TIMER {
    if ($timer eq "cryptic_shout") {
        my @shouts = (
            "The Sanctum of Dust sings still… but the song is missing its final verse.",
            "The Forgotten Lyceum… a library of memory stripped from the living mind.",
            "Even now, the Watch sees you. What will it reflect back when you fall?",
            "Quorra`Zel does not yield her Bastion lightly. Are you worthy of her Oath?",
            "Nyseria’s threads are wrapped tighter now. She pulls… not to embrace, but to unravel.",
            "You think Luclin is unaware? She dreamed of you long before Nyseria whispered your name.",
            "The Umbral Chorus plays dissonance and silence in equal measure.",
            "Some say the Eclipse was a warning. Others say it was a calling.",
            "You climb towers of forgotten stone. But whose design do you think carved the stair?",
            "She tests you not to recruit… but to break. Nyseria wants your *ruin*, not your allegiance.",
            "You are seen. Not just by me, but by *Her*. The one behind the Mirror Moon.",
            "Each of you is a note in the Chorus. Discordant. Unresolved. A threat."
        );

        my $shout = $shouts[int(rand(@shouts))];
        quest::shout($shout);

        # Apply Buffs
        my @buffs = (
            5278,   # Hand of Conviction
            5297,   # Brell's Brawny Bulwark
            5488,   # Circle of Fireskin
            10028,  # Talisman of Persistence
            10031,  # Talisman of the Stoic One
            10013,  # Talisman of Foresight
            10664,  # Voice of Intuition
            9414,   # Holy Battle Hymn V
            300,    # Boon of the Avenging Angel IV
            15031,  # Strength of Gladwalker
            2530,   # Khura's Focusing
            24061   # Lunar Nimbus
        );

        foreach my $spell_id (@buffs) {
            $npc->ApplySpellBuff($spell_id);
        }
    }

    elsif ($timer eq "moonrock_summon") {
        quest::shout("By the shadow of the Mirror Moon, I summon the Moon Rocks to seek the intruders!");

        my $count = int(rand(3)) + 1;  # Random number between 1 and 3

        for (my $i = 0; $i < $count; $i++) {
            quest::spawn2(1974, 0, 0, -179.06, 944.16, -144.16, 0);
        }
    }
}
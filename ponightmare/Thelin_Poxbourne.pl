#Thelin_Poxbourne

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("Thelin Poxbourne",
            "You've made it through the maze... but the nightmare isn't over just yet.<br><br>"
            . "There are five creatures lurking in the hedges—guardians twisted by fear and shadow. Each carries a piece of the nightmare.<br><br>"
            . "Seek them out:<br>"
            . "<c \"#FFD700\">The Scourge Hobgoblin</c><br>"
            . "<c \"#FFD700\">The Gnarled Treant</c><br>"
            . "<c \"#FFD700\">The Dark Visage</c><br>"
            . "<c \"#FFD700\">The Nightstalker</c><br>"
            . "<c \"#FFD700\">The Coven Wolf</c><br><br>"
            . "From each of them, recover their cursed token:<br>"
            . "<c \"#E0E070\">Shard of the Hobgoblin</c><br>"
            . "<c \"#E0E070\">Splintered Treant Branch</c><br>"
            . "<c \"#E0E070\">Veil of the Visage</c><br>"
            . "<c \"#E0E070\">Nightstalker Fang</c><br>"
            . "<c \"#E0E070\">Coven Wolf Paw</c><br><br>"
            . "Combine them in your Tier Kit to create the <c \"#E0E070\">Black Bastardsword</c>.<br>"
            . "Return the sword to me, and I shall summon the Construct of Nightmares. But beware—once called, it cannot be stopped."
        );
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 26039 => 1)) {
        quest::say("The sword is complete. You have done well. Prepare yourself!");
        quest::spawn2(204064, 0, 0, $x, $y, $z, 0); # NPC: #a_construct_of_nightmares
    }
    elsif (plugin::check_handin(\%itemcount, 9258 => 1)) {
        $dagger = 1;
        quest::emote("takes the dagger blade shard and channels its dark energy, forging it into a spectral weapon. Thelin picks up the newly formed blade and hands it to you.");
        quest::summonitem(9259); # Thelin's Dagger
        quest::exp(100000); # unconfirmed
        quest::spawn2(204065, 0, 0, -4554, 5018, 5, 260); # NPC: #Terris_Thule
        quest::depop();
        $spawn_mob1 = undef;
        $spawn_CYCLE = undef;
        $flag = undef;
        $dagger = undef;
        quest::spawn2(204067, 0, 0, $x, $y, $z, 0); # NPC: __Thelin_Poxbourne
    }
    else {
        plugin::return_items(\%itemcount);
    }
}
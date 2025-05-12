sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-tunare_spawn_flag";  # The flag for allowing Tunare to spawn

    my $ready_link = quest::saylink("READY", 1, "Ready");
    my $tunare_link = quest::saylink("TUNARE", 1, "Tunare");

    if ($text=~/hail/i) {
        quest::whisper("Ah, a visitor in these troubled times. You stand before me at a most peculiar moment. The Plane of Growth is not as it once was. There have been recent... disturbances.");
        quest::whisper("If you are prepared to prove your strength, say $ready_link and I will begin the trial.");

        # If player has the flag, show the option to summon Tunare
        if (quest::get_data($flag)) {
            quest::whisper("You have already proven yourself. When you are ready, say $tunare_link to summon Tunare.");
        }

        quest::popup("The Plane of Growth in Distress", "
        <c '#FFCC00'>*The totem stands in silence, its presence emanating a faint glow as it begins to speak, its voice filled with sorrow.*</c><br><br>

        \"Adventurer, the Plane of Growth is no longer as it was. Something has changed, and I feel the weight of it pressing on the very fabric of this sacred place. There have been strange visitors, a coven, whose presence I do not support. Their actions have disturbed the guardians and defenders of this realm, leaving them in an eerie silence.\"<br><br>

        <c '#FFCC00'>*The totem pauses, its glow dimming slightly, as if reflecting the sorrow of the land itself.*</c><br><br>

        \"I am not for their cause, but I will not question Tunare’s will. If She deems it fit for you to pass, then you must first prove your worth. You must face the champions of Tunare and defeat them before you may stand before Her.\"<br><br>

        <c '#FFCC00'>*The totem’s voice grows slightly stronger as it speaks again.*</c><br><br>

        \"Prepare yourself, adventurer, and face the trial that awaits.\"<br><br>

        <c '#FFCC00'>*The totem waits in silence, its presence unwavering.*</c><br><br>
        ");
    }

    if ($text=~/ready/i) {
        quest::whisper("The trial begins. Prepare yourself!");
        quest::signalwith(10, 1, 0);  # Signal NPC ID 10 with signal 1
	quest::depop();
    }

    if ($text=~/tunare/i) {
        if (quest::get_data($flag)) {
            quest::whisper("Very well, adventurer. You have proven your worth. Tunare awaits you.");
            
            # Spawn Tunare (NPC ID 127098) at the totem location
            quest::spawn2(1873, 0, 0, $x, $y, $z, $h);

            # Depop the totem after spawning Tunare
            quest::depop();
        } else {
            quest::whisper("You must prove yourself before you can summon Tunare.");
        }
    }
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $flag = "$char_id-tunare_spawn_flag";
    my $tunare_link = quest::saylink("TUNARE", 1, "Tunare");

    if (plugin::check_handin(\%itemcount, 788 => 1)) {  # Head of the Class item
        quest::whisper("You have proven yourself worthy. When you are ready, say $tunare_link to summon Tunare.");
        quest::set_data($flag, 1);  # Set flag to allow spawning Tunare
    } else {
        plugin::return_items(\%itemcount);
    }
}

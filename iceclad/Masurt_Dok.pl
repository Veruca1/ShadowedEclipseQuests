sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::assigntask(29);
        my $saylink = quest::saylink("to go", 1); # Create clickable saylink
        quest::whisper("Ahoy, matey! Welcome to Iceclad! The only way to find yer bearin's 'ere is to explore the frozen wastes. I can lend ye a hand, but ye'll need to help me out too. Take care o' some o' the beasties lurkin' about, and ye'll see the tide turn in yer favor. Trust in ol' Masurt aye? If ye wish, I can send ye [$saylink] to the Great Divide.");
    }
    elsif ($text=~/to go/i) {
        quest::movepc(118, 701.03, -1085.54, 29.49, 113); # Move player to The Great Divide
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 539 => 1)) { # Check if given item 539
        quest::set_zone_flag(118); # Grant access to The Great Divide
        quest::we(14, "$name has earned access to The Great Divide!"); # Announce to the zone
        my $saylink = quest::saylink("to go", 1); # Create the saylink
        quest::whisper("Arr, ye now 'ave access to The Great Divide! Seek out an old friend there; they'll guide ye further on this journey. Would ye like to [$saylink] there now?");
    }
    elsif (plugin::check_handin(\%itemcount, 512 => 1)) { # Check if given item 512
        quest::set_zone_flag(111); # Grant access to Tower of Frozen Shadows
        quest::we(14, "$name has earned access to The Tower of Frozen Shadows!"); # Announce to the zone
        quest::whisper("Well, ye now 'ave access to that terrible tower. Not sure why ye'd want to go in there. Nobody ever leaves, and that's by choice. Word is, some veiled influence 'as made Tserrina 'erself change 'er focus. Good luck, matey, ye'll need it!");
    }
    elsif (plugin::check_handin(\%itemcount, 528 => 1)) { # Check if given item 528
        quest::set_zone_flag(121); # Grant access to Crystal Caverns
        quest::we(14, "$name has earned access to The Crystal Caverns!"); # Announce to the zone
        quest::whisper("Congratulations, adventurer! The Crystal Caverns await ye. Watch out for the shadows, and tread carefully through the caverns' icy embrace.");
    }
    elsif (plugin::check_handin(\%itemcount, 518 => 1)) { # Check if given item 518
        quest::set_zone_flag(116); # Grant access to Eastern Wastes
        quest::we(14, "$name has earned access to The Eastern Wastes!"); # Announce to the zone
        quest::whisper("Ye've earned yer passage to the Eastern Wastes. Watch yer step, it's a treacherous land out there!");
    }
    elsif (plugin::check_handin(\%itemcount, 60333 => 1)) { # Special handling for 60333
        quest::whisper("Thank ye kindly for this, matey! I'll put it to good use.");
        # Item is not returned intentionally.
    }
    else {
        plugin::return_items(\%itemcount); # Return any items that don't match
    }
}

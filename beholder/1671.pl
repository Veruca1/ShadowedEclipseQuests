sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::whisper("Yo, yo, yo! It's LL Cool Bard, the spinner of legendary beats and boss battles! If you bring me a " . quest::saylink("record", 1) . ", I can spin it up for you. Need a record? Talk to Vinyl Vanguard, the best dealer in town!");
    }
    if ($text =~ /record/i) {
        quest::whisper("A record? Oh yeah, that's my thing. Each one summons a boss to test your mettle. Go see Vinyl Vanguard if you need to buy one!");
    }
}

sub EVENT_ITEM {
    # Ghost of Glass Joe Record
    if (plugin::check_handin(\%itemcount, 102474 => 1)) {
        if (!quest::isnpcspawned(1672)) {
            quest::whisper("Alright, spinning 'The Ghost of Glass Joe'! Get ready for a nostalgic jab!");
            quest::spawn2(1672, 0, 0, -599.36, 494.95, -67.94, 55.25);
        } else {
            quest::whisper("Looks like there's already a boss spawned! Take care of that first, then come back to me.");
        }
    }

    # Bohemian Wraithsody Record
    elsif (plugin::check_handin(\%itemcount, 570 => 1)) {
        if (!quest::isnpcspawned(1674)) {
            quest::whisper("Alright, spinning 'Bohemian Wraithsody'! Prepare for a spectral showdown!");
            quest::spawn2(1674, 0, 0, -599.36, 494.95, -67.94, 55.25);
        } else {
            quest::whisper("Looks like there's already a boss spawned! Take care of that first, then come back to me.");
        }
    }

    # I Need a Hero Record
    elsif (plugin::check_handin(\%itemcount, 580 => 1)) {
        if (!quest::isnpcspawned(1695)) {
            quest::whisper("Alright, spinning 'I Need a Hero'! Boney Tyler is about to make his entrance!");
            quest::spawn2(1695, 0, 0, -599.36, 494.95, -67.94, 55.25);
        } else {
            quest::whisper("Looks like there's already a boss spawned! Take care of that first, then come back to me.");
        }
    }

    # Rockin Raven Vinyl Record
    elsif (plugin::check_handin(\%itemcount, 617 => 1)) {
        if (!quest::isnpcspawned(1710)) {
            quest::whisper("Yo, yo, yo! You brought the 'Rockin Raven Vinyl'! Time to drop some sick beats with the Raven King!");
            quest::spawn2(1710, 0, 0, -599.36, 494.95, -67.94, 55.25);
        } else {
            quest::whisper("Looks like the Raven King is already rocking! Take care of him first, then come back to me.");
        }
    }

    # Season of the Witch Record
    elsif (plugin::check_handin(\%itemcount, 651 => 1)) {
        if (!quest::isnpcspawned(1739)) {
            quest::whisper("Oh snap! Spinning 'Season of the Witch'! Get ready for some supernatural chaos!");
            quest::spawn2(1739, 0, 0, -599.36, 494.95, -67.94, 55.25);
        } else {
            quest::whisper("The Witch is already in season! Handle it first, then come back to me.");
        }
    }

    # Bulls on Parade Record
    elsif (plugin::check_handin(\%itemcount, 707 => 1)) {
        if (!quest::isnpcspawned(1789)) {
            quest::whisper("Oh hell yeah! Spinning 'Bulls on Parade'! Get ready for a raging stampede!");
            quest::spawn2(1789, 0, 0, -599.36, 494.95, -67.94, 55.25);
        } else {
            quest::whisper("Bald Bull is already in the ring! Knock him out first, then come back to me.");
        }
    }

    # I Got You Babe Record
    elsif (plugin::check_handin(\%itemcount, 791 => 1)) {
        if (!quest::isnpcspawned(1786) && !quest::isnpcspawned(1787)) {
            quest::whisper("Spinning 'I Got You Babe'! Get ready for a duet with trouble!");
            quest::spawn2(1836, 0, 0, -559.79, 638.39, -94.67, 135.25);
            quest::spawn2(1837, 0, 0, -462.95, 561.70, -94.69, 506);
        } else {
            quest::whisper("Looks like the duet is already in progress! Handle that first, then come back to me.");
        }
    }

    else {
        quest::whisper("Yo, I don't know what this is, but it ain't a record I can spin!");
        plugin::return_items(\%itemcount);
    }
}

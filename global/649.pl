ssub EVENT_EQUIP_ITEM {
    if ($slotid == 3) {  # Check if the item is equipped in slot 3
        if ($itemid == 649) {  # Malfoy's Mask item ID
            quest::debug("Malfoy's Mask equipped!");  # Log to debug log
            if (!$qglobals{"malfoy_insult"}) {  # Prevent duplicate timers using global
                quest::setglobal("malfoy_insult", $client->GetID(), 5, "F");  # Set the global to client ID
                quest::settimer("malfoy_insult", 30);  # Start insult timer
            } else {
                quest::debug("Malfoy's Mask already active.");  # Log to debug log
            }
        }
    }
}

sub EVENT_ITEM {
    # Additional code here if you want to handle item turn-ins, but it's not needed for the equip logic
}

sub EVENT_TIMER {
    if ($timer eq "malfoy_insult") {
        my $client = $entity_list->GetClientByID($qglobals{"malfoy_insult"});  # Retrieve client object
        if ($client && $client->GetItemIDAt(3) == 649) {  # Ensure client exists and is still wearing mask
            my $chance = int(rand(100));  
            if ($chance < 20) {  # 20% chance to insult
                my @insults = (
                    "Draco Malfoy's voice echoes: 'You really think you look good in this? Pathetic.'",
                    "Draco Malfoy sneers: 'Filthy Mudblood. How *dare* you wear my legacy?'",
                    "You hear Draco’s mocking voice: 'My *father* would *buy* ten of these just to burn them.'",
                    "Draco’s arrogance lingers: 'I should have been in the Slug Club, not you!'",
                    "Draco scoffs: 'I don't lose. This must be some sort of mistake.'",
                    "Draco Malfoy whines: 'Why does Potter *always* get the attention? I should be the hero!'",
                    "You hear Malfoy grumble: 'Ugh, I can *smell* the poverty on you... disgusting.'",
                    "Draco mutters: 'If only the Dark Lord was still here. He’d make you *suffer*.'",
                    "Draco’s voice sneers: 'You’ll never be more than a *side character* in my story.'",
                    "A ghostly Malfoy mutters: 'This isn't fair! I was supposed to *win*!'"
                );

                my $random_insult = $insults[rand @insults];
                $client->Message(15, $random_insult);
            }
        } else {
            quest::stoptimer("malfoy_insult");  # Stop if the mask is removed
            quest::delglobal("malfoy_insult");
        }
    }
}

sub EVENT_DEATH {
    quest::stoptimer("malfoy_insult");
    quest::delglobal("malfoy_insult");
}

sub EVENT_ZONE {
    quest::stoptimer("malfoy_insult");
    quest::delglobal("malfoy_insult");
}

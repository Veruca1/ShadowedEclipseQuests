sub EVENT_SPAWN {
    quest::setnexthpevent(80); # Set the first HP event at 80%
}

sub EVENT_AGGRO {
    quest::shout("We have intruders! Prepare the cells!"); # Zone shout on engage
    #quest::debug("EVENT_AGGRO fired for NPC ID: $npc->GetID()"); # Debug message
}

sub EVENT_HP {
    if ($hpevent == 80) {
        my @hate_list = $npc->GetHateList();
        foreach my $hate_entry (@hate_list) {
            my $ent = $hate_entry->GetEnt();
            if ($ent && $ent->IsClient() && !$ent->IsPet()) {
                my $client = $ent->CastToClient();
                if ($client) {
                    my $instance_id = $client->GetInstanceID();
                    $client->MovePCInstance(44, $instance_id, -90.36, -41.12, -26.50, 0.75); # Teleport the player within the instance
                    $npc->Shout("You are to be detained in Cell B, Begone!"); # Shout the message
                    last; # Stop after moving the first client found
                }
            }
        }
        quest::setnexthpevent(50); # Set the next HP event at 50%
    } elsif ($hpevent == 50) {
        my @hate_list = $npc->GetHateList();
        foreach my $hate_entry (@hate_list) {
            my $ent = $hate_entry->GetEnt();
            if ($ent && $ent->IsClient() && !$ent->IsPet()) {
                my $client = $ent->CastToClient();
                if ($client) {
                    my $instance_id = $client->GetInstanceID();
                    $client->MovePCInstance(44, $instance_id, -21.81, -86.56, -24.50, 167.50); # Teleport the player within the instance
                    $npc->Shout("You are to be detained in Cell A, Begone!"); # Shout the message
                    last; # Stop after moving the first client found
                }
            }
        }
        quest::setnexthpevent(15); # Set the next HP event at 15%
    } elsif ($hpevent == 15) {
        my @hate_list = $npc->GetHateList();
        foreach my $hate_entry (@hate_list) {
            my $ent = $hate_entry->GetEnt();
            if ($ent && $ent->IsClient() && !$ent->IsPet()) {
                my $client = $ent->CastToClient();
                if ($client) {
                    my $instance_id = $client->GetInstanceID();
                    $client->MovePCInstance(44, $instance_id, -147.93, -54.72, -26.50, 5.75); # Teleport the player within the instance
                    $npc->Shout("You are to be detained in Cell C, Begone!"); # Shout the message
                    last; # Stop after moving the first client found
                }
            }
        }
    }
}

sub EVENT_SPAWN {
    # Variables to set hp and get flag to set hp
    my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
    
    # Check if the 60% key exists; if it doesn't, set it to 60% hp event
    if (quest::get_data($hp_key) == 1) {
        quest::setnexthpevent(30);  # Trigger next HP event at 30%
        # Adjust HP if spawned with reduced health
        my $new_hp = $npc->GetMaxHP() * 0.60;
        $npc->SetHP($new_hp);
    } else {
        quest::setnexthpevent(60);  # Trigger next HP event at 60%
    }
}

sub EVENT_HP {
    # First HP check at 60%
    if ($hpevent == 60) {
        my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
        quest::set_data($hp_key, 1);

        # Get current HP percentage
        my $current_hp = $npc->GetHP();
        my $max_hp = $npc->GetMaxHP();
        my $hp_percentage = ($current_hp / $max_hp) * 100;  # Convert to percentage

        # Depop current NPC and spawn at new location with the same HP percentage
        quest::depop();
        my $x = 60.96;
        my $y = -393.62;
        my $z = -38.22;
        my $h = 207;  # Assuming 207 is heading, not spell ID
        my $boss_id = 36117;
        my $new_npc = quest::spawn2($boss_id, 0, 0, $x, $y, $z, $h);
        my $new_npc_entity = $entity_list->GetNPCByID($new_npc);
        if ($new_npc_entity) {
            my $new_hp = $new_npc_entity->GetMaxHP() * ($hp_percentage / 100);  # Adjust new NPC HP
            $new_npc_entity->SetHP($new_hp);
        }
    }
    # Second HP check at 30%
    elsif ($hpevent == 30) {
        # Make the NPC immune to all attacks for 10 seconds
        $npc->SetInvul(1);  # Make NPC invulnerable

        # Schedule an event to remove invulnerability after 10 seconds
        quest::settimer("remove_invul", 10);
    }
}

sub EVENT_TIMER {
    if ($timer eq "remove_invul") {
        quest::stoptimer("remove_invul");
        $npc->SetInvul(0);  # Remove invulnerability
    }
}

sub EVENT_DEATH_COMPLETE {
    # Deletes the key on death
    my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
    quest::delete_data($hp_key);
    
    # Shout message on death
    quest::shout("In the end... Hhhhathhaates Heaaahheaat Will BuuuuBburBurnnn YuooYouuu");
}

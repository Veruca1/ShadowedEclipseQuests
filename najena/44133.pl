my $spell_cast_80 = 0;
my $spell_cast_50 = 0;
my $spell_cast_10 = 0;

sub EVENT_SPAWN {
    # List of spell IDs to apply as buffs
    my @buffs = (167, 2177, 161, 649, 2178);

    # Spawn NPC 44134 as a pet at the same location
    my $pet_npc_id = quest::spawn2(44134, 0, 0, $x, $y, $z, $h);
    # my $pet_npc = $entity_list->GetNPCByID($pet_npc_id);
    
    # if ($pet_npc) {
    #     # Apply buffs to the pet
    #     foreach my $spell_id (@buffs) {
    #         $pet_npc->SpellFinished($spell_id, $pet_npc);
    #     }
    # } else {
    #     quest::shout("Failed to spawn pet NPC 44134.");
    # }

    # # Apply buffs to NPC 44133 itself
    # foreach my $spell_id (@buffs) {
    #     $npc->SpellFinished($spell_id, $npc);
    # }
    
    # # Set a timer to check health
    # quest::settimer("check_health", 1);

    # Add the spawn message
    quest::shout("The fires of hate, and Lords Zarrin and Xyron have been lit!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Entering combat
        my $npc44134 = $entity_list->GetNPCByID($pet_npc_id);
        
        if ($npc44134) {
            # Get the target of NPC 44133
            my $target = $npc->GetHateTop();
            if ($target) {
                # Add the target to NPC 44134's hate list
                $npc44134->AddToHateList($target, 1);
            }
        }
    } elsif ($combat_state == 0) { # Leaving combat
        my $npc44134 = $entity_list->GetNPCByID($pet_npc_id);
        
        if ($npc44134) {
            $npc44134->WipeHateList();
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_health") {
        # Check NPC 44133's health percentage
        my $npc_health = $npc->GetHP();
        my $npc_max_health = $npc->GetMaxHP();
        my $health_percent = ($npc_health / $npc_max_health) * 100;

        if ($health_percent <= 80 && $spell_cast_80 == 0) {
            my $target = $npc->GetHateTop();
            if ($target) {
                quest::shout("May you burn in Xyron's fury!");
                $npc->CastSpell(17782, $target->GetID());
                $spell_cast_80 = 1;
            }
        } 
        elsif ($health_percent <= 50 && $spell_cast_50 == 0) {
            my $target = $npc->GetHateTop();
            if ($target) {
                quest::shout("May you burn in Xyron's fury!");
                $npc->CastSpell(17782, $target->GetID());
                $spell_cast_50 = 1;
            }
        } 
        elsif ($health_percent <= 10 && $spell_cast_10 == 0) {
            my $target = $npc->GetHateTop();
            if ($target) {
                quest::shout("May you burn in Xyron's fury!");
                $npc->CastSpell(17782, $target->GetID());
                $spell_cast_10 = 1;
            }
        }
    }
}

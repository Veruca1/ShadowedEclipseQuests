my $spell_casted = 0;  # Track if the spell has been cast
my $damage_applied = 0; # Track if the 75% max HP damage has been applied

sub EVENT_SPAWN {
    $npc->CameraEffect(1000, 3);

    my @clients = $entity_list->GetClientList();
    my $text = "You hear maniacal laughter echo throughout the tomb.";
    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }

    quest::shout("We meet again my old friend! Hahahaha!");

    # Start a timer to shout and cast the spell after 20 seconds
    quest::settimer("shout_spell", 20);
}

my $minions_spawned = 0;

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat started
        quest::settimer("spell_cast", 10);  # Start casting spell every 10 seconds
        quest::settimer("minion_check", 1); # Start checking health every second
    } elsif ($combat_state == 0) {  # Combat ended
        quest::stoptimer("spell_cast");  # Stop casting spells
        quest::stoptimer("minion_check"); # Stop checking health
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cast") {
        # Cast spell if it hasn't been casted already
        if (!$spell_casted) {
            quest::castspell(40649, $npc->GetID());  # Cast the spell (ID 40649)
            $spell_casted = 1;  # Mark that the spell has been cast
        }
    }

    if ($timer eq "minion_check") {
        my $hp_ratio = $npc->GetHPRatio();

        # Trigger shout and 75% max HP damage when health is at or below 80%, only once
        if ($hp_ratio <= 80 && !$damage_applied) {
            my $hate_target = $npc->GetHateTop();
            if ($hate_target) {
                my $target_name = $hate_target->GetCleanName();
                quest::shout("$target_name! Let's see how you handle THIS!");

                # Deal 75% of the target's max HP as damage
                my $target_max_hp = $hate_target->GetMaxHP();
                my $damage = int($target_max_hp * 0.75);
                $hate_target->Damage($npc, $damage, 0, 0, 0, 0, true);  # Corrected damage method

                # Mark that the damage has been applied
                $damage_applied = 1;
            }
        }

        # Apply spell immunity, ranged immunity, and increase avoidance at 25% health
        if ($hp_ratio <= 25 && !$minions_spawned) {
            # Apply special abilities and avoidance increase
            $npc->ModifyNPCStat("special_abilities", "20,1^46,1");
            $npc->ModifyNPCStat("avoidance", "50");
            quest::shout("Your magic and arrows can no longer touch me!");
        }

        # Summon minions based on HP thresholds
        if ($hp_ratio <= 25 && $minions_spawned < 3) {
            Summon_Minions(3);
            $minions_spawned = 3;
        } elsif ($hp_ratio <= 50 && $hp_ratio > 25 && $minions_spawned < 2) {
            Summon_Minions(2);
            $minions_spawned = 2;
        } elsif ($hp_ratio <= 75 && $hp_ratio > 50 && $minions_spawned < 1) {
            Summon_Minions(1);
            $minions_spawned = 1;
        }
    }
}

sub Summon_Minions {
    my ($count) = @_;
    quest::shout("Minions, assist me in battle!");
    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1847, 0, 0, $x, $y, $z, $npc->GetHeading());
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Hahahaha! As always, we will meet again!");
    quest::stoptimer("spell_cast");
    quest::stoptimer("minion_check");
    quest::depop(1846);
}

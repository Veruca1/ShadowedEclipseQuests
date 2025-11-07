##Thelin_Poxbourne
# Handles player entry into the Hedge Maze trial (PoN)
# Applies random Thelin curses to clients only
# Also buffs mobs in the zone when player enters

my $entry;
my @curses = (41236, 41237, 41239, 41240); # Thelin's Disarm, Voice, Pace, Fortitude

sub EVENT_SAY {
    my $client = plugin::val('$client');
    return unless defined $client;

    if ($text =~ /Hail/i) {
        if (!defined $entry || $entry == 0) {
            quest::say(
                "You there! You look brave enough to face my nightmare... "
                . "Tell me when you are [" . quest::saylink("ready") . "] to begin, "
                . "and together we shall end this torment!"
            );
        } else {
            quest::say("I do not have time for this.");
        }
    }

    if ($text =~ /ready/i) {
        quest::emote(
            "closes his eyes and falls asleep immediately. "
            . "He looks peaceful for a moment and then screams in agony!"
        );

        my $instance_id = $client->GetInstanceID();
        my $zone_id     = 204; # Plane of Nightmare

        if ($instance_id > 0) {
            $client->MovePCInstance($zone_id, $instance_id, -4774, 5198, 4, 0);
        } else {
            $client->MovePC($zone_id, -4774, 5198, 4, 0);
        }

        # Delay curse application
        quest::settimer("apply_curse_" . $client->CharacterID(), 3);

        # Signal Hedge_Trigger controller
        quest::signalwith(204058, 5, 3000);

        # Buff all mobs with Thelin's Pact
        foreach my $mob ($entity_list->GetNPCList()) {
            $mob->CastSpell(41243, $mob->GetID());
        }

        $entry = 1;
    }
}

sub EVENT_TIMER {
    my $timer_name = $timer;

    if ($timer_name =~ /^apply_curse_(\d+)/) {
        quest::stoptimer($timer_name);
        my $char_id = $1;
        my $client = $entity_list->GetClientByCharID($char_id);
        return unless $client;

        my $chosen_curse = $curses[rand @curses];
        quest::crosszonecastspellbycharid($char_id, $chosen_curse);
        $client->Message(15, "A dark presence binds itself to your soul... Thelin’s curse has taken hold!");
        quest::debug("Thelin_Poxbourne: cast curse $chosen_curse on char_id $char_id");

        # Start periodic client-only curse check
        quest::settimer("curse_check", 10);
    }

    elsif ($timer_name eq "curse_check") {
        foreach my $client ($entity_list->GetClientList()) {
            next if $client->GetGM();

            my $is_cursed = 0;
            foreach my $spell_id (@curses) {
                if ($client->FindBuff($spell_id)) {
                    $is_cursed = 1;
                    last;
                }
            }

            unless ($is_cursed) {
                my $chosen_curse = $curses[rand @curses];
                quest::crosszonecastspellbycharid($client->CharacterID(), $chosen_curse);
                $client->Message(15, "You feel the hedge’s influence creeping into your soul...");
                quest::debug("Thelin_Poxbourne: re-cast curse $chosen_curse on " . $client->GetCleanName());
            }
        }
    }
}
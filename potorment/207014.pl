# ===============================================================
# Tylis_Newleaf.pl — Plane of Torment (potorment)
# Shadowed Eclipse: Access NPC for Saryrn Event (DZ-Compatible)
# ===============================================================

my $sphere = undef;
my $raid   = undef;
my $group  = undef;
my $pc     = undef;
my $count  = undef;

sub EVENT_SPAWN {
    $sphere = undef;
    quest::settimer(2, 1);
}

sub EVENT_SIGNAL {
    quest::depop();
}

sub EVENT_SAY {
    my $assist_link = quest::saylink("I will assist you", 1);
    my $ready_link  = quest::saylink("ready", 1);

    if ($text =~ /hail/i && !defined $sphere) {
        quest::whisper("...help ...end this torment ...will you come? I can show you the pain... it moves in the shadows of my mind... will you help me? $assist_link?");
    }
    elsif ($text =~ /will assist you/i) {
        quest::whisper("I... I don't want anyone else to suffer my fate. If you are certain you can help, show me your Screaming Sphere as proof of your strength.");
    }
    elsif ($text =~ /ready/i && $sphere == 1) {
        $raid  = $entity_list->GetRaidByClient($client);
        $group = $entity_list->GetGroupByClient($client);
        my $instance_id = $client->GetInstanceID();

        my $cid = $client->CharacterID();
        quest::set_data("_potor_tylis_keeper_$cid", 1);

        $client->MovePCInstance(207, $instance_id, -175, 815, -955, 0);

        if ($raid) {
            for ($count = 0; $count < $raid->RaidCount(); $count++) {
                $pc = $raid->GetMember($count);
                if ($pc && $pc->IsClient() && $pc->CalculateDistance($x, $y, $z - 15) <= 50) {
                    quest::set_data("_potor_tylis_keeper_" . $pc->CharacterID(), 1);
                    $pc->MovePCInstance(207, $instance_id, -175, 815, -955, 0);
                }
            }
        }
        elsif ($group) {
            for ($count = 0; $count < $group->GroupCount(); $count++) {
                $pc = $group->GetMember($count);
                if ($pc && $pc->IsClient() && $pc->CalculateDistance($x, $y, $z - 15) <= 50) {
                    quest::set_data("_potor_tylis_keeper_" . $pc->CharacterID(), 1);
                    $pc->MovePCInstance(207, $instance_id, -175, 815, -955, 0);
                }
            }
        }
    }
}

sub EVENT_ITEM {

    # --------------------------------------------
    # SCREAMING SPHERE TURN-IN (START THE EVENT)
    # --------------------------------------------
    if (plugin::check_handin(\%itemcount, 22954 => 1)) {
        quest::summonitem(22954);
        my $ready_link = quest::saylink("ready", 1);
        quest::whisper("Please tell me when you are $ready_link. I do not know if I have enough energy to channel all of you, but I can try. When you are $ready_link, I will channel you into my pain.");
        quest::settimer(1, 300);
        $sphere = 1;
        plugin::return_items(\%itemcount);
        return;
    }

    # --------------------------------------------
    # FINAL 5-ITEM SARYRN FLAG TURN-IN
    # --------------------------------------------
    if (
        plugin::check_handin(
            \%itemcount,
            1 => 1,    # item 0001
            2 => 1,    # item 0002
            3 => 1,    # item 0003
            4 => 1,    # item 0004
            5 => 1     # item 0005
        )
    ) {

        my $cid = $client->CharacterID();
        quest::set_data("potor_saryrn_final_$cid", 1);

        quest::whisper("Yes… the essence of the four tormentors and the sorrow they bound to the Keeper. You have done what few ever could. Take this blessing and know that Saryrn’s shield of agony can no longer repel your strength.");

        plugin::return_items(\%itemcount);
        return;
    }

    plugin::return_items(\%itemcount);
}

sub EVENT_TIMER {
    if ($timer == 1) {
        quest::stoptimer(1);
        $sphere = undef;
    }
    elsif ($timer == 2) {
        quest::stoptimer(2);
        $npc->SetAppearance(3);
    }
}

# End of File — Zone: potorment — ID: 207014 — Tylis_Newleaf
my @tints = (40);
my $current = 0;

sub EVENT_SPAWN {
    quest::settimer("tintcycle", 5);
}

sub EVENT_TIMER {
    if ($timer eq "tintcycle") {
        return unless @tints;
        $npc->SetNPCTintIndex($tints[$current]);
        $current = ($current + 1) % @tints;
    }
}

sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text;

    # Distance check: 20 units max
    my $distance = sqrt(($x - $client->GetX())**2 + ($y - $client->GetY())**2 + ($z - $client->GetZ())**2);
    if ($distance > 20) {
        plugin::Whisper("You must be closer to the mirror.");
        return;
    }

    my $char_id = $client->CharacterID();
    my $spawn_flag = "akheva_mirror_${char_id}";
    my $cd_time_flag = "${char_id}-akheva_mirror_cd_start";
    my $cd_duration = 5;

    if ($text =~ /hail/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                plugin::Whisper("You must wait...");
                plugin::Whisper("Time remaining: " . format_time($remaining));
            } else {
                my $saylink = quest::saylink("face the mirror", 1);
                plugin::Whisper("The reflection stirs... Will you $saylink?");
            }
        } else {
            plugin::Whisper("The mirror does not yet recognize your essence.");
        }
    }

    if ($text =~ /face the mirror/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                plugin::Whisper("The mirror is not ready.");
                plugin::Whisper("Time remaining: " . format_time($remaining));
                return;
            }

            plugin::Whisper("The mirror fractures...");
            quest::set_data($cd_time_flag, time);
            clone_and_spawn_mirrors($client);
        }
    }
}

sub EVENT_ITEM {
    return unless defined $client && $client->IsClient();
    my $char_id = $client->CharacterID();

    if (plugin::check_handin(\%itemcount, 40836 => 1, 40837 => 1, 40838 => 1, 40839 => 1)) {
        quest::set_data("akheva_mirror_${char_id}", 1);
        quest::set_data("${char_id}-akheva_mirror_cd_start", time - 5);
        plugin::Whisper("You feel your reflection take shape...");
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub clone_and_spawn_mirrors {
    my ($client) = @_;
    return unless $client;

    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();

    my %seen = ();
    my @targets;

    # Add client
    my $name = $client->GetCleanName();
    $seen{$name} = 1;
    push @targets, $client;

    # Add group members
    if (my $group = $client->GetGroup()) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            my $n = $member->GetCleanName();
            next if $seen{$n};
            $seen{$n} = 1;
            push @targets, $member;
        }
    }

    # Add bots
    my $owner_id = $client->CharacterID();
    foreach my $npc ($entity_list->GetNPCList()) {
        next unless $npc && $npc->IsBot();
        next unless $npc->GetBotOwnerCharacterID() == $owner_id;
        my $n = $npc->GetCleanName();
        next if $seen{$n};
        $seen{$n} = 1;
        push @targets, $npc;
    }

    my $count = 0;
    foreach my $target (@targets) {
        last if $count >= 6;

        my $spawn_x = $x + 10 + ($count * 8);
        my $spawn_id = quest::spawn2(1978, 0, 0, $spawn_x, $y, $z, $h);
        my $mob = $entity_list->GetMobByID($spawn_id);

        if ($mob && $mob->IsNPC()) {
            my $mirror_npc = $mob->CastToNPC();
            my $target_name = $target->GetCleanName();

            plugin::CloneAppearance($target, $mirror_npc, 0);
            $mirror_npc->AddNimbusEffect(466);
            plugin::Debug("Mirror [$count] cloned from $target_name");

            # Apply visible armor (slots 0–6)
            for my $slot (0 .. 6) {
                my $color = 0;
                my $material = 0;

                if ($target->IsClient() || $target->IsBot()) {
                    $color = $target->GetEquipmentColor($slot);
                    $material = $target->GetEquipmentMaterial($slot);
                }

                $mirror_npc->WearChange($slot, $material, $color);
                plugin::Debug("Mirror [$count] Slot $slot - Material=$material Color=$color");
            }

            # Apply visible weapons (slots 7 = primary, 8 = secondary)
            for my $slot (7, 8) {
                my $model = 0;

                if ($target->IsClient() || $target->IsBot()) {
                    $model = $target->GetEquipmentMaterial($slot);
                }

                $mirror_npc->WearChange($slot, $model, 0);
                plugin::Debug("Mirror [$count] Weapon Slot $slot - Model=$model");
            }

        }

        $count++;
    }

    plugin::Debug("The Eclipse Mirror Debugs: Total mirror mimics spawned: $count");
}

sub get_cooldown_remaining {
    my ($char_id, $cd_duration) = @_;
    my $cd_flag = "${char_id}-akheva_mirror_cd_start";
    my $start = quest::get_data($cd_flag);
    return 0 unless $start;
    my $elapsed = time - $start;
    return $cd_duration > $elapsed ? $cd_duration - $elapsed : 0;
}

sub format_time {
    my $s = shift // 0;
    my $m = int($s / 60);
    $s %= 60;
    return sprintf("%02d minute(s) and %02d second(s)", $m, $s);
}
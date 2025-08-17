# Global flags for mirror logic
my $checked_mirror = 0;
my $mirror_trigger_hp = 0;

sub EVENT_SPAWN {
    return unless $npc;

    quest::settimer("init_effects", 1);
    quest::settimer("lunar_nimbus_buff", 8);

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Base stats
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 100000000); 
    $npc->ModifyNPCStat("hp_regen", 800);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 32000);
    $npc->ModifyNPCStat("max_hit", 77000);
    $npc->ModifyNPCStat("atk", 1600);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 18);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    $npc->SetHP($npc->GetMaxHP());
    $checked_mirror = 0;
    quest::setnexthpevent(80);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("cryptic_shout", 60);
        quest::settimer("moonrock_summon", 30);
    } else {
        quest::stoptimer("cryptic_shout");
        quest::stoptimer("moonrock_summon");
        $checked_mirror = 0;
        quest::stoptimer("mirror_check");
    }
}

sub EVENT_HP {
    if ($hpevent == 80 && !$checked_mirror) {
        $mirror_trigger_hp = int(rand(69)) + 11;
        quest::settimer("mirror_check", 5);
    }
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");

        my @buffs = (5278, 5297, 5488, 10028, 10031, 10013, 10664, 9414, 300, 15031, 2530);
        foreach my $spell_id (@buffs) {
            $npc->SpellFinished($spell_id, $npc);
        }

        quest::shout("Through shadow and silence, I return... and the Moon sees all.");
    }

    elsif ($timer eq "lunar_nimbus_buff") {
        quest::stoptimer("lunar_nimbus_buff");
        $npc->CastSpell(24061, $npc->GetID()) if !$npc->FindBuff(24061);
    }

    elsif ($timer eq "cryptic_shout") {
        my @shouts = (
            "So... the dreamers return to Ssra. Did you think the Moon forgot your footsteps?",
            "Luclin watches. Always. Her gaze is the cold shadow at your back.",
            "The Coven awaits you in the dark between stars. Will you walk willingly... or be dragged?",
            "Nyseria’s threads are no longer whispers — they are chains, and you are already bound.",
            "Beyond this hall lies the way to the Black Mirror. It does not reflect — it devours.",
            "The Planes of Power stir. Do you think their lords will greet you as heroes... or as prey?",
            "Every step forward is a step deeper into Her design. The web tightens.",
            "You seek the Coven? Then step through the Mirror Moon, and be remade in shadow.",
            "Nyseria’s embrace is not love, but surrender. Will you kneel when the circle closes?",
            "The Eclipse was not an ending — it was Her invitation. You have already accepted.",
            "The Mirror does not show truth... only the fate She chooses for you.",
            "When the Circle gathers, even the gods will listen. And you... will kneel."
        );
        quest::shout($shouts[int(rand(@shouts))]);
    }

    elsif ($timer eq "moonrock_summon") {
        quest::shout("By the shadow of the Mirror Moon, I summon the Moon Rocks to seek the intruders!");
        my $count = int(rand(3)) + 1;
        for (my $i = 0; $i < $count; $i++) {
            quest::spawn2(1974, 0, 0, -78.17, -1084.92, -255.94, 103.75);
        }
    }

    elsif ($timer eq "mirror_check") {
        return if $checked_mirror;

        my $hp_pct = int($npc->GetHPRatio());
        return if $hp_pct < 10;
        return if $hp_pct > $mirror_trigger_hp;

        foreach my $client ($entity_list->GetClientList()) {
            next unless $client && $client->GetHP() > 0;

            my $item = $client->GetItemAt(22);
            my $item_id = $item ? $item->GetID() : 0;
            my $has_mirror = ($item_id == 49764);
            my $has_buff   = $client->FindBuff(40778);

            next unless $has_mirror && $has_buff;

            my $roll = int(rand(100));
            if ($roll < 25) {
                quest::shout("The mirror cracks... and something darker stirs.");
                quest::settimer("mirror_tint", 1);

                my $new_hp     = int($npc->GetMaxHP() * 1.5);
                my $new_min    = int($npc->GetMinDMG() * 1.5);
                my $new_max    = int($npc->GetMaxDMG() * 1.5);
                my $new_atk    = int($npc->GetATK() * 1.5);
                my $new_hstrik = int($npc->GetNPCStat("heroic_strikethrough") || 0) + 1;

                $npc->ModifyNPCStat("max_hp", $new_hp);
                $npc->ModifyNPCStat("min_hit", $new_min);
                $npc->ModifyNPCStat("max_hit", $new_max);
                $npc->ModifyNPCStat("atk", $new_atk);
                $npc->ModifyNPCStat("attack_delay", 5);
                $npc->ModifyNPCStat("heroic_strikethrough", $new_hstrik);
                $npc->SetHP($npc->GetMaxHP());

                $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

                # --- Add title on transform ---
                my $base_name = $npc->GetCleanName();
                my $title_tag = "the Reflected";
                my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
                $npc->TempName($new_name);
                $npc->ModifyNPCStat("lastname", "Reflected");
                # --- end title ---
            }

            $checked_mirror = 1;
            quest::stoptimer("mirror_check");
            last;
        }

        $checked_mirror = 1;
        quest::stoptimer("mirror_check");
    }

    elsif ($timer eq "mirror_tint") {
        quest::stoptimer("mirror_tint");
        $npc->SetNPCTintIndex(30);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::spawn2(2184, 0, 0, -175.25, -917.95, -255.94, 290);
}
# Glitch Princess 4.0
# Fairy ↔ Invisible Man random glitch swap integrated
# Glitchy Roots (DoT Root for 75k) every 70s while in combat

my $minions_spawned = 0;

# Illusion setup
my @illusion_pool = (
    { race => 473, gender => 2, texture => 0, helm_texture => 0 }, # Fairy
    { race => 127, gender => 0, texture => 0, helm_texture => 0 }, # Invisible Man
);
my @shuffled_pool;
my $illusion_index = 0;

sub EVENT_SPAWN {
    return unless $npc;

    quest::shout("~*gl1tChhhhhh 0nl1n3... y0u arrreeee nnnevvv3rrr aaall0nnnee...*~");
    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # === Apply baseline stats only ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac",        20000);
    $npc->ModifyNPCStat("max_hp",    90000000);
    $npc->ModifyNPCStat("hp_regen",  500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit",   65000);
    $npc->ModifyNPCStat("max_hit",   90000);
    $npc->ModifyNPCStat("atk",       1500);
    $npc->ModifyNPCStat("accuracy",  1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 33);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # Attributes
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # Resistances
    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # Special traits
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    # === Call plugin to scale stats on top of baseline ===
    plugin::RaidScaling($entity_list, $npc);

    # === Heal to full scaled HP ===
    my $scaled_hp = $npc->GetMaxHP();
    $npc->SetHP($scaled_hp) if $scaled_hp > 0;

    # === Black Mirror Buff / Tint ===
    $npc->SetNPCTintIndex(30);
    $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

    # === Mirror Spellset ===
    quest::set_data("mirror_spellset", "40786,40787");
    quest::settimer("cast_cycle", 20);

    # === Title Add ===
    my $base_name = $npc->GetCleanName();
    my $title_tag = "the Reflected";
    my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
    $npc->TempName($new_name);
    $npc->ModifyNPCStat("lastname", "Reflected");

    # === HP event progression (bucket controlled) ===
    my $hp_key = $npc_id . "-60-hp";
    if (defined(quest::get_data($hp_key)) && quest::get_data($hp_key) == 1) {
        quest::setnexthpevent(30);  # skip 60% phase
    } else {
        quest::setnexthpevent(60);
    }

    # === Illusion Glitch Start (always Fairy first) ===
    $npc->SendIllusion(473, 2, 0, 0);
    @shuffled_pool = _shuffle_array(@illusion_pool);
    $illusion_index = 0;
    _set_random_timer();

    # === Glitchy Roots timer (every 70s) ===
    quest::settimer("glitchy_roots", 70);
}

sub EVENT_HP {
    if ($hpevent == 60) {
        my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
        quest::set_data($hp_key, 1);  # mark phase complete

        my $current_hp = $npc->GetHP();
        my $max_hp = $npc->GetMaxHP();
        my $hp_percentage = ($max_hp > 0) ? ($current_hp / $max_hp) : 1;

        quest::depop();
        my $new_npc = quest::spawn2(2195, 0, 0, 78.83, 375.99, 18.06, 256);
        my $new_npc_entity = $entity_list->GetNPCByID($new_npc);
        if ($new_npc_entity) {
            my $new_hp = $new_npc_entity->GetMaxHP() * $hp_percentage;
            $new_npc_entity->SetHP($new_hp);
            quest::setnexthpevent(30);
        }
    }
    elsif ($hpevent == 30) {
        $npc->SetInvul(1);
        quest::settimer("remove_invul", 60);
        quest::setnexthpevent(10);
    }
    elsif ($hpevent == 10) {
        quest::shout("Sy\$st3m br34k... C0v3n pr0t0c0l ::: N¥s3r1a... >Inj3ct sh\@d0w-b34rrr<...");
        quest::spawn2(2199, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    }
}

sub EVENT_TIMER {
    if ($timer eq "remove_invul") {
        quest::stoptimer("remove_invul");
        $npc->SetInvul(0);
    }
    elsif ($timer eq "cast_cycle") {
        my $data = quest::get_data("mirror_spellset") || "";
        my @spells = split(/,/, $data);
        return unless @spells;
        my $spell_id = $spells[int(rand(@spells))];
        my $target = $npc->GetHateRandom();
        $npc->CastSpell($spell_id, $target->GetID()) if $target;
    }
    elsif ($timer eq "illusion_swap") {
        quest::stoptimer("illusion_swap");
        _cycle_illusion();
        _set_random_timer();
    }
    elsif ($timer eq "glitchy_roots") {
        if ($npc->IsEngaged()) {
            my $target = $npc->GetHateRandom();
            $npc->CastSpell(41209, $target->GetID()) if $target;
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
    quest::delete_data($hp_key);  # reset for next fight
    quest::signalwith(2193, 87);
    quest::shout("Th3 C0v3n... N¥s3r1a 1s 1nn3v1t\@bl3... y0u b3l0ng t0 h3r w3b 0f sh\@d0ws...");
}

# === Illusion helpers ===
sub _cycle_illusion {
    if ($illusion_index >= scalar(@shuffled_pool)) {
        @shuffled_pool = _shuffle_array(@illusion_pool);
        $illusion_index = 0;
    }
    my $choice = $shuffled_pool[$illusion_index];
    $illusion_index++;
    $npc->SendIllusion($choice->{race}, $choice->{gender}, $choice->{texture}, $choice->{helm_texture});
}

sub _shuffle_array {
    my @array = @_;
    for (my $i = $#array; $i > 0; $i--) {
        my $j = int(rand($i+1));
        @array[$i, $j] = @array[$j, $i];
    }
    return @array;
}

sub _set_random_timer {
    my $next_time = 0.5 + rand(9.5);
    quest::settimer("illusion_swap", $next_time);
}
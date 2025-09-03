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

    # === Raid scaling logic (4 baseline; 5=+25%, 6=+50%, etc.) ===
    my $client_count = 0;
    foreach my $c ($entity_list->GetClientList()) {
        $client_count++ if $c && $c->GetHP() > 0;
    }

    my $scale = 1.0;
    if ($client_count >= 5) {
        $scale = 1.0 + 0.25 * ($client_count - 4);
    }

    # === Base stats ===
    my $base_level    = 75;
    my $base_ac       = 20000;
    my $base_hp       = 90000000;
    my $base_regen    = 500;
    my $base_min_hit  = 25000;
    my $base_max_hit  = 70000;
    my $base_atk      = 1500;
    my $base_accuracy = 1800;
    my $base_delay    = 5;
    my $base_hs       = 35;  # HS starts at 35

    # === Apply scaled stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", $base_level);
    $npc->ModifyNPCStat("ac",          int($base_ac       * $scale));
    $npc->ModifyNPCStat("max_hp",      int($base_hp       * $scale));
    $npc->ModifyNPCStat("hp_regen",    int($base_regen    * $scale));
    $npc->ModifyNPCStat("mana_regen",  10000);
    $npc->ModifyNPCStat("min_hit",     int($base_min_hit  * $scale));
    $npc->ModifyNPCStat("max_hit",     int($base_max_hit  * $scale));
    $npc->ModifyNPCStat("atk",         int($base_atk      * $scale));
    $npc->ModifyNPCStat("accuracy",    int($base_accuracy * $scale));
    $npc->ModifyNPCStat("avoidance",   100);

    # Attack delay (reduces after 4 players; min 4)
    my $new_delay = $base_delay - ($client_count - 4);
    $new_delay = 4 if $new_delay < 4;
    $npc->ModifyNPCStat("attack_delay", $new_delay);

    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);

    # Heroic strikethrough: 35 + (clients-4), cap 38
    my $new_hs = $base_hs + ($client_count - 4);
    $new_hs = 35 if $new_hs < 35;
    $new_hs = 38 if $new_hs > 38;
    $npc->ModifyNPCStat("heroic_strikethrough", $new_hs);

    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Attributes ===
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # === Resistances ===
    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # === Special traits ===
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    # Full heal to scaled HP
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

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

    # === HP event progression ===
    my $hp_key = $npc_id . "-60-hp";
    if (defined(quest::get_data($hp_key)) && quest::get_data($hp_key) == 1) {
        quest::setnexthpevent(30);
        my $new_hp = $npc->GetMaxHP() * 0.60;
        $npc->SetHP($new_hp);
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
    # === Handle 60% ===
    if ($hpevent == 60) {
        my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
        quest::set_data($hp_key, 1);

        my $current_hp = $npc->GetHP();
        my $max_hp = $npc->GetMaxHP();
        my $hp_percentage = $current_hp / $max_hp;

        quest::depop();
        my $x = 78.83;
        my $y = 375.99;
        my $z = 18.06;
        my $h = 256;
        my $boss_id = 2195;
        my $new_npc = quest::spawn2($boss_id, 0, 0, $x, $y, $z, $h);
        my $new_npc_entity = $entity_list->GetNPCByID($new_npc);
        if ($new_npc_entity) {
            my $new_hp = $new_npc_entity->GetMaxHP() * $hp_percentage;
            $new_npc_entity->SetHP($new_hp);
            quest::setnexthpevent(30);
        }
    }
    # === Handle 30% ===
    elsif ($hpevent == 30) {
        $npc->SetInvul(1);
        quest::settimer("remove_invul", 60);
        quest::setnexthpevent(10);
    }
    # === Handle 10% ===
    elsif ($hpevent == 10) {
        quest::shout("Sy$st3m br34k... C0v3n pr0t0c0l ::: N¥s3r1a... >Inj3ct sh@d0w-b34rrr<...");
        my $npc_id = 2199;  # Replace with final form ID
        quest::spawn2($npc_id, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
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
        # Cast Glitchy Roots (DoT + Root, 75k) only if engaged
        if ($npc->IsEngaged()) {
            my $target = $npc->GetHateRandom();
            $npc->CastSpell(41209, $target->GetID()) if $target;
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
    quest::delete_data($hp_key);
    quest::signalwith(2193, 87);
    quest::shout("Th3 C0v3n... N¥s3r1a 1s 1nn3v1t@bl3... y0u b3l0ng t0 h3r w3b 0f sh@d0ws...");
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
    # Random interval between 0.5 and 10 seconds
    my $next_time = 0.5 + rand(9.5);
    quest::settimer("illusion_swap", $next_time);
}
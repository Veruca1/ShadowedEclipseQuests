my $depop_timer_paused = 0;
my $depop_timer_start = 0;
my $depop_timer_duration = 30 * 60; # 30 minutes in seconds

sub EVENT_SPAWN {
    return unless $npc;

    quest::shout("A roar fills the lower temple halls! The smell of burning ozone and decay fills the air!");
    $depop_timer_start = time;
    $depop_timer_duration = 30 * 60;
    quest::settimer("depop", $depop_timer_duration);

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 62);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 25000000); 
    $npc->ModifyNPCStat("hp_regen", 800);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 12000);
    $npc->ModifyNPCStat("max_hit", 20000);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 22);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 300);
    $npc->ModifyNPCStat("fr", 300);
    $npc->ModifyNPCStat("cr", 300);
    $npc->ModifyNPCStat("pr", 300);
    $npc->ModifyNPCStat("dr", 300);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_COMBAT {
    if ($combat_state == 1 && !$depop_timer_paused) {
        my $elapsed = time - $depop_timer_start;
        quest::stoptimer("depop");
        $depop_timer_duration -= $elapsed;
        $depop_timer_duration = 1 if $depop_timer_duration < 1;
        $depop_timer_paused = 1;
    } elsif ($combat_state == 0 && $depop_timer_paused) {
        $depop_timer_start = time;
        quest::settimer("depop", $depop_timer_duration);
        $depop_timer_paused = 0;

        $npc->SaveGuardSpot($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::depop();
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signal(162255, 1); # #cursed_controller
    quest::setglobal("glyphed_dead", "1", 3, "D3");

    # Reset timer state
    $depop_timer_paused = 0;
    $depop_timer_start = 0;
    $depop_timer_duration = 0;
}
# ===========================================================
# 221000.pl — Terris Thule (PoNightmareB / Lair of Terris Thule)
# Shadowed Eclipse: Reflection Integration + Essence Flag Gating
# ===========================================================

my $DEFILER_SMALL_TYPE = 221006;
my $DEFILER_LARGE_TYPE = 221012;

my $is_boss        = 0;
my $checked_mirror = 0;
my %allowed_damagers;

# Reflected loot table — one of these will be randomly added when reflected
my @reflected_loot = (80063, 80064, 79540, 80065); 

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    $is_boss = ($raw_name =~ /^#/ || $raw_name =~ /Terris_Thule/i) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    if ($is_boss) {
        # === Core Stats ===
        $npc->ModifyNPCStat("level", 68);
        $npc->ModifyNPCStat("ac", 30000);
        $npc->ModifyNPCStat("max_hp", 300000000);
        $npc->ModifyNPCStat("hp_regen", 3000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 65000);
        $npc->ModifyNPCStat("max_hit", 115000);
        $npc->ModifyNPCStat("atk", 2500);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 75);
        $npc->ModifyNPCStat("attack_delay", 6);
        $npc->ModifyNPCStat("heroic_strikethrough", 36);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("aggro", 60);
        $npc->ModifyNPCStat("assist", 1);

        # === Attributes ===
        $npc->ModifyNPCStat("str", 1250);
        $npc->ModifyNPCStat("sta", 1250);
        $npc->ModifyNPCStat("agi", 1250);
        $npc->ModifyNPCStat("dex", 1250);
        $npc->ModifyNPCStat("wis", 1250);
        $npc->ModifyNPCStat("int", 1250);
        $npc->ModifyNPCStat("cha", 1100);

        # === Resists ===
        $npc->ModifyNPCStat("mr", 400);
        $npc->ModifyNPCStat("fr", 400);
        $npc->ModifyNPCStat("cr", 400);
        $npc->ModifyNPCStat("pr", 900);
        $npc->ModifyNPCStat("dr", 900);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1100);

        # === Traits & Abilities ===
        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);
        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^12,1^13,1^14,1^15,1^17,1^21,1");

        # === Raid Scaling ===
        plugin::RaidScaling($entity_list, $npc);
    }

    # === Flag-Gated Invulnerability ===
  $npc->SetInvul(1); # Flag-gated invulnerability on spawn
    quest::settimer("flag_check", 5);

    # === Reset & HP Sync ===
    $npc->SetHP($npc->GetMaxHP());
    $checked_mirror = 0;

    # === Encounter Initialization (Lua) ===
    quest::setnexthpevent(95);
    quest::settimer("gargs", 1); # Always spawn statues on spawn
}

sub EVENT_COMBAT {
    my ($combat_state) = @_;

    if ($combat_state == 1) {
        quest::settimer("OOBcheck", 6000);
        quest::stoptimer("wipereset");
        $checked_mirror = 0;
    } else {
        quest::stoptimer("OOBcheck");
        quest::settimer("wipereset", 60000);
        $checked_mirror = 0;
    }
}

# ===========================================================
# Flag gating logic — only clients with PoTerris_EssenceComplete_X can damage
# ===========================================================
sub EVENT_TIMER {
    if ($timer eq "flag_check") {
        %allowed_damagers = ();
        my $any_flagged = 0;

        foreach my $c ($entity_list->GetClientList()) {
            next unless $c;
            my $cid = $c->CharacterID();
            if (quest::get_data("PoTerris_EssenceComplete_$cid")) {
                $any_flagged = 1;
                $allowed_damagers{$c->GetID()} = 1;

                foreach my $b ($entity_list->GetBotList()) {
                    $allowed_damagers{$b->GetID()} = 1 if $b->GetOwnerID() == $c->GetID();
                }

                foreach my $p ($entity_list->GetMobList()) {
                    next unless $p->IsPet();
                    my $o = $p->GetOwner();
                    if ($o && $o->GetID() == $c->GetID()) {
                        $allowed_damagers{$p->GetID()} = 1;
                    }
                }
            }
        }

        if ($any_flagged) {
    $npc->SetInvul(0);
} else {
    $npc->SetInvul(1);
}

    }

    elsif ($timer eq "OOBcheck") {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        if ($x > -1580 || $x < -2090 || $y > 250 || $y < -280) {
            $entity_list->MessageClose($npc, 1, 200, 0,
              "Terris Thule disappears into the ether and reforms at the center of her chamber, cleansed of your magic!");
            $npc->GMMove($npc->GetSpawnPointX(), $npc->GetSpawnPointY(),
                         $npc->GetSpawnPointZ(), $npc->GetSpawnPointH());
            $npc->CastSpell(3230, $npc->GetID()); # Balance of the Nameless
        }
    }

    elsif ($timer eq "gargs") {
        quest::stoptimer("gargs");
        my @spawns = (
            [-1954, 99, 202, 191],
            [-1748, 91, 202, 330],
            [-1736, -125, 202, 454],
            [-1958, -104, 202, 67]
        );
        foreach my $loc (@spawns) {
            my $id = quest::spawn2(221013, 0, 0, @$loc);
            my $n = $entity_list->GetNPCByID($id);
            $n->SetAppearance(3) if $n;
        }
    }

    elsif ($timer eq "wipereset") {
        quest::stoptimer("wipereset");
        quest::depopall(221007);
        quest::depopall(221013);
        my @spawns = (
            [-1954, 99, 202, 191],
            [-1748, 91, 202, 330],
            [-1736, -125, 202, 454],
            [-1958, -104, 202, 67]
        );
        foreach my $loc (@spawns) {
            my $id = quest::spawn2(221013, 0, 0, @$loc);
            my $n = $entity_list->GetNPCByID($id);
            $n->SetAppearance(3) if $n;
        }
    }
}

# Prevent unflagged attackers from doing real damage
sub EVENT_DAMAGE_GIVEN {
    my ($damage, $spell_id, $skill, $range, $hate, $target) = @_;
    my $attacker = $entity_list->GetMobByID($userid);
    return unless $attacker;
    unless (exists $allowed_damagers{$attacker->GetID()}) {
        $npc->SetHP($npc->GetHP() + $damage);
    }
}

# ===========================================================
# Original fight logic preserved below
# ===========================================================

sub SpawnDefilers {
    my $mob = $_[0];
    my $numSpawns = 0;
    my @hate_list = $mob->GetHateList();
    foreach my $entry (@hate_list) {
        my $hater = $entry->GetEnt();
        next unless $hater && $hater->IsClient();
        $numSpawns++;
    }
    for (my $i = 0; $i < $numSpawns; $i++) {
        my $t = (int(rand(2)) == 0) ? $DEFILER_SMALL_TYPE : $DEFILER_LARGE_TYPE;
        quest::spawn2($t, 0, 0, -1639, -138, 133, 0);
    }
}

sub EVENT_HP {
    if ($hpevent == 95) {
        $entity_list->MessageClose($npc, 1, 250, 0,
          "The sound of a thousand terrified screams fills your head. You feel yourself becoming a part of the fabric of this nightmare realm.");
        quest::setnexthpevent(79);
        quest::setnextinchpevent(96);
    }
    elsif ($hpevent == 79) {
        quest::setnexthpevent(69);
        SpawnDefilers($npc);
    }
    elsif ($hpevent == 69) {
        quest::setnexthpevent(50);
        SpawnDefilers($npc);
    }
    elsif ($hpevent == 50) {
        quest::setnexthpevent(45);
        $entity_list->MessageClose($npc, 1, 250, 0,
          "As if in a waking nightmare, you feel your movements slow and your arms begin to fail you...");
        $npc->CastSpell(3150, $npc->GetID()); # Direption of Dreams
    }
    elsif ($hpevent == 45) {
        my $top = $npc->GetHateTop();
        $npc->SpellFinished(1139, $top) if $top;
        quest::setnexthpevent(40);
    }
    elsif ($hpevent == 40) {
        $npc->Shout("You will not escape my realm so easily!");
        $entity_list->MessageClose($npc, 1, 250, 0,
          "The air grows thick with the smell of burning mana. A rumbling sound draws your attention to the massive statues above...");
        quest::signalwith(221013, 1, 0); # wake statues
        quest::setnexthpevent(35);
    }
    elsif ($hpevent == 35 && !$checked_mirror) {
        plugin::TryPoPCh2ReflectTransformation($npc, $entity_list, \@reflected_loot, 40, \$checked_mirror);
        quest::setnexthpevent(25);
    }
        elsif ($hpevent == 25) {
        if (int(rand(100)) < 40) {
            quest::spawn2(2189, 0, 0, -1758.12, -5.18, 134.58, 390.25);
        }
    }
    elsif ($hpevent == 96) {
        quest::setnexthpevent(95);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::spawn2(202368, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
}
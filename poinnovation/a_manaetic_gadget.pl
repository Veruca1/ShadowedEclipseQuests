# ===========================================================
# a_manaetic_gadget.pl — Plane of Innovation
# Shadowed Eclipse: Endurance Testing Event
# -----------------------------------------------------------
# - Scales with group/raid size and signals #Endurance_Trigger (206081) on death.
# - 20% chance to enable Nyseria "glitch illusion" tech on spawn.
#   When glitching, NPC flickers between its normal appearance
#   and an alternate corrupted “Nyseria Guard” model.
# ===========================================================

my $scaled_spawn   = 0;
my $glitch_enabled = 0;
my $using_glitch   = 0;
my %initial_appearance;
my %glitch_appearance = (
    race         => 566,  # Nyseria Guard model
    gender       => 1,
    texture      => 6,
    helm_texture => 6,
);

sub EVENT_SPAWN {
    return unless $npc;
    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # ===========================================================
    # General setup
    # ===========================================================
    $npc->SetNPCFactionID(623);

    # ===========================================================
    # Set level and apply scaling
    # ===========================================================
    my $is_boss = 0;  # gadgets are not bosses
    $npc->ModifyNPCStat("level", $is_boss ? 66 : 63);

    # Apply baseline stats and scaling
    plugin::DefaultNPCStats($npc, $entity_list);
    plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # ===========================================================
    # Record initial appearance for potential glitching
    # ===========================================================
    $initial_appearance{race}         = $npc->GetRace();
    $initial_appearance{gender}       = $npc->GetGender();
    $initial_appearance{texture}      = $npc->GetTexture();
    $initial_appearance{helm_texture} = $npc->GetHelmTexture();

    # ===========================================================
    # 20% chance to activate glitch tech
    # ===========================================================
    if (rand() <= 0.20) {
        $glitch_enabled = 1;
        quest::debug("a_manaetic_gadget: Glitch mode activated.");

        # Guarantee Shadowed Coven Poppet drop when glitching
        $npc->AddItem(56496, 1);

        # Start random glitch flicker timer
        _set_random_glitch_timer();
    }
}

# ===========================================================
# Glitch Flicker Logic — toggles between normal and corrupted look
# ===========================================================
sub EVENT_TIMER {
    return unless $glitch_enabled;

    if ($timer eq "glitch") {
        if ($using_glitch) {
            # Restore original appearance
            $npc->SendIllusion(
                $initial_appearance{race},
                $initial_appearance{gender},
                $initial_appearance{texture},
                $initial_appearance{helm_texture}
            );
            $using_glitch = 0;
        } else {
            # Apply corrupted/glitch illusion
            $npc->SendIllusion(
                $glitch_appearance{race},
                $glitch_appearance{gender},
                $glitch_appearance{texture},
                $glitch_appearance{helm_texture}
            );
            $using_glitch = 1;
        }

        # Schedule next flicker
        _set_random_glitch_timer();
    }
}

# ===========================================================
# Death Handling — signal the endurance trigger
# ===========================================================
sub EVENT_DEATH_COMPLETE {
    quest::signalwith(206081, 1, 1);  # Notify #Endurance_Trigger
}

# ===========================================================
# Helper: random timer between 0.01s and 3s
# ===========================================================
sub _set_random_glitch_timer {
    my $interval = (rand(2.99) + 0.01);
    quest::stoptimer("glitch");
    quest::settimer("glitch", $interval);
}
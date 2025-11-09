# ===========================================================
# zone_controller.pl — Frostbane Encounter Controller
# Sleeper's Tomb (Shadowed Eclipse)
# -----------------------------------------------------------
# Handles:
# - HP-based rotation between Frostbane's Left/Right Hands
# - Final spawn trigger when both are defeated
# - Safety cleanup on death/reset
# - Debug messages for testing
# ===========================================================

my $count = 0;  # Track number of defeated hands

sub EVENT_SPAWN {
    $count = 0;
    quest::debug("Frostbane Controller: Spawned and initialized. Hand kill count reset.");
}

# ===========================================================
# Signal Handling
# ===========================================================
sub EVENT_SIGNAL {

    # -------------------------------------------------------
    # 11 = A Hand has died
    # -------------------------------------------------------
    if ($signal == 11) {
        $count++;
        quest::debug("Frostbane Controller: Received signal 11 — a hand died. Count = $count");

        if ($count == 1) {
            quest::debug("Frostbane Controller: One hand remains. Making survivor vulnerable.");
            quest::signalwith(1848, 1); # Right Hand vulnerable
            quest::signalwith(1849, 1); # Left Hand vulnerable
        }
        elsif ($count == 2) {
            quest::debug("Frostbane Controller: Both hands dead. Spawning Frostbane Core (1839).");
            quest::spawn2(1839, 0, 0, 417.93, -8.81, 8.60, 376);
            $count = 0;
        }
    }

    # -------------------------------------------------------
    # 100–102 = Right Hand HP triggers (80/40/10%)
    # -------------------------------------------------------
    elsif ($signal >= 100 && $signal <= 102) {
        quest::debug("Frostbane Controller: Right Hand HP event ($signal). Activating Left Hand, freezing Right.");
        quest::shout("The Right Hand falters, its counterpart awakens!");
        quest::signalwith(1848, 2);  # Right becomes invul
        quest::signalwith(1849, 1);  # Left becomes active
    }

    # -------------------------------------------------------
    # 200–202 = Left Hand HP triggers (80/40/10%)
    # -------------------------------------------------------
    elsif ($signal >= 200 && $signal <= 202) {
        quest::debug("Frostbane Controller: Left Hand HP event ($signal). Activating Right Hand, freezing Left.");
        quest::shout("The Left Hand weakens, and the Right Hand surges forth!");
        quest::signalwith(1849, 2);  # Left becomes invul
        quest::signalwith(1848, 1);  # Right becomes active
    }

    # -------------------------------------------------------
    # 10 = Start Encounter (Optional Trigger)
    # -------------------------------------------------------
    elsif ($signal == 10) {
        quest::debug("Frostbane Controller: Start signal (10) received. Checking for Hands...");
        if (quest::isnpcspawned(1848) && quest::isnpcspawned(1849)) {
            if (quest::ChooseRandom(0, 1) == 0) {
                quest::debug("Frostbane Controller: Random start — activating Right Hand first.");
                quest::signalwith(1848, 1);
                quest::signalwith(1849, 2);
                quest::shout("The Right Hand stirs to life!");
            } else {
                quest::debug("Frostbane Controller: Random start — activating Left Hand first.");
                quest::signalwith(1849, 1);
                quest::signalwith(1848, 2);
                quest::shout("The Left Hand shudders and awakens!");
            }
        } else {
            quest::debug("Frostbane Controller: Start signal ignored — one or both hands missing.");
        }
    }

    # -------------------------------------------------------
    # Fallback — unknown signal
    # -------------------------------------------------------
    else {
        quest::debug("Frostbane Controller: Received unrecognized signal ID [$signal]. Ignoring.");
    }
}

# ===========================================================
# Safety Reset — if controller despawns or event fails
# ===========================================================
sub EVENT_DEATH_COMPLETE {
    quest::debug("Frostbane Controller: DEATH event — resetting encounter.");
    quest::signalwith(1848, 1);
    quest::signalwith(1849, 1);
    $count = 0;
}

sub EVENT_DEPOP {
    quest::debug("Frostbane Controller: DEPOP event — cleaning up encounter state.");
    quest::signalwith(1848, 1);
    quest::signalwith(1849, 1);
    $count = 0;
}
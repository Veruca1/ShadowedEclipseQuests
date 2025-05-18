sub EVENT_SIGNAL {
    if ($signal == 101) { # Failure / wipe       
        # Let zone_controller know the event wiped
        quest::signalwith(10, 20); # 10 = zone_controller, 20 = custom wipe code
        quest::signalwith(164120, 10);
        quest::depop();
    }
    elsif ($signal == 201) { # Success
        quest::signalwith(164111, 101); # IMMEDIATE event reset on combat end
    }
}
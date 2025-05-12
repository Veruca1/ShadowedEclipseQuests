sub EVENT_SPAWN {
    quest::setnexthpevent(80);
}

sub EVENT_HP {
    if ($hpevent == 80) {
        quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        quest::setnexthpevent(60);
    } elsif ($hpevent == 60) {
        quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        #quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        quest::setnexthpevent(40);
    } elsif ($hpevent == 40) {
        quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        #quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        #quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        quest::setnexthpevent(20);
    } elsif ($hpevent == 20) {
        quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        #quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        #quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
        #quest::spawn2(108518, 0, 0, $x, $y, $z, $h); # NPC: #Protector_of_Phara_Dar
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1427, 34, 0);
}
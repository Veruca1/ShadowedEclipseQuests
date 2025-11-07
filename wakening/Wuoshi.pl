sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 658 => 3)) {
        quest::say("You have done well, mortal. Those pests were beneath my concern, yet their presence was an annoyance. Since you have seen fit to rid me of them, I shall grant you my attention—for a time.");

        quest::popup("The Dragon’s Warning", "
        <c '#00FF00'>*Wuoshi coils his great form, emerald scales catching the dim light as he regards you with piercing, ancient eyes.*</c><br><br>

        \"You seek answers, and so I shall grant them. These lands are not as they once were. The mortals of this realm have laid down their arms before the Arm—not by force, nor by fear, but by will. A most dangerous thing, indeed.\"<br><br>

        \"At the heart of this shift is Nyseria, a sorceress of great cunning. Where others conquer with blade and fire, she bends minds and warps loyalties. Even Tunare, the Mother of All, has fallen into her grasp. But not all have been swayed, and thus, the Arm moves to silence them.\"<br><br>

        \"Dragons do not meddle in the squabbles of lesser beings, yet even we are not blind. If you wish to stand against this tide, you must first carve a path through the stronghold of Kael Drakkel. Tormax and his kin have bound themselves to the Arm, and they will not suffer your interference lightly.\"<br><br>

        \"To breach their fortress, you must first unravel its veil of secrecy. Five encampments lie scattered across these lands, each bearing the mark of the Arm. From each, you must claim an insignia—five in total. Four shall be combined into the key that will open your way. Bring me this proof, and I shall grant you what aid I may.\"<br><br>

        <c '#00FF00'>*Wuoshi’s eyes narrow, his voice a low rumble.*</c><br><br>

        \"Do not mistake my words for kindness. I aid you only because it serves my interests. Tread carefully, mortal, for not all is as it seems in these lands.\"");

        # Depop all NPCs with ID 1699
        quest::depopall(1699);
    }
    elsif (plugin::check_handin(\%itemcount, 665 => 1)) {
        quest::say("So, you have gathered what is needed. Very well, mortal. Take this and tread carefully—you are stepping into the jaws of fate itself.");
        quest::summonitem(664); # Key to Kael Drakkel

        quest::say("I'm sensing something powerful trying to reach you. This could be good or bad... Either way, I'm not getting involved.");
        
        quest::signalwith(10, 1); # Sends a signal to NPC ID 10 with signal 1
        quest::depop();
    }
    else {
        plugin::return_items(\%itemcount);
    }
}

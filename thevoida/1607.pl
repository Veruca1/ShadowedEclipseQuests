sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::popup(
            "Echoes Beyond the Void",
            "You stand at the <c \"#9900CC\">end of all things</c>. This place—<c \"#CC00CC\">The Void</c>—is not just forgotten by time... it exists outside of it.<br><br>" .
            "The <c \"#99CCFF\">Lunar Shard</c> that brought you here... <c \"#FF99FF\">you’ve felt it, haven’t you?</c> That subtle hum in your pack? That pull toward something greater, something inevitable? That shard is a remnant of a battle long hidden—a last spark stolen from the corpse of dying divinity.<br><br>" .
            "All around you lie the remnants of <c \"#FF6666\">gods</c>, <c \"#9999FF\">planes</c>, and <c \"#CCCCCC\">forgotten ages</c>. But even in this stillness... forces gather.<br><br>" .
            "Soon, you will be asked to step through a breach to <c \"#FFCC66\">Luclin</c>, a shattered moon steeped in shadow. There, one of <c \"#990000\">Nyseria's</c> most powerful allies stirs: <c \"#CC6666\">Sel’Rheza</c>, master of illusory magic and the architect of a quiet doom.<br><br>" .
            "They are not alone. Whispers speak of <c \"#9966FF\">Lord Seru</c>, <c \"#996666\">Grieg</c>, and worse—twisted echoes of what once was. Entire regions have begun to fracture, revealing terrifying <c \"#9933FF\">mirrored versions</c> of familiar places.<br><br>" .
            "<c \"#660066\">The Mistress of Shadows</c> watches. <c \"#CC00CC\">She knows</c> of your intrusion. She <c \"#FF3399\">does not yet approve</c>... but she is curious. Tread carefully, adventurer. The eyes of a goddess are upon you.",
            1
        );
    }
}
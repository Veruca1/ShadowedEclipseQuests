sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("Druzzil Ro",
            "Greetings, mortal<br><br>" .
            "*You* have been chosen.<br><br>" .
            "Here, in Arcstone, you will be given a final test before I open the way.<br><br>" .
            "You will face my minions to begin the process of ascending into the realms of the gods. <br><br>" .
            "The Gods and their realms have begun to influence the mortal realm of Norrath. <c \"#D080E0\">The War begins and you must play a part in it.</c>.<br><br>" .
            "You will be my hand, my eyes, and my ears. You will be freeing the Gods from their War one way or another. *The End* comes to us all if you do not.<br><br>" .
            "Disease. Nightmare. Justice. Honor. War. All of these and more begin to go unchecked on Norrath and the other Planes.<br><br>" .
            "Not only that but some seek their own grand ascendance. A malevolent force seeks to breach the Planes and Norrath alike.<br><br>" .
            "Go. Show me and the Mistress of Shadows that we were not wrong to test you. To name you our champions."
        );
        plugin::Whisper("I bid you away, Champion. Go and protect your people. Your home. Lest it all be lost.");
    }
}
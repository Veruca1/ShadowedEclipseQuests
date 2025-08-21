sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
            "So... you’ve come this far.<br><br>" .
            "*Ssraeshza* is not a place. It is a verdict.<br><br>" .
            "Here the weave grows thin, and threads twist where they should not. Every corner carved with purpose. Every shadow sharpened with intent.<br><br>" .
            "You will face what remains of ambition unbound, of hunger sanctified. They are waiting. All of them. <br><br>" .
            "And yet... beneath it all, a sound persists. A low hum... music not born of this world. <c \"#D080E0\">The Umbral Chorus draws near</c>.<br><br>" .
            "Do not rush. Explore *all*. The forsaken, the forgotten, the seemingly trivial—they were placed with care. Their meaning lies not in what they are, but in what they *reflect*.<br><br>" .
            "You will feel something watching. Some things will be familiar, some new. Yet, a darkness moves when you don't. A mirror that does not echo you, but your inner darkness. It's effect may also reflect the inner darkness of others.<br><br>" .
            "And when the sky fractures, and you meet those who should not walk—remember: she watches still. And the one who once *welcomed* you may walk beside her now.<br><br>" .
            "This is the last whisper before silence. Make it sing."
        );
        plugin::Whisper("The Moon offers no light here. Only echoes of what was... and what you might become.");
    }
}
sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
        "The caverns behind you were a whisper... this place is a scream.<br><br>" .
        "Welcome to <c \"#9999CC\">The Deep</c>, though the name is a mercy. It is not depth alone that defines it, but pressure. Layer upon layer of unseen will... pushing inward.<br><br>" .
        "The <c \"#8080C0\">Umbral Chorus</c> called me here, and so I came. I hear Sel'Rheza’s hum echo even through stone. She watches from the veiled corners where even Luclin dares not gaze.<br><br>" .
        "Beware the <c \"#CCCCCC\">minions</c> that crawl these tunnels. They are not mindless. Some whisper in tongues older than time. Slay them, study them—you may uncover fragments left by those who passed before you.<br><br>" .
        "And the <c \"#FF9999\">named</c>... well, they are no longer what they were. Some wear skin that is not theirs. Some speak in voices they stole. <c \"#9999FF\">Be wary of what seems real</c>. Not all that walks here is truth.<br><br>" .
        "There are rumors, too, passed mouth-to-mind among the faithful. A <c \"#FF6666\">great parasite</c> slumbers somewhere in the Deep, its tendrils curled through the rock. Feeding. Watching.<br><br>" .
        "And then... there is the path. The one you do not see, but must walk. <c \"#AAAAAA\">Trust what is not shown</c>. Trust the space between the stone. <c \"#999999\">Have faith in the unseen</c>.<br><br>" .
        "Only by stepping into the silence will you hear her song.<br><br>" .
        "<c \"#8080C0\">The Chorus waits… and watches.</c>"
        );
        quest::whisper("The Deep will unmake the unworthy. Do not be among them.");
    }
}
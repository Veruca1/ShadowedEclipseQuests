sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
        "<c \"#CCCCFF\">You walk beneath the skin of Luclin now.</c><br><br>" .
        "This place — <c \"#9999CC\">Akheva</c> — was once a temple-city of order and devotion.<br>" .
        "The Akhevans sang to the stars with perfect pitch. Their symmetry was sacred, their rituals precise.<br><br>" .

        "But time forgets. And the old hymns now echo with <c \"#FF9999\">dissonance</c>.<br>" .
        "The <c \"#9999CC\">Coven</c> stirs in these bones. Their purpose is veiled, but their hands reshape what was once flawless.<br><br>" .

        "Whispers speak of something <c \"#CCCCFF\">beneath</c> the ruins. A fractured lens... <c \"#FFDD99\">an Eclipse Mirror</c>.<br>" .
        "Not a relic — a wound. A looking glass for timelines that never were.<br>" .
        "The Chorus has no word for it. Only warnings.<br><br>" .

        "Some of the <c \"#CCAA88\">minions</c> here bear fragments of future memory.<br>" .
        "Their eyes reflect things that have not yet happened.<br>" .
        "If you kill them, do so with <c \"#CCCCCC\">intent</c>. Their blood may stain more than your blade.<br><br>" .

        "<c \"#AAAAFF\">If you find the Mirror... do not gaze too long. Reflections here may blink first.</c>"
        );

        quest::whisper("Your steps echo loudly here. The Chorus is listening — and so is something else.");
    }
}
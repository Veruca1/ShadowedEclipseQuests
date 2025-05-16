# NPC script: cycles through tints every 5 seconds
my @tints = (40); # Replace with valid tint IDs
my $current = 0;

sub EVENT_SPAWN {
    quest::settimer("tintcycle", 5);
}

sub EVENT_TIMER {
    if ($timer eq "tintcycle") {
        $npc->SetNPCTintIndex($tints[$current]);
        $current = ($current + 1) % scalar(@tints);
    }
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
        "You... you carry it, don’t you? <c \"#E0E070\">The Shard</c>. I feel it humming beneath your flesh.<br><br>" .
        "Not the idle crystal of broken planes, no... this is the <c \"#990066\">Planar Shard of the End</c>. Found in that cursed mirror of <c \"#CC99FF\">Veeshan’s Temple</c>, where the sky weeps backwards and time curls like ash.<br><br>" .
        "But it sleeps. It is <c \"#999999\">dormant</c>. As all truths are, until fed the blood of understanding.<br><br>" .
        "To awaken it—to make it <c \"#FFD700\">glow</c> with the promise of what lies beyond—you must offer something worthy. Not power. Not gold. No... <c \"#FFFFFF\">Knowledge</c>.<br><br>" .
        "Bring me the minds of <c \"#CCCCCC\">ten</c> who once shaped the spine of Neriak’s intellect. <br><br>" .
        "<c \"#A070C0\">Oosa Shadowthumper</c>, who mapped fear into flesh.<br>" .
        "<c \"#A070C0\">The Gobbler</c>, who dissected the dreams of children.<br>" .
        "<c \"#A070C0\">X’Ta Tempi</c>, whose whispers broke lesser seers.<br>" .
        "<c \"#A070C0\">Jarrex N’Ryt</c>, whose ink outlived kingdoms.<br>" .
        "<c \"#A070C0\">Vorshar the Despised</c>, who turned envy into alchemy.<br>" .
        "<c \"#A070C0\">Gath N’Mare</c>, whose patience outlasted time.<br>" .
        "<c \"#A070C0\">Verina Tomb</c>, who died a dozen deaths and learned from each.<br>" .
        "<c \"#A070C0\">Selzar L’Crit</c>, a voice they tried to silence, and failed.<br>" .
        "<c \"#A070C0\">Nallar Q’Tentu</c>, whose eyes recorded every treachery.<br>" .
        "<c \"#A070C0\">Talorial D’Estalian</c>, who painted the mind’s abyss.<br><br>" .
        "Take their <c \"#FF9999\">heads</c>. Combine them in your <c \"#9999FF\">tier vessel</c>. Form the <c \"#FFCC00\">Power of Combined Knowledge</c>... and give it to me.<br><br>" .
        "Only then will I awaken the shard. Only then will its path be clear.<br><br>" .
        "<c \"#8080C0\">The Chorus waits… and watches.</c>"
        );
        quest::whisper("You bring me heads... and I shall bring you vision.");
    }
}
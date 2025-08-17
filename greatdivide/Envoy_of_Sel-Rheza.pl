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
		my $curious_link = quest::silent_saylink("curious");
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
		"<c \"#8080C0\">The Chorus waits… and watches.</c><br><br>" .
		"<c \"#FFDD55\">If you truly possess the Planar Shard of the End, let me see it.</c>"
		);
		quest::whisper("You bring me heads... and I shall bring you vision.");
		quest::whisper("Or perhaps you are $curious_link about the echo of Neriak?");
	} elsif ($text =~ /curious/i) {
		quest::whisper("The veil can be parted. The Chorus allows access to:");
		my $neriaka_link = quest::silent_saylink("neriaka", "Neriak - Foreign Quarter");
		my $neriakb_link = quest::silent_saylink("neriakb", "Neriak - Commons");
		my $neriakc_link = quest::silent_saylink("neriakc", "Neriak - Third Gate");
		quest::message(315, "$neriaka_link | $neriakb_link | $neriakc_link");
	} elsif ($text =~ /^(neriaka|neriakb|neriakc)$/i) {
		CreateCustomDZ($text, "Neriak - " . GetNeriakZoneName($text));
	} elsif ($text =~ /ready/i) {
		my $dz = $client->GetExpedition();
		if ($dz) {
			my $zone_short = $dz->GetZoneName();
			quest::whisper("The veil thins. You are being drawn to: $zone_short.");
			$client->MovePCDynamicZone($zone_short);
		} else {
			quest::whisper("You are not yet tethered to an echo. Speak again when you are.");
		}
	}
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $flag_key = "${char_id}_neriak_flag";

    if (plugin::check_handin(\%itemcount, 87479 => 1)) {
        if (!quest::get_data($flag_key)) {
            my $clicker_ip = $client->GetIP();
            my $group = $client->GetGroup();
            my $raid = $client->GetRaid();
            my $flagged = 0;

            if ($group) {
                for (my $i = 0; $i < $group->GroupCount(); $i++) {
                    my $member = $group->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip) {
                        $member->SetZoneFlag(40);  # Neriak A
                        $member->SetZoneFlag(41);  # Neriak B
                        $member->SetZoneFlag(42);  # Neriak C
                        $flagged = 1;
                    }
                }
                quest::we(15, "$name and group members on the same IP have pierced the veil of Neriak's forbidden knowledge.") if $flagged;
            } elsif ($raid) {
                for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                    my $member = $raid->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip) {
                        $member->SetZoneFlag(40);
                        $member->SetZoneFlag(41);
                        $member->SetZoneFlag(42);
                        $flagged = 1;
                    }
                }
                quest::we(15, "$name and raid members on the same IP have pierced the veil of Neriak's forbidden knowledge.") if $flagged;
            } else {
                $client->SetZoneFlag(40);
                $client->SetZoneFlag(41);
                $client->SetZoneFlag(42);
                quest::we(15, "$name has pierced the veil of Neriak's forbidden knowledge.");
            }

            quest::set_data($flag_key, 1);
            quest::summonitem(87479);  # Return the original item
            quest::popup("The Envoy of Sel'Rheza", "Yes... the shard stirs in your grasp. The blood of thought feeds it now.<br><br><c \"#70FF70\">You are attuned to Neriak.</c>");
        } else {
            quest::popup("The Envoy of Sel'Rheza", "You have already gazed through the mind’s mirror. The shard knows its path.");
            quest::summonitem(87479);  # Return the item even if already flag is set
        }
    }
    elsif (plugin::check_handin(\%itemcount, 39634 => 1)) {
        $client->DeleteItemInInventory(39634, 0);
        $client->DeleteItemInInventory(87479, 0);
        quest::summonitem(39617);
        quest::popup("The Envoy of Sel'Rheza",
            "Ah... you bring the <c \"#FFCC00\">Power of Combined Knowledge</c>...<br><br>" .
            "<c \"#70FF70\">Congratulations, you now hold the ability to head to Luclin.</c><br><br>" .
            "Only then will the chorus show you the final door.");
        quest::whisper("Combine it, and the shard will sing its true name.");
    }

    plugin::return_items(\%itemcount);
}

# DZ creation helper
sub CreateCustomDZ {
	my ($shortname, $fullname) = @_;
	my $dz_duration = 14400; # 4 hours
	my $min_players = 1;
	my $max_players = 6;
	my $expedition_name = "DZ - $fullname";
	my $dz = $client->CreateExpedition($shortname, 0, $dz_duration, $expedition_name, $min_players, $max_players);
	if ($dz) {
		my $ready_link = quest::silent_saylink("ready");
		quest::whisper("An echo of '$fullname' has been awakened. Say $ready_link when your spirit is prepared.");
	} else {
		quest::whisper("This echo remains sealed. Try again or consult the Chorus.");
	}
}

# Helper to return full zone name based on short name
sub GetNeriakZoneName {
	my ($short) = @_;
	return "Foreign Quarter" if $short eq "neriaka";
	return "Commons" if $short eq "neriakb";
	return "Third Gate" if $short eq "neriakc";
	return "Unknown";
}
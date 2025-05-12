sub EVENT_SPAWN {
    quest::shout("Why have I been summoned here? I may only be Xyron's pet, but your journey ends here!");
    quest::setnexthpevent(90);
}

sub EVENT_HP {
    if ($hpevent == 90) {
        AdjustSizeAndSpawnSkeletons();
        quest::setnexthpevent(70);
    }
    elsif ($hpevent == 70) {
        AdjustSizeAndSpawnSkeletons();
        quest::setnexthpevent(50);
    }
    elsif ($hpevent == 50) {
        AdjustSizeAndSpawnSkeletons();
        quest::setnexthpevent(30);
    }
    elsif ($hpevent == 30) {
        AdjustSizeAndSpawnSkeletons();
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # NPC is in combat
        quest::settimer("bonesplinter", 25);
    } elsif ($combat_state == 0) {  # NPC is out of combat
        quest::setnexthpevent(90);
        $npc->SetHP($npc->GetMaxHP());
        quest::stoptimer("bonesplinter");
        $npc->ChangeSize(7);  # Reset size when out of combat
    }
}

sub EVENT_TIMER {
    if ($timer eq "bonesplinter") {
        my @hatelist = $npc->GetHateList();
        foreach my $n (@hatelist) {
            next unless defined $n;
            next unless $n->GetEnt();
            next if (!$n->GetEnt()->IsClient() && !$n->GetEnt()->IsBot());
            $npc->SpellFinished(9412, $n->GetEnt()->CastToMob());  # Cast spell 9412
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("bonesplinter");
    quest::signalwith(77027, 9, 2);
}

sub AdjustSizeAndSpawnSkeletons {
    my $CurSize = $npc->GetSize();
    quest::emote("winces in pain as his bones break.");
    $npc->ChangeSize($CurSize - 1);

    # Shout and spawn 5 skeletons
    quest::shout("Pieces of me, arise to slay the enemy!");
    for (my $i = 0; $i < 5; $i++) {
        quest::spawn2(1249, 0, 0, $x + (rand(10) - 5), $y + (rand(10) - 5), $z, $h);  # Spawns skeletons randomly near the NPC
    }

    # Apply scream agony effect
    ScreamAgony();
}

sub ScreamAgony {
    my @hatelist = $npc->GetHateList();
    foreach my $n (@hatelist) {
        next unless defined $n;
        my $ent = $n->GetEnt();
        next unless $ent;
        next unless $ent->IsClient();
        my $client = $ent->CastToClient();
        $npc->SpellFinished(9413, $client);  # Cast spell 9413 (Scream of Agony)
    }
}

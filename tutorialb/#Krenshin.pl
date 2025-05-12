sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::setnexthpevent(90);
      #  quest::debug("Krenshin: Combat started. Next HP event set to 90%");
    } else {
        #quest::debug("Krenshin: Combat ended.");
    }
}

sub EVENT_HP {
  #  quest::debug("Krenshin HP Event Triggered: $hpevent%");

    if ($hpevent == 90) {
        TossPlayer();
        quest::setnexthpevent(60);
    }
    elsif ($hpevent == 60) {
        TossPlayer();
        quest::setnexthpevent(30);
    }
    elsif ($hpevent == 30) {
        TossPlayer();
    }
}

sub TossPlayer {
    my @hate_list = $npc->GetHateList();
    if (@hate_list > 0) {
        my $target = $hate_list[int(rand(@hate_list))]->GetEnt();
        if ($target) {
            $npc->Emote("flails wildly, grabbing a nearby adventurer with terrifying force.");

            if ($target->IsClient()) {
                my $client = $target->CastToClient();
                $client->Message(13, "Krenshin flails around, slamming you back against the wall!");
                $npc->SpellFinished(40677, $client);
              #  quest::debug("Krenshin casts spell 40677 on client: " . $client->GetCleanName());
            }
            elsif ($target->IsBot()) {
                my $bot = $target->CastToBot();
                $npc->SpellFinished(40677, $bot);
              #  quest::debug("Krenshin casts spell 40677 on bot: " . $bot->GetCleanName());
            }
        }
    } else {
       # quest::debug("Krenshin tried to flail someone but the hate list was empty.");
    }
}

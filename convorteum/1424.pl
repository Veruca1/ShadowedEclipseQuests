# ===========================================================
# Hollen Shadowstalker — The Cursebreaker Quest NPC
# ===========================================================

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("Hollen Shadowstalker",
            "<c \"#FFA500\">Ahh, mortal...</c> You reek of the faint chill that follows a cursed trinket.<br><br>"

            . "<c \"#FFFF99\">Do the whispers claw at your mind?</c> Do your charms hum with unseen malice?<br><br>"

            . "Then perhaps fate has led you to me — <c \"#FFFFFF\">Hollen Shadowstalker</c>, curator of the <c \"#FFA500\">broken and the bewitched</c>.<br><br>"

            . "The curses that bind you can be shattered... but not easily. You must seek out and claim <c \"#FFFF99\">ten unique Curse Breakers</c> — relics born of malediction and redemption alike.<br><br>"

            . "When all ten are yours, place them together within your <c \"#FFA500\">tiered reforging kit</c>, and forge the <c \"#FFFFFF\">Seal of Curseproof</c>.<br><br>"

            . "Bring that seal to me, and I shall weave upon you a shroud that no haunting may pierce — <c \"#FFFF99\">a blessing of true curse immunity</c>.<br><br>"

            . "<c \"#FFA500\">Go, then.</c> Face the Lantern’s Tower, the echoes of the damned, and the claws of your own folly.<br><br>"

            . "<c \"#FFFFFF\">If you return intact...</c> perhaps the curse never truly wanted you dead at all."
        );
    }
}

# ------------------------------------------------------------
# EVENT_ITEM — Turn-in for Seal of Curseproof (Item 62544)
# ------------------------------------------------------------
sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 62544 => 1)) {
        my $charid = $client->CharacterID();
        my $flag   = "CONV_Cursed_Broken_" . $charid;
        my $name   = $client->GetCleanName();

        # Prevent duplicate rewards
        if (quest::get_data($flag)) {
            $client->Message(15, "Hollen smirks, 'You already bear my protection, fool. Do not tempt fate twice.'");
            plugin::return_items(\%itemcount);
            return;
        }

        # Set the immunity flag
        quest::set_data($flag, 1);

        # Apply visuals + confirmation
        $client->Message(13, "Hollen whispers: 'The curse will trouble you no more...'");
        $client->SpellEffect(4580, 0);
        quest::ding();
        $client->Message(15, "Hollen Shadowstalker grins darkly, 'You are now curse-proof.'");

        # =============================
        #   Grant the title: Cursebreaker
        # =============================
        $client->SetTitleSuffix("Cursebreaker", 1);   # Add title suffix
        $client->NotifyNewTitlesAvailable();           # Make it visible immediately
        quest::whisper("You have earned the title 'Cursebreaker'!");
        quest::we(13, "$name has shattered the curse and earned the title Cursebreaker!");
        quest::discordsend("titles", "$name has earned the title of Cursebreaker!");

        # =============================
        #   Propagate to same-IP group members
        # =============================
        my $player_ip = $client->GetIP();
        my @group = $entity_list->GetClientList();
        foreach my $pc (@group) {
            next if !$pc || !$pc->IsClient();
            next if $pc->CharacterID() == $charid;
            next if $pc->GetIP() != $player_ip;

            my $gflag = "CONV_Cursed_Broken_" . $pc->CharacterID();
            next if quest::get_data($gflag);

            quest::set_data($gflag, 1);
            $pc->Message(15, "A faint warmth spreads through your bones... the curse’s hold weakens.");
            $pc->SpellEffect(4580, 0);
        }
    }

    plugin::return_items(\%itemcount);
}
sub EVENT_ITEM_CLICK {
    if ($itemid == 9547) {
        my $shrink_spell_id = 345;  # Spell ID for Shrink

        # Shrink client
        SpellShrink($client, $shrink_spell_id);

        # Shrink client's pet
        if ($client->GetPetID() > 0) {
            my $client_pet = $entity_list->GetNPCByID($client->GetPetID());
            SpellShrink($client_pet, $shrink_spell_id);
        }

        # Shrink bots and their pets
        my @bot_list = $entity_list->GetBotListByCharacterID($client->CharacterID());
        foreach my $bot (@bot_list) {
            SpellShrink($bot, $shrink_spell_id);

            if ($bot->GetPetID() > 0) {
                my $bot_pet = $entity_list->GetNPCByID($bot->GetPetID());
                SpellShrink($bot_pet, $shrink_spell_id);
            }
        }

        $client->Message(15, "The world begins to grow.");
    }
}

sub SpellShrink {
    my ($target, $spell_id) = @_;
    return unless defined $target;

    $target->SpellFinished($spell_id, $target);
}

sub EVENT_ITEM_CLICK {
    if ($itemid == 9547) {
        ShrinkClient($client);

        my @bot_list = $entity_list->GetBotListByCharacterID($client->CharacterID());
        if (defined $bot_list[0]) {
            foreach my $bot (@bot_list) {
                # Shrink the bot
                ShrinkEntity($bot, $client);
                
                # Shrink the bot's pet, if it exists
                if ($bot->GetPetID() > 0) {
                    my $bot_pet = $entity_list->GetNPCByID($bot->GetPetID());
                    ShrinkEntity($bot_pet, $client);
                }
            }
        }
        $client->Message(15, "The world begins to grow.");
    }
}

sub ShrinkClient {
    my ($client) = @_;

    # Shrink the client's pet
    if ($client->GetPetID() > 0) {
        my $client_pet = $entity_list->GetNPCByID($client->GetPetID());
        ShrinkEntity($client_pet, $client);
    }

    # Shrink the client
    ShrinkEntity($client, $client);
}

sub ShrinkEntity {
    my ($entity, $client) = @_;

    return unless defined $entity && $entity->isa("Mob");

    $client->SetTarget($entity);
    $client->SendGMCommand("#feature size 2", 1);
}
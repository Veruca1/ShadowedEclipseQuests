sub EVENT_SAY {
    if ($text=~/hail/i) {
        my $rename_pet = quest::saylink("rename my pet", 1);
        quest::say("Greetings, traveler! If you have a pet, I can help you rename it. Just tell me to $rename_pet, and I'll grant you a pet name change.");
    }
    elsif ($text=~/rename my pet/i) {
        if ($client->GetPetID()) { 
            quest::say("Alright! I'm granting you the ability to rename your pet. The next time you log in, you'll be prompted to choose a new name.");
            $client->GrantPetNameChange();
        } else {
            quest::say("You don't seem to have a pet. Summon one first, and then we can rename it.");
        }
    }
}

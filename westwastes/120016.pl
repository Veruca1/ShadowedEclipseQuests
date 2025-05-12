sub EVENT_HP {
    if ($npc->GetHPRatio() <= 50) {
        quest::modifynpcstat("special_abilities", "46,1^28,1^8,1^11,1^12,1^15,1^26,1");

        # Define the radius in which to send the message
        my $radius = 100;  # Set the radius (in game units)
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();

        # Array of possible messages
        my @messages = (
            "You can't fool me any longer!",
            "I've had enough of your nonsense!",
            "Your time is up, prepare for defeat!",
            "No more games, face my wrath!",
            "You won't escape this time!",
            "I've become stronger, you're doomed!",
            "Your powers are no match for mine!",
            "It's too late to back out now!",
            "You're playing with fire, and I've got the blaze!",
            "This battle will end in your failure!"
        );

        # Select a random message
        my $random_message = $messages[int(rand(scalar(@messages)))];

        # Iterate through all clients in the entity list and send the message if within radius
        foreach my $entity ($npc->GetEntityList()->GetClientList()) {
            if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $entity->Message(14, $random_message); # Client Message (Type 14)
            }
        }
    }
} # <-- Closing curly bracket for EVENT_HP

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 1);
}

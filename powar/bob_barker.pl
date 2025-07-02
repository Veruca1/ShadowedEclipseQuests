sub EVENT_SAY {
    return unless $client && $client->IsClient();

    if ($text =~ /hail/i) {
        $client->Message(15, "Welcome to the Infinite Arena, challenger.");
        $client->Message(15, "Use #arena help to view all commands.");
        $client->Message(15, "Basic Flow:");
        $client->Message(15, "  #arena start     - Begin your run");
        $client->Message(15, "  #arena continue  - After a wave, move to the next");
        $client->Message(15, "  #arena resume    - Retry the current wave");
        $client->Message(15, "  #arena restart   - Reset your progress to Wave 1");
        $client->Message(15, "  #arena status    - See your wave and personal best");
        $client->Message(15, "Every 5 waves brings elites. Every 10, a boss.");
        $client->Message(15, "Survive as long as you can.");
    }
}

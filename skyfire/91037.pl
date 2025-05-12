sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Offer a clickable saylink to reset the globes
        $client->Message(14, "If you'd like to reset the globes, click [Reset Globes].");
    }
    if ($text=~/reset globes/i) {
        # Reset all related globals
        quest::delglobal("door_one");
        quest::delglobal("door_two");
        quest::delglobal("door_three");
        quest::delglobal("door_four");
        quest::delglobal("dragon_not_ready");

        $client->Message(14, "The globes and cooldown timer have been reset. You may spin the globes again.");
    }
}

sub EVENT_SAY {
    if ($text=~/hail/i) {
        $client->Message(15, "These Gloomingdeep scum are everywhere... if you're up for some cleanup duty, I've got just the task for you.");
        quest::taskselector(35);  # Task: Taking Out the Trash
    }
}




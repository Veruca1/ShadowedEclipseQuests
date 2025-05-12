sub EVENT_SPAWN {
    quest::set_proximity_range(40, 40);
}

sub EVENT_ENTER {
    $client->Message(15, "Did you remember to make your bot? You'll need them!");
}

sub EVENT_SAY {
    if ($text=~/hail/i) {
        if ($client->IsTaskCompleted(36)) {
            plugin::Whisper("Great job finding the relics! You've uncovered a piece of Gloomingdeep's hidden history.");
            return;
        }

        if ($client->IsTaskActive(36)) {
            plugin::Whisper("Still digging through the past, are we?");

            my %next_hints = (
                0 => "something about a Goblin Idol hidden with their slaves in the lowest mines.",
                1 => "a kobold heirloom hidden behind one of the old beds in their cell blocks.",
                2 => "a map tangled in webbing somewhere deep in the spider caverns.",
                3 => "a stone fragment guarded closely by the Overlord himself.",
                4 => "a cruel whip once wielded by the slavemaster — still near his remains, they say.",
            );

            my $task_id = 36;
            my $has_all_relics = 1;

            for my $step (0..4) {
                if ($client->IsTaskActivityActive($task_id, $step)) {
                    $has_all_relics = 0;
                }
            }

            my $final_step_active = $client->IsTaskActivityActive($task_id, 5);

            # Always give the hint for next active relic step, if one exists
            for my $activity_id (sort keys %next_hints) {
                if ($client->IsTaskActivityActive($task_id, $activity_id)) {
                    plugin::Whisper("Looks like you're after the next relic. What I heard was $next_hints{$activity_id}");
                    last;
                }
            }

            # Then handle the final step logic
            if ($final_step_active) {
                if ($has_all_relics) {
                    plugin::Whisper("Ah, you’ve brought them all. The relics hum in harmony... let me do the rest.");
                    $client->UpdateTaskActivity($task_id, 5, 1);
                } else {
                    plugin::Whisper("You're close, but I don't see everything just yet. Keep searching.");
                }
                return;
            }

            plugin::Whisper("You've come far... maybe it's time to return with what you've found.");
            return;
        }

        plugin::Whisper("You feel it too, don't you? The echoes of rebellion still linger in these tunnels. The Gloomingdeep revolt was more than a prison break... it was a spark of something greater.");
        plugin::Whisper("Relics from that uprising are still scattered across the mines — left behind in haste, hidden in defiance. Find them, and we might uncover the full story.");
        plugin::Whisper("If you're ready to begin the search, say [I will help].");
    }

    if ($text=~/i will help/i) {
        if ($client->IsTaskCompleted(36)) {
            plugin::Whisper("You've already completed this task, adventurer.");
            return;
        }

        plugin::Whisper("Good. The first artifact is said to be hidden among the goblins' own supplies. Recover it, and the rest may reveal themselves in time.");
        quest::taskselector(36);
    }
}

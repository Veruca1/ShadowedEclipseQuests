sub EVENT_ENTERZONE {
    my $task_id = 23; 
    my $min_level = 1;

    if ($ulevel >= $min_level) {
        if (!quest::istaskactive($task_id)) {
            quest::assigntask($task_id);
        }
    }
}


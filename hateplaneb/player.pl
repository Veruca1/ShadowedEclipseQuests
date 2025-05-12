sub EVENT_ENTERZONE {
    my $task_id = 9; 
    my $min_level = 50;

    if ($ulevel >= $min_level) {
        if (!quest::istaskactive($task_id)) {
            quest::assigntask($task_id);
        }
    }
}
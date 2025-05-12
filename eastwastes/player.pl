sub EVENT_ENTERZONE {
    my $task_id = 32; 
    my $min_level = 60;

    if ($ulevel >= $min_level) {
        if (!quest::istaskactive($task_id)) {
            quest::assigntask($task_id);
        }
    }
}
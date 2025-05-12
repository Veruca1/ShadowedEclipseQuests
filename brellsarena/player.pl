sub EVENT_ENTERZONE {
    my $task_id = 10; 
    my $min_level = 20;

    if ($ulevel >= $min_level) {
        if (!quest::istaskactive($task_id)) {
            quest::assigntask($task_id);
        }
    }
}
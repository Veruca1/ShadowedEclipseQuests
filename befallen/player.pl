sub EVENT_ENTERZONE {
    my $task_id = 4; 
    my $min_level = 10;

    if ($ulevel >= $min_level) {
        if (!quest::istaskactive($task_id) || !quest::istaskcompleted($task_id)) {
            quest::assigntask($task_id);
        }
    }
}
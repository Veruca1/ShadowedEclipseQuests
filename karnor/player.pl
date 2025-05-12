sub EVENT_ENTERZONE {
    my $task_id = 22; 
    my $min_level = 1;

    if ($ulevel >= $min_level) {
        if (!quest::istaskactive($task_id)) {
            quest::assigntask($task_id);
        }
    }
}

sub EVENT_DISCOVER_ITEM{
    $linkid=quest::varlink($itemid);
    quest::we(15, "$name has discovered $linkid");
    #quest::whisper("$name has discovered $linkid");
}
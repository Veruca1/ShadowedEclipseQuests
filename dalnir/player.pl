sub EVENT_DISCOVER_ITEM{
    $linkid=quest::varlink($itemid);
    quest::we(15, "$name has discovered $linkid");
    #quest::whisper("$name has discovered $linkid");
}
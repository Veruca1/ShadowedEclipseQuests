sub EVENT_ENTERZONE {
    if ($zoneid == 164 && $instanceversion == 1) {
        quest::signalwith(1937, 1);
    }
}
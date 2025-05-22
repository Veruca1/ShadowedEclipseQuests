sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 50);

    if (!quest::isnpcspawned(2145)) {
        quest::spawn2(2145, 0, 0, -1376.79, 1801.93, 172.06, 126.75);
    }

    if (!quest::isnpcspawned(2163)) {
        quest::spawn2(2163, 0, 0, -1341.79, 1798.97, 167.63, 132.50);
    }
}
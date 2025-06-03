sub EVENT_SPAWN {
    plugin::DoHotzoneSpawn();
}

sub EVENT_TIMER {
    plugin::DoHotzoneTimer($timer);
}
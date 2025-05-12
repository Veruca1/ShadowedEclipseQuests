sub EVENT_DEATH_COMPLETE {
    # When Orc Oracle (1721) dies, depop Orc Legionnaire (1722)
    quest::depop(1722);
}

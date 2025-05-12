sub EVENT_DEATH_COMPLETE {
    # When Orc Legionnaire (1722) dies, depop Orc Oracle (1721)
    quest::depop(1721);
}

sub EVENT_DEATH_COMPLETE {
  # Send signal 99 to restart the druid cycle
  quest::signalwith(10, 99);
  quest::signalwith(10, 3);
}

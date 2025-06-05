sub EVENT_ENTERZONE {
    if ($zoneid == 164 && $instanceversion == 1) {
        quest::signalwith(1937, 1);
    }
}

# sub EVENT_WARP {
#     # Exclude GM players
#     if ($client->GetGM()) {
#         return;
#     }

#     # Kill the player as punishment for warping
#     $client->Kill();
# }
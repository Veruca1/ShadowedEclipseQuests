# sub EVENT_WARP {
#     # Defensive check: ensure $client is defined and is a client
#     return unless defined $client && $client->IsClient();

#     # Exclude GM players
#     if ($client->GetGM()) {
#         return;
#     }

#     # Kill the player as punishment for warping
#     $client->Kill();
# }
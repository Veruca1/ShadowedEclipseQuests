# ===========================================================
# Halloween Event DZ Controller - Tower of Shattered Lanterns
# Restricted Access (Testing Only)
# ===========================================================

my $expedition_name_prefix = "DZ - ";
my $min_players = 1;
my $max_players = 6;
my $dz_duration = 28800;   # 8 hours

# ✅ Allowed testers (case-insensitive match)
my @allowed_names = ("Milo", "Twister", "Dizix", "Sureu");  # <--- add your tester character names here

my %zone_versions = (
    "convorteum" => {
        1 => "Tower of Shattered Lanterns",
    },
);

sub EVENT_SAY {
    my $client      = plugin::val('$client');
    my $text        = plugin::val('$text');
    my $npc         = plugin::val('$npc');
    my $entity_list = plugin::val('$entity_list');
    return unless $client;

    my $name = $client->GetCleanName();
    my $allowed = 0;

    # Check whitelist
    foreach my $allowed_name (@allowed_names) {
        if (lc($name) eq lc($allowed_name)) {
            $allowed = 1;
            last;
        }
    }

    # Block anyone not in the allowed list
    if (!$allowed) {
        quest::whisper("The shadows pay you no heed, $name. Only chosen testers may enter.");
        return;
    }

    # === Normal DZ logic below ===
    if ($text =~ /hail/i) {
        my $zone_link = quest::saylink("Tower of Shattered Lanterns", 1, "Tower of Shattered Lanterns");
        quest::whisper("☠️ Welcome, mortal... This is the [Halloween Event] known as the Tower of Shattered Lanterns.");
        quest::whisper("Do you dare step inside [$zone_link] and face the horrors within?");
    }

    elsif ($text =~ /^Tower of Shattered Lanterns$/i) {
        my $zone    = "convorteum";
        my $version = 1;
        my $expedition_name = $expedition_name_prefix . $zone_versions{$zone}{$version};

        my $dz = $client->CreateExpedition($zone, $version, $dz_duration, $expedition_name, $min_players, $max_players);
        if ($dz) {
            my $era = plugin::DetermineEraForClient($client);

            my $inst_id = quest::GetInstanceID("convorteum", 1);
            quest::setglobal("era_" . $inst_id, $era, 7, "H6");

            quest::whisper("🎃 The Tower awaits. A dark expedition has been forged in the $era era: '$zone_versions{$zone}{$version}'.");

            my $ready_link = quest::saylink("ready", 1, "ready");
            quest::whisper("When your party is gathered, whisper [$ready_link] and I will guide you inside...");
        } 
        else {
            quest::whisper("Something wicked has gone wrong... the lanterns refuse to shatter this time.");
        }
    }

    elsif ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short_name = $dz->GetZoneName();

            my $inst_id = quest::GetInstanceID("convorteum", 1);
            my $era = $qglobals{"era_" . $inst_id} || "unknown";

            quest::whisper("The lanterns crack, shadows spill forth... You are drawn into your expedition: $zone_short_name! (Era: $era)");
            $client->MovePCDynamicZone($zone_short_name);
        } 
        else {
            quest::whisper("The lanterns remain still... you have no expedition to enter.");
        }
    }
}
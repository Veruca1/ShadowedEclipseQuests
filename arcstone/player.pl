sub EVENT_ENTERZONE {
    if ($zoneid == 369 && $instanceversion == 0) {
        my $x = 1668.00;
        my $y = -302.94;
        my $z = 9.47;
        my $h = 70.5;
        my $zone_name = "arcstone";
        my $version = 1;
        my $duration = 43200; # 12 hours

        my $group = $client->GetGroup();
        if ($group) {
            $client->SendToInstance("group", $zone_name, $version, $x, $y, $z, $h, $zone_name, $duration);
        } else {
            $client->SendToInstance("solo", $zone_name, $version, $x, $y, $z, $h, $zone_name, $duration);
        }
    }
}
sub EVENT_SPAWN {
    quest::set_proximity($x - 208, $x + 208, $y - 242, $y + 242, $z - 5, $z + 400);
}

sub EVENT_ENTER {
    return unless $client && $client->IsClient();

    if ($status < 80) {
        my $has_key = plugin::check_hasitem($client, 19719) || $client->KeyRingCheck(19719);
        return if $has_key;

        my $zone_id = 162; # ssratemple
        my $x = 0;
        my $y = 0;
        my $z = 2.2;
        my $h = 65;

        my $instance_id = $client->GetInstanceID();
        if ($instance_id > 0) {
            quest::MovePCInstance($zone_id, $instance_id, $x, $y, $z, $h);
        } else {
            quest::movepc($zone_id, $x, $y, $z, $h);
        }
    }
}
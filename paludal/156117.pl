sub EVENT_SPAWN {
    my $ex = $npc->GetX();
    my $ey = $npc->GetY();
    my $ez = $npc->GetZ();
    
    # Set the proximity around the NPC (with a specified range for x, y, z)
    quest::set_proximity($ex - 65, $ex + 65, $ey - 65, $ey + 65, $ez - 10, $ez + 20);
}

sub EVENT_ENTER {
    # Cast the Rain of Spores (2770) spell on the player who entered proximity
    quest::shout("You have set off a rain of spores!");
    $npc->CastSpell(2770, $client->GetID());
    
    # Depop (remove) the NPC after casting the spell
    $npc->Depop();
}
sub EVENT_DEATH_COMPLETE {
    # Screen shake effect for 3000ms with intensity 6
    $npc->CameraEffect(3000, 6);  # 3000ms screen shake

    # Death shout message
    quest::shout("As Drusella's bones fall to the ground, they let out a loud shrill cackle!");

    # Spawn Queen Drusella Sathir (NPC ID 1374) at location (-765.51, 170.79, 19.25) with heading 127.75
    quest::spawn2(1374, 0, 0, -765.51, 170.79, 19.25, 127.75);
    
    # Spawn Emperor Venril Sathir (NPC ID 1375) at location (-692.23, 170.78, 19.25) with heading 383.50
    quest::spawn2(1375, 0, 0, -692.23, 170.78, 19.25, 383.50);
}

# Initialize signal order and state tracking
my $signal_order_7_12 = 0;
my $signal_order_14_19 = 0;
my $signal_order_21_26 = 0;  # Add signal order for 21-26
my $expecting_signal_7_12 = 7;  # Track the next expected signal for the first batch (7-12)
my $expecting_signal_14_19 = 14;  # Track the next expected signal for the second batch (14-19)
my $expecting_signal_21_26 = 21;  # Track the next expected signal for the third batch (21-26)
my $signal_28_count = 0;  # Initialize a count variable for signal 28
my $signal_29_count = 0;  # Initialize the signal 29 count
my $signal_29_complete_count = 0;  # Initialize a counter for how many times we've reached 4 signal 29s
my $signal_30_received = 0;
my $signal_31_received = 0;
my $expecting_signal_33_38 = 0;


sub EVENT_SPAWN {
    # Spawn NPCs 1536, 1537, and 1538 at their specified locations
    quest::spawn2(1536, 0, 0, 1764.72, 818.93, 49.00, 258.50);
    quest::spawn2(1537, 0, 0, 1709.76, 817.91, 48.82, 256.50);
    quest::spawn2(1538, 0, 0, 1659.79, 814.77, 45.30, 255.75);
    quest::spawn2(1583, 0, 0, 727.25, 1536.80, 626.79, 280.75);
    quest::spawn2(1584, 0, 0, 682.23, 1389.90, 626.79, 29.75);
    quest::spawn2(1593, 0, 0, 1720.41, -161.57, -91.11, 292.75);
}

sub EVENT_SIGNAL {

    # Signal 1-6 Handling (start of the sequence)
    if ($signal == 1) {
        quest::shout("I have been watching you since you set foot in Kunark as you know. I knew you would defeat Zarrin; where he wanted to stop you, I wanted to... welcome you.");
    }
    elsif ($signal == 2) {
        quest::depop(1536);
        quest::depop(1537);
        quest::depop(1538);
        quest::settimer("spawn_npcs", 600);  # Set timer to respawn NPCs in 600 seconds
    }
    elsif ($signal == 3) {
        quest::spawn2(1539, 0, 0, 1101.03, 800.48, 223.19, 129);
    }
    elsif ($signal == 4) {
        quest::spawn2(1540, 0, 0, 1103.58, 1234.62, 242.74, 388.50);
    }
    elsif ($signal == 5) {
        quest::spawn2(1543, 0, 0, 734.07, 340.00, 218.52, 87.00);
    }
    elsif ($signal == 6) {
        my @client_list = $entity_list->GetClientList();  # Get all clients in the zone
        if (@client_list) {
            foreach my $client (@client_list) {
                if (defined $client) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Choose wisely!");
                }
            }
        }
        quest::spawn2(1547, 0, 0, 115.88, 360.32, 362.70, 129.75);
        quest::spawn2(1550, 0, 0, 249.68, 360.30, 362.69, 386.50);
        quest::spawn2(1546, 0, 0, 104.88, 240.20, 362.60, 131.00);
        quest::spawn2(1549, 0, 0, 261.26, 240.29, 365.44, 386.00);
        quest::spawn2(1548, 0, 0, 251.94, 120.01, 364.36, 386.75);
        quest::spawn2(1551, 0, 0, 109.41, 120.08, 362.61, 126.75);
    }
    elsif ($signal == 13) {
        my @client_list = $entity_list->GetClientList();  # Get all clients in the zone
        if (@client_list) {
            foreach my $client (@client_list) {
                if (defined $client) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Very Good! Now, Again!");
                }
            }
        }
        quest::spawn2(1553, 0, 0, 104.88, 240.20, 362.60, 131.00);
        quest::spawn2(1554, 0, 0, 261.26, 240.29, 365.44, 386.00);
        quest::spawn2(1555, 0, 0, 251.94, 120.01, 364.36, 386.75);
        quest::spawn2(1556, 0, 0, 109.41, 120.08, 362.61, 126.75);
        quest::spawn2(1557, 0, 0, 115.88, 360.32, 362.70, 129.75);
        quest::spawn2(1558, 0, 0, 249.68, 360.30, 362.69, 386.50);
    }

    # Signals 7-12 Handling    
    elsif ($signal >= 7 && $signal <= 12) {
        my @client_list = $entity_list->GetClientList();  # Get all clients in the zone

        if ($signal == $expecting_signal_7_12) {
            $signal_order_7_12++;
            $expecting_signal_7_12++;  # Move to the next expected signal for this sequence

            if ($signal_order_7_12 == 6) {  # Sequence complete
                foreach my $client (@client_list) {
                    if (defined $client) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "You have chosen, wisely.");
                        $client->CameraEffect(3000, 3);  # Apply CameraEffect
                    }
                }
                quest::spawn2(1552, 0, 0, 182.04, 265.10, 361.10, 257);  # Spawn NPC on successful sequence
                $expecting_signal_7_12 = 7;  # Reset expectation for the next sequence (7-12)
                $signal_order_7_12 = 0;
            }
        } else {
            # Reset on incorrect signal
            quest::depop(1547);
            quest::depop(1550);
            quest::depop(1546);
            quest::depop(1549);
            quest::depop(1548);
            quest::depop(1551);

            foreach my $client (@client_list) {
                if (defined $client) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "You have chosen, poorly.");
                }
            }

            $signal_order_7_12 = 0;
            $expecting_signal_7_12 = 7;  # Reset expectation for retry (7-12)
        }
    }

    # Signals 14-19 Handling
    elsif ($signal >= 14 && $signal <= 19) {
        my @client_list = $entity_list->GetClientList();  # Get all clients in the zone

        if ($signal == $expecting_signal_14_19) {
            $signal_order_14_19++;
            $expecting_signal_14_19++;  # Move to the next expected signal for this sequence

            if ($signal_order_14_19 == 6) {  # Sequence complete
                foreach my $client (@client_list) {
                    if (defined $client) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "You have chosen, wisely.");
                        $client->CameraEffect(3000, 3);
                    }
                }
                quest::spawn2(1559, 0, 0, 182.04, 265.10, 361.10, 257);  # Spawn NPC on successful sequence
                $expecting_signal_14_19 = 14;  # Reset expectation for the next sequence (14-19)
                $signal_order_14_19 = 0;
            }
        } else {
            # Reset on incorrect signal
            quest::depop(1553);
            quest::depop(1554);
            quest::depop(1555);
            quest::depop(1556);
            quest::depop(1557);
            quest::depop(1558);

            foreach my $client (@client_list) {
                if (defined $client) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "You have chosen, poorly.");
                }
            }

            $signal_order_14_19 = 0;
            $expecting_signal_14_19 = 14;  # Reset expectation for retry (14-19)
        }
    }

    # Signals 21-26 Handling    
elsif ($signal >= 21 && $signal <= 26) {
    my @client_list = $entity_list->GetClientList();  # Get all clients in the zone

    if ($signal == $expecting_signal_21_26) {
        $signal_order_21_26++;
        $expecting_signal_21_26++;  # Move to the next expected signal for this sequence

        if ($signal_order_21_26 == 6) {  # Sequence complete
            foreach my $client (@client_list) {
                if (defined $client) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "You have chosen, wisely.");
                    $client->CameraEffect(3000, 3);  # Apply CameraEffect
                }
            }
            quest::spawn2(1567, 0, 0, 182.04, 265.10, 361.10, 257);  # Spawn NPC on successful sequence
            $expecting_signal_21_26 = 21;  # Reset expectation for the next sequence (21-26)
            $signal_order_21_26 = 0;
        }
    } else {
        # Reset on incorrect signal
        quest::depop(1561);
        quest::depop(1562);
        quest::depop(1563);
        quest::depop(1564);
        quest::depop(1565);
        quest::depop(1566);

        foreach my $client (@client_list) {
            if (defined $client) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "You have chosen, poorly.");
            }
        }

        $signal_order_21_26 = 0;
        $expecting_signal_21_26 = 21;  # Reset expectation for retry (21-26)
    }
}

    # Signal 20 Handling (newly added)
    elsif ($signal == 20) {
        quest::spawn2(1561, 0, 0, 104.88, 240.20, 362.60, 131.00);
        quest::spawn2(1562, 0, 0, 261.26, 240.29, 365.44, 386.00);
        quest::spawn2(1563, 0, 0, 251.94, 120.01, 364.36, 386.75);
        quest::spawn2(1564, 0, 0, 109.41, 120.08, 362.61, 126.75);
        quest::spawn2(1565, 0, 0, 115.88, 360.32, 362.70, 129.75);
        quest::spawn2(1566, 0, 0, 249.68, 360.30, 362.69, 386.50);
        my @client_list = $entity_list->GetClientList();  # Get all clients in the zone
        if (@client_list) {
            foreach my $client (@client_list) {
                if (defined $client) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Very good! Now, finally, do it BACKWARDS");
                }
            }
        }
    }

# Signal 27 Handling (newly added)
elsif ($signal == 27) {
    quest::shout("Very good! Hahaha. You will make an excellent addition to my coven!");
    }

# Signal 28 Handling
elsif ($signal == 28) {
    # Increment the signal 28 count by 1 each time it is triggered
    $signal_28_count++;  
    
    # Debugging: Show the current signal 28 count
    #quest::shout("Signal 28 received. Current count: $signal_28_count");

    # When the count reaches 4, spawn the NPCs
    if ($signal_28_count >= 4) {
        #quest::shout("Signal 28 count reached 4. Spawning NPCs.");

        # Spawn the NPCs at the specified locations
        quest::spawn2(1573, 0, 0, -83.60, -292.30, 429.94, 256.50);
        quest::spawn2(1574, 0, 0, -85.94, -246.37, 429.94, 250.25);
        quest::spawn2(1575, 0, 0, -145.11, -285.99, 422.93, 251.50);
        quest::spawn2(1576, 0, 0, -144.58, -242.94, 422.93, 257.50);

        # Reset the count after spawning the NPCs
        $signal_28_count = 0;  # Reset count to 0 after spawning the NPCs
        #quest::shout("Signal 28 count reset after spawning NPCs.");
    } else {
        # Notify that more signals are required
        my $remaining = 4 - $signal_28_count;
        #quest::shout("Signal 28 received. Waiting for $remaining more signals.");
    }
}

# Signal 29 Handling
elsif ($signal == 29) {
    # Increment the count for Signal 29
    $signal_29_count++;

    # When the count reaches 4, we increase the completion counter
    if ($signal_29_count >= 4) {
        $signal_29_complete_count++;  # Increment the completion count
        $signal_29_count = 0;  # Reset the Signal 29 count after reaching 4

        # Check if we've received 4 signal 29s for 3 cycles
        if ($signal_29_complete_count >= 3) {
            # Spawn NPCs 1577 and 1578 at the specified locations (5th cycle)
            quest::spawn2(1577, 0, 0, -83.60, -292.30, 429.94, 256.50);
            quest::spawn2(1578, 0, 0, -145.11, -285.99, 422.93, 251.50);

            # Reset the completion count after spawning NPCs
            $signal_29_complete_count = 0;
        } else {
            # Spawn NPCs 1569-1572 after each cycle of 4 signals
            quest::spawn2(1569, 0, 0, -83.60, -292.30, 429.94, 256.50);
            quest::spawn2(1570, 0, 0, -85.94, -246.37, 429.94, 250.25);
            quest::spawn2(1571, 0, 0, -145.11, -285.99, 422.93, 251.50);
            quest::spawn2(1572, 0, 0, -144.58, -242.94, 422.93, 257.50);

            # Notify about the number of 4-signal completions (optional)
            #quest::shout("Signal 29 reached 4 $signal_29_complete_count times. Waiting for more signals.");
        }
    } else {
        # Optionally, you could leave this line if you want a reminder for how many more signals are needed
        # quest::shout("Signal 29 received. Waiting for more signals to reach 4.");
    }
}

# Signal 30 - 31 Handling
elsif ($signal == 30) {
    # Mark that Signal 30 has been received
    $signal_30_received = 1;
    
    # Check if both Signal 30 and Signal 31 have been received
    if ($signal_30_received && $signal_31_received) {
        # Spawn NPC 1579 if both signals have been received
        quest::spawn2(1579, 0, 0, -119.56, -164.37, 445.23, 258.75);
        
        # Reset the signals
        $signal_30_received = 0;
        $signal_31_received = 0;
    }
}

elsif ($signal == 31) {
    # Mark that Signal 31 has been received
    $signal_31_received = 1;
    
    # Check if both Signal 30 and Signal 31 have been received
    if ($signal_30_received && $signal_31_received) {
        # Spawn NPC 1579 if both signals have been received
        quest::spawn2(1579, 0, 0, -119.56, -164.37, 445.23, 258.75);
        
        # Reset the signals
        $signal_30_received = 0;
        $signal_31_received = 0;
    }
}

# Signal 33-38 Handling
elsif ($signal >= 33 && $signal <= 38) {
    # Set the flag for the signal
    $expecting_signal_33_38 |= (1 << ($signal - 33));

    # Check if all signals 33-38 have been received
    if ($expecting_signal_33_38 == 0b111111) {
        # Spawn NPC 1581 at the specified location
        quest::spawn2(1588, 0, 0, -565.57, 459.63, 445.07, 241.48);

        # Reset the flag
        $expecting_signal_33_38 = 0;
    }
}

# Signal 39 Handling
elsif ($signal == 39) {
    # Check if NPC 1594 is not already spawned
    if (!quest::isnpcspawned(1594)) {
        quest::spawn2(1594, 2, 0, 162.98, 840.32, 540.96, 384.25);
    }
    
    # Check if NPC 1595 is not already spawned
    if (!quest::isnpcspawned(1595)) {
        quest::spawn2(1595, 1, 0, 166.00, 866.53, 540.90, 385.25);
    }
    
    # Check if NPC 1835 is not already spawned
    if (!quest::isnpcspawned(1835)) {
        quest::spawn2(1835, 1, 0, 165.83, 813.23, 540.93, 384.00);
    }
}

# Signal 40 Handling
elsif ($signal == 40) {
    # Depop all NPCs with IDs 1594 and 1595
    quest::depopall(1594);
    quest::depopall(1595);
}

}
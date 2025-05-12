#Rubeus_Hagrid

sub EVENT_SPAWN {
    # Generate a random number between 1 and 100
    my $chance = int(rand(100)) + 1;

    # Determine which NPC to spawn (25% chance for NPC 1640, otherwise NPC 1619)
    my $npc_id = ($chance <= 25) ? 1640 : 1619;

    # Check if the chosen NPC ID is already up
    if (!quest::isnpcspawned($npc_id)) {
        # Spawn the chosen NPC at the specified location
        quest::spawn2($npc_id, 0, 0, 330.99, 234.53, -0.17, 381.25);
    }
}

# Helper function to check all key locations and add to keyring if needed
sub check_key_locations {
    my ($client, $key_id) = @_;

    # First check if key is already on keyring
    if ($client->KeyRingCheck($key_id)) {
        return 1;
    }

    # If not on keyring, check inventory and bank
    if (plugin::check_hasitem($client, $key_id) || 
        plugin::check_hasitem($client, $key_id, 1)) {  # 1 = bank
        
        # Found key somewhere - add it to keyring and notify player
        $client->KeyRingAdd($key_id);
        my $key_name = get_key_name($key_id);
        quest::whisper("I've added your $key_name to your keyring for safekeeping.");
        return 1;
    }
    
    return 0;
}

# Helper function to get key name from ID
sub get_key_name {
    my ($key_id) = @_;
    my %key_names = (
        20033 => "Crystal Key",
        20034 => "Three Toothed Key", 
        20035 => "Frosty Key",
        20036 => "Small Rusty Key",
        20037 => "Bone Finger Key",
        20038 => "Large Metal Key",
        20039 => "Tserrina's Key"
    );
    return $key_names{$key_id} || "Unknown Key";
}

sub EVENT_SAY {
    # Define level information including keys and coordinates
    my %level_info = (
        2 => { key => 20033, x => 660, y => 100, z => 40, h => 0 },    # Crystal Key
        3 => { key => 20034, x => 670, y => 750, z => 75, h => 0 },    # Three Toothed Key
        4 => { key => 20035, x => 170, y => 755, z => 175, h => 0 },   # Frosty Key
        5 => { key => 20036, x => -150, y => 160, z => 217, h => 0 },  # Small Rusty Key
        6 => { key => 20037, x => -320, y => 725, z => 12, h => 0 },   # Bone Finger Key
        7 => { key => 20037, x => -490, y => 175, z => 2, h => 0 },    # Bone Finger Key
        8 => { key => 20038, x => 10, y => 65, z => 310, h => 0 }      # Large Metal Key
    );
    
    if ($text=~/hail/i) {
        my @available_levels;
        foreach my $level (sort keys %level_info) {
            # Check key locations and add to keyring if found
            if (check_key_locations($client, $level_info{$level}{key})) {
                push(@available_levels, $level);
            }
        }

        # First show the credit exchange information
        quest::whisper("Greetings, adventurer! If you have mirrored items or type molds to spare, hand me one, and I will exchange it for two Student Credits.");

        # Then show available tower levels
        if (@available_levels) {
            my $options = "";
            foreach my $level (@available_levels) {
                $options .= "[" . quest::saylink("enter level $level", 1) . "] ";
            }
            quest::whisper("Your keys grant you access to these levels: $options");
        }
        else {
            quest::whisper("You'll need special keys on your keyring, in your inventory, or in your bank to access the Tower's levels.");
        }

        # Pop-up window with detailed lore and instructions
        quest::popup("The Tower of Frozen Shadows Awaits", "
        <c '#FFCC00'>*The NPC regards you with a measured gaze, acknowledging the long journey you’ve taken to arrive here.*</c><br><br>

        \"Ah, so you've come to the Tower of Frozen Shadows, have you? A wise choice, though not an easy one. Within these icy halls, you will find much to learn, but first—listen well, for the tower has much to offer, and only those who understand its ways can truly succeed.\"<br><br>

        <c '#FFCC00'>*The NPC gestures to the towering structure, its frozen spires rising above.*</c><br><br>

        \"The tower houses four distinct schools of magic, each with its own philosophy and power. But beware, only through perseverance and wisdom can you access them all. Each school lies on separate floors, and to earn access, you must prove your strength in Velious first. The tower’s connection to the lands is deep, but you must earn the right to climb its many steps.

Also, there is one more matter to discuss—your student credit. As you prove your worth in Velious and progress through the tower, you will earn student credit. This special currency can be used to make purchases right here in the Tower of Frozen Shadows. I offer various items that will assist you in your journey. But be mindful, adventurer—your student credit can only go so far, so spend it wisely. The higher your standing, the more you will be able to buy from me.
\"<br><br>

        Let me tell you of the schools, each more intriguing than the last. Listen closely, for your path may depend on your choices here.<br><br>

        <c '#FF6600'>*The NPC motions toward the first floors.*</c><br><br>

        The first floors are the <c '#FF6600'>School of Shadows</c>, where illusions and stealth magic reign. Here, deception is an art, and survival is key. If you wish to become a master of shadows, you must learn to be unseen, your enemies never knowing when you strike.<br><br>

        <c '#FF6600'>*The NPC gestures toward the next set of stairs.*</c><br><br>

        On the next floors, the <c '#FF6600'>School of Frost</c> awaits. Ice and resilience are its foundation. You will endure the cold as you master the art of protection and control. Those who walk the path of frost are as unyielding as the harshest winters, patient and determined.<br><br>

        <c '#FF6600'>*A glint of the ethereal seems to shimmer in the NPC's eyes.*</c><br><br>

        Then there is the <c '#FF6600'>School of Spirits</c>, where the dead speak and the living listen. Necromancy and spirit summoning are the hallmarks of this path. Those who embrace the spirits must balance life and death, drawing upon the power of the other side.<br><br>

        <c '#FF6600'>*The NPC's tone becomes more energetic.*</c><br><br>

        Lastly, there is the <c '#FF6600'>School of Chaos</c>, where magic is unpredictable, destructive, and volatile. Elemental fury and wild power govern here. Only the brave—or the reckless—will thrive in the chaos, for the path to mastery is ever-changing and often explosive.<br><br>

        <c '#FF6600'>*The NPC's expression grows serious as they gesture toward the top floor.*</c><br><br>

        And at the very top, in Tserrina’s domain, the culmination of all these teachings awaits. She is the master of all four schools, a being who has twisted the power of the elements to her will. To reach her, you must first prove yourself in each school, and only then may you face her and test your mastery of the tower’s arcane power.<br><br>

        But remember—this tower is not easily conquered. Your journey through Velious will be long, and only once you have proven yourself in its trials will you gain access to all that the tower has to offer. You will know when the time is right to return, and the floors will open to you.\"<br><br>

        <c '#FFCC00'>*The NPC smiles kindly.*</c><br><br>

        Now, adventurer, step forward and choose your path. The Tower of Frozen Shadows awaits, but first, you must earn your place within it. Farewell for now, and may your magic grow stronger with every step you take.\"
        ");

    } elsif ($text=~/enter level (\d+)/i) {
        my $requested_level = $1;

        # Check if valid level
        if (exists $level_info{$requested_level}) {
            # Try to add key to keyring if found in inventory/bank
            check_key_locations($client, $level_info{$requested_level}{key});
            
            # Now check if key is on keyring
            if ($client->KeyRingCheck($level_info{$requested_level}{key})) {
                my $instance_id = $client->GetInstanceID();
                if (defined $instance_id) {
                    quest::MovePCInstance(111, 
                        $instance_id,
                        $level_info{$requested_level}{x},
                        $level_info{$requested_level}{y},
                        $level_info{$requested_level}{z},
                        $level_info{$requested_level}{h}
                    );
                } else {
                    quest::say("You are not in an instance of the Tower.");
                }
            } else {
                quest::say("You need the proper key on your keyring for that level.");
            }
        }
    }
}

sub EVENT_ITEM {
    # Array of valid item IDs
    my @valid_items = (524, 525, 526, 527, 566, 567, 568, 569, 609, 610, 611, 612, 645, 646, 647, 648, 703, 704, 705, 706, 758, 759, 760, 761, 775, 777, 778, 87362, 87364, 87365, 87366, 87368, 87373, 87374, 87380, 87381, 87382, 87388, 87390, 87392, 87399, 87401, 87402, 87406, 87407, 87427, 87428, 87433, 87434, 133126);

    # Iterate through each valid item ID to check if it was handed in
    foreach my $item_id (@valid_items) {
        if (plugin::check_handin(\%itemcount, $item_id => 1)) {
            quest::summonitem(513, 2);  # Give 2 quantity of item 513 (Student Credit)
            quest::whisper("Thank you for your trade! Here are 2 Student Credits for your efforts.");
            return;
        }
    }

    # If no valid items were handed in, return the items and notify the player
    quest::whisper("I have no use for these items. Please hand me a mirrored item or type mold.");
    plugin::return_items(\%itemcount);
}
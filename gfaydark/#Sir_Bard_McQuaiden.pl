#!/usr/bin/perl

# Enhanced Service NPC - Handles AA refunds, class changes, and race changes
# Optimized for better error handling, user experience, and code maintainability

# Configuration variables
my %CLASS_OPTIONS = (
    "Warrior" => 1, "Cleric" => 2, "Paladin" => 3, "Ranger" => 4,
    "Shadowknight" => 5, "Druid" => 6, "Monk" => 7, "Bard" => 8,
    "Rogue" => 9, "Shaman" => 10, "Necromancer" => 11, "Wizard" => 12,
    "Magician" => 13, "Enchanter" => 14, "Beastlord" => 15, "Berserker" => 16,
);

my @AVAILABLE_RACES = (1..12, 128, 130, 330, 522);

# NPC stats configuration for easier maintenance
my %NPC_STATS = (
    # Basic stats
    level => 100,
    ac => 30000,
    max_hp => 9000000,
    hp_regen => 2500,
    mana_regen => 10000,
    
    # Combat stats
    min_hit => 100000,
    max_hit => 200000,
    atk => 3000,
    accuracy => 1900,
    avoidance => 105,
    attack_delay => 4,
    attack_speed => 100,
    slow_mitigation => 85,
    attack_count => 100,
    heroic_strikethrough => 90,
    
    # AI stats
    aggro => 57,
    assist => 1,
    
    # Attributes
    str => 1100,
    sta => 1100,
    agi => 1100,
    dex => 1100,
    wis => 1100,
    int => 1100,
    cha => 900,
    
    # Resistances
    mr => 350,
    fr => 350,
    cr => 350,
    pr => 350,
    dr => 350,
    corruption_resist => 400,
    physical_resist => 900,
    
    # Misc stats
    runspeed => 2,
    trackable => 1,
    see_invis => 1,
    see_invis_undead => 1,
    see_hide => 1,
    see_improved_hide => 1,
);

my $SPECIAL_ABILITIES = "12,1^13,1^14,1^15,1^16,1^17,1^31,1^18,1^35,1^26,1^28,1^19,1^20,1^21,1^23,1^22,1^24,1^25,1^46,1";

sub EVENT_SPAWN {
    return unless $npc;

    # Set faction to indifferent
    $npc->SetNPCFactionID(0);
    
    # Apply all NPC stats from configuration
    foreach my $stat_name (keys %NPC_STATS) {
        $npc->ModifyNPCStat($stat_name, $NPC_STATS{$stat_name});
    }
    
    # Apply special abilities
    $npc->ModifyNPCStat("special_abilities", $SPECIAL_ABILITIES);

    # Ensure NPC spawns at full health
    my $max_hp = $npc->GetMaxHP();
    if (defined $max_hp && $max_hp > 0) {
        $npc->SetHP($max_hp);
        quest::debug("Service NPC spawned with $max_hp HP", 1);
    }
}

sub EVENT_SAY {
    return unless $client;
    
    # Main menu
    if ($text =~ /hail/i) {
        ShowMainMenu();
    }
    # AA Services
    elsif ($text =~ /^(?:Refund AAs?|aa)$/i) {
        HandleAARefund();
    }
    # Class Change Services
    elsif ($text =~ /^(?:Change Class|class)$/i) {
        ShowClassOptions();
    }
    elsif (exists $CLASS_OPTIONS{$text}) {
        HandleClassChange($text);
    }
    # Race Change Services
    elsif ($text =~ /^(?:Change Race|race)$/i) {
        ShowRaceOptions();
    }
    elsif ($text =~ /^r-(\d+)$/i) {
        my $race_id = $1;
        HandleRaceChange($race_id);
    }
    # Help/Info
    elsif ($text =~ /^(?:help|info|commands?)$/i) {
        ShowDetailedHelp();
    }
    else {
        quest::whisper("I don't recognize that command. Say [" . quest::silent_saylink("hail") . "] for options, or [" . quest::silent_saylink("help") . "] for detailed information.");
    }
}

sub ShowMainMenu {
    my $aa_link = quest::silent_saylink("Refund AAs");
    my $class_link = quest::silent_saylink("Change Class");
    my $race_link = quest::silent_saylink("Change Race");
    my $help_link = quest::silent_saylink("help");
    
    quest::whisper("Greetings, $name! I provide the following services:");
    quest::message(315, "• [$aa_link] - Reset all Alternate Advancement points");
    quest::message(315, "• [$class_link] - Change your character class");
    quest::message(315, "• [$race_link] - Change your character race");
    quest::message(315, "• [$help_link] - Show detailed help information");
    quest::whisper("Click any option above to proceed, or say the keywords directly.");
}

sub ShowDetailedHelp {
    quest::whisper("=== Detailed Service Information ===");
    quest::message(315, "• AA Refund: Completely resets your AA progression and refunds all points");
    quest::message(315, "• Class Change: Changes class, resets skills/spells, trains basic disciplines");
    quest::message(315, "  - REQUIRES: All equipment must be removed first!");
    quest::message(315, "• Race Change: Permanently changes your character race");
    quest::whisper("Warning: Class changes are permanent and will disconnect you briefly!");
    quest::whisper("Make sure you're in a safe location before making changes.");
}

sub HandleAARefund {
    # Validation
    my $current_aa = $client->GetAAPoints();
    my $spent_aa = $client->GetSpentAA();
    
    if ($spent_aa <= 0) {
        quest::whisper("You don't have any spent AA points to refund.");
        return;
    }
    
    quest::whisper("Refunding $spent_aa spent AA points...");
    $client->ResetAA();
    
    # Verify the refund worked
    my $new_aa = $client->GetAAPoints();
    quest::whisper("Success! You now have $new_aa available AA points.");
    quest::debug("Player $name AA refund: was $current_aa, now $new_aa", 1);
}

sub ShowClassOptions {
    quest::whisper("Choose your new class from the following options:");
    quest::whisper("IMPORTANT: You must remove ALL equipment first!");
    
    my @class_links;
    foreach my $class_id (1..16) {
        my $class_name = quest::getclassname($class_id);
        push @class_links, quest::silent_saylink($class_name);
    }
    
    # Display in rows of 4 for better readability
    for (my $i = 0; $i < @class_links; $i += 4) {
        my $end = ($i + 3 < @class_links) ? $i + 3 : $#class_links;
        my $row = join(" | ", @class_links[$i..$end]);
        quest::message(315, $row);
    }
    
    quest::whisper("WARNING: Class changes are permanent and will disconnect you!");
}

sub HandleClassChange {
    my $class_name = shift;
    return unless exists $CLASS_OPTIONS{$class_name};
    
    my $new_class = $CLASS_OPTIONS{$class_name};
    my $current_level = $client->GetLevel();
    my $current_class = $client->GetClass();
    
    # Prevent unnecessary changes
    if ($current_class == $new_class) {
        quest::whisper("You are already a $class_name!");
        return;
    }
    
    # Level validation
    if ($current_level < 1 || $current_level > 100) {
        quest::whisper("Invalid level detected. Class change cancelled for safety.");
        quest::debug("Invalid level for class change: $current_level", 1);
        return;
    }
    
    # Check if player has any gear equipped
    unless (CheckGearEmpty($client)) {
        quest::whisper("You must remove ALL equipment before changing classes!");
        quest::whisper("This includes weapons, armor, jewelry, and bags.");
        quest::whisper("Please unequip everything and try again.");
        return;
    }
    
    quest::whisper("Changing from " . quest::getclassname($current_class) . " to $class_name...");
    
    # Perform class change sequence
    eval {
        quest::untraindiscs();
        quest::whisper("✓ Previous disciplines removed");
        
        $client->SetBaseClass($new_class);
        quest::whisper("✓ Class changed to $class_name");
        
        $client->MaxSkills();
        quest::whisper("✓ Skills updated for new class");
        
        $client->UnscribeSpellAll();
        quest::whisper("✓ Previous spells removed");
        
        $client->ScribeSpells(1, $current_level);
        quest::whisper("✓ New class spells scribed (levels 1-$current_level)");
        
        quest::traindiscs(60, 1);
        quest::whisper("✓ Basic disciplines trained (levels 1-60)");
        
        quest::debug("Class change completed for $name: $current_class -> $new_class", 1);
        
        quest::whisper("Class change complete! You will be disconnected to finalize changes...");
        $client->WorldKick();
    };
    
    if ($@) {
        quest::whisper("An error occurred during class change. Please contact an administrator.");
        quest::debug("Class change error for $name: $@", 1);
    }
}

sub ShowRaceOptions {
    quest::whisper("Choose your new race from the following options:");
    
    my @race_links;
    foreach my $race_id (@AVAILABLE_RACES) {
        my $race_name = quest::getracename($race_id);
        next unless $race_name && $race_name ne "Unknown Race";
        
        my $race_link = quest::silent_saylink("r-$race_id", $race_name);
        push @race_links, $race_link;
    }
    
    # Display in rows of 6 for better readability
    for (my $i = 0; $i < @race_links; $i += 6) {
        my $end = ($i + 5 < @race_links) ? $i + 5 : $#race_links;
        my $row = join(" | ", @race_links[$i..$end]);
        quest::message(315, $row);
    }
}

sub HandleRaceChange {
    my $race_id = shift;
    return unless $race_id;
    
    # Validate race ID
    unless (grep { $_ == $race_id } @AVAILABLE_RACES) {
        quest::whisper("Invalid race selection.");
        return;
    }
    
    my $race_name = quest::getracename($race_id);
    unless ($race_name && $race_name ne "Unknown Race") {
        quest::whisper("Unable to determine race name. Change cancelled.");
        return;
    }
    
    # Prevent unnecessary changes
    my $current_race = $client->GetRace();
    if ($current_race == $race_id) {
        quest::whisper("You are already a $race_name!");
        return;
    }
    
    quest::whisper("Changing your race to $race_name...");
    quest::permarace($race_id);
    quest::whisper("Race change complete! You are now a $race_name.");
    
    quest::debug("Race change for $name: $current_race -> $race_id ($race_name)", 1);
}

sub CheckGearEmpty {
    my $client = shift;
    return 0 unless $client;
    
    # EQEmu slot ID to name mapping (correct IDs)
    my %slot_names = (
        0  => "Charm",
        1  => "Ear 1",
        2  => "Head", 
        3  => "Face",
        4  => "Ear 2",
        5  => "Neck",
        6  => "Shoulder",
        7  => "Arms",
        8  => "Back",
        9  => "Bracer 1",
        10 => "Bracer 2", 
        11 => "Range",
        12 => "Hands",
        13 => "Primary",
        14 => "Secondary",
        15 => "Ring 1",
        16 => "Ring 2",
        17 => "Chest",
        18 => "Legs",
        19 => "Feet",
        20 => "Waist",
        21 => "Powersource",
        22 => "Ammo"
    );
    
    # Check all worn equipment slots (0-22)
    my @worn_slots = (0..22);
    
    foreach my $slot (@worn_slots) {
        my $item = $client->GetItemInInventory($slot);
        if ($item) {
            # Found an item in a worn slot - tell player which slot
            my $slot_name = $slot_names{$slot} || "Slot $slot";
            quest::whisper("You still have an item equipped in your $slot_name slot!");
            return 0;
        }
    }
    
    # All slots are empty
    return 1;
}

sub EVENT_TIMER {
    if ($timer eq "worldkick") {
        quest::stoptimer("worldkick");
        $client->WorldKick();
    }
}
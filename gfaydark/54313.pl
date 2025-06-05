#!/usr/bin/perl
use strict;
use warnings;
use DBI;

# Mapping of class numbers to their corresponding names
my %class_map = (
    1  => 'Warrior',
    2  => 'Cleric',
    3  => 'Paladin',
    4  => 'Ranger',
    5  => 'Shadowknight',
    6  => 'Druid',
    7  => 'Monk',
    8  => 'Bard',
    9  => 'Rogue',
    10 => 'Shaman',
    11 => 'Necromancer',
    12 => 'Wizard',
    13 => 'Mage',
    14 => 'Enchanter',
    15 => 'Beastlord',
    16 => 'Berserker'
);

# EQEmu quest script to show the leaderboard in a popup with sorting options
sub EVENT_SAY {
    our $text;  # Declare the global $text variable

    if ($text =~ /hail/i) {
        # Introduction message
        quest::whisper("Yo, I run the Leaderboard around here, if you ain't first, you're last. Here are the top 10 players sorted by HP:");

        # Connect to the database using plugin::LoadMysql
        my $dbh = plugin::LoadMysql() or return;

        # Query to fetch the leaderboard data including aa_points and spell_damage, without race
        my $sql = qq{
            SELECT name, class, level, hp, ac, aa_points, spell_damage
            FROM character_stats_record WHERE status = 0
            ORDER BY hp DESC, level DESC
            LIMIT 10
        };

        my $sth = $dbh->prepare($sql);
        $sth->execute();

        # Generate the HTML for the leaderboard
        my $leaderboard_html = "<table><tr><th>Name</th><th>Class</th><th>Level</th><th>Health</th><th>Armor Class</th><th>AA Points</th><th>Spell Damage</th></tr>";
        while (my $row = $sth->fetchrow_hashref) {
            my $class_name = $class_map{$row->{class}};
            my $health = quest::commify($row->{hp});
            my $armor_class = quest::commify($row->{ac});
            my $aa_points = quest::commify($row->{aa_points});
            my $spell_damage = quest::commify($row->{spell_damage});
            $leaderboard_html .= "<tr><td>$row->{name}</td><td>$class_name</td><td>$row->{level}</td><td>$health</td><td>$armor_class</td><td>$aa_points</td><td>$spell_damage</td></tr>";
        }
        $leaderboard_html .= "</table>";

        # Disconnect from the database
        $sth->finish;
        $dbh->disconnect;

        # Show the leaderboard in a popup
        my $title = "Top 10 Characters Leaderboard (sorted by HP)";
        quest::popup($title, $leaderboard_html);
    }
}

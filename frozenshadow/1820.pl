sub EVENT_SAY {
    if ($text=~/hail/i) {
         if (quest::get_data("riddle_cooldown")) {
    	 my $remaining = quest::get_data_expires("riddle_cooldown") - time();
   	 my $minutes = int($remaining / 60);
   	 my $seconds = $remaining % 60;
   	 quest::whisper("Ah, impatience... the mark of a fool. Return in $minutes minutes and $seconds seconds.");
   	 return;
    }


        quest::whisper("So... a seeker of knowledge stands before me. But knowledge is a dangerous thing. Answer my riddles, and perhaps I shall deem you worthy... or your ignorance will summon something far less kind.");

        my @riddles = (
    {
        question => "I walk without legs, I strike without arms. I slay the strongest, yet cower from the meek. What am I?",
        answers  => ["Disease", "Magic", "Shadow", "Fear"],
        correct  => "Disease"
    },
    {
        question => "I am unseen yet felt, I am whispered yet deafening. In Norrath, I have shaped the fate of kings and beggars alike. What am I?",
        answers  => ["Wind", "Death", "Prophecy", "Silence"],
        correct  => "Prophecy"
    },
    {
        question => "Born from ice, yet I burn. I feed the living, yet embrace the dead. Seek me in the North, but beware my touch. What am I?",
        answers  => ["Fire Beetle", "Frostfire", "Dragon’s Breath", "Iceflame"],
        correct  => "Iceflame"
    },
    {
        question => "I was once whole, but now I am many. Some seek me for fortune, others for power, but none will ever wield me alone. What am I?",
        answers  => ["A shattered sword", "A guild", "A broken spell", "A gem of many facets"],
        correct  => "A shattered sword"
    },
    {
        question => "I am bound by no walls, yet I confine the strongest of warriors. I am both a prison and a path to power. What am I?",
        answers  => ["Magic", "Time", "Fear", "Cazic-Thule’s Grasp"],
        correct  => "Time"
    },
    {
        question => "You may see me, yet never catch me. The young crave me, the old fear me. Once I take hold, I never let go. What am I?",
        answers  => ["Memory", "Shadow", "Dream", "Fate"],
        correct  => "Fate"
    },
    {
        question => "In darkness, I thrive. In light, I wither. No spell can conjure me, yet I haunt every heart. What am I?",
        answers  => ["Hate", "Fear", "Betrayal", "Shadow"],
        correct  => "Fear"
    },
    {
        question => "I have no master, yet all obey me. I move unseen, yet all feel my hand. My touch is final, my grip eternal. What am I?",
        answers  => ["Death", "Silence", "Despair", "Time"],
        correct  => "Death"
    },
    {
        question => "The more you take, the more you leave behind. What am I?",
        answers  => ["Time", "Shadows", "Footsteps", "Memories"],
        correct  => "Footsteps"
    },
    {
        question => "I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?",
        answers  => ["A mirage", "A dream", "A map", "A book"],
        correct  => "A map"
    }
);

        use List::Util 'shuffle';
        my @selected_riddles = (shuffle(@riddles))[0..2];

        for my $i (0..2) {
            quest::set_data("riddle_${i}_question", $selected_riddles[$i]->{question});
            quest::set_data("riddle_${i}_correct", $selected_riddles[$i]->{correct});
            quest::set_data("riddle_${i}_answer1", $selected_riddles[$i]->{answers}->[0]);
            quest::set_data("riddle_${i}_answer2", $selected_riddles[$i]->{answers}->[1]);
            quest::set_data("riddle_${i}_answer3", $selected_riddles[$i]->{answers}->[2]);
            quest::set_data("riddle_${i}_answer4", $selected_riddles[$i]->{answers}->[3]);
        }

        quest::set_data("riddle_correct", 0);
        quest::set_data("riddle_wrong", 0);
        quest::set_data("current_riddle", 0);

        AskRiddle(0);
    } else {
        my $index = quest::get_data("current_riddle");
        my $correct_answer = quest::get_data("riddle_${index}_correct");

        if ($text eq $correct_answer) {
            quest::set_data("riddle_correct", quest::get_data("riddle_correct") + 1);
            quest::whisper("Interesting... it seems you are not entirely a fool.");
        } else {
            quest::set_data("riddle_wrong", quest::get_data("riddle_wrong") + 1);
            quest::whisper("Ah... ignorance. How delightful.");
        }

        if ($index < 2) {
            quest::set_data("current_riddle", $index + 1);
            AskRiddle($index + 1);
        } else {
            ResolveOutcome();
        }
    }
}

sub AskRiddle {
    my ($index) = @_;
    my $question = quest::get_data("riddle_${index}_question");

    my $answer1 = quest::get_data("riddle_${index}_answer1");
    my $answer2 = quest::get_data("riddle_${index}_answer2");
    my $answer3 = quest::get_data("riddle_${index}_answer3");
    my $answer4 = quest::get_data("riddle_${index}_answer4");

    my $options = join(", ", quest::saylink($answer1, 1), quest::saylink($answer2, 1), quest::saylink($answer3, 1), quest::saylink($answer4, 1));
    quest::whisper("$question [$options]");
}

sub ResolveOutcome {
    my $correct = quest::get_data("riddle_correct");

    if ($correct >= 2) {
        quest::spawn2(1821, 0, 0, -366.69, 1138.12, 2.81, 358.25);
        quest::whisper("Hah! It seems you have some wit about you after all. I shall grant you a reward.");
    } else {
        quest::spawn2(1823, 0, 0, -220.42, 1144.83, -8.21, 38.75);
        quest::whisper("Ignorance is dangerous... and now, so is your situation.");
    }

    # Reset riddle state for future attempts
    quest::delete_data("riddle_cooldown");
    quest::set_data("riddle_cooldown", 1, 300); # 5-minute cooldown
}
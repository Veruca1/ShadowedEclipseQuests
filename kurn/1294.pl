# NPCID 1294 - Custom NPC
# This NPC shouts on death warning players about the amplification resuming in 15 minutes

sub EVENT_DEATH {
    # Shout the warning message on death
    quest::shout("You have 15 minutes before amplification resumes, plan accordingly!");

    # Optionally, set a 15-minute timer for an event related to amplification if needed
    # quest::settimer("amplification_resume", 900); # 900 seconds = 15 minutes
}

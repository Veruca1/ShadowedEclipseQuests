my $is_boss = 0;
my $wrath_triggered = 0;

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;

    my %exclusion_list = (
    179154 => 1,
    179170 => 1,
    179185 => 1,
    179162 => 1,
    179183 => 1,
    179140 => 1,
    179163 => 1,
    179156 => 1,
    179143 => 1,
    179149 => 1,
    179172 => 1,
    179168 => 1,
    179025 => 1,
    179150 => 1,
    179146 => 1,
    179132 => 1,
    164120 => 1,
    164116 => 1,
    164098 => 1,
    164089 => 1,
    164117 => 1,
    164099 => 1,
    1972   => 1,
    1950   => 1,
    1951   => 1,
    1959   => 1,
    1947   => 1,
    1948   => 1,
    500    => 1,
    857    => 1,
    681    => 1,
    679    => 1,
    776    => 1,
    172168 => 1,
    172127 => 1,
    172172 => 1,
    172129 => 1,
    172122 => 1,
    172096 => 1,
    172180 => 1,
    172132 => 1,
    172162 => 1,
    172116 => 1,
        map { $_ => 1 } (2000000..2000017)
    );
    return if exists $exclusion_list{$npc_id};
    return if $npc->IsPet();

    $is_boss = ($raw_name =~ /^#/ || ($npc_id == 1919 && $npc_id != 1974)) ? 1 : 0;

    $npc->SetNPCFactionID(623);

    $wrath_triggered = 0;

    if ($is_boss) {
        $npc->ModifyNPCStat("level", 63);
        $npc->ModifyNPCStat("ac", 20000);
        $npc->ModifyNPCStat("max_hp", 22500000);
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 9000);
        $npc->ModifyNPCStat("max_hit", 15000);
        $npc->ModifyNPCStat("atk", 1400);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 90);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 32);
        $npc->ModifyNPCStat("aggro", 60);
        $npc->ModifyNPCStat("assist", 1);

        $npc->ModifyNPCStat("str", 1200);
        $npc->ModifyNPCStat("sta", 1200);
        $npc->ModifyNPCStat("agi", 1200);
        $npc->ModifyNPCStat("dex", 1200);
        $npc->ModifyNPCStat("wis", 1200);
        $npc->ModifyNPCStat("int", 1200);
        $npc->ModifyNPCStat("cha", 1000);
        
        $npc->ModifyNPCStat("mr", 500);
        $npc->ModifyNPCStat("fr", 500);
        $npc->ModifyNPCStat("cr", 500);
        $npc->ModifyNPCStat("pr", 500);
        $npc->ModifyNPCStat("dr", 500);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1000);
 
        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

        quest::setnexthpevent(75);
    } else {
        $npc->ModifyNPCStat("level", 61);
        $npc->ModifyNPCStat("ac", 15000);
        $npc->ModifyNPCStat("max_hp", 7000000);
        $npc->ModifyNPCStat("hp_regen", 800);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 8000);
        $npc->ModifyNPCStat("max_hit", 12000);
        $npc->ModifyNPCStat("atk", 1200);
        $npc->ModifyNPCStat("accuracy", 1800);
        $npc->ModifyNPCStat("avoidance", 80);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 80);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 22);
        $npc->ModifyNPCStat("aggro", 55);
        $npc->ModifyNPCStat("assist", 1);

        $npc->ModifyNPCStat("str", 1000);
        $npc->ModifyNPCStat("sta", 1000);
        $npc->ModifyNPCStat("agi", 1000);
        $npc->ModifyNPCStat("dex", 1000);
        $npc->ModifyNPCStat("wis", 1000);
        $npc->ModifyNPCStat("int", 1000);
        $npc->ModifyNPCStat("cha", 800);

        $npc->ModifyNPCStat("mr", 300);
        $npc->ModifyNPCStat("fr", 300);
        $npc->ModifyNPCStat("cr", 300);
        $npc->ModifyNPCStat("pr", 300);
        $npc->ModifyNPCStat("dr", 300);
        $npc->ModifyNPCStat("corruption_resist", 300);
        $npc->ModifyNPCStat("physical_resist", 800);

        $npc->ModifyNPCStat("runspeed", 2);       
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1");
    }

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_HP {
    return unless $npc;
    return unless $is_boss;

    if ($hpevent == 75 || $hpevent == 25) {
        # Check if NPC has debuff spell 40745 active
        if ($npc->FindBuff(40745)) {
            plugin::Debug("Boss has debuff 40745 mark of silence, skipping help call.");
            return;
        }

        quest::shout("Surrounding minions of the mountains, arise and assist me!");
        my $top = $npc->GetHateTop();
        return unless $top;

        my @npcs = $entity_list->GetNPCList();
        return unless @npcs;

        foreach my $mob (@npcs) {
            next unless $mob && $mob->GetID() != $npc->GetID();
            my $dist = $npc->CalculateDistance($mob);
            $mob->AddToHateList($top, 1) if defined $dist && $dist <= 300;
        }

        quest::setnexthpevent(25) if $hpevent == 75;
    }
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        quest::settimer("life_drain", 5) if $is_boss;
    } else {
        quest::stoptimer("life_drain") if $is_boss;
        quest::settimer("reset_hp_event", 75) if $is_boss;
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "life_drain" && $is_boss) {
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
        return unless defined $x && defined $y && defined $z;
        my $radius = 50;
        my $dmg = 6000;

        foreach my $c ($entity_list->GetClientList()) {
            next unless $c && $c->CalculateDistance($x, $y, $z) <= $radius;
            $c->Damage($npc, $dmg, 0, 1, false);
        }

        foreach my $b ($entity_list->GetBotList()) {
            next unless $b && $b->CalculateDistance($x, $y, $z) <= $radius;
            $b->Damage($npc, $dmg, 0, 1, false);
        }
    }

    if ($timer eq "reset_hp_event" && $is_boss) {
        quest::setnexthpevent(75);
        quest::stoptimer("reset_hp_event");
    }
}

sub EVENT_DAMAGE_TAKEN {
    return unless $npc;

    # Define excluded pet NPC type IDs
    my %excluded_pet_npc_ids = (
    500 => 1, 549 => 1, 857 => 1, 681 => 1, 679 => 1, 776 => 1,
    map { $_ => 1 } (2000000..2000017),
    293201 => 1, 293205 => 1, 293207 => 1, 669 => 1, 500 => 1, 509 => 1, 510 => 1, 511 => 1, 512 => 1, 513 => 1, 514 => 1,
    501 => 1, 502 => 1, 503 => 1, 504 => 1, 505 => 1, 506 => 1, 507 => 1, 508 => 1, 212073 => 1, 671 => 1, 650 => 1, 776 => 1,
    824 => 1, 825 => 1, 826 => 1, 827 => 1, 828 => 1, 854 => 1, 855 => 1, 642 => 1, 643 => 1, 515 => 1, 516 => 1, 517 => 1,
    518 => 1, 519 => 1, 520 => 1, 521 => 1, 522 => 1, 523 => 1, 524 => 1, 894 => 1, 525 => 1, 895 => 1, 896 => 1, 897 => 1,
    526 => 1, 898 => 1, 899 => 1, 900 => 1, 901 => 1, 527 => 1, 794 => 1, 795 => 1, 796 => 1, 797 => 1, 798 => 1, 838 => 1,
    839 => 1, 528 => 1, 799 => 1, 800 => 1, 801 => 1, 802 => 1, 803 => 1, 856 => 1, 837 => 1, 647 => 1, 744 => 1, 664 => 1,
    692 => 1, 889 => 1, 890 => 1, 891 => 1, 892 => 1, 638 => 1, 529 => 1, 530 => 1, 531 => 1, 532 => 1, 533 => 1, 534 => 1,
    710 => 1, 711 => 1, 712 => 1, 694 => 1, 713 => 1, 714 => 1, 715 => 1, 716 => 1, 718 => 1, 704 => 1, 719 => 1, 720 => 1,
    721 => 1, 722 => 1, 723 => 1, 724 => 1, 726 => 1, 686 => 1, 687 => 1, 535 => 1, 725 => 1, 690 => 1, 691 => 1, 693 => 1,
    536 => 1, 537 => 1, 538 => 1, 695 => 1, 539 => 1, 697 => 1, 717 => 1, 698 => 1, 734 => 1, 699 => 1, 700 => 1, 701 => 1,
    702 => 1, 703 => 1, 540 => 1, 705 => 1, 688 => 1, 733 => 1, 706 => 1, 707 => 1, 696 => 1, 708 => 1, 730 => 1, 709 => 1,
    727 => 1, 728 => 1, 729 => 1, 731 => 1, 732 => 1, 735 => 1, 736 => 1, 737 => 1, 738 => 1, 689 => 1, 745 => 1, 739 => 1,
    740 => 1, 741 => 1, 646 => 1, 829 => 1, 743 => 1, 635 => 1, 541 => 1, 542 => 1, 543 => 1, 544 => 1, 672 => 1, 334107 => 1,
    778 => 1, 779 => 1, 780 => 1, 781 => 1, 782 => 1, 783 => 1, 844 => 1, 845 => 1, 645 => 1, 834 => 1, 835 => 1, 836 => 1,
    551 => 1, 617 => 1, 618 => 1, 619 => 1, 614 => 1, 620 => 1, 621 => 1, 622 => 1, 623 => 1, 624 => 1, 625 => 1, 902 => 1,
    626 => 1, 903 => 1, 627 => 1, 904 => 1, 628 => 1, 905 => 1, 907 => 1, 906 => 1, 615 => 1, 629 => 1, 908 => 1, 909 => 1,
    910 => 1, 911 => 1, 912 => 1, 630 => 1, 913 => 1, 914 => 1, 915 => 1, 916 => 1, 917 => 1, 631 => 1, 918 => 1, 919 => 1,
    920 => 1, 921 => 1, 922 => 1, 663 => 1, 632 => 1, 789 => 1, 790 => 1, 791 => 1, 792 => 1, 793 => 1, 840 => 1, 841 => 1,
    633 => 1, 784 => 1, 785 => 1, 786 => 1, 787 => 1, 788 => 1, 842 => 1, 843 => 1, 616 => 1, 649 => 1, 634 => 1, 545 => 1,
    546 => 1, 547 => 1, 548 => 1, 549 => 1, 550 => 1, 678 => 1, 742 => 1, 666 => 1, 560 => 1, 561 => 1, 562 => 1, 563 => 1,
    564 => 1, 565 => 1, 752 => 1, 753 => 1, 754 => 1, 755 => 1, 756 => 1, 566 => 1, 804 => 1, 805 => 1, 806 => 1, 807 => 1,
    808 => 1, 846 => 1, 847 => 1, 552 => 1, 768 => 1, 553 => 1, 554 => 1, 555 => 1, 556 => 1, 557 => 1, 558 => 1, 559 => 1,
    857 => 1, 775 => 1, 662 => 1, 676 => 1, 575 => 1, 576 => 1, 577 => 1, 578 => 1, 579 => 1, 580 => 1, 757 => 1, 758 => 1,
    759 => 1, 760 => 1, 761 => 1, 581 => 1, 809 => 1, 810 => 1, 811 => 1, 812 => 1, 813 => 1, 848 => 1, 849 => 1, 567 => 1,
    767 => 1, 568 => 1, 569 => 1, 570 => 1, 571 => 1, 572 => 1, 573 => 1, 574 => 1, 590 => 1, 591 => 1, 592 => 1, 593 => 1,
    594 => 1, 595 => 1, 762 => 1, 763 => 1, 764 => 1, 765 => 1, 766 => 1, 596 => 1, 814 => 1, 815 => 1, 816 => 1, 817 => 1,
    818 => 1, 850 => 1, 851 => 1, 582 => 1, 770 => 1, 583 => 1, 584 => 1, 585 => 1, 586 => 1, 587 => 1, 588 => 1, 589 => 1,
    685 => 1, 597 => 1, 598 => 1, 772 => 1, 644 => 1, 771 => 1, 641 => 1, 607 => 1, 608 => 1, 609 => 1, 610 => 1, 611 => 1,
    612 => 1, 747 => 1, 748 => 1, 749 => 1, 750 => 1, 751 => 1, 613 => 1, 819 => 1, 820 => 1, 821 => 1, 822 => 1, 823 => 1,
    852 => 1, 853 => 1, 599 => 1, 769 => 1, 600 => 1, 601 => 1, 602 => 1, 603 => 1, 604 => 1, 605 => 1, 606 => 1, 340021 => 1,
    681 => 1, 651 => 1, 652 => 1, 653 => 1, 654 => 1, 656 => 1, 682 => 1, 683 => 1, 684 => 1, 648 => 1, 777 => 1, 660 => 1,
    659 => 1, 655 => 1, 661 => 1, 658 => 1, 675 => 1, 831 => 1, 832 => 1, 833 => 1, 657 => 1, 636 => 1, 677 => 1, 680 => 1,
    679 => 1, 773 => 1, 774 => 1, 1544 => 1, 673 => 1, 667 => 1, 830 => 1, 866 => 1, 867 => 1, 858 => 1, 859 => 1, 860 => 1,
    861 => 1, 862 => 1, 863 => 1, 864 => 1, 865 => 1, 868 => 1, 869 => 1, 870 => 1, 871 => 1, 872 => 1, 873 => 1, 874 => 1,
    875 => 1, 876 => 1, 877 => 1, 878 => 1, 879 => 1, 880 => 1, 881 => 1, 882 => 1, 883 => 1, 884 => 1, 885 => 1, 886 => 1,
    887 => 1, 888 => 1, 665 => 1, 188000 => 1, 86177 => 1, 1250 => 1, 86178 => 1, 1276 => 1, 1279 => 1, 1287 => 1, 1338 => 1,
    1386 => 1, 1410 => 1, 1472 => 1, 1475 => 1, 1476 => 1, 1478 => 1, 1480 => 1, 1481 => 1, 1482 => 1, 1483 => 1, 1485 => 1,
    1486 => 1, 1487 => 1, 1596 => 1, 1568 => 1, 1599 => 1, 1602 => 1, 1603 => 1, 1605 => 1, 1606 => 1, 2135 => 1, 1608 => 1,
    1609 => 1, 1610 => 1, 1611 => 1, 1612 => 1, 1613 => 1, 1614 => 1, 1645 => 1, 1684 => 1, 1709 => 1, 1831 => 1, 1914 => 1,
    637 => 1, 639 => 1, 640 => 1, 1936 => 1,
);

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;

        if (quest::ChooseRandom(1..100) <= 20) {
            $npc->Shout("The Wrath of Luclin is unleashed!");

            my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
            return unless defined $x && defined $y && defined $z;
            my $radius = 50;
            my $dmg = 40000;

            foreach my $e ($entity_list->GetClientList()) {
                next unless $e;
                $e->Damage($npc, $dmg, 0, 1, false) if $e->CalculateDistance($x, $y, $z) <= $radius;

                my $pet = $e->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                    next if $excluded_pet_npc_ids{$pet->GetNPCTypeID()};
                    $pet->Damage($npc, $dmg, 0, 1, false);
                }
            }

            foreach my $b ($entity_list->GetBotList()) {
                next unless $b;
                $b->Damage($npc, $dmg, 0, 1, false) if $b->CalculateDistance($x, $y, $z) <= $radius;

                my $pet = $b->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                    next if $excluded_pet_npc_ids{$pet->GetNPCTypeID()};
                    $pet->Damage($npc, $dmg, 0, 1, false);
                }
            }
        }
    }

    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    return unless $npc;

   my %exclusion_list = (
        153095 => 1,
        1986 => 1,
        1984 => 1,
        1922 => 1,
        1954 => 1,
        1974 => 1,
        1936 => 1,
        1921 => 1,
        1709 => 1,
        1568 => 1,
        1831 => 1,
        857 => 1,
        681 => 1,
        679 => 1,
        776 => 1,
    );

    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if exists $exclusion_list{$npc_id};

    if (quest::ChooseRandom(1..100) <= 10) {
        my ($x, $y, $z, $h) = ($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        quest::spawn2(1984, 0, 0, $x, $y, $z, $h);
    }
}
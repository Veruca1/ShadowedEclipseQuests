sub EVENT_DEATH_COMPLETE {
   my $librarian = int(rand(100) + 1);
   if ($librarian <= 10) {
      my $angrylibr = quest::spawn2(111161, 0, 0, $x, $y, $z, 0); # NPC: #an_angry_librarian
      my $attack = $entity_list->GetMobID($angrylibr);

      if ($attack) {
         my $angrylibrattk = $attack->CastToNPC();
         if ($angrylibrattk && $client) {
            $angrylibrattk->AddToHateList($client, 1);
         } else {
            quest::debug("Failed to add to hate list: Client or NPC is undefined.");
         }
      } else {
         quest::debug("Failed to retrieve Mob ID for angry librarian.");
      }
   }
}

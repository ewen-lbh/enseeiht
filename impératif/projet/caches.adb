with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;     use Ada.Float_Text_IO;

package body Caches is

    procedure Afficher_Stat(Stat: in StatsCache) is
    begin
        Put("Défauts: ");
        Put(Stat.Defauts);
        Put(" sur ");
        Put(Stat.Demandes);
        Put(" (");
        Put((Float(Stat.Defauts) / Float(Stat.Demandes)) * 100.0, 5, 3, 0);
        Put("%)"); New_Line;
    end Afficher_Stat;

end Caches;
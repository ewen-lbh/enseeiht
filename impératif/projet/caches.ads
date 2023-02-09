package Caches is
    type StatsCache is record
        Defauts: Integer;
        Demandes: Integer;
    end record;

    procedure Afficher_Stat(Stat: in StatsCache);

end Caches;

with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Stocks_Materiel;     use Stocks_Materiel;

-- Auteur: Ewen Le Bihan
-- Gérer un stock de matériel informatique.
--
procedure Scenario_Stock is

    Mon_Stock : T_Stock;
begin
    -- Créer un stock vide
    Creer (Mon_Stock);
    pragma Assert (Nb_Materiels (Mon_Stock) = 0);

    -- Enregistrer quelques matériels
    Enregistrer (Mon_Stock, 1_012, UNITE_CENTRALE, 2_016);
    pragma Assert (Nb_Materiels (Mon_Stock) = 1);
    pragma Assert (Nb_Materiels_HS (Mon_Stock) = 0);

    Enregistrer (Mon_Stock, 2_143, ECRAN, 2_016);
    pragma Assert (Nb_Materiels (Mon_Stock) = 2);
    pragma Assert (Nb_Materiels_HS (Mon_Stock) = 0);

    Enregistrer (Mon_Stock, 3_001, IMPRIMANTE, 2_017);
    pragma Assert (Nb_Materiels (Mon_Stock) = 3);
    pragma Assert (Nb_Materiels_HS (Mon_Stock) = 0);

    Enregistrer (Mon_Stock, 3_012, UNITE_CENTRALE, 2_017);
    pragma Assert (Nb_Materiels (Mon_Stock) = 4);
    pragma Assert (Nb_Materiels_HS (Mon_Stock) = 0);

    Mettre_A_Jour (Mon_Stock, 3_012, UNITE_CENTRALE, 2017, false);
    pragma Assert (Nb_Materiels (Mon_Stock) = 4);
    pragma Assert (Nb_Materiels_HS (Mon_Stock) = 1);

end Scenario_Stock;

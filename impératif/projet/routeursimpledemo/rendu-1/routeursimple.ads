with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Table;                 use Table.Table_LCA;

package RouteurSimple is

    -- Récupère l'interface par rapport à une adresse
    function Trouver_interface
       (T                              : in T_LCA; IP : in Table.T_Adresse_IP;
        meilleur_masque : in Table.T_Adresse_IP := Table.T_Adresse_IP (0);
        interface_avec_meilleur_masque :    Unbounded_String   :=
           To_Unbounded_String (""))
        return Unbounded_String;

    -- Effectue la commande table
    procedure Commande_Table (T : in T_LCA);

    -- Parse et éxecute les commandes
    procedure Analyse_fichier_paquets
       (T              : in T_LCA; Fichier_paquets : in Unbounded_String;
        Fichier_Resultats : in Unbounded_String);
   

end RouteurSimple;

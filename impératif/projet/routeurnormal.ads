with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Table;                 use Table.Table_LCA;
with lca;
with parsing; use parsing;
with Table; use Table; 


package routeurnormal is 

    private 
        Type_Routage: Integer; -- Par quelle méthode: Arbre? LCA? --> LFU, LRU? opérer le routeur
        Politique: Integer;


    procedure Afficher_Table();

    procedure Afficher_Cache();

    procedure Router_Adresse(Adr: in T_Adresse_IP);
    procedure Parser_Methode(Type: out Integer);
    procedure Parser_Politique(Type: out Integer);

end routeurnormal;

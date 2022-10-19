-- Auteur:
-- Gérer un stock de matériel informatique.

package Stocks_Materiel is

   CAPACITE : constant Integer :=
     10;      -- nombre maximum de matériels dans un stock

   type T_Nature is (UNITE_CENTRALE, DISQUE, ECRAN, CLAVIER, IMPRIMANTE);

   type Materiel is record
      Numero_Serie : Integer;
      Nature       : T_Nature;
      Annee_Achat  : Integer;
      Fonctionne   : Boolean;
   end record;

   type T_Stock_Elements is array (1 .. CAPACITE) of Materiel;

   type T_Stock is record
      Valeurs : T_Stock_Elements;
      Taille  : Integer;
   end record;

   -- Créer un stock vide.
   --
   -- paramètres
   --     Stock : le stock à créer
   --
   -- Assure
   --     Nb_Materiels (Stock) = 0
   --
   procedure Creer (Stock : out T_Stock) with
     Post => Nb_Materiels (Stock) = 0;

   -- Obtenir le nombre de matériels dans le stock Stock.
   --
   -- Paramètres
   --    Stock : le stock dont ont veut obtenir la taille
   --
   -- Nécessite
   --     Vrai
   --
   -- Assure
   --     Résultat >= 0 Et Résultat <= CAPACITE
   --
   function Nb_Materiels (Stock : in T_Stock) return Integer with
     Post => Nb_Materiels'Result >= 0 and Nb_Materiels'Result <= CAPACITE;

   -- Enregistrer un nouveau métériel dans le stock.  Il est en
   -- fonctionnement.  Le stock ne doit pas être plein.
   --
   -- Paramètres
   --    Stock : le stock à compléter
   --    Numero_Serie : le numéro de série du nouveau matériel
   --    Nature       : la nature du nouveau matériel
   --    Annee_Achat  : l'année d'achat du nouveau matériel
   --
   -- Nécessite
   --    Nb_Materiels (Stock) < CAPACITE
   --
   -- Assure
   --    Nouveau matériel ajouté
   --    Nb_Materiels (Stock) = Nb_Materiels (Stock)'Avant + 1
   procedure Enregistrer
     (Stock : in out T_Stock; Numero_Serie : in Integer; Nature : in T_Nature;
      Annee_Achat : in     Integer) with
     Pre  => Nb_Materiels (Stock) < CAPACITE,
     Post => Nb_Materiels (Stock) = Nb_Materiels (Stock)'Old + 1;

   -- Mettre à jour un matériel par son numéro de série.
   --
   -- Paramètres
   --  Stock           : le stock à modifier
   --  Numero_Serie    : Le numéro de série du matériel à mettre à jour
   --  Nature          : la nouvelle nature
   --  Annee_Achat     : la nouvelle date d'achat
   --  Fonctionnement  : le matériel fonctionne-t-il ?
   --
   -- Nécéssite
   --  Nb_Materiels(Stock) < CAPACITE
   --
   -- Assure
   --  Le matériel correspondant a été modifié
   --- Le reste du matériel n'est pas modifié
   procedure Mettre_A_Jour
     (Stock : in out T_Stock; Numero_Serie : in Integer; Nature : in T_Nature;
      Annee_Achat : in     Integer; Fonctionne : in Boolean) with
     Pre => Nb_Materiels (Stock) < CAPACITE;

   -- Compter le nombre de matériel étant hors service.
   --
   -- Paramètres
   --  Stock           : le stock où compter
   --
   -- Nécéssite
   --  Nb_Materiels(Stock) < CAPACITE
   --
   -- Assure
   --  Nb_Materiels_HS(Stock) < CAPACITE
   function Nb_Materiels_HS (Stock : in T_Stock) return Integer with
     Pre => Nb_Materiels (Stock) < CAPACITE;
   --   Post => Result < CAPACITE;

   -- Supprimer un matériel du stock par son numéro de série.
   --
   -- Paramètres
   --  Stock           : le stock à modifier
   --
   -- Nécéssite
   --  vrai
   --
   -- Assure
   --  Nb_Materiels(Stock'New) = Nb_Materiels(Stock'Old) - 1
   procedure Supprimer (Stock : in T_Stock; Numero_Serie : in Integer);
   --    Post => Nb_Materiels(Stock) = Nb_Materiels(Stock'Old) + 1;

   -- Afficher la liste du stock dans le terminal
   -- Paramètres
   --  Stock           : le stock à afficher
   --
   -- Nécéssite
   --  vrai
   --
   -- Assure
   --  vrai
   procedure Afficher (Stock: in T_Stock);

end Stocks_Materiel;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Table;
with Caches;

package Lca_Lru is

    type T_Lru is limited private;

    -- Initialisation d'un cache FIFO
    procedure Initialiser(Lru: out T_Lru; Capacite: in Integer) with
        Pre => Capacite > 0;

    -- Affichage d'un cache FIFO
    procedure Afficher(Lru: in T_Lru);

    -- Affichage des stats du caches
    procedure Afficher_Stat(Lru: in T_Lru);

   -- Récupere le nombre de demande et de défault de cache
    procedure Recuperer_Stat(Lru: in T_Lru; Demande: out Integer; Defaut: out Integer) with
        Post => Demande >= 0 and Defaut >= 0;

    -- Vérifie si une adresse est trouver dans le cache
    procedure Verifier_Cache(Lru: in out T_Lru; Trouver: out Boolean; Adresse: in Table.T_Adresse_IP; Eth: out Unbounded_String) with
        Post => (Trouver and Eth /= To_Unbounded_String("")) or ((not Trouver) and Eth = To_Unbounded_String(""));

    -- Ajouter une adresse, un masque et une interface dans le cache
    procedure Ajouter_Dans_Cache(Lru: in out T_Lru; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) with
        Pre => Table.T_Adresse_IP_Vers_String_IP(Masque) /= To_Unbounded_String("0.0.0.0") and Eth /= To_Unbounded_String("");

    procedure Vider (Lru: in out T_Lru);

private

    type T_Cellule;

    type T_LCA is access T_Cellule;

    type T_Cellule is
        record 
            Ip: Table.T_Adresse_IP;
            Masque: Table.T_Adresse_IP;
            Eth: Unbounded_String;
            Compteur: Integer;
            Suivant: T_LCA;
        end record;

    type T_Lru is 
        record
            Stat: Caches.StatsCache;
            Lca: T_LCA;
            Compteur: Integer;
            Capacite: Integer;
            Taille: Integer;
        end record;
        
    procedure Remplacer_Dans_Cache(Lru: in out T_Lru; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) with
        Post => Lru.Taille'Old = Lru.Taille;

end Lca_Lru;
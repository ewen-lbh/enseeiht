with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Table;
with Caches;

package Lca_Fifo is

    type T_Fifo is limited private;

    -- Initialisation d'un cache FIFO
    procedure Initialiser(Fifo: out T_Fifo; Capacite: in Integer) with
        Pre => Capacite > 0;

    -- Affichage d'un cache FIFO
    procedure Afficher(Fifo: in T_Fifo);

    -- Affichage des stats du caches
    procedure Afficher_Stat(Fifo: in T_Fifo);

    -- Récupere le nombre de demande et de défault de cache
    procedure Recuperer_Stat(Fifo: in T_Fifo; Demande: out Integer; Defaut: out Integer) with
        Post => Demande >= 0 and Defaut >= 0;

    -- Vérifie si une adresse est trouver dans le cache
    procedure Verifier_Cache(Fifo: in out T_Fifo; Trouver: out Boolean; Adresse: in Table.T_Adresse_IP; Eth: out Unbounded_String) with
        Post => (Trouver and Eth /= To_Unbounded_String("")) or ((not Trouver) and Eth = To_Unbounded_String(""));

    -- Ajouter une adresse, un masque et une interface dans le cache
    procedure Ajouter_Dans_Cache(Fifo: in out T_Fifo; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) with
        Pre => Table.T_Adresse_IP_Vers_String_IP(Masque) /= To_Unbounded_String("0.0.0.0") and Eth /= To_Unbounded_String("");

    procedure Vider (Fifo: in out T_Fifo);

private

    type T_Cellule;

    type T_LCA is access T_Cellule;

    type T_Cellule is
        record 
            Ip: Table.T_Adresse_IP;
            Masque: Table.T_Adresse_IP;
            Eth: Unbounded_String;
            Suivant: T_LCA;
        end record;

    type T_Fifo is 
        record
            Stat: Caches.StatsCache;
            Lca: T_LCA;
            Capacite: Integer;
            Taille: Integer;
        end record;

    procedure Remplacer_Dans_Cache(Fifo: in out T_Fifo; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) with
        Post => Fifo.Taille'Old = Fifo.Taille;
end Lca_Fifo;
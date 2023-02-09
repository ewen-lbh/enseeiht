with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Table;                 use Table;
with Caches;                use Caches;
with Table;

package cache_abr is
    type T_Noeud;
    type T_ABR is access T_Noeud;
    type T_Noeud is record
        fils_gauche       : T_ABR;
        fils_droit        : T_ABR;
        -- contient la partie de l'adresse IP. en concaténant les fragments de tout les parents, on obtient un préfixe d'IP qui doit être routé à eth.
        fragment          : Unbounded_String;
        -- une chaîne vide, sauf pour les feuilles, qui stockent l'interface à utiliser pour une addresse IP dont le chemin d'accès à ce nœud est un préfixe.
        eth               : Unbounded_String;
        -- crière politique: la valeur diffère selon la politique utilisée.
        -- valeur de -1, sauf pour les feuilles:
        -- LRU: nombre d'accès qui n'ont pas atteint ce nœud. le nœud avec la plus grande valeur sera supprimé dès la saturation du cache.
        -- LFU: fréquence d'accès. le nœud avec la plus petite valeur sera supprimé dès la saturation du cache.
        -- FIFO: nombre d'ajouts après l'ajout de ce nœud. le nœud avec la plus grande valeur sera supprimé dès la saturation du cache.
        critere_politique : Float;
        masque            : Table.T_Adresse_IP;
        ip_originale      : Table.T_Adresse_IP;
    end record;

    Arbre_Vide : exception;

    type T_Politique is (LRU, FIFO, LFU);

    type T_Cache_ABR is record
        arbre     : T_ABR;
        politique : T_Politique;
        stats     : StatsCache;
        Capacite  : Integer;
    end record;

    procedure Initialiser
       (cache : out T_Cache_ABR; politique : in T_Politique; capacite : in Integer) with
       Pre  => capacite > 0,
       Post =>
        cache.Capacite = capacite and cache.politique = politique and cache.stats.Demandes = 0 and
        cache.stats.Defauts = 0;

    procedure Ajouter_Dans_Cache
       (cache : in out T_Cache_ABR; addr : in Table.T_Adresse_IP; Masque : in Table.T_Adresse_IP;
        Eth   : in     Unbounded_String) with
       Pre  => Length (Eth) > 0,
       Post =>
        taille_cache (cache'Old.arbre) <= taille_cache (cache.arbre) + 1 and
        cache'Old.politique = cache.politique and cache'Old.Capacite = cache.Capacite and
        cache'Old.stats.Demandes = cache.stats.Demandes and
        cache'Old.stats.Defauts = cache.stats.Defauts;

    procedure Verifier_cache
       (cache : in out T_Cache_ABR; trouve : out Boolean; addr : in Table.T_Adresse_IP;
        eth   :    out Unbounded_String) with
       Pre  => cache.arbre /= null,
       Post =>
        ((trouve and eth /= "") or (not trouve and eth = "")) and
        cache'Old.politique = cache.politique and cache'Old.Capacite = cache.Capacite and
        cache'Old.stats.Demandes = cache.stats.Demandes - 1 and
        cache'Old.stats.Defauts <= cache.stats.Defauts;

    procedure Afficher (cache : in T_Cache_ABR);

    procedure Afficher_Stat (cache : in T_Cache_ABR);

    procedure Recuperer_Stat
       (cache : in T_Cache_ABR; Demande : out Integer; Defaut : out Integer) with
       Post => Demande = cache.stats.Demandes and Defaut = cache.stats.Defauts;

    function Arbre_To_String
       (arbre : in T_ABR; indentation_initiale : Integer) return Unbounded_String with
       Pre => indentation_initiale >= 0;

    function Est_Plein (cache : T_Cache_ABR) return Boolean;

    procedure Supprimer_pire_noeud (cache : in out T_Cache_ABR) with
       Post => taille_cache (cache'Old.arbre) >= taille_cache (cache.arbre);

    procedure Vider (cache : in out T_Cache_ABR);

--  private
    --  procedure Supprimer
    --     (cache : in out T_Cache_ABR; addr : Table.T_Adresse_IP);
    procedure Creer_ABR
       (fils_gauche : in     T_ABR; fils_droit : in T_ABR; critere_politique : in Float;
        eth : in Unbounded_String; fragment : in Unbounded_String; masque : in Table.T_Adresse_IP;
        arbre       :    out T_ABR) with
       Pre  => critere_politique >= 0.0,
       Post =>
        arbre /= null and arbre.fils_gauche = fils_gauche and arbre.fils_droit = fils_droit and
        arbre.critere_politique = critere_politique and arbre.eth = eth and
        arbre.fragment = fragment and arbre.masque = masque;

    function ip_to_binary_string (addr : in Table.T_Adresse_IP) return Unbounded_String;

    function bitstring_to_t_addresse_ip (bitstring : in Unbounded_String) return Table.T_Adresse_IP;

    function est_feuille (noeud : T_ABR) return Boolean with
       Pre => noeud /= null;

    function prefixe_adresse
       (ip : Unbounded_String; masque : Unbounded_String) return Unbounded_String;

    function a_prefixe (source : Unbounded_String; prefixe : Unbounded_String) return Boolean;

    procedure separer_prefixe
       (a         : in Unbounded_String; b : in Unbounded_String; prefixe : out Unbounded_String;
        suffixe_a :    out Unbounded_String; suffixe_b : out Unbounded_String);

    procedure incrementer_anciennete (arbre : in T_ABR);

    function taille_cache (arbre : T_ABR) return Integer with
       Post => taille_cache'Result >= 0;

    procedure vider_arbre (arbre : in out T_ABR);

    function debug_arbre (arbre : T_ABR; indentation_initiale : Integer) return Unbounded_String;

    procedure Afficher_debug (cache : in T_Cache_ABR);
end cache_abr;

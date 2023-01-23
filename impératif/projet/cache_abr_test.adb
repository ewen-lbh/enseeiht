with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Exceptions;        use Ada.Exceptions;
with cache_abr;             use cache_abr;
with Table;                 use Table;
with Ada.Text_IO;           use Ada.Text_IO;

procedure Cache_Abr_Test is
    NL    : constant Character := (Character'Val (10));
    cache : T_Cache_ABR;

    procedure Assert_Routage (cache : in out T_Cache_ABR; addr : in String; eth : in String) is
        reel   : Unbounded_String;
        voulu  : Unbounded_String := To_Unbounded_String (eth);
        trouve : Boolean          := False;
    begin
        Verifier_cache
           (cache, trouve, String_IP_Vers_T_Adresse_IP (To_Unbounded_String (addr)), reel);
        Put_Line (addr & " -> " & To_String (reel) & " (expected " & eth & ")");
        pragma Assert (reel = voulu);
        pragma Assert (trouve = (voulu /= To_Unbounded_String ("")));
    end Assert_Routage;

    procedure Assert_Etat_Arbre (cache : T_Cache_ABR; etat : String) is
        reel  : Unbounded_String;
        voulu : Unbounded_String := To_Unbounded_String (etat);
    begin
        reel := debug_arbre (cache.arbre, 0);
        if reel /= voulu then
            Put_Line
               ("Etat de l'arbre: " & NL & To_String (reel) & NL & "Etat attendu: " & NL &
                To_String (voulu));
            Afficher_debug (cache);
        end if;
        pragma Assert (reel = voulu);
    end Assert_Etat_Arbre;

    procedure Assert_Erreur_a_la_suppression (cache : in out T_Cache_ABR) is
    begin
        Supprimer_pire_noeud (cache);
        pragma Assert (1 = 0);
    exception
        when Arbre_Vide =>
            null;
    end Assert_Erreur_a_la_suppression;

    procedure Test_operations_prefixes is
        a         : Unbounded_String;
        b         : Unbounded_String;
        prefixe   : Unbounded_String;
        suffixe_a : Unbounded_String;
        suffixe_b : Unbounded_String;
    begin
        a := To_Unbounded_String ("110100111");
        b := To_Unbounded_String ("11010010001");
        separer_prefixe (a, b, prefixe, suffixe_a, suffixe_b);
        pragma Assert (prefixe = To_Unbounded_String ("1101001"));
        pragma Assert (suffixe_a = To_Unbounded_String ("11"));
        pragma Assert (suffixe_b = To_Unbounded_String ("0001"));
        pragma Assert (a_prefixe (a, prefixe));
        a := To_Unbounded_String ("00100110111111100010010");
        b := To_Unbounded_String ("0010011011111110001");
        separer_prefixe (a, b, prefixe, suffixe_a, suffixe_b);
        pragma Assert (prefixe = To_Unbounded_String ("0010011011111110001"));
        pragma Assert (suffixe_a = To_Unbounded_String ("0010"));
        pragma Assert (suffixe_b = To_Unbounded_String (""));
        pragma Assert (a_prefixe (a, prefixe));
    end Test_operations_prefixes;

    procedure Test_conversion_bitstring is
        a : Unbounded_String;
        b : T_Adresse_IP;
    begin
        pragma Assert
           (To_String
               (T_Adresse_IP_Vers_String_IP
                   (bitstring_to_t_addresse_ip
                       (ip_to_binary_string
                           (String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.16.0")))))) =
            "147.127.16.0");
    end Test_conversion_bitstring;

    procedure Setup_cache_LFU (cache : out T_Cache_ABR) is
    begin
        Initialiser (cache, LFU, 10);
        Put_Line
           ("Ajout dans cache de " & ("147.127.16.0") & " " & ("255.255.240.0") & " " & "eth0");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.16.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.240.0")),
            To_Unbounded_String ("eth0"));
        Put_Line
           ("Ajout dans cache de " & ("147.127.18.0") & " " & ("255.255.255.0") & " " & "eth1");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.18.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth1"));
        Put_Line
           ("Ajout dans cache de " & ("147.127.0.0") & " " & ("255.255.255.0") & " " & "eth2");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth2"));
        Put_Line ("Ajout dans cache de " & ("212.0.0.0") & " " & ("255.0.0.0") & " " & "eth3");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("212.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.0.0.0")),
            To_Unbounded_String ("eth3"));
        Put_Line ("Ajout dans cache de " & ("0.0.0.0") & " " & ("0.0.0.0") & " " & "eth0");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            To_Unbounded_String ("eth0"));
    end Setup_cache_LFU;

    procedure Setup_cache_LRU (cache : out T_Cache_ABR) is
    begin
        Initialiser (cache, LRU, 10);
        Put_Line
           ("Ajout dans cache de " & ("147.127.16.0") & " " & ("255.255.240.0") & " " & "eth0");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.16.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.240.0")),
            To_Unbounded_String ("eth0"));
        Put_Line
           ("Ajout dans cache de " & ("147.127.18.0") & " " & ("255.255.255.0") & " " & "eth1");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.18.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth1"));
        Put_Line
           ("Ajout dans cache de " & ("147.127.0.0") & " " & ("255.255.255.0") & " " & "eth2");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth2"));
        Put_Line ("Ajout dans cache de " & ("212.0.0.0") & " " & ("255.0.0.0") & " " & "eth3");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("212.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.0.0.0")),
            To_Unbounded_String ("eth3"));
        Put_Line ("Ajout dans cache de " & ("0.0.0.0") & " " & ("0.0.0.0") & " " & "eth0");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            To_Unbounded_String ("eth0"));
    end Setup_cache_LRU;

    procedure Setup_cache_FIFO (cache_out : out T_Cache_ABR) is
        cache : T_Cache_ABR;
    begin
        Initialiser (cache, FIFO, 10);
        Put_Line
           ("Ajout dans cache de " & ("147.127.16.0") & " " & ("255.255.240.0") & " " & "eth0");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.16.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.240.0")),
            To_Unbounded_String ("eth0"));
        Put_Line
           ("Ajout dans cache de " & ("147.127.18.0") & " " & ("255.255.255.0") & " " & "eth1");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.18.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth1"));
        Put_Line
           ("Ajout dans cache de " & ("147.127.0.0") & " " & ("255.255.255.0") & " " & "eth2");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth2"));
        Put_Line ("Ajout dans cache de " & ("212.0.0.0") & " " & ("255.0.0.0") & " " & "eth3");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("212.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.0.0.0")),
            To_Unbounded_String ("eth3"));
        Put_Line ("Ajout dans cache de " & ("0.0.0.0") & " " & ("0.0.0.0") & " " & "eth0");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            To_Unbounded_String ("eth0"));
        cache_out := cache;
    end Setup_cache_FIFO;

    procedure Test_ajouter_dans_cache_lfu is
    begin
        Initialiser (cache, LFU, 10);
        -- format ... & " " & de déboguage de l'état de l'arbre:
        --      [...]: fragment,
        --      (...): interface,
        --      Put_Line("Ajout dans cache de " &
        --      0.00: critèrcache.arbre, "[] () 0.00 { x; x }" & " " & e de politique,
        --      {...; ...}: fils gauche et droit.
        Assert_Etat_Arbre (cache, "[] () 0.00 { x; x }");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.16.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.240.0")),
            To_Unbounded_String ("eth0"));
        Assert_Etat_Arbre (cache, "[] () 0.00 { x; [0010011011111110001] (eth0) 0.00 { x; x } }");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.18.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth1"));
        Assert_Etat_Arbre
           (cache,
            "[] () 0.00 { x; [0010011011111110001] (eth0) 0.00 { [010] (eth1) 0.00 { x; x }; x } }");
        Put_Line
           ("Ajout dans cache de " & ("147.127.0.0") & " " & ("255.255.255.0") & " " & "eth2");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth2"));
        Assert_Etat_Arbre
           (cache,
            "[] () 0.00 { x; [001001101111111000] () 0.00 { [0000] (eth2) 0.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 0.00 { x; x }; x } } }");
        Put_Line ("Ajout dans cache de " & ("212.0.0.0") & " " & ("255.0.0.0") & " " & "eth3");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("212.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.0.0.0")),
            To_Unbounded_String ("eth3"));
        Assert_Etat_Arbre
           (cache,
            "[] () 0.00 { x; [] () 0.00 { [01001101111111000] () 0.00 { [0000] (eth2) 0.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 0.00 { x; x }; x } }; [010100] (eth3) 0.00 { x; x } } }");
        Put_Line ("Ajout dans cache de " & ("0.0.0.0") & " " & ("0.0.0.0") & " " & "eth0");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            To_Unbounded_String ("eth0"));
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 0.00 { x; [] () 0.00 { [01001101111111000] () 0.00 { [0000] (eth2) 0.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 0.00 { x; x }; x } }; [010100] (eth3) 0.00 { x; x } } }");
        Vider (cache);
    end Test_ajouter_dans_cache_lfu;

    procedure Test_ajouter_dans_cache_fifo is
    begin
        Initialiser (cache, FIFO, 10);
        -- format de déboguage de l'état de l'arbre:
        --      [...]: fragment,
        --      (...): interface,
        --      0.00: critère de politique,
        --      {...; ...}: fils gauche et droit.
        Assert_Etat_Arbre (cache, "[] () 0.00 { x; x }");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.16.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.240.0")),
            To_Unbounded_String ("eth0"));
        Assert_Etat_Arbre (cache, "[] () 1.00 { x; [0010011011111110001] (eth0) 0.00 { x; x } }");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.18.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth1"));
        Assert_Etat_Arbre
           (cache,
            "[] () 2.00 { x; [0010011011111110001] (eth0) 1.00 { [010] (eth1) 0.00 { x; x }; x } }");
        Put_Line
           ("Ajout dans cache de " & ("147.127.0.0") & " " & ("255.255.255.0") & " " & "eth2");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth2"));
        Assert_Etat_Arbre
           (cache,
            "[] () 3.00 { x; [001001101111111000] () 0.00 { [0000] (eth2) 0.00 { x; x }; [] (eth0) 2.00 { [010] (eth1) 1.00 { x; x }; x } } }");
        Put_Line ("Ajout dans cache de " & ("212.0.0.0") & " " & ("255.0.0.0") & " " & "eth3");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("212.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.0.0.0")),
            To_Unbounded_String ("eth3"));
        Assert_Etat_Arbre
           (cache,
            "[] () 4.00 { x; [] () 0.00 { [01001101111111000] () 1.00 { [0000] (eth2) 1.00 { x; x }; [] (eth0) 3.00 { [010] (eth1) 2.00 { x; x }; x } }; [010100] (eth3) 0.00 { x; x } } }");
        Put_Line ("Ajout dans cache de " & ("0.0.0.0") & " " & ("0.0.0.0") & " " & "eth0");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            To_Unbounded_String ("eth0"));
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 0.00 { x; [] () 1.00 { [01001101111111000] () 2.00 { [0000] (eth2) 2.00 { x; x }; [] (eth0) 4.00 { [010] (eth1) 3.00 { x; x }; x } }; [010100] (eth3) 1.00 { x; x } } }");
        Vider (cache);
    end Test_ajouter_dans_cache_fifo;

    procedure Test_ajouter_dans_cache_lru is
    begin
        Initialiser (cache, LRU, 10);
        -- format de déboguage de l'état de l'arbre:
        --      [...]: fragment,
        --      (...): interface,
        --      0.00: critère de politique,
        --      {...; ...}: fils gauche et droit.
        Assert_Etat_Arbre (cache, "[] () 0.00 { x; x }");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.16.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.240.0")),
            To_Unbounded_String ("eth0"));
        Assert_Etat_Arbre (cache, "[] () 0.00 { x; [0010011011111110001] (eth0) 0.00 { x; x } }");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.18.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth1"));
        Assert_Etat_Arbre
           (cache,
            "[] () 0.00 { x; [0010011011111110001] (eth0) 0.00 { [010] (eth1) 0.00 { x; x }; x } }");
        Put_Line
           ("Ajout dans cache de " & ("147.127.0.0") & " " & ("255.255.255.0") & " " & "eth2");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.255.255.0")),
            To_Unbounded_String ("eth2"));
        Assert_Etat_Arbre
           (cache,
            "[] () 0.00 { x; [001001101111111000] () 0.00 { [0000] (eth2) 0.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 0.00 { x; x }; x } } }");
        Put_Line ("Ajout dans cache de " & ("212.0.0.0") & " " & ("255.0.0.0") & " " & "eth3");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("212.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.0.0.0")),
            To_Unbounded_String ("eth3"));
        Assert_Etat_Arbre
           (cache,
            "[] () 0.00 { x; [] () 0.00 { [01001101111111000] () 0.00 { [0000] (eth2) 0.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 0.00 { x; x }; x } }; [010100] (eth3) 0.00 { x; x } } }");
        Put_Line ("Ajout dans cache de " & ("0.0.0.0") & " " & ("0.0.0.0") & " " & "eth0");
        Ajouter_Dans_Cache
           (cache, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
            To_Unbounded_String ("eth0"));
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 0.00 { x; [] () 0.00 { [01001101111111000] () 0.00 { [0000] (eth2) 0.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 0.00 { x; x }; x } }; [010100] (eth3) 0.00 { x; x } } }");
        Vider (cache);
    end Test_ajouter_dans_cache_lru;

    procedure Test_supprimer_lru is
        cache  : T_Cache_ABR;
        trouve : Boolean;
        eth    : Unbounded_String;
    begin
        Setup_cache_LRU (cache);
        Verifier_cache
           (cache, trouve, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("127.122.19.2")), eth);
        Verifier_cache
           (cache, trouve, String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("147.127.18.2")), eth);
        Supprimer_pire_noeud (cache);
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 1.00 { x; [] () 0.00 { [01001101111111000] () 0.00 { x; [] () 0.00 { [010] (eth1) 0.00 { x; x }; x } }; x } }");
        Supprimer_pire_noeud (cache);
        Assert_Etat_Arbre
           (cache, "[] (eth0) 1.00 { x; [] () 0.00 { [01001101111111000] () 0.00 { x; x }; x } }");
        Supprimer_pire_noeud (cache);
        Assert_Etat_Arbre (cache, "[] (eth0) 1.00 { x; x }");
        Supprimer_pire_noeud (cache);
        Assert_Etat_Arbre (cache, "x");
        Assert_Erreur_a_la_suppression (cache);
        Vider (cache);
    end Test_supprimer_lru;

    procedure Test_supprimer_fifo is
        cache : T_Cache_ABR;
    begin
        Setup_cache_FIFO (cache);
        Supprimer_pire_noeud (cache);
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 0.00 { x; [] () 1.00 { [01001101111111000] () 2.00 { [0000] (eth2) 2.00 { x; x }; [] (eth0) 4.00 { x; x } }; [010100] (eth3) 1.00 { x; x } } }");
        Supprimer_pire_noeud (cache);
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 0.00 { x; [] () 1.00 { [01001101111111000] () 2.00 { [0000] (eth2) 2.00 { x; x }; x }; [010100] (eth3) 1.00 { x; x } } }");
        Supprimer_pire_noeud (cache);
        Assert_Etat_Arbre
           (cache, "[] (eth0) 0.00 { x; [] () 1.00 { x; [010100] (eth3) 1.00 { x; x } } }");
        Supprimer_pire_noeud (cache);
        Assert_Etat_Arbre (cache, "[] (eth0) 0.00 { x; x }");
        Supprimer_pire_noeud (cache);
        Assert_Etat_Arbre (cache, "x");
        Assert_Erreur_a_la_suppression (cache);
        Vider (cache);
    end Test_supprimer_fifo;

    procedure Test_routage_lru is
        cache : T_Cache_ABR;
    begin
        Setup_cache_LRU (cache);
        Afficher (cache);
        Afficher_debug (cache);
        Put_Line (To_String (debug_arbre (cache.arbre, 0)));
        Assert_Routage (cache, "212.212.212.212", "eth3");
        Put_Line (To_String (debug_arbre (cache.arbre, 0)));
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 1.00 { x; [] () 1.00 { [01001101111111000] () 1.00 { [0000] (eth2) 1.00 { x; x }; [] (eth0) 1.00 { [010] (eth1) 1.00 { x; x }; x } }; [010100] (eth3) 0.00 { x; x } } }");
        Assert_Routage (cache, "147.127.18.80", "eth1");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 2.00 { x; [] () 2.00 { [01001101111111000] () 2.00 { [0000] (eth2) 2.00 { x; x }; [] (eth0) 2.00 { [010] (eth1) 0.00 { x; x }; x } }; [010100] (eth3) 1.00 { x; x } } }");
        Assert_Routage (cache, "147.127.18.85", "eth1");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 3.00 { x; [] () 3.00 { [01001101111111000] () 3.00 { [0000] (eth2) 3.00 { x; x }; [] (eth0) 3.00 { [010] (eth1) 0.00 { x; x }; x } }; [010100] (eth3) 2.00 { x; x } } }");
        Assert_Routage (cache, "147.127.19.1", "eth0");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 4.00 { x; [] () 4.00 { [01001101111111000] () 4.00 { [0000] (eth2) 4.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 1.00 { x; x }; x } }; [010100] (eth3) 3.00 { x; x } } }");
        Assert_Routage (cache, "147.127.20.20", "eth0");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 5.00 { x; [] () 5.00 { [01001101111111000] () 5.00 { [0000] (eth2) 5.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 2.00 { x; x }; x } }; [010100] (eth3) 4.00 { x; x } } }");
        Assert_Routage (cache, "147.127.32.32", "eth0");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 0.00 { x; [] () 6.00 { [01001101111111000] () 6.00 { [0000] (eth2) 6.00 { x; x }; [] (eth0) 1.00 { [010] (eth1) 3.00 { x; x }; x } }; [010100] (eth3) 5.00 { x; x } } }");

        -- Test si une route non existante n'est pas trouvée
        cache.arbre.eth := To_Unbounded_String ("");
        Assert_Routage (cache, "147.127.32.32", "");
        Vider (cache);
    end Test_routage_lru;

    procedure Test_routage_lfu is
        cache : T_Cache_ABR;
    begin
        Setup_cache_LFU (cache);
        Assert_Routage (cache, "212.212.212.212", "eth3");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 1.00 { x; [] () 1.00 { [01001101111111000] () 1.00 { [0000] (eth2) 1.00 { x; x }; [] (eth0) 1.00 { [010] (eth1) 1.00 { x; x }; x } }; [010100] (eth3) 0.00 { x; x } } }");
        Assert_Routage (cache, "147.127.18.80", "eth1");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 2.00 { x; [] () 2.00 { [01001101111111000] () 2.00 { [0000] (eth2) 2.00 { x; x }; [] (eth0) 2.00 { [010] (eth1) 0.00 { x; x }; x } }; [010100] (eth3) 1.00 { x; x } } }");
        Assert_Routage (cache, "147.127.18.85", "eth1");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 3.00 { x; [] () 3.00 { [01001101111111000] () 3.00 { [0000] (eth2) 3.00 { x; x }; [] (eth0) 3.00 { [010] (eth1) 0.00 { x; x }; x } }; [010100] (eth3) 2.00 { x; x } } }");
        Assert_Routage (cache, "147.127.19.1", "eth0");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 4.00 { x; [] () 4.00 { [01001101111111000] () 4.00 { [0000] (eth2) 4.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 1.00 { x; x }; x } }; [010100] (eth3) 3.00 { x; x } } }");
        Assert_Routage (cache, "147.127.20.20", "eth0");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 5.00 { x; [] () 5.00 { [01001101111111000] () 5.00 { [0000] (eth2) 5.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 2.00 { x; x }; x } }; [010100] (eth3) 4.00 { x; x } } }");
        Assert_Routage (cache, "147.127.32.32", "eth0");
        Assert_Etat_Arbre
           (cache,
            "[] (eth0) 6.00 { x; [] () 6.00 { [01001101111111000] () 6.00 { [0000] (eth2) 6.00 { x; x }; [] (eth0) 0.00 { [010] (eth1) 3.00 { x; x }; x } }; [010100] (eth3) 5.00 { x; x } } }");

        -- Test si une route non existante n'est pas trouvée
        cache.arbre.eth := To_Unbounded_String ("");
        Assert_Routage (cache, "147.127.32.32", "");
        Vider (cache);
    end Test_routage_lfu;

    procedure Test_routage_fifo is
        cache      : T_Cache_ABR;
        etat_arbre : constant Unbounded_String :=
           To_Unbounded_String
              ("[] (eth0) 0.00 { x; [] () 1.00 { [01001101111111000] () 2.00 { [0000] (eth2) 2.00 { x; x }; [] (eth0) 4.00 { [010] (eth1) 3.00 { x; x }; x } }; [010100] (eth3) 1.00 { x; x } } }");
    begin
        Setup_cache_FIFO (cache);
        Assert_Routage (cache, "212.212.212.212", "eth3");
        Assert_Etat_Arbre (cache, To_String (etat_arbre));
        Assert_Routage (cache, "147.127.18.80", "eth1");
        Assert_Etat_Arbre (cache, To_String (etat_arbre));
        Assert_Routage (cache, "147.127.18.85", "eth1");
        Assert_Etat_Arbre (cache, To_String (etat_arbre));
        Assert_Routage (cache, "147.127.19.1", "eth0");
        Assert_Etat_Arbre (cache, To_String (etat_arbre));
        Assert_Routage (cache, "147.127.20.20", "eth0");
        Assert_Etat_Arbre (cache, To_String (etat_arbre));
        Assert_Routage (cache, "147.127.32.32", "eth0");
        Assert_Etat_Arbre (cache, To_String (etat_arbre));

        -- Test si une route non existante n'est pas trouvée
        cache.arbre.eth := To_Unbounded_String ("");
        Assert_Routage (cache, "147.127.32.32", "");
        Vider (cache);
    end Test_routage_fifo;

begin
    --  Test_conversion_bitstring;
    --  Test_operations_prefixes;

    --  Test_ajouter_dans_cache_lfu;
    Test_ajouter_dans_cache_fifo;
    Test_ajouter_dans_cache_lru;

    --  Test_routage_lfu;
    Test_routage_fifo;
    Test_routage_lru;

    Test_supprimer_lru;
    Test_supprimer_fifo;
end Cache_Abr_Test;

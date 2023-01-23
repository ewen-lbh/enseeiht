with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;           use Ada.Text_IO;

with Lca_Fifo;
with Lca_Lru;
with Lca_Lfu;
with Table;


procedure Cache_lca_test is

    procedure Afficher_Ajout(ip: in Table.T_Adresse_IP; masque: in Table.T_Adresse_IP; eth: in Unbounded_String) is
    begin
            Put("Ajout de " & To_String(Table.T_Adresse_IP_Vers_String_IP(ip)) & " " 
                & To_String(Table.T_Adresse_IP_Vers_String_IP(masque) & " " & eth)); New_Line;
    end;

    procedure Afficher_Verification(ip: in Table.T_Adresse_IP; eth: in Unbounded_String) is
    begin
        Put("Verification de " & To_String(Table.T_Adresse_IP_Vers_String_IP(ip) & " => " & eth)); New_Line;
    end;

    procedure Test_Fifo_Ajouter_Verifier is
        Cache: Lca_Fifo.T_Fifo;
        Capacite: constant Integer := 3;
        Adresse1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.0"));
        Adresse2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.0"));
        Adresse3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.0"));
        Masque1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        AdresseATrouver1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.1"));
        AdresseATrouver2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.1"));
        AdresseATrouver3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.1"));
        Eth1: constant Unbounded_String := To_Unbounded_String("Eth1");
        Eth2: constant Unbounded_String := To_Unbounded_String("Eth2");
        Eth3: constant Unbounded_String := To_Unbounded_String("Eth3");
        Eth: Unbounded_String;
        AdresseANePasTrouver: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.100.0.17"));
        Trouver: Boolean;
    begin
        Lca_Fifo.Initialiser(Cache, Capacite);
        Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse1, Masque1, Eth1);
        Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse2, Masque2, Eth2);
        Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse3, Masque3, Eth3);
        Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth);
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth1);
        Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth);
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth2);
        Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth);
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth3);
        Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseANePasTrouver, Eth); -- On cherche AdresseANePasTrouver mais elle n'est pas trouvé
        pragma Assert(not Trouver);
        Lca_Fifo.Vider(Cache);
    end Test_Fifo_Ajouter_Verifier;

    procedure Test_Fifo_Remplacer is
            Cache: Lca_Fifo.T_Fifo;
            Capacite: constant Integer := 3;
            Adresse1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.0"));
            Adresse2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.0"));
            Adresse3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.0"));
            Adresse4: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.171.0.0"));
            Masque1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
            Masque2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
            Masque3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
            Masque4: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
            AdresseATrouver1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.1"));
            AdresseATrouver2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.1"));
            AdresseATrouver3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.1"));
            AdresseATrouver4: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.171.0.1"));
            Eth1: constant Unbounded_String := To_Unbounded_String("Eth1");
            Eth2: constant Unbounded_String := To_Unbounded_String("Eth2");
            Eth3: constant Unbounded_String := To_Unbounded_String("Eth3");
            Eth4: constant Unbounded_String := To_Unbounded_String("Eth4");
            Eth: Unbounded_String;
            Trouver: Boolean;
        begin
            Lca_Fifo.Initialiser(Cache, Capacite);
            Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse1, Masque1, Eth1);
            Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse2, Masque2, Eth2);
            Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse3, Masque3, Eth3);
            Afficher_Ajout(Adresse1, Masque1, Eth1);
            Afficher_Ajout(Adresse2, Masque2, Eth2);
            Afficher_Ajout(Adresse3, Masque3, Eth3); New_Line;

            Put("Cache"); New_Line;
            Lca_Fifo.Afficher(Cache); New_Line;

            Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth);
            pragma Assert(Trouver);
            pragma Assert(Eth = Eth1);
            Afficher_Verification(AdresseATrouver1, Eth);
            Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth);
            pragma Assert(Trouver);
            pragma Assert(Eth = Eth2);
            Afficher_Verification(AdresseATrouver2, Eth);
            Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth);
            pragma Assert(Trouver);
            pragma Assert(Eth = Eth3);
            Afficher_Verification(AdresseATrouver3, Eth); New_Line;

            Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse4, Masque4, Eth4); -- On ajoute Adresse4, donc Adresse1 est supprimé du cache
            Afficher_Ajout(Adresse4, Masque4, Eth4); New_Line;
            Put("Cache"); New_Line;
            Lca_Fifo.Afficher(Cache); New_Line;
            Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver4, Eth); -- On cherche AdresseATrouver4
            Afficher_Verification(AdresseATrouver4, Eth); New_Line;
            pragma Assert(Trouver);
            pragma Assert(Eth = Eth4);
            Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth); -- Donc AdresseATrouver1 n'est pas trouvé
            pragma Assert(not Trouver);
            Lca_Fifo.Vider(Cache);
        end Test_Fifo_Remplacer;

    procedure Test_Fifo_Stat is
        Cache: Lca_Fifo.T_Fifo;
        Capacite: constant Integer := 3;
        Adresse1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.0"));
        Adresse2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.0"));
        Adresse3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.0"));
        Masque1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        AdresseATrouver1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.1"));
        AdresseATrouver2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.1"));
        AdresseATrouver3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.1"));
        Eth1: constant Unbounded_String := To_Unbounded_String("Eth1");
        Eth2: constant Unbounded_String := To_Unbounded_String("Eth2");
        Eth3: constant Unbounded_String := To_Unbounded_String("Eth3");
        Eth: Unbounded_String;
        AdresseANePasTrouver: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.100.0.17"));
        Trouver: Boolean;
        Demande: Integer;
        Defaut: Integer;
    begin
        Lca_Fifo.Initialiser(Cache, Capacite);
        Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse1, Masque1, Eth1);
        Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse2, Masque2, Eth2);
        Lca_Fifo.Ajouter_Dans_Cache(Cache, Adresse3, Masque3, Eth3);
        Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth);
        Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth);
        Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth);
        Lca_Fifo.Verifier_Cache(Cache, Trouver, AdresseANePasTrouver, Eth); -- On cherche AdresseANePasTrouver mais elle n'est pas trouvé
        Lca_Fifo.Recuperer_Stat(Cache, Demande, Defaut);
        pragma Assert(Demande = 4);
        pragma Assert(Defaut = 1);
        Lca_Fifo.Vider(Cache);
    end Test_Fifo_Stat;

    procedure Test_Lru_Ajouter_Verifier is
        Cache: Lca_Lru.T_Lru;
        Capacite: constant Integer := 3;
        Adresse1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.0"));
        Adresse2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.0"));
        Adresse3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.0"));
        Masque1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        AdresseATrouver1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.1"));
        AdresseATrouver2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.1"));
        AdresseATrouver3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.1"));
        Eth1: constant Unbounded_String := To_Unbounded_String("Eth1");
        Eth2: constant Unbounded_String := To_Unbounded_String("Eth2");
        Eth3: constant Unbounded_String := To_Unbounded_String("Eth3");
        Eth: Unbounded_String;
        AdresseANePasTrouver: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.100.0.17"));
        Trouver: Boolean;
    begin
        Lca_Lru.Initialiser(Cache, Capacite);
        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse1, Masque1, Eth1);
        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse2, Masque2, Eth2);
        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse3, Masque3, Eth3);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth);
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth1);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth);
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth2);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth);
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth3);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseANePasTrouver, Eth); -- On cherche AdresseANePasTrouver mais elle n'est pas trouvé
        pragma Assert(not Trouver);
        Lca_Lru.Vider(Cache);
    end Test_Lru_Ajouter_Verifier;

    procedure Test_Lru_Remplacer is
        Cache: Lca_Lru.T_Lru;
        Capacite: constant Integer := 3;
        Adresse1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.0"));
        Adresse2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.0"));
        Adresse3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.0"));
        Adresse4: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.171.0.0"));
        Masque1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque4: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        AdresseATrouver1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.1"));
        AdresseATrouver2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.1"));
        AdresseATrouver3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.1"));
        AdresseATrouver4: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.171.0.1"));
        Eth1: constant Unbounded_String := To_Unbounded_String("Eth1");
        Eth2: constant Unbounded_String := To_Unbounded_String("Eth2");
        Eth3: constant Unbounded_String := To_Unbounded_String("Eth3");
        Eth4: constant Unbounded_String := To_Unbounded_String("Eth4");
        Eth: Unbounded_String;
        Trouver: Boolean;
    begin
        Lca_Lru.Initialiser(Cache, Capacite);
        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse1, Masque1, Eth1);
        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse2, Masque2, Eth2);
        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse3, Masque3, Eth3);
        Afficher_Ajout(Adresse1, Masque1, Eth1);
        Afficher_Ajout(Adresse2, Masque2, Eth2);
        Afficher_Ajout(Adresse3, Masque3, Eth3); New_Line;

        Put("Cache"); New_Line;
        Lca_Lru.Afficher(Cache); New_Line;

        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth);
        Afficher_Verification(AdresseATrouver3, Eth);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth);
        Afficher_Verification(AdresseATrouver2, Eth);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth);
        Afficher_Verification(AdresseATrouver1, Eth); New_Line;

        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse4, Masque4, Eth4); -- On ajoute Adresse4, donc c'est AdresseATrouver3 qui est supprimé car le plus ancien utilisé
        Afficher_Ajout(Adresse4, Masque4, Eth4); New_Line;

        Put("Cache"); New_Line;
        Lca_Lru.Afficher(Cache); New_Line;
        
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver4, Eth); -- On cherche AdresseATrouver4
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth4);
        Afficher_Verification(AdresseATrouver4, Eth); New_Line;
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth); -- On cherche AdresseATrouver3, et elle n'est donc pas trouvé
        pragma Assert(not Trouver);
        Lca_Lru.Vider(Cache);
    end Test_Lru_Remplacer;

    procedure Test_Lru_Stat is
        Cache: Lca_Lru.T_Lru;
        Capacite: constant Integer := 3;
        Adresse1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.0"));
        Adresse2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.0"));
        Adresse3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.0"));
        Masque1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        AdresseATrouver1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.1"));
        AdresseATrouver2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.1"));
        AdresseATrouver3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.1"));
        Eth1: constant Unbounded_String := To_Unbounded_String("Eth1");
        Eth2: constant Unbounded_String := To_Unbounded_String("Eth2");
        Eth3: constant Unbounded_String := To_Unbounded_String("Eth3");
        Eth: Unbounded_String;
        AdresseANePasTrouver: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.100.0.17"));
        Trouver: Boolean;
        Demande: Integer;
        Defaut: Integer;
    begin
        Lca_Lru.Initialiser(Cache, Capacite);
        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse1, Masque1, Eth1);
        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse2, Masque2, Eth2);
        Lca_Lru.Ajouter_Dans_Cache(Cache, Adresse3, Masque3, Eth3);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth);
        Lca_Lru.Verifier_Cache(Cache, Trouver, AdresseANePasTrouver, Eth); -- On cherche AdresseANePasTrouver mais elle n'est pas trouvé
        Lca_Lru.Recuperer_Stat(Cache, Demande, Defaut);
        pragma Assert(Demande = 4);
        pragma Assert(Defaut = 1);
        Lca_Lru.Vider(Cache);
    end Test_Lru_Stat;

    procedure Test_Lfu_Ajouter_Verifier is
        Cache: Lca_Lfu.T_Lfu;
        Capacite: constant Integer := 3;
        Adresse1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.0"));
        Adresse2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.0"));
        Adresse3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.0"));
        Masque1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        AdresseATrouver1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.1"));
        AdresseATrouver2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.1"));
        AdresseATrouver3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.1"));
        Eth1: constant Unbounded_String := To_Unbounded_String("Eth1");
        Eth2: constant Unbounded_String := To_Unbounded_String("Eth2");
        Eth3: constant Unbounded_String := To_Unbounded_String("Eth3");
        Eth: Unbounded_String;
        AdresseANePasTrouver: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.100.0.17"));
        Trouver: Boolean;
    begin
        Lca_Lfu.Initialiser(Cache, Capacite);
        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse1, Masque1, Eth1);
        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse2, Masque2, Eth2);
        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse3, Masque3, Eth3);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth);
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth1);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth);
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth2);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth);
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth3);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseANePasTrouver, Eth); -- On cherche AdresseANePasTrouver mais elle n'est pas trouvé
        pragma Assert(not Trouver);
        Lca_Lfu.Vider(Cache);
    end Test_Lfu_Ajouter_Verifier;

    procedure Test_Lfu_Remplacer is
        Cache: Lca_Lfu.T_Lfu;
        Capacite: constant Integer := 3;
        Adresse1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.0"));
        Adresse2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.0"));
        Adresse3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.0"));
        Adresse4: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.171.0.0"));
        Masque1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque4: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        AdresseATrouver1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.1"));
        AdresseATrouver2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.1"));
        AdresseATrouver3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.1"));
        AdresseATrouver4: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.171.0.1"));
        Eth1: constant Unbounded_String := To_Unbounded_String("Eth1");
        Eth2: constant Unbounded_String := To_Unbounded_String("Eth2");
        Eth3: constant Unbounded_String := To_Unbounded_String("Eth3");
        Eth4: constant Unbounded_String := To_Unbounded_String("Eth4");
        Eth: Unbounded_String;
        Trouver: Boolean;
    begin
        Lca_Lfu.Initialiser(Cache, Capacite);
        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse1, Masque1, Eth1);
        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse2, Masque2, Eth2);
        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse3, Masque3, Eth3);
        Afficher_Ajout(Adresse1, Masque1, Eth1);
        Afficher_Ajout(Adresse2, Masque2, Eth2);
        Afficher_Ajout(Adresse3, Masque3, Eth3); New_Line;

        Put("Cache"); New_Line;
        Lca_Lfu.Afficher(Cache); New_Line;

        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth); -- On cherche deux fois AdresseATrouver1
        Afficher_Verification(AdresseATrouver1, Eth);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth);
        Afficher_Verification(AdresseATrouver1, Eth);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth); -- On cherche une seul fois AdresseATrouver2
        Afficher_Verification(AdresseATrouver2, Eth);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth); -- On cherche deux fois AdresseATrouver3
        Afficher_Verification(AdresseATrouver3, Eth);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth);
        Afficher_Verification(AdresseATrouver3, Eth); New_Line;

        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse4, Masque4, Eth4); -- On ajoute Adresse4
        Afficher_Ajout(Adresse4, Masque4, Eth4); New_Line;

        Put("Cache"); New_Line;
        Lca_Lfu.Afficher(Cache); New_Line;

        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver4, Eth); -- On cherche AdresseATrouver4
        pragma Assert(Trouver);
        pragma Assert(Eth = Eth4);
        Afficher_Verification(AdresseATrouver4, Eth); New_Line;
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth); -- On cherche AdresseATrouver2 et on ne trouve 
        pragma Assert(not Trouver);                                    -- pas car elle n'a été cherché qu'une seul fois, donc remplacé par Adresse4
        Lca_Lfu.Vider(Cache);
    end Test_Lfu_Remplacer;

    procedure Test_Lfu_Stat is
        Cache: Lca_Lfu.T_Lfu;
        Capacite: constant Integer := 3;
        Adresse1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.0"));
        Adresse2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.0"));
        Adresse3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.0"));
        Masque1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        Masque3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("255.255.0.0"));
        AdresseATrouver1: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.168.0.1"));
        AdresseATrouver2: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.169.0.1"));
        AdresseATrouver3: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.170.0.1"));
        Eth1: constant Unbounded_String := To_Unbounded_String("Eth1");
        Eth2: constant Unbounded_String := To_Unbounded_String("Eth2");
        Eth3: constant Unbounded_String := To_Unbounded_String("Eth3");
        Eth: Unbounded_String;
        AdresseANePasTrouver: constant Table.T_Adresse_IP := Table.String_IP_Vers_T_Adresse_IP(To_Unbounded_String("192.100.0.17"));
        Trouver: Boolean;
        Demande: Integer;
        Defaut: Integer;
    begin
        Lca_Lfu.Initialiser(Cache, Capacite);
        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse1, Masque1, Eth1);
        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse2, Masque2, Eth2);
        Lca_Lfu.Ajouter_Dans_Cache(Cache, Adresse3, Masque3, Eth3);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver1, Eth);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver2, Eth);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseATrouver3, Eth);
        Lca_Lfu.Verifier_Cache(Cache, Trouver, AdresseANePasTrouver, Eth); -- On cherche AdresseANePasTrouver mais elle n'est pas trouvé
        Lca_Lfu.Recuperer_Stat(Cache, Demande, Defaut);
        pragma Assert(Demande = 4);
        pragma Assert(Defaut = 1);
        Lca_Lfu.Vider(Cache);
    end Test_Lfu_Stat;

begin

    Test_Fifo_Ajouter_Verifier;
    Put_Line ("Test_Fifo_Ajouter_Verifier OK");
    Test_Lru_Ajouter_Verifier;
    Put_Line ("Test_Lru_Ajouter_Verifier OK");
    Test_Lfu_Ajouter_Verifier;
    Put_Line ("Test_Lfu_Ajouter_Verifier OK");
    Test_Fifo_Stat;
    Put_Line ("Test_Fifo_Stat OK");
    Test_Lru_Stat;
    Put_Line ("Test_Lru_Stat OK");
    Test_Lfu_Stat;
    Put_Line ("Test_Lfu_Stat OK");
    Put_Line ("--- Test_Fifo_Remplacer ---");
    Test_Fifo_Remplacer;
    Put_Line ("Test_Fifo_Remplacer OK");
    Put_Line ("--- Test_Lru_Remplacer ---");
    Test_Lru_Remplacer;
    Put_Line ("Test_Lru_Remplacer OK");
    Put_Line ("--- Test_Lfu_Remplacer ---");
    Test_Lfu_Remplacer;
    Put_Line ("Test_Lfu_Remplacer OK");
end Cache_lca_test;
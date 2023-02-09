with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Lca_Lru is

    procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);

    procedure Initialiser(Lru: out T_Lru; Capacite: in Integer) is
    begin
        Lru.Lca := Null;
        Lru.Capacite := Capacite;
        Lru.Taille := 0;
        Lru.Compteur := 0;
        Lru.Stat.Demandes := 0;
        Lru.Stat.Defauts := 0;
    end Initialiser;

    procedure Afficher(Lru: in T_Lru) is
        Lca: T_LCA;
    begin
        Lca := Lru.Lca;
        while not (Lca = Null) loop
            Put(To_String(Table.T_Adresse_IP_Vers_String_IP(Lca.All.Ip)));
            Put(" "); 
            Put(To_String(Table.T_Adresse_IP_Vers_String_IP(Lca.All.Masque))); 
            Put(" "); 
            Put(To_String(Lca.All.Eth)); 
            New_Line;
            Lca := Lca.All.Suivant;
        end loop;
    end Afficher;

    procedure Afficher_Stat(Lru: in T_Lru) is
    begin
        Caches.Afficher_Stat(Lru.Stat);
    end Afficher_Stat;

    procedure Recuperer_Stat(Lru: in T_Lru; Demande: out Integer; Defaut: out Integer) is
    begin
        Demande := Lru.Stat.Demandes;
        Defaut := Lru.Stat.Defauts;
    end;

    procedure Verifier_Cache(Lru: in out T_Lru; Trouver: out Boolean; Adresse: in Table.T_Adresse_IP; Eth: out Unbounded_String) is
        Lca: T_LCA;
    begin
        Eth := To_Unbounded_String("");
        Trouver := False;
        Lca := Lru.Lca;
        while not Trouver and not (Lca = Null) loop -- On itère sur la lca
            if Table."=" ((Table."and" (Adresse, Lca.All.Masque)), Lca.All.Ip) then -- On vérifie si l'adresse correspond
                Trouver := True;
                Eth := Lca.All.Eth;
                Lca.All.Compteur := Lru.Compteur;
                Lru.Compteur := Lru.Compteur + 1;
            else
                Lca := Lca.All.Suivant;
            end if;
        end loop;
        Lru.Stat.Demandes := Lru.Stat.Demandes + 1;
        if not Trouver then
            Lru.Stat.Defauts :=  Lru.Stat.Defauts + 1;
        else
            null;
        end if;
    end Verifier_Cache;

    procedure Ajouter_Dans_Cache(Lru: in out T_Lru; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) is
    begin 
        if Lru.Taille < Lru.Capacite then -- Si le cache n'est pas plein, on ajoute dans le cache
            Lru.Lca := new T_Cellule'(Adresse, Masque, Eth, Lru.Compteur, Lru.Lca); -- On ajoute l'élément avec le compteur actuel
            Lru.Compteur := Lru.Compteur + 1; -- On incrémente le compteur de 1
            Lru.Taille := Lru.Taille + 1;
        else -- Sinon, on remplace avec un élément du cache
            Remplacer_Dans_Cache(Lru, Adresse, Masque, Eth);
        end if;
    end Ajouter_Dans_Cache;

    procedure Remplacer_Dans_Cache(Lru: in out T_Lru; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) is
        Lca: T_LCA;
        Min: Integer;
        AdresseRemplacer: Table.T_Adresse_IP;
        Trouver: Boolean;
    begin
        Lca := Lru.Lca;
        Min := Lca.All.Compteur;
        AdresseRemplacer := Lca.All.Ip;
        Lca := Lca.All.Suivant;
        while not (Lca = Null) loop-- On itère sur le cache et on cherche le moins recemment utilisé
            if Lca.All.Compteur < Min then
                Min := Lca.All.Compteur;
                AdresseRemplacer := Lca.All.Ip;
            else
                Null;
            end if;
            Lca := Lca.All.Suivant;
        end loop;
        Trouver := False;
        Lca := Lru.Lca;
        while not Trouver or not (Lca = Null) loop -- On cherche puis on remplace le moins recemment
            if Table."="(AdresseRemplacer, Lca.All.Ip) then -- utilisé avec l'élément à insérer
                Lca.All.Ip := Adresse;
                Lca.All.Masque := Masque;
                Lca.All.Eth := Eth;
                Lca.All.Compteur := Lru.Compteur; -- On lui attribue le compteur actuel
                Lru.Compteur := Lru.Compteur + 1; -- On incrémente le compteur de 1
                Trouver := True;
            else
                Lca := Lca.All.Suivant;
            end if;
        end loop;
    end Remplacer_Dans_Cache;

	procedure Vider (Lru : in out T_Lru) is
        Lca: T_LCA;
        LcaASuppr: T_LCA;
    begin
        Lca := Lru.Lca;
        while not (Lca = Null)  loop
            LcaASuppr := Lca;
            Lca := Lca.All.Suivant;
            Free(LcaASuppr);
        end loop;
	end Vider;

end Lca_Lru;
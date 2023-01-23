with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Lca_Lfu is

    procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);

    procedure Initialiser(Lfu: out T_Lfu; Capacite: in Integer) is
    begin
        Lfu.Lca := Null;
        Lfu.Capacite := Capacite;
        Lfu.Taille := 0;
        Lfu.Stat.Demandes := 0;
        Lfu.Stat.Defauts := 0;
    end Initialiser;

    procedure Afficher(Lfu: in T_Lfu) is
        Lca: T_LCA;
    begin
        Lca := Lfu.Lca;
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

    procedure Afficher_Stat(Lfu: in T_Lfu) is
    begin
        Caches.Afficher_Stat(Lfu.Stat);
    end Afficher_Stat;

    procedure Recuperer_Stat(Lfu: in T_Lfu; Demande: out Integer; Defaut: out Integer) is
    begin
        Demande := Lfu.Stat.Demandes;
        Defaut := Lfu.Stat.Defauts;
    end;

    procedure Verifier_Cache(Lfu: in out T_Lfu; Trouver: out Boolean; Adresse: in Table.T_Adresse_IP; Eth: out Unbounded_String) is
        Lca: T_LCA;
    begin
        Eth := To_Unbounded_String("");
        Trouver := False;
        Lca := Lfu.Lca;
        while not Trouver and not (Lca = Null) loop -- On itère sur la lca
            if Table."=" ((Table."and" (Adresse, Lca.All.Masque)), Lca.All.Ip) then -- On vérifie si l'adresse correspond
                Trouver := True;
                Eth := Lca.All.Eth;
                Lca.All.Frequence := Lca.All.Frequence + 1; -- On augmente la fréquence d'apparition de 1
            else
                Lca := Lca.Suivant;
            end if;
        end loop;
        Lfu.Stat.Demandes := Lfu.Stat.Demandes + 1;
        if not Trouver then
            Lfu.Stat.Defauts :=  Lfu.Stat.Defauts + 1;
        else
            null;
        end if;
    end Verifier_Cache;

    procedure Ajouter_Dans_Cache(Lfu: in out T_Lfu; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) is
    begin 
        if Lfu.Taille < Lfu.Capacite then -- Si le cache n'est pas plein, on ajoute dans le cache
            Lfu.Lca := new T_Cellule'(Adresse, Masque, Eth, 0, Lfu.Lca);
            Lfu.Taille := Lfu.Taille + 1;
        else -- Sinon, on remplace avec un élément du cache
            Remplacer_Dans_Cache(Lfu, Adresse, Masque, Eth);
        end if;
    end Ajouter_Dans_Cache;

    procedure Remplacer_Dans_Cache(Lfu: in out T_Lfu; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) is
        Lca: T_LCA;
        Min: Integer;
        AdresseRemplacer: Table.T_Adresse_IP;
        Trouver: Boolean;
    begin
        Lca := Lfu.Lca;
        Min := Lca.All.Frequence;
        AdresseRemplacer := Lca.All.Ip;
        Lca := Lca.All.Suivant;
        while not (Lca = Null) loop -- On itère sur le cache et on cherche le moins frequemment utilisé
            if Lca.All.Frequence < Min then
                Min := Lca.All.Frequence;
                AdresseRemplacer := Lca.All.Ip;
            else
                Null;
            end if;
            Lca := Lca.All.Suivant;
        end loop;
        Trouver := False;
        Lca := Lfu.Lca;
        while not Trouver or not (Lca = Null) loop -- On cherche puis on remplace le moins frequemment 
            if Table."="(AdresseRemplacer, Lca.All.Ip) then -- utilisé avec l'élément à insérer
                Lca.All.Ip := Adresse;
                Lca.All.Masque := Masque;
                Lca.All.Eth := Eth;
                Lca.All.Frequence := 0;
                Trouver := True;
            else
                Lca := Lca.All.Suivant;
            end if;
        end loop;
    end Remplacer_Dans_Cache;

    procedure Vider (Lfu : in out T_Lfu) is
        Lca: T_LCA;
        LcaASuppr: T_LCA;
    begin
        Lca := Lfu.Lca;
        while not (Lca = Null)  loop
            LcaASuppr := Lca;
            Lca := Lca.All.Suivant;
            Free(LcaASuppr);
        end loop;
	end Vider;

end Lca_Lfu;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Lca_Fifo is

    procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);

    procedure Initialiser(Fifo: out T_Fifo; Capacite: in Integer) is
    begin
        Fifo.Lca := Null;
        Fifo.Capacite := Capacite;
        Fifo.Taille := 0;
        Fifo.Stat.Demandes := 0;
        Fifo.Stat.Defauts := 0;
    end Initialiser;

    procedure Afficher(Fifo: in T_Fifo) is
        Lca: T_LCA;
    begin
        Lca := Fifo.Lca;
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

    procedure Afficher_Stat(Fifo: in T_Fifo) is
    begin
        Caches.Afficher_Stat(Fifo.Stat);
    end Afficher_Stat;

    procedure Recuperer_Stat(Fifo: in T_Fifo; Demande: out Integer; Defaut: out Integer) is
    begin
        Demande := Fifo.Stat.Demandes;
        Defaut := Fifo.Stat.Defauts;
    end;

    procedure Verifier_Cache(Fifo: in out T_Fifo; Trouver: out Boolean; Adresse: in Table.T_Adresse_IP; Eth: out Unbounded_String) is
        Lca: T_LCA;
    begin
        Eth := To_Unbounded_String("");
        Trouver := False;
        Lca := Fifo.Lca;
        while not Trouver and not (Lca = Null) loop -- On itère sur la lca
            if Table."=" ((Table."and" (Adresse, Lca.All.Masque)), Lca.All.Ip) then -- On vérifie si l'adresse correspond
                Trouver := True;
                Eth := Lca.All.Eth;
            else
                Lca := Lca.All.Suivant;
            end if;
        end loop;
        Fifo.Stat.Demandes := Fifo.Stat.Demandes + 1;
        if not Trouver then
            Fifo.Stat.Defauts :=  Fifo.Stat.Defauts + 1;
        else
            null;
        end if;
    end Verifier_Cache;

    procedure Ajouter_Dans_Cache(Fifo: in out T_Fifo; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) is
    begin 
        if Fifo.Taille < Fifo.Capacite then -- Si le cache n'est pas plein, on ajoute dans le cache
            Fifo.Lca := new T_Cellule'(Adresse, Masque, Eth, Fifo.Lca);
            Fifo.Taille := Fifo.Taille + 1;
        else -- Sinon, on remplace avec un élément du cache
            Remplacer_Dans_Cache(Fifo, Adresse, Masque, Eth);
        end if;
    end Ajouter_Dans_Cache;

    procedure Remplacer_Dans_Cache(Fifo: in out T_Fifo; Adresse: in Table.T_Adresse_IP; Masque: in Table.T_Adresse_IP; Eth: in Unbounded_String) is
        Lca: T_LCA;
        LcaASuppr: T_LCA;
        Last: T_LCA;
    begin
        Lca := Fifo.Lca;
        Fifo.Lca := new T_Cellule'(Adresse, Masque, Eth, Fifo.Lca); -- On ajoute l'élément au début de la lca
        if Fifo.Capacite > 2 then -- Si la capacité est supérieure à 2, on supprime le dernier élément
            while not (Lca.All.Suivant.All.Suivant = Null) loop
                Lca := Lca.All.Suivant;
            end loop;
            Last := Lca.All.Suivant;
            Lca.All.Suivant := Null;
            Free(Last);
        elsif Fifo.Capacite = 2 then -- Si la capacité est de 2, on enlève le troisième élément
            LcaASuppr := Lca.All.Suivant;
            Lca.All.Suivant := Null;
            Free(LcaASuppr);
        else -- Si la capacité est de 1, on enlève le deuxième élément
            Fifo.Lca.all.Suivant := Null;
            Free(Lca);
        end if;
    end Remplacer_Dans_Cache;

	procedure Vider (Fifo : in out T_Fifo) is
        Lca: T_LCA;
        LcaASuppr: T_LCA;
    begin
        Lca := Fifo.Lca;
        while not (Lca = Null)  loop
            LcaASuppr := Lca;
            Lca := Lca.All.Suivant;
            Free(LcaASuppr);
        end loop;
	end Vider;

end Lca_Fifo;
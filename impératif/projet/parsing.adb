with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Exceptions;               use Exceptions;

package body Parsing is

    procedure Analyse_fichier_table (T : in out T_LCA; File : in Unbounded_String) is
        F      : File_Type;
        Line   : Unbounded_String;
        Adress : Unbounded_String;
        Mask   : Unbounded_String;
        Eth    : Unbounded_String;
        N      : Integer;
    begin
        N := 0;
        Open (F, In_File, To_String (File));
        while not End_Of_File (F) loop
            Line   := Get_Line (F);
            Mask   := To_Unbounded_String ("");
            Adress := To_Unbounded_String ("");
            Eth    := To_Unbounded_String ("");
            Analyse_ligne (Trim (Line, Ada.Strings.Both), Adress, Mask, Eth);
            Enregistrer
               (T, N, Table.String_IP_Vers_T_Adresse_IP (Adress),
                Table.String_IP_Vers_T_Adresse_IP (Mask), Eth);
            N := N + 1;
        end loop;
        Close (F);
    exception
        when Table_Fichier_Incorrect_Exception =>
            Close (F);
            raise Table_Fichier_Incorrect_Exception;
    end Analyse_fichier_table;

    procedure Analyse_ligne
       (Line : in     Unbounded_String; Adress : in out Unbounded_String;
        Mask : in out Unbounded_String; Eth : in out Unbounded_String)
    is
        I    : Integer;
        Size : Integer;
    begin
        I    := 1;
        Size := 0;
        while Element (Line, I) /= ' ' loop -- Récupération de l'adresse
            Append (Adress, Element (Line, I));
            I    := I + 1;
            Size := Size + 1;
            if I = Length (Line) then
                raise Table_Fichier_Incorrect_Exception with "Table incorrect";
            end if;
        end loop;
        if Size <= 6 or Size >= 16 then
            raise Table_Fichier_Incorrect_Exception with "Adresse IP invalide";
        end if;

        I    := I + 1;
        Size := 0;
        while Element (Line, I) /= ' ' loop -- Récupération du masque
            Append (Mask, Element (Line, I));
            I    := I + 1;
            Size := Size + 1;
            if I = Length (Line) then
                raise Table_Fichier_Incorrect_Exception with "Table incorrect";
            end if;
        end loop;
        if Size <= 6 or Size >= 16 then
            raise Table_Fichier_Incorrect_Exception with "Adresse IP invalide";
        end if;

        I    := I + 1;
        Size := 0;
        while I <= Length (Line) loop -- -- Récupération de l'interface
            Append (Eth, Element (Line, I));
            I    := I + 1;
            Size := Size + 1;
        end loop;
    end Analyse_ligne;

    procedure Analyse_Ligne_de_commande
       (args : in     arguments; taille_cache : out Natural; politique_cache : out Unbounded_String;
        afficher_stats    :    out Boolean; cacher_stats : out Boolean;
        fichier_table     :    out Unbounded_String; fichier_paquets : out Unbounded_String;
        fichier_resultats :    out Unbounded_String; erronee : out Boolean)
    is
        analyse_de_taille    : Boolean := False;
        analyse_de_politique : Boolean := False;
        analyse_de_table     : Boolean := False;
        analyse_de_paquets   : Boolean := False;
        analyse_de_resultats : Boolean := False;
    begin
        -- Valeurs par défaut
        fichier_table     := To_Unbounded_String ("table.txt");
        fichier_resultats := To_Unbounded_String ("resultats.txt");
        fichier_paquets   := To_Unbounded_String ("paquets.txt");
        politique_cache   := To_Unbounded_String ("FIFO");
        taille_cache      := 10;
        afficher_stats    := True;
        cacher_stats      := False;
        erronee           := False;

        for i in args'Range loop
            if args (i) = "" then
                -- ignorer les arguments vides
                null;
            elsif args (i) = "-c" then
                analyse_de_taille    := True;
                analyse_de_politique := False;
                analyse_de_table     := False;
                analyse_de_paquets   := False;
                analyse_de_resultats := False;
            elsif args (i) = "-s" then
                analyse_de_taille    := False;
                analyse_de_politique := False;
                analyse_de_table     := False;
                analyse_de_paquets   := False;
                analyse_de_resultats := False;
                afficher_stats       := True;
                cacher_stats         := False;
            elsif args (i) = "-S" then
                analyse_de_taille    := False;
                analyse_de_politique := False;
                analyse_de_table     := False;
                analyse_de_paquets   := False;
                analyse_de_resultats := False;
                cacher_stats         := True;
                afficher_stats       := False;
            elsif args (i) = "-P" then
                analyse_de_taille    := False;
                analyse_de_politique := True;
                analyse_de_table     := False;
                analyse_de_paquets   := False;
                analyse_de_resultats := False;
            elsif args (i) = "-t" then
                analyse_de_taille    := False;
                analyse_de_politique := False;
                analyse_de_table     := True;
                analyse_de_paquets   := False;
                analyse_de_resultats := False;
            elsif args (i) = "-p" then
                analyse_de_taille    := False;
                analyse_de_politique := False;
                analyse_de_table     := False;
                analyse_de_paquets   := True;
                analyse_de_resultats := False;
            elsif args (i) = "-r" then
                analyse_de_taille    := False;
                analyse_de_politique := False;
                analyse_de_table     := False;
                analyse_de_paquets   := False;
                analyse_de_resultats := True;
            else
                if analyse_de_taille then
                    taille_cache := Integer'Value (To_String (args (i)));
                elsif analyse_de_politique then
                    politique_cache := args (i);
                elsif analyse_de_table then
                    fichier_table := args (i);
                elsif analyse_de_paquets then
                    fichier_paquets := args (i);
                elsif analyse_de_resultats then
                    fichier_resultats := args (i);
                else
                    if args (i) /= "-h" and args (i) /= "--help" then
                        Put_Line ("Argument inconnu: " & args (i));
                    end if;
                    erronee := True;
                    return;
                end if;
            end if;
        end loop;

    end Analyse_Ligne_de_commande;

end Parsing;

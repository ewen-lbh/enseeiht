with Ada.Text_IO;              use Ada.Text_IO;
with Table;                    use Table;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
package body RouteurSimple is

    function Trouver_interface
       (T                              : in T_LCA; IP : in Table.T_Adresse_IP;
        meilleur_masque : in Table.T_Adresse_IP := Table.T_Adresse_IP (0);
        interface_avec_meilleur_masque :    Unbounded_String   :=
           To_Unbounded_String (""))
        return Unbounded_String
    is
        masque_courant     : Table.T_Adresse_IP;
        ip_courante        : Table.T_Adresse_IP;
        interface_courante : Unbounded_String;
    begin
        if Est_Vide (T) then
            return interface_avec_meilleur_masque;
        else
            interface_courante := L_interface (T);
            masque_courant     := Le_Masque (T);
            ip_courante        := L_ip (T);
            if Table."=" ((Table."and" (IP, masque_courant)), ip_courante) and
               Table.">=" (masque_courant, meilleur_masque)
            then
                return
                   Trouver_interface
                      (Le_suivant (T), IP, masque_courant, interface_courante);
            else
                return
                   Trouver_interface
                      (Le_suivant (T), IP, meilleur_masque,
                       interface_avec_meilleur_masque);
            end if;
        end if;
    end Trouver_interface;

    procedure Commande_Table (T : in T_LCA) is
    begin
        Table.Afficher (T);
    end Commande_Table;

    procedure Analyse_fichier_paquets
       (T                 : in T_LCA; Fichier_paquets : Unbounded_String;
        Fichier_Resultats :    Unbounded_String)
    is
        paquets_descripteur   : File_Type;
        resultats_descripteur : File_Type;
        Ligne_courante        : Unbounded_String;
        addr                  : Table.T_Adresse_IP;
        eth                   : Unbounded_String;
        numero_ligne          : Integer := 1;
    begin
        Open (paquets_descripteur, In_File, To_String (Fichier_paquets));
        if not Fichier_existe (Fichier_Resultats) then
            Create
               (resultats_descripteur, Name => To_String (Fichier_Resultats));
            Close (resultats_descripteur);
        end if;
        Open (resultats_descripteur, Out_File, To_String (Fichier_Resultats));
        while not End_Of_File (paquets_descripteur) loop
            Ligne_courante := Unbounded_IO.Get_Line (paquets_descripteur);
            --  Ada.Strings.Unbounded.Trim (Current_Line);

            if Ligne_courante = "table" then
                Ada.Text_IO.Put_Line
                   ("table (ligne " & Integer'Image (numero_ligne) & ")");
                Commande_Table (T);
            elsif Ligne_courante = "fin" or Ligne_courante = "cache" or
               Ligne_courante = "stat"
            then
                Ada.Text_IO.Put_Line
                   (To_String (Ligne_courante) & " (ligne " &
                    Integer'Image (numero_ligne) & ")");
                Close (resultats_descripteur);
                Close (paquets_descripteur);
                return;
            else
                addr := Table.String_IP_Vers_T_Adresse_IP (Ligne_courante);
                eth  := Trouver_interface (T, addr);
                Put_Line
                   (resultats_descripteur,
                    Table.T_Adresse_IP_Vers_String_IP (addr) & " " &
                    To_String (eth));
            end if;
            numero_ligne := numero_ligne + 1;
        end loop;
        Close (resultats_descripteur);
        Close (paquets_descripteur);
    end Analyse_fichier_paquets;

end RouteurSimple;

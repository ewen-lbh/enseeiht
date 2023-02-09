with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Fixed;   use Ada.Strings.Fixed;

package body Table is

    procedure Afficher_ligne_table
       (Cle : Integer; Ip : Table.T_Adresse_IP; Masque : Table.T_Adresse_IP;
        Eth : Unbounded_String)
    is
    begin
        Put (To_String (T_Adresse_IP_Vers_String_IP (Ip)));
        Put (" ");
        Put (To_String (T_Adresse_IP_Vers_String_IP (Masque)));
        Put (" ");
        Put (To_String (Eth));
        New_Line;
    end Afficher_ligne_table;

    function String_IP_Vers_T_Adresse_IP
       (S_ip : Unbounded_String) return T_Adresse_IP
    is
        BYTE   : constant T_Adresse_IP := 2**8;
        BYTE_S : Unbounded_String;
        IP     : T_Adresse_IP;
        J      : Integer;
    begin
        J      := 3;
        IP     := 0;
        BYTE_S := To_Unbounded_String ("");
        for I in 1 .. Length (S_ip) loop -- On itère sur l'adresse IP
            if Element (S_ip, I) /= '.' then
                Append (BYTE_S, Element (S_ip, I));
            else
                IP     :=
                   IP +
                   T_Adresse_IP (Integer'Value (To_String (BYTE_S))) *
                      (BYTE**J);
                BYTE_S := To_Unbounded_String ("");
                J      := J - 1;
            end if;
        end loop;
        IP :=
           IP + T_Adresse_IP (Integer'Value (To_String (BYTE_S))) * (BYTE**J);
        return IP;
    end String_IP_Vers_T_Adresse_IP;

    procedure Afficher_IP (IP : in T_Adresse_IP) is
    begin
        Put ("IP = ");
        Put (Natural ((IP / OCTET**3) mod OCTET), 1);
        Put ("."); -- 1er octet
        Put (Natural ((IP / OCTET**2) mod OCTET), 1);
        Put ("."); -- 2eme octet
        Put (Natural ((IP / OCTET**1) mod OCTET), 1);
        Put ("."); -- 3eme octet
        Put (Natural (IP mod OCTET), 1); -- 4eme octet
    end Afficher_IP;

    function T_Adresse_IP_Vers_String_IP
       (Ip : in T_Adresse_IP) return Unbounded_String
    is
        S_IP : Unbounded_String;
    begin
        S_IP := To_Unbounded_String ("");
        Append
           (S_IP,
            Trim
               (Integer'Image (Natural ((Ip / OCTET**3) mod OCTET)),
                Ada.Strings.Both)); -- 1er octet
        Append (S_IP, ".");
        Append
           (S_IP,
            Trim
               (Integer'Image (Natural ((Ip / OCTET**2) mod OCTET)),
                Ada.Strings.Both)); -- 2eme octet
        Append (S_IP, '.');
        Append
           (S_IP,
            Trim
               (Integer'Image (Natural ((Ip / OCTET**1) mod OCTET)),
                Ada.Strings.Both)); -- 3eme octet
        Append (S_IP, '.');
        Append
           (S_IP,
            Trim
               (Integer'Image (Natural (Ip mod OCTET)),
                Ada.Strings.Both)); -- 4eme octet
        return S_IP;
    end T_Adresse_IP_Vers_String_IP;

    function Fichier_existe (Chemin : Unbounded_String) return Boolean is
        Fichier : Ada.Text_IO.File_Type;
    begin
        Open (Fichier, In_File, To_String (Chemin));
        Close (Fichier);
        return True;
    exception
        when Name_Error =>
            return False;
    end Fichier_existe;

end Table;

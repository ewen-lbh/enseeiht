with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with LCA;

package Table is

    -- Type d'une IP
    type T_Adresse_IP is mod 2**32;

    package Table_LCA is new LCA
       (T_Cle => Integer, T_Ip => T_Adresse_IP, T_Masque => T_Adresse_IP,
        T_Eth => Unbounded_String);

    -- Afficher une ligne dans la table de routage
    procedure Afficher_ligne_table
       (Cle : Integer; Ip : Table.T_Adresse_IP; Masque : Table.T_Adresse_IP;
        Eth : Unbounded_String);

    procedure Afficher is new Table_LCA.Pour_Chaque (Afficher_ligne_table);

    -- Récupère une T_Adresse_IP à partir d'un String
    function String_IP_Vers_T_Adresse_IP
       (S_ip : Unbounded_String) return T_Adresse_IP; 

    -- Affiche une T_Adresse_IP
    procedure Afficher_IP (IP : in T_Adresse_IP);

    -- Récupère une String à partir d'un T_Adresse_IP
    function T_Adresse_IP_Vers_String_IP
       (Ip : in T_Adresse_IP) return Unbounded_String with
       Post =>
        Length (T_Adresse_IP_Vers_String_IP'Result) >= 7 and
        Length (T_Adresse_IP_Vers_String_IP'Result) <= 15;

    -- Représentation d'un octet
    OCTET : constant T_Adresse_IP := 2**8;

    -- Représentation du bit de poids fort
    Poids_Fort : constant T_Adresse_IP := 2**31;

    -- Teste si un fichier existe
    function Fichier_existe (Chemin : in Unbounded_String) return Boolean;
end Table;

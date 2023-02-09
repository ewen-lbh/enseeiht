with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Table;                 use Table.Table_LCA;
with Ada.Text_IO;           use Ada.Text_IO;
with RouteurSimple;         use RouteurSimple;

procedure routeur_simple_test is
    procedure assert_equal (a, b : String) is
    begin
        Put_Line ("Expected: " & a);
        Put_Line ("Actual:   " & b);
        pragma Assert (a = b);
    end assert_equal;

    T    : T_LCA;
    eth0 : constant Unbounded_String := To_Unbounded_String ("eth0");
    eth1 : constant Unbounded_String := To_Unbounded_String ("eth1");
    eth2 : constant Unbounded_String := To_Unbounded_String ("eth2");
    eth3 : constant Unbounded_String := To_Unbounded_String ("eth3");

begin

   --147.127.16.0 255.255.240.0 eth0
   --147.127.18.0 255.255.255.0 eth1
   --147.127.0.0 255.255.255.0 eth2
   --212.0.0.0 255.0.0.0 eth3
   --0.0.0.0 0.0.0.0 eth0

   Initialiser (T);

    --creation d'une fausse table de routage

    Enregistrer
       (T, 1,
        Table.String_IP_Vers_T_Adresse_IP
           (To_Unbounded_String ("147.127.16.0")),
        Table.String_IP_Vers_T_Adresse_IP
           (To_Unbounded_String ("255.255.240.0")),
        eth0);
    Enregistrer
       (T, 2,
        Table.String_IP_Vers_T_Adresse_IP
           (To_Unbounded_String ("147.127.18.0")),
        Table.String_IP_Vers_T_Adresse_IP
           (To_Unbounded_String ("255.255.255.0")),
        eth1);
    Enregistrer
       (T, 3,
        Table.String_IP_Vers_T_Adresse_IP
           (To_Unbounded_String ("147.127.0.0")),
        Table.String_IP_Vers_T_Adresse_IP
           (To_Unbounded_String ("255.255.255.0")),
        eth2);
    Enregistrer
       (T, 4,
        Table.String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("212.0.0.0")),
        Table.String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("255.0.0.0")),
        eth3);

    assert_equal
       ("",
        To_String
           (Trouver_interface
               (T,
                Table.String_IP_Vers_T_Adresse_IP
                   (To_Unbounded_String ("200.45.36.12")))));

    Put_Line ("Le test passe pour une adresse 'non-routable'");

    Enregistrer
       (T, 5,
        Table.String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
        Table.String_IP_Vers_T_Adresse_IP (To_Unbounded_String ("0.0.0.0")),
        eth0);

    assert_equal
       (To_String (eth3),
        To_String
           (Trouver_interface
               (T,
                Table.String_IP_Vers_T_Adresse_IP
                   (To_Unbounded_String ("212.212.212.212")))));
    assert_equal
       (To_String (eth1),
        To_String
           (Trouver_interface
               (T,
                Table.String_IP_Vers_T_Adresse_IP
                   (To_Unbounded_String ("147.127.18.80")))));
    assert_equal
       (To_String (eth1),
        To_String
           (Trouver_interface
               (T,
                Table.String_IP_Vers_T_Adresse_IP
                   (To_Unbounded_String ("147.127.18.85")))));
    assert_equal
       (To_String (eth0),
        To_String
           (Trouver_interface
               (T,
                Table.String_IP_Vers_T_Adresse_IP
                   (To_Unbounded_String ("147.127.19.1")))));
    assert_equal
       (To_String (eth0),
        To_String
           (Trouver_interface
               (T,
                Table.String_IP_Vers_T_Adresse_IP
                   (To_Unbounded_String ("147.127.20.20")))));
    assert_equal
       (To_String (eth0),
        To_String
           (Trouver_interface
               (T,
                Table.String_IP_Vers_T_Adresse_IP
                   (To_Unbounded_String ("147.127.32.32")))));

    Put_Line ("Tous les tests classiques passent");

   Vider (T);

end routeur_simple_test;

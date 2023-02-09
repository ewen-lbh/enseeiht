with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Table;                 use Table;
with Ada.Text_IO;           use Ada.Text_IO;

procedure table_test is
    procedure assertion_egal (a, b : String) is
    begin
        Put_Line ("Expected: " & a);
        Put_Line ("Actual:   " & b);
        pragma Assert (a = b);
    end assertion_egal;

    procedure test_conversion_involutive (s : String) is
    begin
        assertion_egal
           (s,
            To_String
               (T_Adresse_IP_Vers_String_IP
                   (String_IP_Vers_T_Adresse_IP (To_Unbounded_String (s)))));
    end test_conversion_involutive;

begin
    test_conversion_involutive ("192.168.0.1");
    test_conversion_involutive ("192.0.0.4");
    test_conversion_involutive ("184.0.5.56");
    test_conversion_involutive ("187.253.0.1");
end table_test;

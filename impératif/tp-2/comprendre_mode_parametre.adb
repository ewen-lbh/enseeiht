with Ada.Text_IO;
use Ada.Text_IO;

-- Dans ce programme, les commentaires de spécification
-- ont **volontairement** été omis !

procedure Comprendre_Mode_Parametre is

    function Double (N : in Integer) return Integer is
    begin
        return 2 * N;
    end Double;

    procedure Incrementer (N : in out Integer) is
    begin
        N := N + 1;
    end Incrementer;

    procedure Mettre_A_Zero (N : out Integer) is
    begin
        N := 0;
    end Mettre_A_Zero;

    procedure Comprendre_Les_Contraintes_Sur_L_Appelant is
        A, B, R : Integer;
    begin
        A := 5;
        -- Indiquer pour chacune des instructions suivantes si elles sont
        -- acceptées par le compilateur.
        R := Double (A); -- Oui
        R := Double (10); -- Oui
        R := Double (10 * A); -- Oui
        R := Double (B); -- Non

        Incrementer (A); -- Oui
        Incrementer (10); -- Non
        Incrementer (10 * A); -- Non
        Incrementer (B); -- Non

        Mettre_A_Zero (A); -- Oui
        Mettre_A_Zero (10); -- Non
        Mettre_A_Zero (10 * A); -- Non
        Mettre_A_Zero (B); -- Oui
    end Comprendre_Les_Contraintes_Sur_L_Appelant;


    procedure Comprendre_Les_Contrainte_Dans_Le_Corps (
            A      : in Integer;
            B1, B2 : in out Integer;
            C1, C2 : out Integer)
    is
        L: Integer;
    begin
        -- pour chaque affectation suivante indiquer si elle est autorisée
        L := A; -- Oui
        A := 1; -- Non

        B1 := 5; -- Oui

        L := B2; -- Oui
        B2 := B2 + 1; -- Oui

        C1 := L; -- Oui

        L := C2; -- Non

        C2 := A; -- Oui
        C2 := C2 + 1; -- Non
    end Comprendre_Les_Contrainte_Dans_Le_Corps;


begin
    Comprendre_Les_Contraintes_Sur_L_Appelant;
    Put_Line ("Fin");
end Comprendre_Mode_Parametre;

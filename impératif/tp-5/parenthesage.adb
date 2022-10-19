with Ada.Text_IO; use Ada.Text_IO;
with Piles;

procedure Parenthesage is

    package PileCaracteres is new Piles
       (Capacite => 99, T_Element => Character);
    package PileEntiers is new Piles (Capacite => 99, T_Element => Integer);

    -- L'indice dans la chaîne Meule de l'élément Aiguille.
    -- Si l'Aiguille n'est pas dans la Meule, on retourne Meule'Last + 1.
    function Index
       (Meule : in String; Aiguille : Character) return Integer with
       Post =>
        Meule'First <= Index'Result and then Index'Result <= Meule'Last + 1
        and then
        (Index'Result > Meule'Last or else Meule (Index'Result) = Aiguille)
    is
    begin
        for index in Meule'First .. Meule'Last loop
            if Meule (index) = Aiguille then
                return index;
            end if;
        end loop;
        return Meule'Last + 1;
    end Index;

    -- Programme de test de Index.
    procedure Tester_Index is
        ABCDEF : constant String := "abcdef";
    begin
        pragma Assert (1 = Index (ABCDEF, 'a'));
        pragma Assert (3 = Index (ABCDEF, 'c'));
        pragma Assert (6 = Index (ABCDEF, 'f'));
        pragma Assert (7 = Index (ABCDEF, 'z'));
        pragma Assert (4 = Index (ABCDEF (1 .. 3), 'z'));
        pragma Assert (3 = Index (ABCDEF (3 .. 5), 'c'));
        pragma Assert (5 = Index (ABCDEF (3 .. 5), 'e'));
        pragma Assert (6 = Index (ABCDEF (3 .. 5), 'a'));
        pragma Assert (6 = Index (ABCDEF (3 .. 5), 'g'));
    end Tester_Index;

    -- Vérifier les bon parenthésage d'une Chaîne (D).  Le sous-programme
    -- indique si le parenthésage est bon ou non (Correct : R) et dans le cas
    -- où il n'est pas correct, l'indice (Indice_Erreur : R) du symbole qui
    -- n'est pas appairé (symbole ouvrant ou fermant).
    --
    -- Exemples
    --   "[({})]"  -> Correct
    --   "]"       -> Non Correct et Indice_Erreur = 1
    --   "((()"    -> Non Correct et Indice_Erreur = 2
    --
    procedure Verifier_Parenthesage
       (Chaine : in String; Correct : out Boolean; Indice_Erreur : out Integer)
    is
        Ouvrants      : constant String := "([{";
        Fermants      : constant String := ")]}";
        Pile_Ouvrants : PileCaracteres.T_Pile;
        Pile_Indices  : PileEntiers.T_Pile;
        c             : Character;
    begin
        Correct := True;
        PileCaracteres.Initialiser (Pile_Ouvrants);
        PileEntiers.Initialiser (Pile_Indices);
        for i in Chaine'First .. Chaine'Last loop
            c := Chaine (i);
            -- si le caractère est une parenthèse ouvrante
            if Index (Ouvrants, c) <= Ouvrants'Last then
                PileCaracteres.Empiler (Pile_Ouvrants, c);
                PileEntiers.Empiler (Pile_Indices, i);
            -- si le caractère est une parenthèse fermante
            elsif Index (Fermants, c) <= Fermants'Last then
                -- si on ne peut pas dépiler (soit parce qu'il n'y a rien avant, soit parce que le sommet de la pile n'est pas du type de parenthèse correspondant (on ne ferme pas un '[' avec un ')', par ex.))
                if PileCaracteres.Est_Vide (Pile_Ouvrants)
                   or else
                      Index
                         (Ouvrants, PileCaracteres.Sommet (Pile_Ouvrants)) /=
                      Index (Fermants, c)
                then
                    -- on mets correct à false dès maintenant, on calcule l'indice de l'erreur et on sort de la boucle
                    Correct       := False;
                    Indice_Erreur := i;
                    exit;
                else
                    PileCaracteres.Depiler (Pile_Ouvrants);
                    PileEntiers.Depiler (Pile_Indices);
                end if;
            end if;
        end loop;
        -- quand correct est faux, c'est que l'on est sorti prématurément de la boucle, et les valeurs de Correct et Indice_Erreur ont déjà été calculés
        if Correct then
            Correct := PileCaracteres.Est_Vide (Pile_Ouvrants);
            if not Correct then
                Indice_Erreur := PileEntiers.Sommet (Pile_Indices);
            end if;
        end if;
    end Verifier_Parenthesage;

    -- Programme de test de Verifier_Parenthesage
    procedure Tester_Verifier_Parenthesage is
        Exemple1 : constant String (1 .. 2)   := "{}";
        Exemple2 : constant String (11 .. 18) := "]{[(X)]}";

        Indice  : Integer;   -- Résultat de ... XXX
        Correct : Boolean;
    begin
        Verifier_Parenthesage ("(a < b)", Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage ("([{a}])", Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage ("(][{a}])", Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 2);

        Verifier_Parenthesage ("]([{a}])", Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 1);

        Verifier_Parenthesage ("([{}])}", Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 7);

        Verifier_Parenthesage ("([{", Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 3);

        Verifier_Parenthesage ("([{}]", Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 1);

        Verifier_Parenthesage ("", Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage (Exemple1, Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage (Exemple2, Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 11);

        Verifier_Parenthesage (Exemple2 (12 .. 18), Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage (Exemple2 (12 .. 15), Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 14);
    end Tester_Verifier_Parenthesage;

begin
    Tester_Index;
    Tester_Verifier_Parenthesage;
end Parenthesage;

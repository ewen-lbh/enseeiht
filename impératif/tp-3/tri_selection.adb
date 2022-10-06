--
--  Les TODO dans le texte vous indique les parties de ce programme à completer.
--  Les autres parties ne doivent pas être modifiees.
--
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

-- Objectif : Afficher un tableau trie suivant le principe du tri par selection.

procedure Tri_Selection is

    Capacite : constant Integer := 10;   -- Cette taille est arbitraire

    type T_TableauElements is array (1 .. Capacite) of Integer;

    type T_Tableau is record
        Elements : T_TableauElements;
        Taille   : Integer;
        -- Invariant: 0 <= Taille and Taille <= Capacite;
    end record;

    -- Objectif : Afficher le tableau.
    --    Les elements sont affiches entre crochets, separes par des virgules.
    -- Paramètres :
    --    Tab : le tableau à afficher.
    procedure Ecrire (Tab : in T_Tableau) is
    begin
        Put ('[');
        if Tab.Taille > 0 then
            -- ecrire le premier element
            Put (Tab.Elements (1), 1);

            -- ecrire les autres elements precedes d'une virgule
            for I in 2 .. Tab.Taille loop
                Put (", ");
                Put (Tab.Elements (I), 1);
            end loop;
        else
            null;
        end if;
        Put (']');
    end Ecrire;

    -- TODO : specifier et implanter un sous-programme qui trie un tableau
    -- suivant l'algorithme du tri pas selection.

    -- Objectif : Indiquer si deux tableaux son egaux.
    -- Paramètres :
    --     Tab1, Tab2 : les deux tableaux à comparer
    -- Resultat
    --     Vrai si et seulement si Tab1 et Tab2 sont egaux.
    --
    -- Remarque : Ici on redefinit l'operateur "=" dejà present en Ada qui par
    -- defaut compara les tailles et tous les elements de Elements.
    function "=" (Tab1, Tab2 : in T_Tableau) return Boolean is
        Resultat : Boolean;
        Indice   : Integer;
    begin
        if Tab1.Taille /= Tab2.Taille then
            Resultat := False;
        else
            Indice := 1;
            while Indice <= Tab1.Taille
               and then Tab1.Elements (Indice) = Tab2.Elements (Indice)
            loop
                Indice := Indice + 1;
            end loop;
            Resultat := Indice > Tab1.Taille;
        end if;
        return Resultat;
    end "=";

    function Position_Minimum_Dans
       (Tab : in T_Tableau; debut : in Integer) return Integer
    is
        position_minimum : Integer;
    begin
        position_minimum := debut;
        for i in (debut + 1) .. Tab.Taille loop
            if Tab.Elements (i) < Tab.Elements (position_minimum) then
                position_minimum := i;
            end if;
        end loop;
        return position_minimum;
    end Position_Minimum_Dans;

    -- Objectif: Trier un tableau d'entiers
    -- Paramètres:
    --      Tab : le tableau à trier
    -- Resultat:
    --      Rien
    -- Effets de bord:
    --      Tab est trie
    procedure Trier (Tab : in out T_Tableau) is
        switch_buffer : Integer;
        index_minimum : Integer;
    begin
        -- le curseur correspond à la position qui separe la partie dejà triee de celle à trier
        for cursor in 1 .. Tab.Taille loop
            index_minimum := Position_Minimum_Dans (Tab, cursor);
            switch_buffer                := Tab.Elements (index_minimum);
            Tab.Elements (index_minimum) := Tab.Elements (cursor);
            Tab.Elements (cursor)        := switch_buffer;
        end loop;
    end Trier;

    -- Programme de test de la procedure Trier.
    procedure Tester_Trier is

        procedure Tester (Tab, Attendu : in T_Tableau) is
            Copie : T_Tableau;
        begin
            Put ("From ");
            Ecrire (Tab);
            New_Line;
            Put ("Want ");
            Ecrire (Attendu);
            New_Line;
            Copie := Tab;
            Trier (Copie);
            Put ("Have ");
            Ecrire (Copie);
            New_Line;
            -- TODO : faire l'appel pour trier le tableau Copie
            pragma Assert (Copie = Attendu);
            Put_Line ("----");
        end Tester;

    begin
        Tester (((1, 9, others => 0), 2), ((1, 9, others => 0), 2));
        Tester (((4, 2, others => 0), 2), ((2, 4, others => 0), 2));
        Tester
           (((1, 3, 4, 2, others => 0), 4), ((1, 2, 3, 4, others => 0), 4));
        Tester
           (((4, 3, 2, 1, others => 0), 4), ((1, 2, 3, 4, others => 0), 4));
        Tester
           (((-5, 3, 8, 1, -25, 0, 8, 1, 1, 1), 10),
            ((-25, -5, 0, 1, 1, 1, 1, 3, 8, 8), 10));
        Tester (((others => 0), 0), ((others => 0), 0));
    end Tester_Trier;

    Tab1 : T_Tableau;
begin
    -- Initialiser le tableau
    Tab1 := ((1, 3, 4, 2, others => 0), 4);

    -- Afficher le tableau
    Ecrire (Tab1);
    New_Line;

    -- Trier le tableau
    -- TODO

    -- Afficher le tableau trie
    Ecrire (Tab1);
    New_Line;

    Tester_Trier;

end Tri_Selection;

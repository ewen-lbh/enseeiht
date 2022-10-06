with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

procedure Specifier_Et_Tester is

    -- Calculer le plus grand commun diviseur de deux entiers strictement
    -- positifs.
    -- Paramètres :
    --  A : in Entier
    --  B : in Entier
    -- Retour : Entier -- le pgcd de A et B
    -- Nécessite :
    --      A > 0
    --      B > 0
    -- Assure :
    --      Pgcd'Result >= 1
    --      A mod Pgcd'Résultat = 0    -- le pgcd divise A
    --      B mod Pgcd'Résultat = 0    -- le pgcd divise B
    --      -- c'est le plus grand des entiers qui divisent A et B
    --          // mais on ne sait pas l'exprimer simplement
    -- Exemples : voir Tester_Pgcd
    -- Efficacité : faible car on utilise une version naïve de l'algorithme
    -- d'Euclide.
    -- Pgcd'Result contient la valeur retournée par la fonction
    function Pgcd (A, B : in Integer) return Integer with
        Pre =>  A > 0 and B > 0,
        Post =>  Pgcd'Result >= 1
            and A mod Pgcd'Result = 0 -- Le Pgcd divise A
            and B mod Pgcd'Result = 0 -- Le Pgcd divise B
    is
        L_A, L_B: Integer;  -- variables correspondant à A et B
            -- A et B étant en in, on ne peut pas les modifier dans la
            -- fonction.  Or pour appliquer l'algortihme d'Euclide, il faut
            -- retrancher le plus petit au plus grand jusqu'à avoir deux
            -- nombres égaux.  Nous passons donc par des variables locales et
            -- utilisons le nom des paramètres formels préfixés par 'L_'.
    begin
        L_A := A;
        L_B := B;
        while L_A /= L_B loop
            -- soustraire au plus grand le plus petit
            if L_A > L_B then
                L_A := L_A - L_B;
            else
                L_B := L_B - L_A;
            end if;
        end loop;
        pragma Assert (L_A = L_B);  -- la condition de sortie de boucle.
        return L_A;
    end Pgcd;


    -- Exemple d'utilisation du Pgcd.
    -- Est-ce que le corps de cette procédure est correct ?  Pourquoi ?
    -- Que donne son exécution ?
    procedure Utiliser_Pgcd is
        Resultat: Integer;
    begin
        Resultat := Pgcd (0, 10); -- Pas correct, A > 0 est faux
        Put ("Pgcd (0, 10) = ");
        Put (Resultat, 1);
        New_Line;
    end Utiliser_Pgcd;


    -- Permuter deux entiers.
    -- Paramètres :
    --  A, B : in out Entier    -- les deux entiers à permuter
    -- Nécessite : Néant
    -- Assure :
    --  A = B'Avant et B = A'Avant  -- les valeurs de A et B sont bien permutées
    procedure Permuter (A, B: in out Integer) with
        Post => A = B'Old and B = A'Old
        -- v'Old correspond à la valeur d'un paramètre v avant exécution de la fonction
    is
        Copie_A : Integer;
    begin
        Copie_A := A;
        A := B;
        B := Copie_A;
    end Permuter;

    -- Calculer le nombre de jours dans le mois. Ne gère pas les années bisextiles.
    -- Paramètres:
    --  Mois : in Entier  -- le jour du mois (1 = janvier, ..., 12 = décembre)
    -- Nécéssite: 
    --  Mois : compris entre 1 et 12
    -- Assure : 
    --  Jour_Du_Mois'Résultat vaut 30 ou 31.
    procedure Jour_Du_Mois (Mois: in Integer) with
        Pre => Mois >= 1 and Mois <= 12
        Post => Jour_Du_Mois'Result = 30 or Jour_Du_Mois'Result = 31
    is
        


    -- Procédure de test de Pgcd.
    -- -- Parce que c'est une procédure de test, elle n'a pas de paramètre,
    -- -- pas de type de retour, pas de précondition, pas de postcondition.
    procedure Tester_Pgcd is
    begin
        pragma Assert (4 = Pgcd (4, 4));       -- A = B
        pragma Assert (2 = Pgcd (10, 16));     -- A < B
        pragma Assert (1 = Pgcd (21, 10));     -- A > B
        pragma Assert (3  = Pgcd (105, 147));  -- un autre
    end Tester_Pgcd;


    -- Procédure de test pour mettre en évidence la faible efficacité de Pgcd.
    procedure Tester_Performance_Pgcd is
    begin
        pragma Assert (1 = Pgcd (1, 10 ** 9)); -- lent !
    end Tester_Performance_Pgcd;


    -- Procédure de test de Permuter.
    procedure Tester_Permuter is
        N1, N2: Integer;
    begin
        -- initialiser les données du test
        N1 := 5;
        N2 := 18;

        -- lancer la procédure à tester
        Permuter (N1, N2);

        -- contrôler que la procédure a eu l'effet escompté
        pragma Assert (18 = N1);
        pragma Assert (5 = N2);
    end Tester_Permuter;

    --  Procédyre de test de JourDuMois
    procedure Tester_Jour_Du_Mois is
    begin
        pragma Assert (Jour_Du_Mois(1) = 31);
        pragma Assert (Jour_Du_Mois(2) = 30);
        pragma Assert (Jour_Du_Mois(3) = 31);
        pragma Assert (Jour_Du_Mois(4) = 30);
    end Tester_Jour_Du_Mois;

begin
    --  Utiliser_Pgcd;

    -- lancer les programmes de test.
    Tester_Pgcd;
    Tester_Performance_Pgcd;
    Tester_Permuter;
    Put_Line ("Fini.");

end Specifier_Et_Tester;

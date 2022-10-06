with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;

--  Structure d'un sous-programme récursif:
--  procedure Truc is ... begin ... Truc; ... end Truc;

--  Moyen de garantir la terminaison: Cas d'arrêt / Cas de base

procedure Puissance is

    -- Retourne Nombre à la puissance Exposant : Nombre ** Exposant (sans
    -- utiliser **).
    --
    -- Paramètres :
    --    Nombre: le nombre à élever à la puissance
    --    Exposant: l'exposant
    --
    -- Précondition : L'exposant est positif.
    --
    function Puissance_Positive_Iteratif
       (Nombre : in Float; Exposant : in Integer) return Float with
       Pre => Exposant >= 0
    is
        Resultat : Float;
    begin
        Resultat := 1.0;
        for i in 1 .. Exposant loop
            Resultat := Resultat * Nombre;
        end loop;
        return Resultat;
    end Puissance_Positive_Iteratif;

    procedure Tester_Puissance_Positive_Iteratif is
    begin
        pragma Assert (Puissance_Positive_Iteratif (5.0, 2) = 25.0);
        pragma Assert (Puissance_Positive_Iteratif (1.2, 2) = 1.44);
        pragma Assert (Puissance_Positive_Iteratif (50.3, 0) = 1.0);
        pragma Assert (Puissance_Positive_Iteratif (2.0, 3) = 8.0);
        pragma Assert (Puissance_Positive_Iteratif (-1.0, 10_000) = 1.0);
        pragma Assert (Puissance_Positive_Iteratif (-1.0, 10_001) = -1.0);
    end Tester_Puissance_Positive_Iteratif;

    -- Retourne Nombre à la puissance Exposant : Nombre ** Exposant (sans
    -- utiliser **).
    --
    -- Paramètres :
    --    Nombre: le nombre à élever à la puissance
    --    Exposant: l'exposant
    --
    -- Précondition : Si Nombre = 0, Exposant >= 0.
    function Puissance_Iteratif
       (Nombre : in Float; Exposant : in Integer) return Float with
       Pre => not (Nombre = 0.0 and Exposant < 0)
    is
    begin
        if Exposant < 0 then
            return 1.0 / Puissance_Positive_Iteratif(Nombre, -Exposant);
        end if;
        return Puissance_Positive_Iteratif(Nombre, Exposant);
    end Puissance_Iteratif;

    procedure Tester_Puissance_Iteratif is
    begin
        pragma Assert (Puissance_Iteratif (5.0, 2) = 25.0);
        pragma Assert (Puissance_Iteratif (1.2, 2) = 1.44);
        pragma Assert (Puissance_Iteratif (50.3, 0) = 1.0);
        pragma Assert (Puissance_Iteratif (2.0, 3) = 8.0);
        pragma Assert (Puissance_Iteratif (4.0, -1) = 0.25);
        pragma Assert (Puissance_Iteratif (-1.0, -3) = -1.0);
        pragma Assert (Puissance_Iteratif (2.0, -3) = 0.125);
        pragma Assert (Puissance_Iteratif (-1.0, 10_000) = 1.0);
        pragma Assert (Puissance_Iteratif (-1.0, 10_001) = -1.0);
    end Tester_Puissance_Iteratif;

    -- Retourne Nombre à la puissance Exposant : Nombre ** Exposant (sans
    -- utiliser **).
    --
    -- Paramètres :
    --    Nombre: le nombre à élever à la puissance
    --    Exposant: l'exposant
    --
    -- Précondition : Si Nombre = 0, Exposant >= 0.
    function Puissance_Recursif
       (Nombre : in Float; Exposant : in Integer) return Float with
       Pre => not (Nombre = 0.0 and Exposant < 0)
    is
    begin
        if Exposant < 0 then return 1.0 / Puissance_Recursif(Nombre, -Exposant); end if;
        if Exposant = 0 then return 1.0; end if;
        return Puissance_Recursif (Nombre, Exposant - 1) * Nombre;
    end Puissance_Recursif;

    procedure Tester_Puissance_Recursif is
    begin
        pragma Assert (Puissance_Recursif (5.0, 2) = 25.0);
        pragma Assert (Puissance_Recursif (1.2, 2) = 1.44);
        pragma Assert (Puissance_Recursif (50.3, 0) = 1.0);
        pragma Assert (Puissance_Recursif (2.0, 3) = 8.0);
        pragma Assert (Puissance_Recursif (4.0, -1) = 0.25);
        pragma Assert (Puissance_Recursif (-1.0, -3) = -1.0);
        pragma Assert (Puissance_Recursif (2.0, -3) = 0.125);
        pragma Assert (Puissance_Recursif (-1.0, 10_000) = 1.0);
        pragma Assert (Puissance_Recursif (-1.0, 10_001) = -1.0);
    end Tester_Puissance_Recursif;

    Un_Reel   : Float;         -- un réel lu au clavier
    Un_Entier : Integer;     -- un entier lu au clavier
begin
    Tester_Puissance_Positive_Iteratif;
    Tester_Puissance_Iteratif;
    Tester_Puissance_Recursif;

    -- Demander le réel
    Put ("Un nombre réel : ");
    Get (Un_Reel);

    -- Demander l'entier
    Put ("Un nombre entier : ");
    Get (Un_Entier);

    -- Afficher la puissance en version itérative et récusive (si possible)
    -- TODO : à corriger...
    Put ("Puissance (itérative) : ");
    Put (Puissance_Iteratif (Un_Reel, Un_Entier), Fore => 0, Exp => 0,
        Aft                                            => 4);
    Put ("Puissance (récursive) : ");
    Put (Puissance_Recursif (Un_Reel, Un_Entier), Fore => 0, Exp => 0,
        Aft                                            => 4);
    New_Line;

end Puissance;

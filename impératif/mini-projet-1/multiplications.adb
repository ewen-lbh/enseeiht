with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Alea;


procedure Multiplications is
    Table           : Integer;
    Answer          : Integer;
    Errors          : Integer;
    Continue        : Boolean;
    Item            : Integer;
    Answer_Continue : Character;
    Questions       : Integer;
    Question : Integer;
    Already_Asked: Boolean;

    package randomtableitem is
        new alea(1, 10);
    use RandomTableItem;
begin
    -- On stocke les questions déjà posées dans un entier où chaque dizaine correspond à une question, avec 0 qui correspond à 10:
    -- si les questions ×2, ×5, ×10 et ×8 on été posées, Questions = 8052
    Questions := 0;
    loop
        -- Demander la table à réviser
        Put ("Table à réviser : ");
        Get (Table);
        while Table < 0 or Table > 10 loop
            Put_Line ("Impossible. La table doit être entre 0 et 10.");
            Put ("Table à réviser : ");
            Get (Table);
        end loop;

        -- Réviser la table de multiplication
        Errors := 0;
        for i in 0 .. 9 loop
            loop

                Get_Random_Number(Item);
                if i = 0 then
                    Already_Asked := false;
                else
                    -- Chercher à travers toutes les questions posées
                    for Question_Index in 0 .. i loop
                        Question := Questions / (10 ** Question_Index);
                        if Question = 0 then
                            Question := 10;
                        end if;
                        Already_Asked := Already_Asked or Question = Item;
                    end loop;
                end if;
                exit when not Already_Asked;
            end loop;

            --  Enregistrer la question posée
            if Item /= 10 then 
                Questions := Questions + (10 ** i) * Item;
            end if;

            -- Réviser la valeur d'une multiplication
            Put ("(M" & Integer'Image (i) & ") " & Integer'Image (Table) &
                " * " & Integer'Image (Item) & " ? ");
            Get (Answer);
            if Answer /= Table * Item then
                Errors := Errors + 1;
            end if;
        end loop;

        -- Afficher le message d'erreur
        case Errors is
            when 0 =>
                Put_Line ("Aucune erreur. Excellent !");
            when 1 =>
                Put_Line ("Une seule erreur. Très bien.");
            when 2 .. 4 =>
                Put ("Seulement " & Integer'Image (10 - Errors) &
                    " bonne réponses. Il faut apprendre la table de " &
                    Integer'Image (Table) & " !");
            when 5 .. 9 =>
                Put (Integer'Image (Errors) &
                    " erreurs. Il faut encore travailler la table de " &
                    Integer'Image (Table) & ".");
            when 10 =>
                Put_Line ("Tout est faux! Volontaire?");
            when others =>
                Put_Line ("unreachable code");
        end case;

        -- Demander à continuer
        Put ("On continue (o/n) ? ");
        Get (Answer_Continue);
        Continue := Answer_Continue = 'o' or Answer_Continue = 'O';
        exit when not Continue;
    end loop;
end Multiplications;

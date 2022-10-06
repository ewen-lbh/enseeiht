with Ada.Text_IO;        	use Ada.Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Calendar;			use Ada.Calendar; 
with Alea;

procedure Multiplications is
	Table             : Integer;
	Answer            : Integer;
	Errors            : Integer;
	Continue          : Boolean;
	Item              : Integer;
	Answer_Continue   : Character;
	Previous_Question : Integer;

	package randomtableitem is new Alea (1, 10);
	use randomtableitem;
begin
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
				Get_Random_Number (Item);
				exit when i = 0 or Item /= Previous_Question;
			end loop;

			--  Enregistrer la question posée
			Previous_Question := Item;

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

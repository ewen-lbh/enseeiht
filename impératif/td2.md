## Exercice 1

```ada
with Ada.Text_IO;		use Ada.Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;

procedure CalculPGCD is
	a: Integer;
	b: Integer;
	na: Integer;
	nb: Integer;
	pgcd: Integer;
begin
	-- Demander deux entiers a et b
	Put("A et B ? ");
	Get(a);
	Get(b);

	-- Déterminer le pgcd de a et b
	na <- a;
	nb <- b;
	while na /= nb loop
		-- Soustraire au plus grand le plus petit
		if na > nb then
			na <- na - nb;
		else
			nb <- nb - na;
		end if
	end loop
	pgcd <- na;

	-- Afficher le pgcd
	Put("pgcd = ")
	Put(pgcd)
```

## Exercice 2

```
R0: Piloter un drone

R1: Comment «Piloter un drone» ?
    Initialiser le drone			En_Route, Est_Perdu, Altitude, Quitter: out
    TantQue Non (Quitter OuAlors Est_Perdu)
	    Afficher l'altitude du drone	Altitude: in
	    Afficher le menu			
	    Demander le choix de l'utilisateur	Choix: out
	    Traiter le choix de l'utilisateur
    FinTQ
    Afficher les raisons de l'arrêt

R2: Comment «Initialiser le drone» ?
    En_Route <- FAUX
    Est_Perdu <-- FAUX
    Altitude <-- 0
    Quitter <- FAUX

R2: Comment «Affiche l'altitude du drone» ?
    Nouvelle_Ligne
    Écrire("Altitude : ")
    Écrire(Altitude, 1)
    Nouvelle_Ligne

R2: Comment «Afficher le menu» ?
    Nouvelle_Ligne
    Écrire_Ligne("Que faire ?")
    Écrire_Ligne("    d -- Démarrer")
    Écrire_Ligne("    m -- Monter")
    Écrire_Ligne("    s -- Descendre")
    Écrire_Ligne("    q -- Quitter")

R2: Comment «Demander le choix de l'utilisateur» ?
    Écrire("Votre choix : )
    Lire(Choix)
    Sauter_Ligne

R2: Comment «Traiter le choix de l'utilisateur» ?
    Selon Choix Dans
    	"d" | "D" => Mettre le drone en route	En_Route: in out
	"m" | "M" => Faire monter le drone	En_Route: in, Altitude, Est_Perdu: in out
	"s" | "S" => Faire descendre le drone	En_Route: in, Altitude: in out
	"q" | "Q" | "0" => Quitter		Quitter: out
	Autres => Écrire_Ligne("Je n'ai pas compris !")
    FinSelon

R3: Comment «Mettre le drone en route» ?
    En_Route <- VRAI

R3: Comment «Faire monter le drone» ?
    Si En_Route Alors
    	Altitude <- Altitude + 1
    Sinon
    	Écrire_Ligne("Le drone n'est pas démarré.")
    FinSi
    Est_Perdu <- Altitude >= LIMITE_PORTEE

R3: Comment «Faire descendre le drone» ?
    Si En_Route Alors
    	Si Altitude > 0 Alors
		Altitude <- Altitude - 1
	Sinon
		Écrire_Ligne("Le drone est déjà posé.")
	FinSi
    Sinon
    	Écrire_Ligne("Le drone n'est pas démarré.")
    FinSi

R3: Comment «Quitter» ?
    Quitter <- VRAI

R2: Comment «Afficher les raisons de l'arrêt» ?
    Nouvelle_Ligne
    Si Est_Perdu Alors
    	Écrire_Ligne("Le drone est hors de portée... et donc perdu !")
    Sinon Si Non En_Route Alors
    	Écrire_Ligne("Vous n'avez pas réussi à le mettre en route ?")
    Sinon
    	Écrire_Ligne("Au revoir...")
    FinSi
```

## Exercice 3

### 1

```
R0: Afficher les nombres premiers jusqu'à un certain entier

R1: Comment «Afficher les nombres premiers jusqu'à un certain entier» ?
    Demander la limite à l'utilisateur		Limite: out
    TantQue Nombre < Limite Faire
    	Afficher le prochain nombre premier	Nombre: in out	
    FinPour

R2: Comment «Demander la limite à l'utilisateur» ?
    Écrire("Afficher les nombres premiers de 2 à: ")
    Lire(Limite)

R2: Comment «Afficher le prochain nombre premier» ?
    Nombre <- Nombre  + 1
    TantQue Nombre n'est pas premier Faire
    	Nombre <- Nombre + 1
    FinTQ

R3: Comment [déterminer] «Nombre n'est pas premier» ?
    Résultat <- VRAI
    TantQue Diviseur < Nombre Faire
    	Si Diviseur mod Nombre = 0 Alors
		Résultat <- FAUX
	FinSi
    	Diviseur <- Diviseur + 1
    FinTQ


R0: Afficher les nombres amis jusqu'à un certain entier

R1: Comment «Afficher les nombres amis jusqu'à un certain entier»
    Demander la limite à l'utilisateur		Limite: out
    TantQue N <= M EtAlors M <= Limite
    	Afficher le prochain couple de nombre amis	N, M: in out
    FinTQ

R2: Comment «Afficher le prochain couple de nombres amis» ?
    M <- M + 1
    TantQue N et M ne sont pas amis Faire
	TantQue N et M ne sont pas amis Faire
		M <- M + 1
	FinTQ
    	N <- N + 1
    FinTQ

R3: Comment [déterminer] «N et M ne sont pas amis» ?
    TantQue Diviseur < M Faire
    	SommeDiviseursM <- SommeDiviseursM + Diviseur
	Obtenir le prochain diviseur de M		Diviseur: in out, M: in
    FinTQ
    TantQue Diviseur < N Faire
    	SommeDiviseursN <- SommeDiviseursN + Diviseur
	Obtenir le prochain diviseur de N		Diviseur: in out, N: in
    FinTQ
    Résultat <- SommeDiviseursN = M EtAlors SommeDiviseursM = N

R4: Comment «Obtenir le prochain diviseur de $» ?
    TantQue Non (Diviseur divise $) Faire
    	Diviseur <- Diviseur + 1
    FinTQ

R5: Comment [déterminer] «$a divise $b» ?
    Résultat <- $a mod $b = 0
```

### 2

Utiliser des sous-programmes

## Exercice 4

R0: Construire un algorithme

R1: Comment «Construire un algorithme» ?
    Choisir l'étape la moins bien comprise
    Comprendre le problème
    Construire le raffinage d'une étape
    Produire le programme
    Vérifier l'ensemble de l'algorithme

R2: Comment «Comprendre le problème» ?
    Identifier des jeux de tests
    Identifier les flots de données
    Identifier une solution informelle

R2: Comment «Construire le raffinage d'une étape» ?
    Construire R1
    TantQue Il y a des étapes non élémentaires Faire
    	Lister les étapes
	Ordonner les étapes
    	Raffiner les étapes non élémentaires
    FinTQ

R2: Comment «Indentifier des jeux de tests» ?
    Identifier des jeux de tests correspondant aux cas hors-limites
    Identifier des jeux de tests correspondant aux cas limites
    Identifier des jeux de tests représentatifs des cas nominaux

R2: Comment «Vérifier l'ensemble de l'algorithme» ?
    Tester le programme

# Bilan

## Quelle est la portée de chaque variable déclarée ? Pour chaque variable, on donnera le numéro de ligne où commence et se termine sa portée.

| Variable | Début | Fin |
| -------- | ----- | --- |
| n        | 8     | 37  |
| \*p      | 9     | 37  |
| a        | 13    | 18  |
| n        | 22    | 25  |
| r        | 30    | 33  |

## Y a-t-il un exemple de masquage de variable dans ce programme ?

Oui, la variable n déclarée à la ligne 8 est masquée des lignes 22 à 25 par la variable n déclarée à la ligne 22.

## Peut-on savoir ce que devrait afficher l’exécution de ce programme ?

Non, la ligne 10 affiche l'addresse en mémoire de la variable n, qui ne peut être connue avant exécution.

## Même s’il compile sans erreur, ce programme est faux. Pourquoi ?

À la ligne 20, on déréférence p, qui d'après la ligne 14, pointe sur a. Hors a est hors-portée.

## La valeur de `p` change-t-elle après l’initialisation de la ligne 14 ?

Non, `p` n'est pas modifié ensuite.

## Que se passerait-il si on modifiait `*p` après la ligne 19 ?

L'affichage aux lignes 20, 27 et 34 change

## Travail non terminé

J'ai un memory leak de 6 multiplets (correspondant à un `free`) que je n'arrive pas à résoudre.

J'ai aussi fait une fonction `join_strings` pour récupérer tout les arguments de la commande pour `lj`, mais j'ai des caractères corrompus au début, malgré un `malloc` me semblant correct. J'utilise donc seulement le nom du programme.

## Question 7

On ajoute un handler qui exécutera le même code que `sj` pour `SIGSTP`.

## Question 8

On ajoute un handler qui enverra `SIGINT` au processus actuel.

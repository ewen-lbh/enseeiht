## Module générique en Ada: exemple de la pile

1. La documentation est avec l'interface, séparée de l'implémentation car la spécification est publique

2. Les contrats sont formalisés dans les pré/post conditions ainsi que dans les types de paramètres (la signature)

3. La spécification débute avec le mot clé `generic`. Les paramètres sont:
  - un entier `Capacite`
  - un type `T_Pile`
  Pour utiliser le module, il faut d'abord l'instancier en donnant des valeurs concrètes à ces paramètres de généricité.

4. On définit la procédure dans le `.adb` et sa spécification dans le `.ads`

5. Surcharger une fonction, c'est la réimplémenter sous le même nom mais avec de nouveaux types pour ses paramètres.

6. L'implémentation de la manière dont on affiche un élément n'est pas unique selon le type des éléments de la pile, donc on peut vouloir appeler deux fois cette procédure avec des affichages différents sans réinstancier le module

7. On préfixe les procédures et fonctions par le nom du paquet.

## Expression bien appairée

1. cf `parenthesage.adb`

2. Avant de l'utiliser dans d'autres programmes, il faut copier-coller les signatures des fonctions dans un fichier de spécifications `.ads`.

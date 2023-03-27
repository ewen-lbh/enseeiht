class LigneTab implements Ligne {
        caracteres: char[];
        curseur: int;

         LigneTab(capacite) {
             this.caracteres = new String[capacite]();
             this.curseur = 0;
         }

         public void avancer() {
             this.curseur += 1;
         }

         public void raz() {
             this.curseur = 0;
         }
}

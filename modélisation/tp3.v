Require Import Extraction.
(* Ouverture d’une section *)
Section Induction.
(* Déclaration d’un domaine pour les éléments des listes *)
Variable A : Set.

Inductive liste : Set :=
  Nil : liste
| Cons : A -> liste -> liste.

Print liste_ind.

(* Déclaration du nom de la fonction *)
Variable append_spec : liste -> liste -> liste.

(* Spécification du comportement pour Nil *)
Axiom append_Nil : forall (l : liste), append_spec Nil l = l.

(* Spécification du comportement pour Cons *)
Axiom append_Cons : forall (t : A), forall (q l : liste),
   append_spec (Cons t q) l = Cons t (append_spec q l).

Theorem append_Nil_right : forall (l : liste), (append_spec l Nil) = l.
intros.

Qed.

Theorem append_associative : forall (l1 l2 l3 : liste),
   (append_spec l1 (append_spec l2 l3)) = (append_spec (append_spec l1 l2) l3).
(* TO DO *)
Qed.

(* Implantation de la fonction append *)
Fixpoint append_impl (l1 l2 : liste) {struct l1} : liste :=
   match l1 with
      Nil => l2
      | (Cons t1 q1) => (Cons t1 (append_impl q1 l2))
end.

Theorem append_correctness : forall (l1 l2 : liste),
   (append_spec l1 l2) = (append_impl l1 l2).
(* TO DO *)
Qed.

Variable rev_spec : liste -> liste.

Axiom rev_Nil : (rev_spec Nil) = Nil.

Axiom rev_Cons : forall (t : A), forall (q : liste), 
  (rev_spec (Cons t q)) = (append_spec (rev_spec q) (Cons t Nil)).

Theorem rev_append : forall (l1 l2 : liste), 
  (rev_spec (append_spec l1 l2)) = (append_spec (rev_spec l2) (rev_spec l1)).
Qed.

Theorem rev_rev : forall (l : liste), (rev_spec (rev_spec l)) = l.
(* TO DO *)
Qed.

(* Implantation de la fonction rev (reverse d'une liste) *)
Fixpoint rev_impl (l : liste) : liste :=
(* TO DO *)
.

Theorem rev_correctness : forall (l : liste), (rev_impl l) = (rev_spec l).
(* TO DO *)
Qed.

End Induction.
Extraction Language Ocaml.
Extraction "/tmp/induction" append_impl rev_impl.
Extraction Language Haskell.
Extraction "/tmp/induction" append_impl rev_impl.
Extraction Language Scheme.
Extraction "/tmp/induction" append_impl rev_impl.


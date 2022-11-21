Require Import Naturelle.
Section Session1_2022_Logique_Exercice_2.

Variable A B : Prop.

(*
I_imp HNAIB.
absurde H.
I_antiT B.
E_imp (~A).
Hyp HNAIB.
cut (~A /\ ~B).
intro H2.
elim H2.
intros HNA HNB.
exact HNA.
*)

Theorem Exercice_2_Naturelle : ((~A) -> B) -> (A \/ B).
Proof.
I_imp HNAIB.
absurde H.
E_non B.
E_imp (~A).
Hyp HNAIB.
E_ou (A \/ B).
Qed.

Theorem Exercice_2_Coq : ((~A) -> B) -> (A \/ B).
intros.
Admitted.

End Session1_2022_Logique_Exercice_2.


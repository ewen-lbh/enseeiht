Require Import Naturelle.
Section Session1_2022_Logique_Exercice_1.

Variable A B : Prop.

Theorem Exercice_1_Naturelle : (A \/ B) -> (~A) -> B.
Proof.
I_imp HAOB.
I_imp HNA.
E_ou A B.
Hyp HAOB.
I_imp HA.
E_antiT.
E_non A.
Hyp HA.
Hyp HNA.
I_imp HB.
Hyp HB.
Qed.

Theorem Exercice_1_Coq : (A \/ B) -> (~A) -> B.
Proof.
intros.
elim H.
intros.
cut False.
intros.
contradiction.
absurd A.
exact H0.
exact H1.
intros.
exact H1.
Qed.

End Session1_2022_Logique_Exercice_1.


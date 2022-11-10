Require Import Naturelle.
Section Session1_2019_Logique_Exercice_2.

Variable A B : Prop.

Theorem Exercice_2_Naturelle : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
I_imp HNAB.
E_ou (A) (~A).
TE.
I_imp HA.
I_ou_d.
I_et.
Hyp HA.
E_ou (~A) B.
Hyp HNAB.
I_imp HNA.
E_antiT.
E_non A.
Hyp HA.
Hyp HNA.
I_imp HB.
Hyp HB.
I_imp HNA.
I_ou_g.
Hyp HNA.
Qed.


Theorem Exercice_2_Coq : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
intros.
cut (A \/ ~A).
intros.
elim H0.
intros.
right.
split.
exact H1.
cut (~A \/ B).
intros.
destruct H0.
destruct H2.
absurd A.
exact H2.
exact H1.
exact H2.
absurd A.
exact H0.
exact H1.
exact H.
intros.
left.
exact H1.
apply (classic A).

Qed.

End Session1_2019_Logique_Exercice_2.


(* Les rÃ¨gles de la dÃ©duction naturelle doivent Ãªtre ajoutÃ©es Ã  Coq. *) 
Require Import naturelle. 

(* Ouverture d'une section *) 
Section LogiquePropositions. 

(* DÃ©claration de variables propositionnelles *) 
Variable A B C E Y R : Prop. 

Theorem Thm_0 : A /\ B -> B /\ A.
I_imp HAetB.
I_et.
E_et_d A.
Hyp HAetB.
E_et_g B.
Hyp HAetB.
Qed.

Theorem Thm_1 : ((A \/ B) -> C) -> (B -> C).
I_imp AouBimpC.
I_imp BimpC.
E_imp (A \/ B).
Hyp AouBimpC.
I_ou_d.
Hyp BimpC.
Qed.

Theorem Thm_2 : A -> ~~A.
I_imp HA.
I_non HNNA.
E_non A.
Hyp HA.
Hyp HNNA.
Qed.
(*
Theorem Thm_3 : (A -> B) -> (~B -> ~A).
I_imp AimpB.
I_imp NBimpNA.
I_non HA.
E_imp A.


Qed.*)

Theorem Thm_4 : (~~A) -> A.
I_imp HNNA.
absurde HA.
I_antiT (~A).
Hyp(HA).
Hyp(HNNA).
Qed.

Theorem Thm_5 : (~B -> ~A) -> (A -> B).
I_imp I1.
I_imp I2.
absurde NB.
E_non A.
Hyp I2.
E_imp (~B).

Hyp I1.
Hyp NB.
Qed.

Theorem Thm_6 : ((E -> (Y \/ R)) /\ (Y -> R)) -> ~R -> ~E.
I_imp H.
I_imp H0.
I_non HE.
I_antiT R.
E_imp Y.
E_et_d (E -> Y \/ R).
Hyp H.
E_ou Y R.
E_imp E.
E_et_g (Y -> R).
Hyp H.
Hyp HE.
I_imp YY.
Hyp YY.
I_imp HR.
absurde Habs.
I_antiT R.
Hyp HR.
Hyp H0.
Hyp H0.
Qed.

(* Version en Coq *)

Theorem Coq_Thm_0 : A /\ B -> B /\ A.
intro H.
destruct H as (HA,HB).  (* Ã©limination conjonction *)
split.                  (* introduction conjonction *)
exact HB.               (* hypothÃ¨se *)
exact HA.               (* hypothÃ¨se *)
Qed.


Theorem Coq_E_imp : ((A -> B) /\ A) -> B.
intros.
cut A.
destruct H as (HAB, HA).
exact HAB.
destruct H as (HAB, HA).
exact HA.
Qed.

Theorem Coq_E_et_g : (A /\ B) -> A.
intros.
destruct H as (HA, HB).
exact HA.
Qed.

Theorem Coq_E_ou : ((A \/ B) /\ (A -> C) /\ (B -> C)) -> C.
intros.
destruct H as (HAB, H_).
destruct H_ as (HAC, HBC).
elim HAB.
exact HAC.
exact HBC.
Qed.

Theorem Coq_Thm_7 : ((E -> (Y \/ R)) /\ (Y -> R)) -> (~R -> ~E).
intros.
unfold not.
intro HE.
absurd R.
exact H0.
destruct H as (HEimp, HY).
cut Y.
exact HY.
elim HEimp.
auto.
intro.
absurd R.
exact H0.
exact H.
exact HE.
Qed.

End LogiquePropositions.


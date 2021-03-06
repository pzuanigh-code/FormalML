Require Import Morphisms.
Require Import Equivalence.
Require Import Program.Basics.
Require Import Lra.
Require Import Classical.
Require Import FunctionalExtensionality.

Require Import hilbert.

Require Export RandomVariableLpR.
Require Import quotient_space.

Require Import AlmostEqual.
Require Import utils.Utils.
Require Import List.

Set Bullet Behavior "Strict Subproofs".

Section L2.
  Context {Ts:Type} 
          {dom: SigmaAlgebra Ts}
          (prts: ProbSpace dom).

  Lemma big2 : 1 <= 2.
  Proof.
    lra.
  Qed.
  Let nneg2 : nonnegreal := mknonnegreal 2 ltac:(lra).
  Canonical nneg2.


  Global Instance IsL2_Finite (rv_X:Ts->R)
        {rrv:RandomVariable dom borel_sa rv_X}
        {lp:IsLp prts 2 rv_X} : IsFiniteExpectation prts rv_X.
  Proof.
    apply IsLp_Finite in lp; trivial.
    apply big2.
  Qed.

  Lemma Expectation_sqr
        (rv_X :Ts->R)  :
    Expectation (rvsqr rv_X) = Some (Expectation_posRV (rvsqr rv_X)).
  Proof.
    apply Expectation_pos_posRV.
  Qed.
  
  Lemma rvabs_bound (rv_X : Ts -> R) :
    rv_le (rvabs rv_X) (rvplus (rvsqr rv_X) (const 1)).
  Proof.
    assert (PositiveRandomVariable (rvsqr (rvplus (rvabs rv_X) (const (-1))))) by apply prvsqr.
    assert (rv_eq (rvsqr (rvplus (rvabs rv_X) (const (-1))))
                  (rvplus 
                     (rvplus (rvsqr (rvabs rv_X)) (rvscale (-2) (rvabs rv_X)))
                     (const 1))).
    intro x.
    unfold rvsqr, rvplus, rvscale, rvabs, const, Rsqr.
    now ring_simplify.
    rewrite H0 in H; clear H0.
    unfold PositiveRandomVariable in H.
    unfold rv_le; intros x.
    specialize (H x).
    unfold rvsqr, rvminus, rvplus, rvmult, rvopp, rvscale, rvabs in *.
    rewrite Rsqr_abs.
    unfold Rsqr in *.
    apply Rplus_le_compat_l with (r := 2 * Rabs (rv_X x)) in H.
    ring_simplify in H.
    generalize (Rabs_pos (rv_X x)); intros.
    apply Rplus_le_compat_l with (r := Rabs(rv_X x)) in H0.
    lra.
  Qed.

  Lemma rvabs_pos_eq (rv_X:Ts->R) {prv:PositiveRandomVariable rv_X} :
    rv_eq (rvabs rv_X) rv_X.
  Proof.
    intros a.
    unfold rvabs.
    now rewrite Rabs_pos_eq.
  Qed.
    
  Lemma rvabs_sqr (rv_X : Ts -> R) :
    rv_eq (rvabs (rvsqr rv_X)) (rvsqr rv_X).
    Proof.
      intro x.
      unfold rvabs, rvsqr.
      apply Rabs_pos_eq.
      apply Rle_0_sqr.
    Qed.
      
  Lemma rvsqr_abs (rv_X : Ts -> R) :
    rv_eq (rvsqr (rvabs rv_X)) (rvsqr rv_X).
    Proof.
      intro x.
      unfold rvabs, rvsqr.
      now rewrite <- Rsqr_abs.
    Qed.

    Lemma rvmult_abs (rv_X1 rv_X2 : Ts -> R):
      rv_eq (rvabs (rvmult rv_X1 rv_X2)) (rvmult (rvabs rv_X1) (rvabs rv_X2)).
      Proof.
        intro x.
        unfold rvmult, rvabs.
        apply Rabs_mult.
     Qed.

  Lemma rvprod_bound (rv_X1 rv_X2 : Ts->R) :
    rv_le (rvscale 2 (rvmult rv_X1 rv_X2))
                          (rvplus (rvsqr rv_X1) (rvsqr rv_X2)).
  Proof.
    assert (PositiveRandomVariable (rvsqr (rvminus rv_X1 rv_X2))) by apply prvsqr.
    assert (rv_eq (rvsqr (rvminus rv_X1 rv_X2)) 
                  (rvplus (rvplus (rvsqr rv_X1) (rvopp (rvscale 2 (rvmult rv_X1 rv_X2))))
                          (rvsqr rv_X2))).
    intro x.
    unfold rvsqr, rvminus, rvplus, rvmult, rvopp, rvscale, Rsqr.
    now ring_simplify.
    rewrite H0 in H; clear H0.
    intros x.
    unfold rvsqr, rvminus, rvplus, rvmult, rvopp, rvscale, Rsqr in *.
    unfold PositiveRandomVariable in H.
    specialize (H x).
    lra.
  Qed.  
  
  Lemma rvprod_abs_bound (rv_X1 rv_X2 : Ts->R) :
    rv_le (rvscale 2 (rvabs (rvmult rv_X1 rv_X2)))
                          (rvplus (rvsqr rv_X1) (rvsqr rv_X2)).
  Proof.
    generalize (rvprod_bound (rvabs rv_X1) (rvabs rv_X2)); intros.
    do 2 rewrite rvsqr_abs in H.
    now rewrite rvmult_abs.
  Qed.

  Lemma rvsum_sqr_bound (rv_X1 rv_X2 : Ts->R) :
    rv_le (rvsqr (rvplus rv_X1 rv_X2)) 
                          (rvscale 2 (rvplus (rvsqr rv_X1) (rvsqr rv_X2))).
  Proof.
    assert (PositiveRandomVariable (rvsqr (rvminus rv_X1 rv_X2))) by apply prvsqr.
    assert (rv_eq (rvsqr (rvminus rv_X1 rv_X2)) 
                  (rvplus (rvplus (rvsqr rv_X1) (rvopp (rvscale 2 (rvmult rv_X1 rv_X2))))
                          (rvsqr rv_X2))).
    intro x.
    unfold rvsqr, rvminus, rvplus, rvmult, rvopp, rvscale, Rsqr.
    now ring_simplify.
    rewrite H0 in H; clear H0.
    unfold PositiveRandomVariable in H.
    intros x.
    specialize (H x).
    unfold rvsqr, rvminus, rvplus, rvmult, rvopp, rvscale, Rsqr in *.
    apply Rplus_le_compat_l with (r:= ((rv_X1 x + rv_X2 x) * (rv_X1 x + rv_X2 x))) in H.
    ring_simplify in H.
    ring_simplify.
    apply H.
  Qed.    

    Global Instance is_L2_mult_finite x y 
        {xrv:RandomVariable dom borel_sa x}
        {yrv:RandomVariable dom borel_sa y} : 
    IsLp prts 2 x -> IsLp prts 2 y ->
    IsFiniteExpectation prts (rvmult x y).
  Proof.
    intros HH1 HH2.
    unfold IsLp, IsFiniteExpectation in *.
    match_case_in HH1
    ; [intros ? eqq1 | intros eqq1]
    ; rewrite eqq1 in HH1
    ; try contradiction.
    match_destr_in HH1; try contradiction.
    match_case_in HH2
    ; [intros ? eqq2 | intros eqq2]
    ; rewrite eqq2 in HH2
    ; try contradiction.
    match_destr_in HH2; try contradiction.

    apply Expectation_abs_then_finite.
    - typeclasses eauto.
    - generalize (rvprod_abs_bound x y)
      ; intros xyle.

      rewrite (Expectation_pos_posRV _).
      generalize (Finite_Expectation_posRV_le (rvabs (rvmult x y))
                                              (rvplus (rvsqr x) (rvsqr y))
                                              _
                                              _
                 )
      ; intros HH.
      rewrite <- HH; trivial.
      + etransitivity; try eapply xyle.
        intros a.
        unfold rvscale, rvabs, rvmult.
        assert (0 <= Rabs (x a * y a))
          by apply Rabs_pos.
        lra.
      + generalize (Expectation_posRV_sum (rvsqr x) (rvsqr y))
        ; intros HH3.
        erewrite Expectation_posRV_pf_irrel in HH3.
        rewrite HH3.

        rewrite rvpower_abs2_unfold in eqq1, eqq2.
        
        rewrite (Expectation_pos_posRV _) in eqq1.
        rewrite (Expectation_pos_posRV _) in eqq2.
        invcs eqq1.
        invcs eqq2.
        rewrite H0, H1.
        reflexivity.
  Qed.

  Definition L2RRVinner (x y:LpRRV prts 2) : R
    := FiniteExpectation prts (rvmult x y).

  Global Instance L2RRV_inner_proper : Proper (LpRRV_eq prts ==> LpRRV_eq prts ==> eq) L2RRVinner.
  Proof.
    unfold Proper, respectful, LpRRV_eq.

    intros x1 x2 eqq1 y1 y2 eqq2.
    unfold L2RRVinner.
    assert (eqq:rv_almost_eq prts (rvmult x1 y1) (rvmult x2 y2)).
    - LpRRV_simpl.
      now apply rv_almost_eq_mult_proper.
    - eapply FiniteExpectation_proper_almost; try eapply eqq
      ; try typeclasses eauto.
  Qed.    

  Lemma L2RRV_inner_comm (x y : LpRRV prts 2) :
    L2RRVinner x y = L2RRVinner y x.
  Proof.
    unfold L2RRVinner.
    apply FiniteExpectation_ext.
    apply rvmult_comm.
  Qed.
  
  Lemma L2RRV_inner_pos (x : LpRRV prts 2) : 0 <= L2RRVinner x x.
  Proof.
    unfold L2RRVinner.
    apply FiniteExpectation_pos.
    typeclasses eauto.
  Qed.

  Lemma rvsqr_eq (x:Ts->R): rv_eq (rvsqr x) (rvmult x x).
  Proof.
    intros ?.
    reflexivity.
  Qed.

  Lemma L2RRV_inner_zero_inv (x:LpRRV prts 2) : L2RRVinner x x = 0 ->
                                         LpRRV_eq prts x (LpRRVconst prts 0).
  Proof.
    unfold L2RRVinner, LpRRV_eq; intros.
    apply FiniteExpectation_zero_pos in H; try typeclasses eauto.
    red.
    erewrite ps_proper; try eapply H.
    intros a.
    unfold LpRRVconst, const, rvmult.
    split; intros; simpl in *.
    - rewrite H0; lra.
    - now apply Rsqr_0_uniq in H0.
  Qed.
  
  Lemma L2RRV_inner_scal (x y : LpRRV prts 2) (l : R) :
    L2RRVinner (LpRRVscale prts l x) y = l * L2RRVinner x y.
  Proof.
    unfold L2RRVinner, LpRRVscale; simpl.
    rewrite (FiniteExpectation_ext _ _ (rvscale l (rvmult x y))).
    - destruct (Req_EM_T l 0).
      + subst.
        erewrite (FiniteExpectation_ext _ _ (const 0)).
        * rewrite FiniteExpectation_const; lra.
        * intro x0.
          unfold rvscale, rvmult, const; lra.
      + now rewrite (FiniteExpectation_scale _ l (rvmult x y)).
    - intro x0.
      unfold rvmult, rvscale.
      lra.
  Qed.

  Lemma rvprod_abs1_bound (rv_X1 rv_X2 : Ts->R) :
    rv_le (rvabs (rvmult rv_X1 rv_X2))
                          (rvplus (rvsqr rv_X1) (rvsqr rv_X2)).
  Proof.
    generalize (rvprod_abs_bound rv_X1 rv_X2).
    unfold rv_le, rvscale, rvabs, rvmult, rvsqr, Rsqr; intros H x.
    specialize (H x).
    assert (Rabs (rv_X1 x * rv_X2 x) <= 2 * Rabs (rv_X1 x * rv_X2 x)).
    apply Rplus_le_reg_l with (r := - Rabs(rv_X1 x * rv_X2 x)).
    ring_simplify.
    apply Rabs_pos.
    lra.
  Qed.

  Global Instance L2Expectation_l1_prod (rv_X1 rv_X2:Ts->R) 
        {rv1 : RandomVariable dom borel_sa rv_X1}
        {rv2 : RandomVariable dom borel_sa rv_X2} 
        {l21:IsLp prts 2 rv_X1}
        {l22:IsLp prts 2 rv_X2}        
    :  IsFiniteExpectation prts (rvabs (rvmult rv_X1 rv_X2)).

  Proof.
    assert (PositiveRandomVariable (rvabs (rvmult rv_X1 rv_X2))) by apply prvabs.
    generalize (Expectation_pos_posRV (rvabs (rvmult rv_X1 rv_X2))); intros.
    generalize (rvprod_abs1_bound rv_X1 rv_X2); intros.
    assert (PositiveRandomVariable (rvplus (rvsqr rv_X1) (rvsqr rv_X2)))
      by (apply rvplus_prv; apply prvsqr).
    generalize (Finite_Expectation_posRV_le _ _ H H2 H1); intros.
    unfold IsLp, IsFiniteExpectation in *.
    rewrite (Expectation_pos_posRV _) in l21.
    rewrite (Expectation_pos_posRV _)  in l22.    
    match_case_in l21
    ; [intros ? eqq1 | intros eqq1..]
    ; rewrite eqq1 in l21
    ; try contradiction.
    match_case_in l22
    ; [intros ? eqq2 | intros eqq2..]
    ; rewrite eqq2 in l22
    ; try contradiction.
    assert (PositiveRandomVariable (rvsqr rv_X1)) by apply prvsqr.
    assert (PositiveRandomVariable (rvsqr rv_X2)) by apply prvsqr.
    generalize (Expectation_posRV_sum (rvsqr rv_X1) (rvsqr rv_X2)); intros.
    cut_to H3.
    - rewrite Expectation_pos_posRV with (prv := H).
      now rewrite <- H3.
    - erewrite Expectation_posRV_pf_irrel in H6.
      rewrite H6.
      rewrite (Expectation_posRV_ext _ _ (rvpower_abs2_unfold _)) in eqq1.
      rewrite (Expectation_posRV_ext _ _  (rvpower_abs2_unfold _)) in eqq2.
      erewrite Expectation_posRV_pf_irrel in eqq1.
      rewrite eqq1.
      erewrite Expectation_posRV_pf_irrel in eqq2.
      rewrite eqq2.
      simpl.
      now unfold is_finite.
  Qed.

  Lemma L2RRV_inner_plus (x y z : LpRRV prts 2) :
    L2RRVinner (LpRRVplus prts x y) z = L2RRVinner x z + L2RRVinner y z.
  Proof.
    unfold L2RRVinner, LpRRVplus; simpl.
    erewrite (FiniteExpectation_ext _ _ (rvplus (rvmult x z) (rvmult y z))).
    - erewrite <- FiniteExpectation_plus.
      apply FiniteExpectation_pf_irrel.
    - intro x0.
      unfold rvmult, rvplus.
      lra.
  Qed.

  (* get abs version by saying (x : L2RRV) <-> (abs x : L2RRV) *)

  Lemma L2RRV_inner_plus_r (x y z : LpRRV prts 2) :
    L2RRVinner x (LpRRVplus prts y z) = L2RRVinner x y  + L2RRVinner x z.
  Proof.
    do 3 rewrite L2RRV_inner_comm with (x := x).
    now rewrite L2RRV_inner_plus.
  Qed.

  Lemma L2RRV_inner_scal_r (x y : LpRRV prts 2) (l : R) :
    L2RRVinner x (LpRRVscale prts l y) = l * L2RRVinner x y.
  Proof.
    do 2 rewrite L2RRV_inner_comm with (x := x).
    now rewrite L2RRV_inner_scal.
  Qed.

  Lemma L2RRV_Cauchy_Schwarz (x1 x2 : LpRRV prts 2) :
    0 < L2RRVinner x2 x2 ->
    Rsqr (L2RRVinner x1 x2) <= (L2RRVinner x1 x1)*(L2RRVinner x2 x2).
  Proof.
    generalize (L2RRV_inner_pos 
                  (LpRRVminus prts
                     (LpRRVscale prts (L2RRVinner x2 x2) x1)
                     (LpRRVscale prts (L2RRVinner x1 x2) x2))); intros.
    rewrite LpRRVminus_plus, LpRRVopp_scale in H.
    repeat (try rewrite L2RRV_inner_plus in H; try rewrite L2RRV_inner_plus_r in H; 
            try rewrite L2RRV_inner_scal in H; try rewrite L2RRV_inner_scal_r in H).
    ring_simplify in H.
    unfold pow in H.
    do 3 rewrite Rmult_assoc in H.
    rewrite <- Rmult_minus_distr_l in H.
    replace (0) with (L2RRVinner x2 x2 * 0) in H by lra.
    apply Rmult_le_reg_l with (r := L2RRVinner x2 x2) in H; trivial.
    rewrite L2RRV_inner_comm with (x := x2) (y := x1) in H.
    unfold Rsqr; lra.
  Qed.

  Definition L2RRVq_inner : LpRRVq prts 2 -> LpRRVq prts 2 -> R
    := quot_lift2_to _ L2RRVinner.

  Lemma L2RRVq_innerE x y : L2RRVq_inner (Quot _ x) (Quot _ y) = (L2RRVinner x y).
  Proof.
    apply quot_lift2_toE.
  Qed.

  Hint Rewrite L2RRVq_innerE : quot.

  Lemma L2RRVq_inner_comm (x y : LpRRVq_ModuleSpace prts nneg2) :
    L2RRVq_inner x y = L2RRVq_inner y x.
  Proof.
    LpRRVq_simpl.
    apply L2RRV_inner_comm.
  Qed.
  
  Lemma L2RRVq_inner_pos (x : LpRRVq_ModuleSpace prts nneg2) : 0 <= L2RRVq_inner x x.
  Proof.
    LpRRVq_simpl.
    apply L2RRV_inner_pos.
  Qed.
  
  Lemma L2RRVq_inner_zero_inv (x:LpRRVq_ModuleSpace prts nneg2) : L2RRVq_inner x x = 0 ->
                                                       x = zero.
  Proof.
    unfold zero; simpl.
    LpRRVq_simpl; intros; LpRRVq_simpl.
    now apply L2RRV_inner_zero_inv.
  Qed.
  
  Lemma L2RRVq_inner_scal (x y : LpRRVq_ModuleSpace prts nneg2) (l : R) :
    L2RRVq_inner (scal l x) y = l * L2RRVq_inner x y.
  Proof.
    unfold scal; simpl.
    LpRRVq_simpl.
    apply L2RRV_inner_scal.
  Qed.

  Lemma L2RRVq_inner_plus (x y z : LpRRVq_ModuleSpace prts nneg2) :
    L2RRVq_inner (plus x y) z = L2RRVq_inner x z + L2RRVq_inner y z.
  Proof.
    unfold plus; simpl.
    LpRRVq_simpl.
    apply L2RRV_inner_plus.
  Qed.
  
  Definition L2RRVq_PreHilbert_mixin : PreHilbert.mixin_of (LpRRVq_ModuleSpace prts nneg2)
    := PreHilbert.Mixin (LpRRVq_ModuleSpace prts nneg2) L2RRVq_inner
                        L2RRVq_inner_comm  L2RRVq_inner_pos L2RRVq_inner_zero_inv
                        L2RRVq_inner_scal L2RRVq_inner_plus.

  Canonical L2RRVq_PreHilbert :=
    PreHilbert.Pack (LpRRVq prts 2) (PreHilbert.Class _ _ L2RRVq_PreHilbert_mixin) (LpRRVq prts 2).

  Lemma L2RRVq_Cauchy_Schwarz (x1 x2 : LpRRVq prts 2) :
    0 < L2RRVq_inner x2 x2 ->
    Rsqr (L2RRVq_inner x1 x2) <= (L2RRVq_inner x1 x1)*(L2RRVq_inner x2 x2).
  Proof.
    LpRRVq_simpl.
    apply L2RRV_Cauchy_Schwarz.
  Qed.

  Definition L2RRVq_lim (lim : ((LpRRVq prts 2 -> Prop) -> Prop)) : LpRRVq prts 2.
  Admitted.
  
  Lemma L2RRVq_lim_complete (F : (PreHilbert_UniformSpace -> Prop) -> Prop) :
    ProperFilter F -> cauchy F -> forall eps : posreal, F (ball (L2RRVq_lim  F) eps).
  Proof.
  Admitted.

  Definition L2RRVq_Hilbert_mixin : Hilbert.mixin_of L2RRVq_PreHilbert
    := Hilbert.Mixin L2RRVq_PreHilbert L2RRVq_lim L2RRVq_lim_complete.

  Canonical L2RRVq_Hilbert :=
    Hilbert.Pack (LpRRVq prts 2) (Hilbert.Class _ _ L2RRVq_Hilbert_mixin) (LpRRVq prts 2).

End L2.

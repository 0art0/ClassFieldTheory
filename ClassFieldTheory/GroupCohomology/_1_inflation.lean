import Mathlib
import ClassFieldTheory.GroupCohomology._0_Current_PRs
import ClassFieldTheory.GroupCohomology._1_Basic
import ClassFieldTheory.GroupCohomology._1_restriction

open CategoryTheory
  Limits
  Rep
  groupCohomology
  HomologicalComplex

variable {R G : Type} [CommRing R] [Group G] [DecidableEq G]

variable {H : Type} [Group H] {φ : G →* H} (surj : Function.Surjective φ) [DecidableEq H]

noncomputable def Rep.quotientToInvariantsFunctor :
    Rep R G ⥤ Rep R H where
  obj M := M.quotientToInvariants φ.ker ↓ (QuotientGroup.quotientKerEquivOfSurjective φ surj).symm
  map f := by
    sorry

instance : (quotientToInvariantsFunctor (R := R) surj).PreservesZeroMorphisms := sorry

set_option quotPrecheck false in
/--
`M ↑ H` means the `H` invariants of `M`, as a representation of `G ⧸ H`.
-/
notation M " ↑ " surj => (Rep.quotientToInvariantsFunctor surj).obj M

def groupCohomology.cochain_infl :
    quotientToInvariantsFunctor surj ⋙ cochainsFunctor R H ⟶ cochainsFunctor R G :=
  sorry -- current PR

/--
# TODO :
  move this to the file `Basic.lean`.

The `n`-th group cohomology functor is the composition of the cochains functor and the
`n`-homology functor.
-/
noncomputable def groupCohomology.functor_iso_cochainsFunctor_comp_homology (n : ℕ) :
    functor R G n ≅ cochainsFunctor R G ⋙ homologyFunctor _ _ n := Iso.refl _

/--
The inflation map `Hⁿ(G⧸H, M ↑ H) ⟶ Hⁿ(G,M)` as a natural transformation.
This is defined using the inflation map on cocycles.
-/
noncomputable def groupCohomology.infl (n : ℕ) :
    Rep.quotientToInvariantsFunctor surj ⋙ functor R H n ⟶ functor R G n :=
  (groupCohomology.cochain_infl surj) ◫ 𝟙 (homologyFunctor _ _ n)

/--
Suppose we have a short exact sewuence `0 ⟶ A ⟶ B ⟶ C ⟶ 0` in `Rep R G`.
If `H¹(H,A) = 0` then the invariants form a short exact sequence in `Rep R H`:

  `0 ⟶ Aᴷ ⟶ Bᴷ ⟶ Cᴷ ⟶ 0`, where `K = φ.ker`.
-/
lemma quotientToInvariantsFunctor_shortExact_ofShortExact {S : ShortComplex (Rep R G)}
    (hS : S.ShortExact) (hS' : IsZero (H1 (S.X₁ ↓ φ.ker.subtype))) :
    (S.map (quotientToInvariantsFunctor surj)).ShortExact :=
  /-
  This is the opening section of the long exact sequence. The next term is `H¹(K,S.X₁)`, which
  is assumeed to be zero.
  -/
  sorry

/--
Assume that we have a short exact sequence `0 → A → B → C → 0` in `Rep R G`
and that the sequence of `H`- invariants is also a short exact in `Rep R (G ⧸ H)` :

  `0 → Aᴴ → Bᴴ → Cᴴ → 0`.

Then we have a commuting square

`   Hⁿ(G ⧸ H, Cᴴ)  ⟶   H^{n+1}(G ⧸ H, Aᴴ) `
`         |                 |             `
`         ↓                 ↓             `
`     Hⁿ(G , C)    ⟶   H^{n+1}(G,A)       `

where the horizontal maps are connecting homomorphisms
and the vertical maps are inflation.
-/
lemma groupCohomology.infl_δ_naturality {S : ShortComplex (Rep R G)} (hS : S.ShortExact)
    (hS' : (S.map (quotientToInvariantsFunctor surj)).ShortExact)  (i j : ℕ) (hij : i + 1 = j) :
    δ hS' i j hij ≫ (infl surj j).app _ = (infl surj i).app _ ≫ δ hS i j hij
    := by
  let C := S.map (cochainsFunctor R G)
  let S' := S.map (quotientToInvariantsFunctor surj)
  let C' := S'.map (cochainsFunctor R H)
  let φ : C' ⟶ C := {
    τ₁ := by
        change (cochainsFunctor _ _).obj S'.X₁ ⟶ (cochainsFunctor _ _).obj S.X₁
        exact (cochain_infl surj).app S.X₁
    τ₂ := by
        change (cochainsFunctor _ _).obj S'.X₂ ⟶ (cochainsFunctor _ _).obj S.X₂
        exact (cochain_infl surj).app S.X₂
    τ₃ := by
        change (cochainsFunctor _ _).obj S'.X₃ ⟶ (cochainsFunctor _ _).obj S.X₃
        exact (cochain_infl surj).app S.X₃
    comm₁₂ := ((cochain_infl surj).naturality S.f).symm
    comm₂₃ := ((cochain_infl surj).naturality S.g).symm
  }
  have ses₁ : C.ShortExact := sorry -- current PR
  have ses₂ : C'.ShortExact := sorry -- current PR
  exact HomologySequence.δ_naturality φ ses₂ ses₁ i j hij

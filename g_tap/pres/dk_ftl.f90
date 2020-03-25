!        Generated by TAPENADE     (INRIA, Ecuador team)
!  tapenade 3.x
!
!  Differentiation of dk in forward (tangent) mode:
!   variations   of useful results: dk
!   with respect to varying inputs: *temp *propunit *tsal *pres
!   Plus diff mem management of: temp:in propunit:in tsal:in pres:in
!>    @brief average effective diffusivities on cell faces in z direction
!>    @param[in] i grid indices
!>    @param[in] j grid indices
!>    @param[in] k grid indices
!>    @param[in] spec species
!>    @param[in] ismpl local sample index
!>    @return effective diffusivities (J/mK)
DOUBLE PRECISION FUNCTION g_DK(i, j, k, spec, ismpl, dk)
  USE ARRAYS

  USE g_ARRAYS

  USE MOD_GENRL
  IMPLICIT NONE
  INTEGER :: i, j, k
  INTEGER :: ismpl
  INTEGER :: spec
  DOUBLE PRECISION :: f1, f2, prod, summ, betx, bety, betz, bet
  DOUBLE PRECISION :: g_f1, g_f2, g_prod, g_summ, g_betx, &
& g_bety, g_betz, g_bet
  EXTERNAL POR, DISP, VZ, VY, VX
  EXTERNAL g_POR, g_DISP, g_VZ, g_VY, g_VX
  DOUBLE PRECISION :: POR, DISP, VZ, VY, &
& VX
  DOUBLE PRECISION :: g_POR, g_DISP, g_VZ, g_VY, g_VX
  INTRINSIC SQRT
  DOUBLE PRECISION :: result1
  DOUBLE PRECISION :: g_result1
  DOUBLE PRECISION :: result2
  DOUBLE PRECISION :: g_result2
  DOUBLE PRECISION :: temp0
  DOUBLE PRECISION :: dk
  dk = 0.d0
  betx = 0.d0
  bety = 0.d0
  betz = 0.d0
  IF (j0 .GT. 1 .AND. j .LT. j0) THEN
    g_bety = g_VY(i, j, k, ismpl, bety)
    g_bety = 2*bety*g_bety
    bety = bety*bety
  ELSE
    g_bety = 0.D0
  END IF
  IF (i0 .GT. 1 .AND. i .LT. i0) THEN
    g_betx = g_VX(i, j, k, ismpl, betx)
    g_betx = 2*betx*g_betx
    betx = betx*betx
  ELSE
    g_betx = 0.D0
  END IF
  IF (k0 .GT. 1 .AND. k .LT. k0) THEN
    g_betz = g_VZ(i, j, k, ismpl, betz)
    g_betz = 2*betz*g_betz
    betz = betz*betz
    temp0 = SQRT(betx + bety + betz)
    IF (betx + bety + betz .EQ. 0.0) THEN
      g_bet = 0.D0
    ELSE
      g_bet = (g_betx+g_bety+g_betz)/(2.0*temp0)
    END IF
    bet = temp0
    g_result1 = g_POR(i, j, k, ismpl, result1)
    g_result2 = g_DISP(i, j, k, ismpl, result2)
    g_f1 = diff_c(spec)*g_result1 + bet*g_result2 + result2*&
&     g_bet
    f1 = result1*diff_c(spec) + result2*bet
    g_result1 = g_POR(i, j, k + 1, ismpl, result1)
    g_result2 = g_DISP(i, j, k + 1, ismpl, result2)
    g_f2 = diff_c(spec)*g_result1 + bet*g_result2 + result2*&
&     g_bet
    f2 = result1*diff_c(spec) + result2*bet
    g_prod = f2*g_f1 + f1*g_f2
    prod = f1*f2
    g_summ = delz(k+1)*g_f1 + delz(k)*g_f2
    summ = f1*delz(k+1) + f2*delz(k)
    IF (summ .GT. 0.d0) THEN
      g_dk = 2.d0*(g_prod-prod*g_summ/summ)/summ
      dk = 2.d0*prod/summ
    ELSE
      g_dk = 0.D0
    END IF
  ELSE
    g_dk = 0.D0
  END IF
  RETURN
END FUNCTION g_DK


!        Generated by TAPENADE     (INRIA, Ecuador team)
!  tapenade 3.x
!
!  Differentiation of vy in forward (tangent) mode:
!   variations   of useful results: vy
!   with respect to varying inputs: *temp *propunit *tsal *pres
!   Plus diff mem management of: temp:in propunit:in tsal:in pres:in
!>    @brief calculate velocities at cell faces
!>    @param[in] i grid indices
!>    @param[in] j grid indices
!>    @param[in] k grid indices
!>    @param[in] ismpl local sample index
!>    @return y velocity (m/(Pa s))
DOUBLE PRECISION FUNCTION g_VY(i, j, k, ismpl, vy)
  USE ARRAYS

  USE g_ARRAYS

  USE MOD_GENRL
  USE MOD_FLOW
  IMPLICIT NONE
  INTEGER :: ismpl
  INTEGER :: i, j, k
  EXTERNAL GJ
  EXTERNAL g_GJ
  DOUBLE PRECISION :: f1, f2, dif, GJ
  DOUBLE PRECISION :: g_dif, g_GJ
  DOUBLE PRECISION :: result1
  DOUBLE PRECISION :: g_result1
  DOUBLE PRECISION :: vy
  vy = 0.d0
  IF (j0 .GT. 1 .AND. j .LT. j0) THEN
    g_dif = g_pres(i, j+1, k, ismpl) - g_pres(i, j, k, ismpl)
    dif = pres(i, j+1, k, ismpl) - pres(i, j, k, ismpl)
    g_result1 = g_GJ(i, j, k, ismpl, result1)
    g_vy = -(dif*g_result1+result1*g_dif)
    vy = -(result1*dif)
  ELSE
    g_vy = 0.D0
  END IF
  RETURN
END FUNCTION g_VY


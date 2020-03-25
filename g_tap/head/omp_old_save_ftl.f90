!        Generated by TAPENADE     (INRIA, Ecuador team)
!  tapenade 3.x
!
!  Differentiation of omp_old_save in forward (tangent) mode:
!   variations   of useful results: *concold *headold *tempold
!                *presold
!   with respect to varying inputs: *concold *temp *headold *head
!                *tempold *presold *conc *pres
!   Plus diff mem management of: concold:in temp:in headold:in
!                head:in tempold:in presold:in conc:in pres:in
!> @brief save current state as an old version
!> @param[in] level level number (which old version)
!> @param[in] ismpl local sample index
SUBROUTINE g_OMP_OLD_SAVE(level, ismpl)
  USE ARRAYS

  USE g_ARRAYS

  USE MOD_GENRL
  USE MOD_CONC
  IMPLICIT NONE
! local sample index
  INTEGER :: ismpl
! cgen level index
  INTEGER, INTENT(IN) :: level
! directional cell-indices
  INTEGER :: i, j, k
! counter for concentration
  INTEGER :: l
! Start position in array for process
  INTEGER :: tpos
! Number of array elements for process
  INTEGER :: tanz
  INTRINSIC ABS
  INTRINSIC MAX
  INTEGER :: abs0
  INTEGER :: abs1
  INTEGER :: abs2
  INTEGER :: abs3
  INTEGER :: max1
  INTEGER :: max2
  INTEGER :: max3
  INTEGER :: max4
! OpenMP partition, get tpos, tanz
  CALL OMP_PART(i0*j0*k0, tpos, tanz)
! Get i, j, k indices for tpos
  CALL IJK_M(tpos, i, j, k)
  IF (ismpl .GE. 0.) THEN
    abs0 = ismpl
  ELSE
    abs0 = -ismpl
  END IF
  IF (1 .LT. ismpl) THEN
    max1 = ismpl
  ELSE
    max1 = 1
  END IF
! Copy all variable arrays to old: var -> varold
  CALL g_DCOPY(tanz, head(i, j, k, abs0), g_head(i, j, k, abs0), 1, &
&          headold(tpos, level, max1), g_headold(tpos, level, max1), 1&
&         )
  IF (ismpl .GE. 0.) THEN
    abs1 = ismpl
  ELSE
    abs1 = -ismpl
  END IF
  IF (1 .LT. ismpl) THEN
    max2 = ismpl
  ELSE
    max2 = 1
  END IF
  CALL g_DCOPY(tanz, temp(i, j, k, abs1), g_temp(i, j, k, abs1), 1, &
&          tempold(tpos, level, max2), g_tempold(tpos, level, max2), 1&
&         )
  IF (ismpl .GE. 0.) THEN
    abs2 = ismpl
  ELSE
    abs2 = -ismpl
  END IF
  IF (1 .LT. ismpl) THEN
    max3 = ismpl
  ELSE
    max3 = 1
  END IF
  CALL g_DCOPY(tanz, pres(i, j, k, abs2), g_pres(i, j, k, abs2), 1, &
&          presold(tpos, level, max3), g_presold(tpos, level, max3), 1&
&         )
  DO l=1,ntrans
    IF (ismpl .GE. 0.) THEN
      abs3 = ismpl
    ELSE
      abs3 = -ismpl
    END IF
    IF (1 .LT. ismpl) THEN
      max4 = ismpl
    ELSE
      max4 = 1
    END IF
    CALL g_DCOPY(tanz, conc(i, j, k, l, abs3), g_conc(i, j, k, l, &
&            abs3), 1, concold(tpos, l, level, max4), g_concold(tpos, &
&            l, level, max4), 1)
  END DO
  RETURN
END SUBROUTINE g_OMP_OLD_SAVE

!        Generated by TAPENADE     (INRIA, Tropics team)
!  tapenade 3.x
!
!>    @brief reinjection "dummy" routine, no "reinjection" functionality
!>    @param[in] ismpl local sample index
SUBROUTINE calc_user_ad(ismpl)
  USE MOD_LINFOS
  USE MOD_GENRL
  USE ARRAYS
  IMPLICIT NONE
  integer :: ismpl
  integer :: i
  INTRINSIC INT
  IF (linfos(3) .GE. 2) WRITE(*, *) ' ... calc_user'
!     Dummy body
  i = INT(head(1, 1, 1, ismpl))
  RETURN
END SUBROUTINE calc_user_ad
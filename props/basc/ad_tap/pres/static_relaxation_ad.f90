!        Generated by TAPENADE     (INRIA, Ecuador team)
!  tapenade 3.x
!
!  Differentiation of static_relaxation in reverse (adjoint) mode (with options noISIZE i8):
!   gradient     of useful results: *temp *tempold *presold *pres
!   with respect to varying inputs: *temp *tempold *presold *pres
!   Plus diff mem management of: temp:in tempold:in presold:in
!                pres:in
! MIT License
!
! Copyright (c) 2020 SHEMAT-Suite
!
! Permission is hereby granted, free of charge, to any person obtaining a copy
! of this software and associated documentation files (the "Software"), to deal
! in the Software without restriction, including without limitation the rights
! to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
! copies of the Software, and to permit persons to whom the Software is
! furnished to do so, subject to the following conditions:
!
! The above copyright notice and this permission notice shall be included in all
! copies or substantial portions of the Software.
!
! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
! AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
! OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
! SOFTWARE.
!>    @brief Compute static relaxation for flow and temperature
!>    @param[in] ijk number of cells
!>    @param[inout] ismpl local sample index
!>    @details
!> Static relaxation is computed for variable arrays head, pres, temp:
!> \n\n
!>
!> var = (1-theta)*varold + theta*var \n
SUBROUTINE STATIC_RELAXATION_AD(ijk, ismpl)
  use arrays

  USE ARRAYS_AD

  USE MOD_GENRL
  use mod_time

  USE MOD_TIME_AD

  IMPLICIT NONE
! local sample index
  INTEGER :: ismpl
! Number of cells
  INTEGER, INTENT(IN) :: ijk
  DOUBLE PRECISION :: arg1
  DOUBLE PRECISION :: arg1_ad
  INTEGER :: branch
! flow
  IF (thetaf .NE. 1.0d0) THEN
    CALL PUSHCONTROL1B(0)
  ELSE
    CALL PUSHCONTROL1B(1)
  END IF
! temperature
  IF (thetat .NE. 1.0d0) THEN
    arg1 = 1.0d0 - thetat
    CALL DAXPY_AD(ijk, arg1, arg1_ad, tempold(1, cgen_time, ismpl), &
&           tempold_ad(1, cgen_time, ismpl), 1, temp(1, 1, 1, ismpl), &
&           temp_ad(1, 1, 1, ismpl), 1)
    thetat_ad = 0.D0
    CALL DSCAL_AD(ijk, thetat, thetat_ad, temp(1, 1, 1, ismpl), temp_ad2&
&           (1, 1, 1, ismpl), 1)
  END IF
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 0) THEN
    arg1 = 1.0d0 - thetaf
    CALL DAXPY_AD(ijk, arg1, arg1_ad, presold(1, cgen_time, ismpl), &
&           presold_ad(1, cgen_time, ismpl), 1, pres(1, 1, 1, ismpl), &
&           pres_ad(1, 1, 1, ismpl), 1)
    thetaf_ad = 0.D0
    CALL DSCAL_AD(ijk, thetaf, thetaf_ad, pres(1, 1, 1, ismpl), pres_ad(&
&           1, 1, 1, ismpl), 1)
  END IF
END SUBROUTINE STATIC_RELAXATION_AD

!        Generated by TAPENADE     (INRIA, Ecuador team)
!  tapenade 3.x
!
!  Differentiation of rhoi in forward (tangent) mode:
!   variations   of useful results: rhoi
!   with respect to varying inputs: *temp
!   Plus diff mem management of: temp:in
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
!>    @brief calculate ice density  [kg/m^3]
!>    @param[in] i cell index, direction I0
!>    @param[in] j cell index, direction J0
!>    @param[in] k cell index, direction K0
!>    @param[in] ismpl local sample index
!>    @details
!>    Fukusako, S.:
!>    Thermophysical Properties of Ice, Snow,and Sea Ice
!>    International Journal of Thermophysics, 1990, 11, 353-372
!>
!>    There should be another source.
DOUBLE PRECISION FUNCTION g_RHOI(i, j, k, ismpl, rhoi)
  USE ARRAYS

  USE g_ARRAYS

  IMPLICIT NONE
  INTEGER :: i, j, k, ui, ismpl
  DOUBLE PRECISION :: plocal, tlocal
  DOUBLE PRECISION :: g_tlocal
  DOUBLE PRECISION :: rhoi
  g_tlocal = g_temp(i, j, k, ismpl)
  tlocal = temp(i, j, k, ismpl)
  IF (tlocal .GT. 0.d0) THEN
    tlocal = 0.d0
    g_tlocal = 0.D0
  END IF
  g_rhoi = -(0.151d0*g_tlocal)
  rhoi = 917.d0 - 0.151d0*tlocal
  RETURN
END FUNCTION g_RHOI

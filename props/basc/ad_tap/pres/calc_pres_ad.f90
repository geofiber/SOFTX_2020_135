!        Generated by TAPENADE     (INRIA, Ecuador team)
!  tapenade 3.x
!
!  Differentiation of calc_pres in reverse (adjoint) mode (with options noISIZE i8):
!   gradient     of useful results: *d *e *f *g *temp *w *x *dbc_data
!                *bcperiod *propunit *tsal *presold *pres *a *b
!                *c
!   with respect to varying inputs: *d *e *f *g *temp *w *x *dbc_data
!                *bcperiod *propunit *tsal *presold *pres *a *b
!                *c
!   Plus diff mem management of: d:in e:in f:in g:in temp:in w:in
!                x:in dbc_data:in bcperiod:in propunit:in tsal:in
!                presold:in pres:in simtime:in a:in b:in c:in
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
!>    @brief top level routine for setup and computing pressure flow
!>    @param[in] ismpl local sample index
SUBROUTINE CALC_PRES_AD(ismpl)
  use arrays

  USE ARRAYS_AD

  USE MOD_GENRLC
  USE MOD_GENRL
  USE MOD_FLOW
  use mod_time

  USE MOD_TIME_AD

  USE MOD_LINFOS
  USE MOD_OMP_TOOLS
  IMPLICIT NONE
  INTEGER :: ismpl
  INTEGER :: i
  INCLUDE 'OMP_TOOLS.inc'
  INTEGER :: ijk
  INTEGER :: branch
  IF (linfos(3) .GE. 2) WRITE(*, *) ' ... calc_pres'
!
  ijk = i0*j0*k0
!     initialize coefficients for sparse solvers
  CALL OMP_SET_DVAL(ijk, 0.d0, a(1, 1, 1, ismpl))
  CALL OMP_SET_DVAL(ijk, 0.d0, b(1, 1, 1, ismpl))
  CALL OMP_SET_DVAL(ijk, 0.d0, c(1, 1, 1, ismpl))
  CALL OMP_SET_DVAL(ijk, 0.d0, d(1, 1, 1, ismpl))
  CALL OMP_SET_DVAL(ijk, 0.d0, e(1, 1, 1, ismpl))
  CALL OMP_SET_DVAL(ijk, 0.d0, f(1, 1, 1, ismpl))
  CALL OMP_SET_DVAL(ijk, 0.d0, g(1, 1, 1, ismpl))
  CALL OMP_SET_DVAL(ijk, 0.d0, w(1, 1, 1, ismpl))
!     calculate coefficients
  CALL SET_PCOEF(ismpl)
!     set fluid sources/sinks
  IF (ALLOCATED(simtime)) THEN
    CALL PUSHREAL8ARRAY(simtime, SIZE(simtime, 1))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  CALL SET_PQ(ismpl)
  IF (ALLOCATED(simtime)) THEN
    CALL PUSHREAL8ARRAY(simtime, SIZE(simtime, 1))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(delt_count)) THEN
    CALL PUSHINTEGER8ARRAY(delt_count, SIZE(delt_count, 1))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(flag_1st_timestep)) THEN
    CALL PUSHINTEGER8ARRAY(flag_1st_timestep, SIZE(flag_1st_timestep, 1)&
&                   )
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(delt_old)) THEN
    CALL PUSHREAL8ARRAY(delt_old, SIZE(delt_old, 1))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(d)) THEN
    CALL PUSHREAL8ARRAY(d, SIZE(d, 1)*SIZE(d, 2)*SIZE(d, 3)*SIZE(d, 4))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  CALL SET_PCOEFRS(ismpl)
!     set boundary conditions
  IF (ALLOCATED(c)) THEN
    CALL PUSHREAL8ARRAY(c, SIZE(c, 1)*SIZE(c, 2)*SIZE(c, 3)*SIZE(c, 4))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(b)) THEN
    CALL PUSHREAL8ARRAY(b, SIZE(b, 1)*SIZE(b, 2)*SIZE(b, 3)*SIZE(b, 4))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(a)) THEN
    CALL PUSHREAL8ARRAY(a, SIZE(a, 1)*SIZE(a, 2)*SIZE(a, 3)*SIZE(a, 4))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(pres)) THEN
    CALL PUSHREAL8ARRAY(pres, SIZE(pres, 1)*SIZE(pres, 2)*SIZE(pres, 3)*&
&                 SIZE(pres, 4))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(g)) THEN
    CALL PUSHREAL8ARRAY(g, SIZE(g, 1)*SIZE(g, 2)*SIZE(g, 3)*SIZE(g, 4))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(f)) THEN
    CALL PUSHREAL8ARRAY(f, SIZE(f, 1)*SIZE(f, 2)*SIZE(f, 3)*SIZE(f, 4))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  IF (ALLOCATED(e)) THEN
    CALL PUSHREAL8ARRAY(e, SIZE(e, 1)*SIZE(e, 2)*SIZE(e, 3)*SIZE(e, 4))
    CALL PUSHCONTROL1B(1)
  ELSE
    CALL PUSHCONTROL1B(0)
  END IF
  CALL SET_PBC(ismpl)
  IF (linfos(3) .GE. 2) WRITE(*, *) ' ... solve(pres)'
  CALL SOLVE_AD(pv_pres, -1, pres(1, 1, 1, ismpl), pres_ad(1, 1, 1, &
&         ismpl), errf, aparf, controlf, ismpl)
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(e, SIZE(e, 1)*SIZE(e, 2)*SIZE(e&
&                                 , 3)*SIZE(e, 4))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(f, SIZE(f, 1)*SIZE(f, 2)*SIZE(f&
&                                 , 3)*SIZE(f, 4))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(g, SIZE(g, 1)*SIZE(g, 2)*SIZE(g&
&                                 , 3)*SIZE(g, 4))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(pres, SIZE(pres, 1)*SIZE(pres, 2&
&                                 )*SIZE(pres, 3)*SIZE(pres, 4))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(a, SIZE(a, 1)*SIZE(a, 2)*SIZE(a&
&                                 , 3)*SIZE(a, 4))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(b, SIZE(b, 1)*SIZE(b, 2)*SIZE(b&
&                                 , 3)*SIZE(b, 4))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(c, SIZE(c, 1)*SIZE(c, 2)*SIZE(c&
&                                 , 3)*SIZE(c, 4))
  CALL SET_PBC_AD(ismpl)
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(d, SIZE(d, 1)*SIZE(d, 2)*SIZE(d&
&                                 , 3)*SIZE(d, 4))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(delt_old, SIZE(delt_old, 1))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPINTEGER8ARRAY(flag_1st_timestep, SIZE(&
&                                    flag_1st_timestep, 1))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPINTEGER8ARRAY(delt_count, SIZE(delt_count, &
&                                    1))
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(simtime, SIZE(simtime, 1))
  CALL SET_PCOEFRS_AD(ismpl)
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 1) CALL POPREAL8ARRAY(simtime, SIZE(simtime, 1))
  CALL SET_PQ_AD(ismpl)
  CALL SET_PCOEF_AD(ismpl)
  CALL OMP_SET_DVAL_AD(ijk, 0.d0, w(1, 1, 1, ismpl), w_ad(1, 1, 1, ismpl&
&                ))
  CALL OMP_SET_DVAL_AD(ijk, 0.d0, g(1, 1, 1, ismpl), g_ad(1, 1, 1, ismpl&
&                ))
  CALL OMP_SET_DVAL_AD(ijk, 0.d0, f(1, 1, 1, ismpl), f_ad(1, 1, 1, ismpl&
&                ))
  CALL OMP_SET_DVAL_AD(ijk, 0.d0, e(1, 1, 1, ismpl), e_ad(1, 1, 1, ismpl&
&                ))
  CALL OMP_SET_DVAL_AD(ijk, 0.d0, d(1, 1, 1, ismpl), d_ad(1, 1, 1, ismpl&
&                ))
  CALL OMP_SET_DVAL_AD(ijk, 0.d0, c(1, 1, 1, ismpl), c_ad(1, 1, 1, ismpl&
&                ))
  CALL OMP_SET_DVAL_AD(ijk, 0.d0, b(1, 1, 1, ismpl), b_ad(1, 1, 1, ismpl&
&                ))
  CALL OMP_SET_DVAL_AD(ijk, 0.d0, a(1, 1, 1, ismpl), a_ad(1, 1, 1, ismpl&
&                ))
END SUBROUTINE CALC_PRES_AD

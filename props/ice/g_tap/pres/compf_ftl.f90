!        Generated by TAPENADE     (INRIA, Ecuador team)
!  tapenade 3.x
!
!  Differentiation of compf in forward (tangent) mode:
!   variations   of useful results: compf
!   with respect to varying inputs: *temp *pres
!   Plus diff mem management of: temp:in pres:in
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
!>    @brief compf calculates compressibility of pure water
!>    @param[in] i cell index, direction I0
!>    @param[in] j cell index, direction J0
!>    @param[in] k cell index, direction K0
!>    @param[in] ismpl local sample index
!>    @return  compressibility                     compf  [1./Pa]
!>    @details
!>    compf calculates compressibility of pure water \n
!>    given temperature (t, in C), and pressure (p,in Pa)\n
!>    at node(plocal,tlocal).\n
!>    method: compf = 1/rhof d/dP rhof, rhof= fluid density.\n
!>    derived from the formulation given in:\n
!>          zylkovskij et al: models and methods summary for\n
!>          the fehmn application,\n
!>           ecd 22, la-ur-94-3787, los alamos nl, 1994.\n
!>    range of validity:\n
!>                   pressures      0.01 - 110 MPa,\n
!>                   temperature   0.001 - 350 �C and -46�C - 0�C\n
!>    input:\n
!>      pressure                               plocal [Pa]\n
!>      temperature                         tlocal in [C]\n
DOUBLE PRECISION FUNCTION g_COMPF(i, j, k, ismpl, compf)
  USE ARRAYS

  USE g_ARRAYS

  USE MOD_FLOW
  IMPLICIT NONE
  INTEGER :: i, j, k, ismpl
  DOUBLE PRECISION :: cf(20), bf(6)
  DOUBLE PRECISION :: ta, tb, da, db, b2, rhof_loc, drhodp, t, t2, t3, &
& tlocal, tred, p, p2, p3, p4, plocal, tp, t2p, tp2
  DOUBLE PRECISION :: g_ta, g_tb, g_da, g_db, g_b2, &
& g_rhof_loc, g_drhodp, g_t, g_t2, g_t3, g_tlocal, g_tred&
& , g_p, g_p2, g_p3, g_plocal, g_tp, g_t2p, g_tp2
  INTRINSIC SQRT
  DOUBLE PRECISION :: result1
  DOUBLE PRECISION :: g_result1
  DOUBLE PRECISION :: temp0
  DOUBLE PRECISION :: compf
  DATA cf /0.10000000d+01, 0.17472599d-01, -0.20443098d-04, -&
&      0.17442012d-06, 0.49564109d-02, -0.40757664d-04, 0.50676664d-07, &
&      0.50330978d-04, 0.33914814d-06, -0.18383009d-06, 0.10009476d-02, &
&      0.16812589d-04, -0.24582622d-07, -0.17014984d-09, 0.48841156d-05&
&      , -0.32967985d-07, 0.28619380d-10, 0.53249055d-07, 0.30456698d-09&
&      , -0.12221899d-09/
!     new: after Speedy (1987) for T < 0 to -46 C
  DATA bf /20.d0, 4.12d0, -1.13d0, 77.817d0, -78.143d0, 54.29d0/
!     end new
  g_plocal = pa_conv1*g_pres(i, j, k, ismpl)
  plocal = pres(i, j, k, ismpl)*pa_conv1
  g_tlocal = g_temp(i, j, k, ismpl)
  tlocal = temp(i, j, k, ismpl)
  IF (tlocal .LT. -45d0) THEN
    tlocal = -45.d0
    g_tlocal = 0.D0
  END IF
  IF (tlocal .LT. 0.d0) THEN
!     new: after Speedy (1987) for T < 0 to -46 C
    g_tred = g_tlocal/227.15d0
    tred = (tlocal+273.15d0-227.15d0)/227.15d0
    temp0 = SQRT(tred)
    IF (tred .EQ. 0.0) THEN
      g_result1 = 0.D0
    ELSE
      g_result1 = g_tred/(2.0*temp0)
    END IF
    result1 = temp0
    temp0 = bf(1)/result1
    g_compf = (bf(3)+bf(4)*2*tred+bf(5)*3*tred**2+bf(6)*4*tred**3)*&
&     g_tred - temp0*g_result1/result1
    compf = bf(2) + temp0 + bf(3)*tred + bf(4)*(tred*tred) + bf(5)*(tred&
&     *tred*tred) + bf(6)*tred**4
    g_compf = 1.d-11*g_compf
    compf = compf*1.d-11
  ELSE
!     end new
    IF (tlocal .GT. 300.d0) THEN
      tlocal = 300.d0
      g_tlocal = 0.D0
    END IF
    g_p = g_plocal
    p = plocal
    g_t = g_tlocal
    t = tlocal
    g_p2 = 2*p*g_p
    p2 = p*p
    g_p3 = p*g_p2 + p2*g_p
    p3 = p2*p
    p4 = p3*p
    g_t2 = 2*t*g_t
    t2 = t*t
    g_t3 = t*g_t2 + t2*g_t
    t3 = t2*t
    g_tp = t*g_p + p*g_t
    tp = p*t
    g_t2p = p*g_t2 + t2*g_p
    t2p = t2*p
    g_tp2 = p2*g_t + t*g_p2
    tp2 = t*p2
! liquid density
    g_ta = cf(2)*g_p + cf(3)*g_p2 + cf(4)*g_p3 + cf(5)*g_t + &
&     cf(6)*g_t2 + cf(7)*g_t3 + cf(8)*g_tp + cf(10)*g_t2p + cf(9&
&     )*g_tp2
    ta = cf(1) + cf(2)*p + cf(3)*p2 + cf(4)*p3 + cf(5)*t + cf(6)*t2 + cf&
&     (7)*t3 + cf(8)*tp + cf(10)*t2p + cf(9)*tp2
    g_tb = cf(12)*g_p + cf(13)*g_p2 + cf(14)*g_p3 + cf(15)*g_t&
&     + cf(16)*g_t2 + cf(17)*g_t3 + cf(18)*g_tp + cf(20)*g_t2p +&
&     cf(19)*g_tp2
    tb = cf(11) + cf(12)*p + cf(13)*p2 + cf(14)*p3 + cf(15)*t + cf(16)*&
&     t2 + cf(17)*t3 + cf(18)*tp + cf(20)*t2p + cf(19)*tp2
    g_rhof_loc = (g_ta-ta*g_tb/tb)/tb
    rhof_loc = ta/tb
! derivative C   C2+2*C3*p+3*C4*p^2+C8*t+C10*t^2+2*C9*t*p
    g_da = cf(3)*2.d0*g_p + cf(4)*3.d0*g_p2 + cf(8)*g_t + cf(9)*&
&     2.d0*g_tp + cf(10)*g_t2
    da = cf(2) + 2.d0*cf(3)*p + 3.d0*cf(4)*p2 + cf(8)*t + 2.d0*cf(9)*tp &
&     + cf(10)*t2
! derivative C12+2*C13*p+3*C14*p^2+C18*t+C20*t^2+2*C19*t*p
    g_db = cf(13)*2.d0*g_p + cf(14)*3.d0*g_p2 + cf(18)*g_t + cf(&
&     19)*2.0*g_tp + cf(20)*g_t2
    db = cf(12) + 2.d0*cf(13)*p + 3.d0*cf(14)*p2 + cf(18)*t + 2.0*cf(19)&
&     *tp + cf(20)*t2
    g_b2 = 2*tb*g_tb
    b2 = tb*tb
    temp0 = (da*tb-ta*db)/b2
    g_drhodp = (tb*g_da+da*g_tb-db*g_ta-ta*g_db-temp0*g_b2)/&
&     b2
    drhodp = temp0
!      Compf=rhof_loc/drhodp
!      Compf=rhof_loc
    g_compf = 1.e-6*(g_drhodp-drhodp*g_rhof_loc/rhof_loc)/rhof_loc
    compf = 1.e-6*drhodp/rhof_loc
  END IF
  RETURN
END FUNCTION g_COMPF

!        Generated by TAPENADE     (INRIA, Ecuador team)
!  tapenade 3.x
!
!  Differentiation of cpf in reverse (adjoint) mode (with options noISIZE i8):
!   gradient     of useful results: *temp *pres cpf
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
!>    @brief cpf(i,j,k,ismpl) calculates the isobaric heat capacity in (in J/kg/K)
!>    @param[in] i cell index, direction I0
!>    @param[in] j cell index, direction J0
!>    @param[in] k cell index, direction K0
!>    @param[in] ismpl local sample index
!>    @return cpf [J/kg/K]
!>    @details
!>    cpf(i,j,k,ismpl) calculates the isobaric heat capacity in (in J/kg/K)\n
!>    of pure water, given temperature (t, in C), and pressure (p,in Pa)\n
!>    at node(i,j,k).\n
!>    method: c_p = d/dT E, E= fluid enthaply.\n
!>    derived from the formulation given in:\n
!>          zylkovskij et al: models and methods summary for\n
!>          the fehmn application,\n
!>          ecd 22, la-ur-94-3787, los alamos nl, 1994.\n
!>          Speedy, R.J. (1987) Thermodynamic properties of supercooled water \n
!>          at 1 atm. Journal of Physical Chemistry, 91: 3354–3358. \n
!>    range of validity:\n
!>                   pressures      0.01 - 110 MPa,\n
!>                   temperature   0.001 - 350 °c\n
!>    input:\n
!>      pressure                            plocal [Pa]\n
!>      temperature                         tlocal in [C]\n
SUBROUTINE CPF_AD(i, j, k, ismpl, cpf_adv)
  use arrays

  USE ARRAYS_AD

  USE MOD_FLOW
  IMPLICIT NONE
  double precision :: cpf_adv
  INTEGER :: i, j, k, ismpl
  DOUBLE PRECISION :: plocal, tlocal, enth, denthdt, tred, p, p1, p2, p3&
& , p4, t, t1, t2, t3, tp, t2p, tp2, ta, tb, da, db, b2
  DOUBLE PRECISION :: plocal_ad, tlocal_ad, denthdt_ad, tred_ad, p_ad, &
& p2_ad, p3_ad, t_ad, t2_ad, t3_ad, tp_ad, t2p_ad, tp2_ad, ta_ad, tb_ad&
& , da_ad, db_ad, b2_ad
  DOUBLE PRECISION :: cf(20), bf(6)
  INTRINSIC SQRT
  DOUBLE PRECISION :: temp0
  DOUBLE PRECISION :: temporary_ad
  INTEGER :: branch
  DOUBLE PRECISION :: cpf
  DATA cf /0.25623465d-3, 0.10184405d-2, 0.22554970d-4, 0.34836663d-7, &
&      0.41769866d-2, -0.21244879d-4, 0.25493516d-7, 0.89557885d-4, &
&      0.10855046d-6, -0.21720560d-6, 0.10000000d+1, 0.23513278d-1, &
&      0.48716386d-4, -0.19935046d-8, -0.50770309d-2, 0.57780287d-5, &
&      0.90972916d-9, -0.58981537d-4, -0.12990752d-7, 0.45872518d-8/
!     new: after Speedy (1987) for T < 0 to -46 C
  DATA bf /14.2d0, 25.952d0, 128.281d0, -221.405d0, 196.894d0, -64.812d0&
&     /
!     end new
  plocal = pres(i, j, k, ismpl)*pa_conv1
  tlocal = temp(i, j, k, ismpl)
  IF (tlocal .LT. -45d0) THEN
    tlocal = -45.d0
    CALL PUSHCONTROL1B(0)
  ELSE
    CALL PUSHCONTROL1B(1)
  END IF
  IF (tlocal .LT. 0.d0) THEN
!     new: after Speedy (1987) for T < 0 to -46 C
    tred = (tlocal+273.15d0-227.15d0)/227.15d0
    cpf_adv = 1000.d0*0.99048992406520d0*cpf_adv/18.d0
    temp0 = SQRT(tred)
    IF (tred .EQ. 0.0) THEN
      tred_ad = (bf(3)+2*tred*bf(4)+3*tred**2*bf(5)+4*tred**3*bf(6))*&
&       cpf_adv
    ELSE
      tred_ad = (bf(3)+2*tred*bf(4)+3*tred**2*bf(5)+4*tred**3*bf(6)-bf(1&
&       )/(2.0*temp0**3))*cpf_adv
    END IF
    tlocal_ad = tred_ad/227.15d0
    plocal_ad = 0.D0
  ELSE
!     end new
    IF (tlocal .GT. 300.d0) THEN
      tlocal = 300.d0
      CALL PUSHCONTROL1B(0)
    ELSE
      CALL PUSHCONTROL1B(1)
    END IF
    p = plocal
    t = tlocal
    p2 = p*p
    p3 = p2*p
    t2 = t*t
    t3 = t2*t
    tp = p*t
    t2p = t2*p
    tp2 = t*p2
! enthalpy
    ta = cf(1) + cf(2)*p + cf(3)*p2 + cf(4)*p3 + cf(5)*t + cf(6)*t2 + cf&
&     (7)*t3 + cf(8)*tp + cf(10)*t2p + cf(9)*tp2
    tb = cf(11) + cf(12)*p + cf(13)*p2 + cf(14)*p3 + cf(15)*t + cf(16)*&
&     t2 + cf(17)*t3 + cf(18)*tp + cf(20)*t2p + cf(19)*tp2
! derivative
    da = cf(5) + 2.d0*cf(6)*t + 3.d0*cf(7)*t2 + cf(8)*p + 2.d0*cf(10)*tp&
&     + cf(9)*p2
    db = cf(15) + 2.d0*cf(16)*t + 3d0*cf(17)*t2 + cf(18)*p + 2.d0*cf(20)&
&     *tp + cf(19)*p2
    b2 = tb*tb
    denthdt_ad = 1.d6*cpf_adv
    da_ad = denthdt_ad/tb
    temporary_ad = -(denthdt_ad/b2)
    ta_ad = db*temporary_ad
    db_ad = ta*temporary_ad
    b2_ad = -(ta*db*temporary_ad/b2)
    tb_ad = 2*tb*b2_ad - da*denthdt_ad/tb**2
    tp_ad = 2.d0*cf(20)*db_ad + 2.d0*cf(10)*da_ad + cf(18)*tb_ad + cf(8)&
&     *ta_ad
    p3_ad = cf(14)*tb_ad + cf(4)*ta_ad
    t3_ad = cf(17)*tb_ad + cf(7)*ta_ad
    t2p_ad = cf(20)*tb_ad + cf(10)*ta_ad
    t2_ad = 3d0*cf(17)*db_ad + 3.d0*cf(7)*da_ad + cf(16)*tb_ad + cf(6)*&
&     ta_ad + p*t2p_ad + t*t3_ad
    tp2_ad = cf(19)*tb_ad + cf(9)*ta_ad
    t_ad = 2.d0*cf(16)*db_ad + 2.d0*cf(6)*da_ad + cf(15)*tb_ad + cf(5)*&
&     ta_ad + p2*tp2_ad + p*tp_ad + t2*t3_ad + 2*t*t2_ad
    p2_ad = cf(19)*db_ad + cf(9)*da_ad + cf(13)*tb_ad + cf(3)*ta_ad + t*&
&     tp2_ad + p*p3_ad
    p_ad = cf(18)*db_ad + cf(8)*da_ad + cf(12)*tb_ad + cf(2)*ta_ad + t2*&
&     t2p_ad + t*tp_ad + p2*p3_ad + 2*p*p2_ad
    tlocal_ad = t_ad
    plocal_ad = p_ad
    CALL POPCONTROL1B(branch)
    IF (branch .EQ. 0) tlocal_ad = 0.D0
  END IF
  CALL POPCONTROL1B(branch)
  IF (branch .EQ. 0) tlocal_ad = 0.D0
  temp_ad(i, j, k, ismpl) = temp_ad(i, j, k, ismpl) + tlocal_ad
  pres_ad(i, j, k, ismpl) = pres_ad(i, j, k, ismpl) + pa_conv1*plocal_ad
END SUBROUTINE CPF_AD

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

! ******************************************************
!   WARNING: need 32 Bit version of the HDF5 library !
! ******************************************************

!>    @brief reads an 3-dimensional array HDF5 file
!>    @param[in] NI 1.dimension
!>    @param[in] NJ 2.dimension
!>    @param[in] NK 3.dimension
!>    @param[in] A_name array name
!>    @param[in] f_name hdf5 file name
!>    @param[out] A double precision array with all readed data
!>    @details
!>    This routine is used to open external hdf5 files specified in
!>    the SHEMAT-Suite input file and read a double precision array.
      SUBROUTINE read_hdf5(ni,nj,nk,a,a_name,f_name)
#ifndef noHDF
        USE hdf5
        use mod_hdf5_vars, only: file_id, error
#endif
        use mod_linfos
        IMPLICIT NONE

!      arrayname and filename
        character (len=*) :: a_name, f_name

        INTEGER ni, nj, nk
        DOUBLE PRECISION a(ni,nj,nk)

#ifndef noHDF
!      Dataset identifier
        INTEGER (hid_t) dset_id

!      Data type identifier
        INTEGER (hid_t) dtype_id
#endif

#ifndef noHDF
!      Data buffers
        INTEGER (hsize_t) data_dims(7)
#endif

#ifndef noHDF

        data_dims(1) = ni
        data_dims(2) = nj
        data_dims(3) = nk

!     Open hdf5 file if closed
        CALL closeopen_hdf5(f_name)

!      Access dataset 'A' in the first file under 'A_name' name.
        CALL h5dopen_f(file_id,a_name,dset_id,error)

        IF (error/=0) THEN
          WRITE(*,*)
          WRITE(*,'(5A)') 'error: no array "', a_name, &
            '" on    the file "', f_name, '" !!!'
          IF (a_name=='head') THEN
            WRITE(*,'(2A)') '*** May be an old "phi" style file,', &
              ' then change it to "head" ! ***'
            WRITE(*,'(1A)') ' -> try to find "phi" ...'
            WRITE(*,*)
            CALL h5dopen_f(file_id,'phi',dset_id,error)
            GO TO 300
          END IF
          WRITE(*,*)
          STOP
        END IF
300     CONTINUE

!      Get dataset's data type.
        CALL h5dget_type_f(dset_id,dtype_id,error)

!      Read the dataset in 'A'.
!AW      call h5dread_f(dset_id, dtype_id, A, data_dims, error)
        CALL h5dread_f(dset_id,h5t_native_double,a,data_dims,error)

        IF (error/=0) THEN
          WRITE(*,'(5A)') 'error: can not read the array "', a_name, &
            '" on the file "', f_name, '" !'
          STOP
        END IF

!      Close file, dataset and dataspace identifiers.
        CALL h5dclose_f(dset_id,error)
        CALL h5tclose_f(dtype_id,error)

        IF (linfos(1)>=1) WRITE(*,*) '  open HDF5 file: ', f_name

#else
        WRITE(*,*) 'error: HDF5 support was not compiled in'
        STOP
#endif
        RETURN
      END

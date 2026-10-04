c-----------------------------------------------------------------------
c  GFCOMPAT.f  -  portability shims for building DLEARN with gfortran
c
c  Provides the Microsoft Fortran PowerStation extension GETTIM used by
c  subroutine TIMING (DL2) on top of the standard DATE_AND_TIME intrinsic.
c  Added 2026 for the dlearn-ppd repository; not part of the original code.
c-----------------------------------------------------------------------
      subroutine gettim(ihr,imin,isec,ihund)
      integer*4 ihr,imin,isec,ihund
      integer iv(8)
      call date_and_time(values=iv)
      ihr   = iv(5)
      imin  = iv(6)
      isec  = iv(7)
      ihund = iv(8)/10
      return
      end

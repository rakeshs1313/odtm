         subroutine stability_check ()
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c
c       subroutine to ensure the stability of layer is maintained
c       
c       Writen on: 20-Feb-2017
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
            use size_mod, only : i, j, k, taun, km, tr01_max, rkmh, tr02_max
            use size_mod, only : tr02_min, t, zdz, h, tr01_min
            use presgrad_mod, only : density_nonlinear
        implicit none
        real :: rho_local(km), rtemp, rsalt, rDep
        integer :: kk, icheck, iter


        do kk=1,km-1

       if(t(i,j,kk,1,taun) .gt. tr01_max(kk))
     &   t(i,j,kk,1,taun)=tr01_max(kk)*rkmh(i,j)
       if(t(i,j,kk,2,taun) .gt. tr02_max(kk))
     &   t(i,j,kk,2,taun)=tr02_max(kk)*rkmh(i,j)

       if(t(i,j,kk,1,taun) .lt. tr01_min(kk))
     &   t(i,j,kk,1,taun)=tr01_min(kk)*rkmh(i,j)
       if(t(i,j,kk,2,taun) .lt. tr02_min(kk))
     &   t(i,j,kk,2,taun)=tr02_min(kk)*rkmh(i,j)

        enddo

        do iter = 1,0 !Prajeesh why checking 100 times
        icheck = 0
        
        write(*,*) 'In stability check: iter = ', iter
        do kk=1,km
         rTemp = t(i,j,kk,1,taun)
         rSalt = t(i,j,kk,2,taun)
         rDep = zdz(kk)
         rho_local(kk) = density_nonlinear (rTemp, rSalt, rDep) * rkmh(i,j)
        enddo

        do kk=2,km
        if ( rho_local(kk)*rkmh(i,j) .lt. rho_local(kk-1)*rkmh(i,j)) then
        t(i,j,kk,1,taun) = (
     &   (t(i,j,kk,1,taun)*h(i,j,kk,taun) + 
     &    t(i,j,kk-1,1,taun)*h(i,j,kk-1,taun))/
     &   (h(i,j,kk,taun) + 
     &    h(i,j,kk-1,taun)) )*rkmh(i,j)
        
        t(i,j,kk-1,1,taun) = t(i,j,kk,1,taun) * rkmh(i,j)
        
        icheck = 1
        endif
        enddo

        if (icheck .eq. 0) goto 125
        
        enddo

 125    continue

        do iter = 1,0
        icheck = 0
        
        do kk=1,km
         rTemp = t(i,j,kk,1,taun)
         rSalt = t(i,j,kk,2,taun)
         rDep = zdz(kk)
         rho_local(kk) = density_nonlinear (rTemp, rSalt, rDep)*rkmh(i,j)
        enddo

        do kk=2,km
        if ( rho_local(kk)*rkmh(i,j) .lt. rho_local(kk-1)*rkmh(i,j)) then
        
        t(i,j,kk,2,taun) = (
     &   (t(i,j,kk,2,taun)*h(i,j,kk,taun) + 
     &    t(i,j,kk-1,2,taun)*h(i,j,kk-1,taun))/
     &   (h(i,j,kk,taun) +  
     &    h(i,j,kk-1,taun)) )*rkmh(i,j)

        t(i,j,kk-1,2,taun) = t(i,j,kk,2,taun) * rkmh(i,j)

        icheck = 1

        endif
        enddo

        if (icheck .eq. 0) goto 126
        
        enddo

 126    continue

        return
        end subroutine

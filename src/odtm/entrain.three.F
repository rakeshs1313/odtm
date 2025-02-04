	subroutine entrain_detrain
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c
c
c	attempt to impliment artificial entrainment term
c	McCreary and Lu (1994), J.P.O, Vol.24, pp. 466-497
c
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
            use size_mod, only : we, wd, h, hd, he, i, j, k, rkmh, taun
            use size_mod, only : isc, iec, jsc, jec, km
            use param_mod, only : td, te
        implicit none
        real :: rwesum
	rwesum = 0.0
	we(:,:,:) = 0.0
	wd(:,:,:) = 0.0
c
c entrain from layer below to layer above if mass receds he(k)
c
	
	do k=1,km-1
	do i=isc, iec
	do j=jsc, jec
	
	if (he(k) .gt. h(i,j,k,taun) )  then
	 we(i,j,k) =  rkmh(i,j) *( he(k) - h(i,j,k,taun) )**2
     &           /(he(k)*te)
	 wd(i,j,k+1) =  -1.0*rkmh(i,j) *( he(k) - h(i,j,k,taun) )**2
     &           /(he(k)*te)
	
         wd(i,j,km) = 0.0
	endif

	enddo
	enddo
	enddo
	
c
c detrain from layer above to below if mass exceeds hd(k)
c
	do k=1,km-1
        do i=isc, iec
        do j=jsc, jec

        if (hd(k) .lt. h(i,j,k,taun) )  then
         wd(i,j,k) =  wd(i,j,k) - rkmh(i,j)*(hd(k)-h(i,j,k,taun))**2
     &           /(hd(k)*td)
         we(i,j,k+1) =  we(i,j,k+1) + rkmh(i,j)*(hd(k)-h(i,j,k,taun))**2
     &           /(hd(k)*td)

        endif

        enddo
        enddo
        enddo

	return
	stop
	end

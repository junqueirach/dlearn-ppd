c new ***********************************************************
c
c        Subrotina que monta k (riglob), m (xmasglob) e 
c
c         condiþ§es iniciais
c   
c     ***********************************************************
c
      subroutine km(alhs,alhk,idiag,nalhs,neq)
c
      implicit double precision (a-h,o-z)
c
c     Deactivate above comand(s) for single-precision operation
c
      common /iounit/ iin,iout,irsin,irsout
      common /mass  / imass
      common /system/ riglob(100,100),xmasglob(100,100),xi(200),
     &                 xm(200,200),xn(200,200),q(200,200),r(200,200),
     &                 pi10(200),b(200),pi1(200)
      dimension alhs(1),alhk(1),idiag(1)
c
c     ***********************************************
c
c       Montagem de Riglob e Xmasglob
c
c     ***********************************************
c
c       RecuperaþÒo do triÔngulo superior de matriz simÚtrica a
c       partir de vetor armazenado por altura efetiva de coluna
c
      do 50 iz=1,neq
      do 50 jz=1,neq
      riglob(iz,jz)  = 0.0
   50 xmasglob(iz,jz)=0.0
      riglob(1,1)   = alhk(1)
      xmasglob(1,1) = alhs(1)
c
      do 100 j = 2,neq
c
         do 200 i = j + 1 - (idiag(j) - idiag(j-1)),j
c
              riglob(i,j)   = alhk(idiag(j)-(j-i))
              xmasglob(i,j) = alhs(idiag(j)-(j-i))
c
              riglob(j,i)   = riglob(i,j)
              xmasglob(j,i) = xmasglob(i,j)
c
  200    continue
c
  100 continue
c
c
c
c      Impressao provisoria
c
      do 12 ii=1,8
      write(iout,11)(xmasglob(ii,jj),jj=1,8)
c      write(iout,11)alhk(ii)
   12 continue
   11 format(8(1pe15.8),/)
c   13 format(5x,i5)
c
c          Fim da impressÒo provis¾ria
c     *************************************************
c
c        Chamada da rotina para inversÒo de xmasglob
c           (A inversa Ú guardada na pr¾pria)
c
c     *************************************************
c
      if (imass.ne.2) call inverm(neq)
c      write (iout,99)((xmasglob(i,j),i=1,neq),j=1,neq),imass
c   99 format(4(1x,1pe20.8),i5)
c
      return
      end
c
c new **************************************************************
c
c        Montagem do sistema:
c
c       [M]{x(i+1)} = - [N]{x(i)} + [Q]{p(i+1)} + [R]{p(i)}
c
c     **************************************************************
c
      subroutine montherm(neq,nstep1,dt1,brhs,brh2,id,acc)
c
      implicit double precision (a-h,o-z)
c
c     Deactivate above card(s) for single-precision operation
c
      dimension brhs(1),v(1),acc(1),d(1),aux(100),brh2(1)
      dimension xm11(100,100),xm12(100,100),xm21(100,100),xm22(100,100),
     &          xn11(100,100),xn12(100,100),xn21(100,100),xn22(100,100),
     &          q11(100,100),q12(100,100),q21(100,100),q22(100,100),
     &          r11(100,100),r12(100,100),r21(100,100),r22(100,100)
c
      common / system/ riglob(100,100),xmasglob(100,100),xi(200),
     &                 xm(200,200),xn(200,200),q(200,200),r(200,200),
     &                 pi10(200),b(200),pi1(200)
      common /iounit /iin,iout,irsin,irsout
      common /info   /iexec,iacode,ldyn,ireadr,iwritr,iprtin,irank,
     &                numseq,ndout,nsd,numnp,ndof,nlvect,nltftn,nptslf,
     &                numeg,iordherm
c
c     *****************************************************************
c
c         Chamada dos algoritmos para montagem das matrizes
c
c     *****************************************************************
c
c      do 111 i = 1,neq
c      do 111 j = 1,neq
c  111 write(iout,99)i,j,xmasglob(i,j)
c  99 format(i5,2x,i5,2x,1pe20.8)
c      write(iout,1)iordherm
c    1 format(i5)
      go to (1000,2000,3000,4000) iordherm
c
 1000 continue
c
c     *****************************************************************
c
c          Algoritmo hermitiano de ordem 1
c
c     *****************************************************************
c
      do 100 i = 1,neq
c
          do 200 j = 1,neq
c
              do 300 k = 1,neq
c
                  xm11(i,j) = xm11(i,j) + xmasglob(i,k) * riglob(k,j)
c
  300         continue
c
              xm21(i,j) = - dt1*dt1*xm11(i,j)
              xm11(i,j) = -.5*xm21(i,j)
c
              if (i.eq.j) then
c
                  xm12(i,j) = 1.0
                  xn11(i,j) = 1.0
                  xn22(i,j) = 1.0
                  xm11(i,j) = xm11(i,j) - 1.0
c
              else
c
                  xm12(i,j) = 0.0
                  xn11(i,j) = 0.0
                  xn22(i,j) = 0.0
c
              endif
c
              xm22(i,j) = xm11(i,j)
              xn12(i,j) = 0.0
              xn21(i,j) = 0.0
              r11(i,j)  = 0.0
              r12(i,j)  = 0.0
              r21(i,j)  = 0.0
              r22(i,j)  = 0.0
              q11(i,j)  = .5*dt1*dt1*xmasglob(i,j)
              q21(i,j)  = -2*q11(i,j)
              q22(i,j)  = q11(i,j)
              q12(i,j)  = 0.0
c
c          ImpressÒo provis¾ria
c
c      write(iout,99)i,j,riglob(i,j),xmasglob(i,j)
c   99 format(4x,i5,4x,i5,2(3x,1pe20.8))
c
  200     continue
c
  100 continue
c
      go to 9000
c
 2000 continue
c
c     ***************************************************
c
c        Algoritmo hermitiano de ordem 2
c
c     ***************************************************
c
c      write(iout,1)iordherm
c    1 format(i5)
c
      do 2100 i = 1,neq
c
          do 2200 j = 1,neq
c
              do 2300 k = 1,neq
c
                  xm11(i,j) = xm11(i,j) + xmasglob(i,k)*riglob(k,j)
c
 2300         continue
c
              xm21(i,j) = 4*dt1*dt1*xm11(i,j)
              xm11(i,j) = -0.25*xm21(i,j)
c
              if(i.eq.j) then
c
                  xm12(i,j) = -4.0
                  xn11(i,j) = -6.0
                  xn12(i,j) = -2.0
                  xn22(i,j) = -6.0
                  xm11(i,j) = 6.0 + xm11(i,j)
c
              else
c
                  xm12(i,j) = 0.0
                  xn11(i,j) = 0.0
                  xn22(i,j) = 0.0
                  xn12(i,j) = 0.0
c
              endif
c
              xm22(i,j) = xm11(i,j)
              xn21(i,j) = 0.5*xm21(i,j)
              q11(i,j)  = -dt1*dt1*xmasglob(i,j)
              q12(i,j)  = 0.0                                                                                                                           
              q21(i,j)  = -4.0*q11(i,j)
              q22(i,j)  = q11(i,j)
              r11(i,j)  = 0.0
              r12(i,j)  = 0.0
              r21(i,j)  = -2.0*q11(i,j)
              r22(i,j)  = 0.0
c              
 2200     continue              
c
 2100 continue
c
      go to 9000
c
 3000 continue
c
c     ***************************************************
c
c         Algoritmo hermitiano de ordem 3
c
c     ***************************************************
c
c      write(iout,11) iordherm
c 11   format(i5)
c
      do 3110 i = 1,neq
c
          do 3110 j = 1,neq
c
              do 3110 k = 1,neq
c
                 r22(i,j) = r22(i,j) + dt1*dt1*xmasglob(i,k)*riglob(k,j)
c
 3110 continue
c
      do 3120 i = 1,neq
c
          do 3120 j = 1,neq
c
              do 3120 k = 1,neq
c
                  r11(i,j) = r11(i,j) + r22(i,k)*r22(k,j)
c
 3120 continue
c
      do 3130 i = 1,neq
c
          do 3130 j = 1,neq
c
              do 3130 k = 1,neq
c
                  r12(i,j) = r12(i,j) + dt1*dt1*r22(i,k)*xmasglob(k,j)
c
 3130 continue
c
      do 3100 i = 1,neq
c
          do 3200 j = 1,neq
c
              xm11(i,j) = 6*r22(i,j)
              xm12(i,j) = -r22(i,j)
              xm21(i,j) = -18*r22(i,j)+r11(i,j)
c
              xn21(i,j) = -6*r22(i,j)
              q11(i,j) = 6*dt1*dt1*xmasglob(i,j)
              q12(i,j) = -q11(i,j)/6
              q21(i,j) = r12(i,j) - 3*q11(i,j)
              q22(i,j) = q11(i,j)
              xn11(i,j) = 0.0
              xn12(i,j) = 0.0
              xn22(i,j) = 0.0
              r11(i,j) = 0.0
              r12(i,j) = 0.0
              r21(i,j) = -q22(i,j)
              r22(i,j) = 0.0
c
              if (i.eq.j) then
c
                  xm11(i,j) = xm11(i,j) - 24.0
                  xm12(i,j) = xm12(i,j) + 18.0
                  xn11(i,j) = 24.0
                  xn12(i,j) = 6.0
                  xn22(i,j) = 24.0
c
              endif
c
              xm22(i,j) = xm11(i,j)
c
 3200     continue
c
 3100 continue
c
      go to 9000
c
 4000 continue
c
c     *************************************************
c
c       Algoritmo hermitiano de ordem 4
c
c     *************************************************
c
c      write(iout,11)iordherm
c
      do 4105 i = 1,neq
          do 4105 j = 1,neq
c
              xn21(i,j) = 0.0
              r12(i,j)  = 0.0
              q21(i,j)  = 0.0
c
 4105 continue
      do 4110 i = 1,neq
c
          do 4110 j = 1,neq
c
              do 4110 k = 1,neq
c
               xn21(i,j) = xn21(i,j) + dt1*dt1*xmasglob(i,k)*riglob(k,j)
c
 4110 continue
c
      do 4120 i = 1,neq
c
          do 4120 j = 1,neq
c
              do 4120 k = 1,neq
c
                  r12(i,j) = r12(i,j) + xn21(i,k)*xn21(k,j)
                  q21(i,j) = q21(i,j) + dt1*dt1*xn21(i,k)*xmasglob(k,j)
c
 4120 continue
c
      do 4100 i = 1,neq
c
          do 4200 j = 1,neq
c
              xm11(i,j) = 9*xn21(i,j)
              xm12(i,j) = -xn21(i,j)
              xm21(i,j) = r12(i,j) - 36*xn21(i,j)
c
              xn11(i,j) = -3*xn21(i,j)
              xn12(i,j) = 0.0
c
              q11(i,j) = 9*dt1*dt1*xmasglob(i,j)
              q12(i,j) = -q11(i,j)/9
              q22(i,j) = q11(i,j)
c
              r11(i,j) = -q11(i,j)/3
              r21(i,j) = -8*q11(i,j)/3
c
              if(i.eq.j) then
c
                  xm11(i,j) = xm11(i,j) - 60.0
                  xm12(i,j) = xm12(i,j) + 36.0
                  xn11(i,j) = xn11(i,j) + 60.0
                  xn12(i,j) = 24.0
c
              else
c
                  continue
c
              endif
c
              xm22(i,j) = xm11(i,j)
              xn22(i,j) = xn11(i,j)
              xn21(i,j) = -24*xn21(i,j)
              q21(i,j) = -4*q11(i,j) + q21(i,j)
              r12(i,j) = 0.0        
              r22(i,j) = r11(i,j)
c
 4200     continue
c
 4100 continue
c
      go to 9000
c
 5000 continue
c
c     **********************************************
c
c     Algoritmo hermitiano de ordem 5
c
c     **********************************************
c              
      go to 9000
c
c     ***************************************************
c
c        Montagem do sistema para o instante i + 1
c
c     ***************************************************
c
 9000 continue
c
      do 400 i = 1,neq
c
          do 500 j = 1,neq
c
              xm(i,j)         = xm11(i,j)
              xm(i+neq,j+neq) = xm22(i,j)
              xm(i+neq,j)     = xm21(i,j)
              xm(i,j+neq)     = xm12(i,j)
c
              xn(i,j)         = xn11(i,j)
              xn(i+neq,j+neq) = xn22(i,j)
              xn(i+neq,j)     = xn21(i,j)
              xn(i,j+neq)     = xn12(i,j)
c
              q(i,j)         = q11(i,j)
              q(i+neq,j+neq) = q22(i,j)
              q(i+neq,j)     = q21(i,j)
              q(i,j+neq)     = q12(i,j)
c
              r(i,j)         = r11(i,j)
              r(i+neq,j+neq) = r22(i,j)
              r(i+neq,j)     = r21(i,j)
              r(i,j+neq)     = r12(i,j)
c
  500     continue
c
              pi1(i)         = brhs(i)
              pi1(i+neq)     = pi1(i) - pi10(i)
c
  400 continue
c
      call clear(b,2*neq)
c
      do 700 i = 1,2*neq
c
          do 800 j = 1,2*neq
c
              b(i) = b(i) - xn(i,j)*xi(j) + q(i,j)*pi1(j) + 
     &               r(i,j)*pi10(j)
c
  800     continue
c
          pi10(i) = pi1(i)
c
  700 continue
c
c       ImpressÒo provis¾ria
c
c      do 501 i = 1, neq
c  501 write(iout,502)i,brh2(i)
c  502 format(i5,3x,1pe20.8)
c
c     **********************************************************
c
c     SoluþÒo do sistema para o instante i + 1
c
c     **********************************************************
c
      call solsispla(ierro2,neq)
c
c        ImpressÒo provis¾ria
c
c      do 10 i = 1,neq
c
c          d(i) = xi(i)
c          v(i) = xi(i+neq)/dt1
c          ac(i) = 0.0
c
   10 continue
c
c     *************************************************
c
c        Cßlculo da aceleraþÒo
c
c     *************************************************
c
c      do 600 i = 1,2*neq
c      write(iout,96)i,brhs(i)
c   96 format(i5,5x,1pe20.8)
c  600 continue
c
      do 14 jj = 1,neq
c
          aux2    = 0.0
          aux(jj) = 0.0
c
          do 15 kk = 1,neq
c
   15         aux2 = aux2 + riglob(jj,kk)*xi(kk)
c
   14 aux(jj) = brhs(jj) - aux2
c
      do 18 ik = 1,neq
c
          acc(ik) = 0.0  
c
          do 18 jj = 1,neq
c
  18         acc(ik) = acc(ik) + xmasglob(ik,jj)*aux(jj)
c
c      do 600 i = 1,2*neq
c      write(iout,96)i,xi(i)
c   96 format(i5,5x,1pe20.8)
c  600 continue
c    
      return
      end
c             
c new ***************************************************************
c
c       Subrotina para inverter matriz de massa
c
c     ***************************************************************
      subroutine inverm(neq)
c
      implicit double precision (a-h,o-z)
c
      common / system/ riglob(100,100),xmasglob(100,100),xi(200),
     &                 xm(200,200),xn(200,200),q(200,200),r(200,200),
     &                 pi10(200),b(200),pi1(200)
c
      common /mass  / imass
      common / iounit/ iin,iout,irsin,irsout
c
      write(iout,12)imass
   12 format(5x,i5)
c
c
c
      go to (100,200) (imass+1)
c
  100 continue

c
c
c ...   Rotina para inversÒo de matriz esparsa
c            (massa consistente)
c
      do 10 i = 1,neq
c
   10     xmasglob(i,i) = xmasglob(i,i) + 1.0D0
c
      do 20 m = 1,neq
c
          aux = xmasglob(m,m) - 1.0D0
c
          if(abs(aux).le.1.0D-12) go to 60
c
          do 30 j = 1,neq
c
   30     xmasglob(m,j) = xmasglob(m,j)/aux
c
          do 20 i = 1,neq
c
              if(i.eq.m) go to 20
              q1 = xmasglob(i,m)
c
              do 40 j = 1,neq
c
   40         xmasglob(i,j) = xmasglob(i,j) - q1*xmasglob(m,j)
c
   20 continue
c
      do 50 i = 1,neq
c
   50 xmasglob(i,i) = xmasglob(i,i) - 1.0D0
c
c     ImpressÒo provis¾ria
c
c      write(iout,91)
c   91 format(////,' inversa de m',///)
c
c      do 92 i = 1,neq
c   92 write(iout,93) (xmasglob(i,j),j=1,neq)
c   93 format(4(1pe20.8))
c
c     Fim da impressÒo provis¾ria
c
      go to 70
c
   60 write(iout,94) m
   94 format(///,'singularidade na linha: ',i5)
c
   70 return
c
  200 continue
c
c ...   Rotina para inversÒo de matriz diagonal
c            (massa concentrada)
c
      do 300 i = 1,neq
c
          xmasglob(i,i) = 1./xmasglob(i,i)
c
  300 continue
c
c     Impressao provisoria
c
      write(iout,11)
   11 format(' ','Passou aqui')
c
c     Fim da impressao
c
      return
      end
c
c     ****************************************************
c
c       Subrotina que resolve o sistema de equaþ§es - SOLSISPLA
c
c     ****************************************************
c
      subroutine solsispla(ierro2,neq)
c
      implicit double precision (a-h,o-z)
c
c     Deactivate above comand(s) for single-precision operation
c
      common / system/ riglob(100,100),xmasglob(100,100),xi(200),
     &                 xm(200,200),xn(200,200),q(200,200),r(200,200),
     &                 pi10(200),b(200),pi1(200)
c
c      EliminaþÒo de Gauss
c
      do 10 i = 1,2*neq-1
c
          aux1 = xm(i,i)
          ii = i+1
c
          if(dabs(aux1).lt.1.0d-10) then
c
              ierro2 = 1
              print*,'singularidade na linha ',i,' da matriz M'
c
          endif
c
          if(ierro2.eq.1)go to 50
c
c     ***********************************************
c
c      Dividindo a linha pelos coeficientes da diagonal
c
c     ***********************************************
c
          do 20 j = ii,2*neq
c
   20         xm(i,j) = xm(i,j)/aux1
              b(i)    = b(i)/aux1
c
c     ************************************************
c
c      Eliminando as inc¾gnitas xi(i) a partir da linha k
c
c     ************************************************
c
          do 10 k = ii,2*neq
c
              aux1 = xm(k,i)
              do 30 j = ii,2*neq
   30         xm(k,j) = xm(k,j) - aux1*xm(i,j)
c
   10 b(k) = b(k) - aux1*b(i)
c
      if(dabs(xm(2*neq,2*neq)).lt.1.0d-10) then
c
          ierro2 = 1
          print*,'singularidade na linha ',2*neq,'da matriz M'
c
      endif
c
      if(ierro2.eq.1) go to 50
c
c     ****************************************************
c
c       Cßlculo da ·ltima inc¾gnita
c
c     ****************************************************
c
      b(2*neq) = b(2*neq)/xm(2*neq,2*neq)
c
c     **************************************************
c
c       Processo de retrossubstituiþÒo
c
c     *************************************************
c
      do 40 i = 1,2*neq-1
c
          ii = 2*neq-i+1
c
          do 40 j = ii,2*neq
c
   40 b(ii-1) = b(ii-1) - xm(ii-1,j)*b(j)
c
      do 60 i = 1,2*neq
        xi(i) = b(i)
c        if(i.le.40) then
c        print*,xi(i)
c        endif
c
   60 continue
c
   50 return
      end      
c
c     ***************************************************
c
c      Subrotina para voltar as direþ§es originais
c
c     ***************************************************
c
      subroutine realoca(id,d,v,ac,acc,ndof,numnp,neq,dt1)
c
      implicit double precision(a-h,o-z)
c
c     Deactivate above card(s) for single-precision operation
c
      common / system/ riglob(100,100),xmasglob(100,100),xi(200),
     &                 xm(200,200),xn(200,200),q(200,200),r(200,200),
     &                 pi10(200),b(200),pi1(200)
      dimension id(ndof,1),d(ndof,1),v(ndof,1),acc(1),ac(ndof,1)
c
      do 200 i = 1,ndof
c
          do 100 j = 1,numnp
c
              k = id(i,j)
              if(k.gt.0) then
c
                  d(i,j)  = xi(k)
                  v(i,j)  = xi(k+neq)/dt1
                  ac(i,j) = acc(k)
c
              endif
c
  100     continue
c
  200 continue
c
      return
      end
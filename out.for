C ====================
C  OUTPUT OF SOLUTION
C ====================
C
      SUBROUTINE OUT
C
      COMMON /CONTR/ TITLE(18),NP,NE,NB,NDF,NCN,NLD,NMAT,NSZF,LI
      COMMON CORD(170,2),NOP(300,4),IMAT(300),ORT(25,2),NBC(60),NFIX(60)
     1      ,R1(500),SK(500,90),THICK(300)
     2      ,R(3),SHEAR(300)
C
C
      WRITE(*,610)
  610 FORMAT(1H ,'START SUBROUTINE OUTPUT')
C
      WRITE(36,620)
  620 FORMAT(1H , '============================================')
      WRITE(36,630)
  630 FORMAT(1H , ' GRID NO.      W        THETA-X     THETA-Y ')
      WRITE(36,620)
C
      DO 100 I=1,NP
        WRITE(36,640) I, R1(I*3-2), R1(I*3-1), R1(I*3)
  640 FORMAT(1H , I7,3X,3G12.5)
  100 CONTINUE
C
C --------------------------- SCAN ELEMENTS
         WRITE(36,660)
  660 FORMAT(1H , '============================',
     1            '=========================')
         WRITE(36,670)
  670 FORMAT(1H , ' ELEMENT NO.   X           Y           AREA',
     1            '        W')
         WRITE(36,660)
C
      DO 400 N=1,NE
C --------------------------- DEFORMATION AT ELEMENT CENTER
         X1=CORD(NOP(N,1),1)
         Y1=CORD(NOP(N,1),2)
         X2=CORD(NOP(N,2),1)
         Y2=CORD(NOP(N,2),2)
         X3=CORD(NOP(N,3),1)
         Y3=CORD(NOP(N,3),2)
C
         WELM=(R1(NOP(N,1)*3-2)+R1(NOP(N,2)*3-2)+R1(NOP(N,3)*3-2))/3.
C
         XCG=(X1+X2+X3)/3.0
         YCG=(Y1+Y2+Y3)/3.0
         X1A=X1-XCG
         Y1A=Y1-YCG
         X2A=X2-XCG
         Y2A=Y2-YCG
         X3A=X3-XCG
         Y3A=Y3-YCG
C
         AREA=0.5*(X2A*Y3A+X3A*Y1A+X1A*Y2A-X1A*Y3A-X2A*Y1A-X3A*Y2A)
C
         WRITE(36,680) N, XCG, YCG, AREA, WELM
  680 FORMAT(1H , I7,3X,4G12.5)
  400 CONTINUE
C
      RETURN
      END


C =======================
C  FORM STIFFNESS MATRIX
C =======================
C
      SUBROUTINE FORMK
      COMMON /CONTR/ TITLE(18),NP,NE,NB,NDF,NCN,NLD,NMAT,NSZF,LI
      COMMON CORD(900,2),NOP(900,4),IMAT(900),ORT(25,2),NBC(90),NFIX(90)
     1      ,R1(2700),SK(2700,180),THICK(900)
     2      ,R(3),SHEAR(900)
      DIMENSION XK(9,9),XK1(9,9),BDB(9,9),AINV(9,9),DUMMY(9,9),IXX(9)
C
C
      WRITE(*,610)
  610 FORMAT(1H ,'START SUBROUTINE FORMK')
C
C --------------------------- SET BANDMAX AND NO OF EQUATIONS
C
      NBAND=180
C
C --------------------------- ZERO STIFFNESS MATRIX
C
      DO 300 N=1,NSZF
      DO 300 M=1,NBAND
        SK(N,M)=0.0
  300 CONTINUE
C
C --------------------------- SCAN ELEMENTS
C
      DO 400 N=1,NE
C --------------------------- ELEMENT STIFFNESS MATRIX
         X1=CORD(NOP(N,1),1)
         Y1=CORD(NOP(N,1),2)
         X2=CORD(NOP(N,2),1)
         Y2=CORD(NOP(N,2),2)
         X3=CORD(NOP(N,3),1)
         Y3=CORD(NOP(N,3),2)
         TH=THICK(N)
         E=ORT(IMAT(N),1)
         V=ORT(IMAT(N),2)
         SH=SHEAR(N)
C
C ===================================================================
C     TRIANGULAR ELEMENT BENDING WITH TRANSVERSE SHEAR
C
         G=0.5*E/(1.0+V)
         D=E*TH**3/12.0/(1.0-V*V)
C
      CALL TRI_INT(AREA,X,Y,XY,X1,Y1,X2,Y2,X3,Y3)
C
C =======================
C  INVERSE MATRIX OF [A]
C =======================
C
      XCG=(X1+X2+X3)/3.0
      YCG=(Y1+Y2+Y3)/3.0
C
      X1A=X1-XCG
      Y1A=Y1-YCG
      X2A=X2-XCG
      Y2A=Y2-YCG
      X3A=X3-XCG
      Y3A=Y3-YCG
C
      AINV(1,1)=1.0
      AINV(1,2)=X1A
      AINV(1,3)=Y1A
      AINV(1,4)=0.0
      AINV(1,5)=-0.5*X1A*X1A
      AINV(1,6)=-0.5*X1A*Y1A
      AINV(1,7)=0.0
      AINV(1,8)=-0.5*X1A*Y1A
      AINV(1,9)=-0.5*Y1A*Y1A
C
      AINV(2,1)=1.0
      AINV(2,2)=X2A
      AINV(2,3)=Y2A
      AINV(2,4)=0.0
      AINV(2,5)=-0.5*X2A*X2A
      AINV(2,6)=-0.5*X2A*Y2A
      AINV(2,7)=0.0
      AINV(2,8)=-0.5*X2A*Y2A
      AINV(2,9)=-0.5*Y2A*Y2A
C
      AINV(3,1)=1.0
      AINV(3,2)=X3A
      AINV(3,3)=Y3A
      AINV(3,4)=0.0
      AINV(3,5)=-0.5*X3A*X3A
      AINV(3,6)=-0.5*X3A*Y3A
      AINV(3,7)=0.0
      AINV(3,8)=-0.5*X3A*Y3A
      AINV(3,9)=-0.5*Y3A*Y3A
C
      AINV(4,1)=0.0
      AINV(4,2)=0.0
      AINV(4,3)=0.0
      AINV(4,4)=1.0
      AINV(4,5)=X1A
      AINV(4,6)=Y1A
      AINV(4,7)=0.0
      AINV(4,8)=0.0
      AINV(4,9)=0.0
C
      AINV(5,1)=0.0
      AINV(5,2)=0.0
      AINV(5,3)=0.0
      AINV(5,4)=1.0
      AINV(5,5)=X2A
      AINV(5,6)=Y2A
      AINV(5,7)=0.0
      AINV(5,8)=0.0
      AINV(5,9)=0.0
C
      AINV(6,1)=0.0
      AINV(6,2)=0.0
      AINV(6,3)=0.0
      AINV(6,4)=1.0
      AINV(6,5)=X3A
      AINV(6,6)=Y3A
      AINV(6,7)=0.0
      AINV(6,8)=0.0
      AINV(6,9)=0.0
C
      AINV(7,1)=0.0
      AINV(7,2)=0.0
      AINV(7,3)=0.0
      AINV(7,4)=0.0
      AINV(7,5)=0.0
      AINV(7,6)=0.0
      AINV(7,7)=1.0
      AINV(7,8)=X1A
      AINV(7,9)=Y1A
C
      AINV(8,1)=0.0
      AINV(8,2)=0.0
      AINV(8,3)=0.0
      AINV(8,4)=0.0
      AINV(8,5)=0.0
      AINV(8,6)=0.0
      AINV(8,7)=1.0
      AINV(8,8)=X2A
      AINV(8,9)=Y2A
C
      AINV(9,1)=0.0
      AINV(9,2)=0.0
      AINV(9,3)=0.0
      AINV(9,4)=0.0
      AINV(9,5)=0.0
      AINV(9,6)=0.0
      AINV(9,7)=1.0
      AINV(9,8)=X3A
      AINV(9,9)=Y3A
C
      CALL MAINV1(AINV,9,DET)
C
C
C
      DO 1000 IX=1,9
        DO 1010 JX=1,9
            BDB(IX,JX)=0.0
            XK1(IX,JX)=0.0
            XK(IX,JX)=0.0
            DUMMY(IX,JX)=0.0
 1010   CONTINUE
 1000 CONTINUE
C
      BDB(2,2)=SH*TH*G*AREA
      BDB(2,4)=BDB(2,2)
      BDB(3,3)=BDB(2,2)
      BDB(3,7)=BDB(2,2)
      BDB(4,2)=BDB(2,2)
      BDB(4,4)=BDB(2,2)
      BDB(5,5)=D*AREA
      BDB(5,9)=V*D*AREA
      BDB(6,6)=0.5*(1.0-V)*D*AREA+0.25*SH*TH*G*(X+Y)
      BDB(6,8)=0.5*(1.0-V)*D*AREA-0.25*SH*TH*G*(X+Y)
      BDB(7,3)=BDB(2,2)
      BDB(7,7)=BDB(2,2)
      BDB(8,6)=0.5*(1.0-V)*D*AREA-0.25*SH*TH*G*(X+Y)
      BDB(8,8)=0.5*(1.0-V)*D*AREA+0.25*SH*TH*G*(X+Y)
      BDB(9,5)=V*D*AREA
      BDB(9,9)=D*AREA
C
      DO 1020 IX=1,9
        DO 1030 JX=1,9
            DO 1040 KX=1,9
                DUMMY(IX,JX)=DUMMY(IX,JX)+BDB(IX,KX)*AINV(KX,JX)
 1040       CONTINUE
 1030   CONTINUE
 1020 CONTINUE
C
      DO 1050 IX=1,9
        DO 1060 JX=1,9
            DO 1070 KX=1,9
                XK1(IX,JX)=XK1(IX,JX)+AINV(KX,IX)*DUMMY(KX,JX)
 1070       CONTINUE
 1060   CONTINUE
 1050 CONTINUE
C
      IXX(1)=1
      IXX(2)=4
      IXX(3)=7
      IXX(4)=2
      IXX(5)=5
      IXX(6)=8
      IXX(7)=3
      IXX(8)=6
      IXX(9)=9
C
      DO 1100 IX=1,9
        DO 1110 JX=1,9
            XK(IX,JX)=XK1(IXX(IX),IXX(JX))
 1110   CONTINUE
 1100 CONTINUE
C
C
C --------------------------- RETURNS XK(9,9) AS STIFFNESS MATRIX
C
C --------------------------- STORE XK IN SK
C
C --------------------------- FIRST, ROWS
C
         DO 350 JJ=1,NCN
           NROWB=(NOP(N,JJ)-1)*NDF
           DO 350 J=1,NDF
             NROWB=NROWB+1
             I=(JJ-1)*NDF+J
C
C --------------------------- THEN, COLUMNS
C
             DO 330 KK=1,NCN
               NCOLB=(NOP(N,KK)-1)*NDF
               DO 320 K=1,NDF
                 L=(KK-1)*NDF+K
                 NCOL=NCOLB+K+1-NROWB
C
C --------------------------- SKIP STORING IF BELOW BAND
C
                 IF(NCOL) 320,320,310
  310            SK(NROWB,NCOL)=SK(NROWB,NCOL)+XK(I,L)
  320          CONTINUE
  330        CONTINUE
  350    CONTINUE
  400 CONTINUE
C
C --------------------------- INSERT BOUNDARY CONDITION
C
      DO 500 N=1,NB
        NX=10**(NDF-1)
        I=NBC(N)
        NROWB=(I-1)*NDF
C
C --------------------------- EXAMINE EACH DEGREE OF FREEDOM
C
        DO 490 M=1,NDF
          NROWB=NROWB+1
          ICON=NFIX(N)/NX
          IF (ICON) 450,450,420
  420       SK(NROWB,1)=1.0
            R1(NROWB)=0.0
            DO 430 J=2,NBAND
              SK(NROWB,J)=0.0
              NR=NROWB+1-J
              IF (NR) 430,430,425
  425           SK(NR,J)=0.0
  430       CONTINUE
            NFIX(N)=NFIX(N)-NX*ICON
  450     NX=NX/10
  490   CONTINUE
  500 CONTINUE
C
C
      WRITE(*,650)
  650 FORMAT(1H ,'END SUBROUTINE FORMK')
C
C
      RETURN
      END


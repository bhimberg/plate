C =============================
C  ADD LOAD VECTOR OF PRESSURE
C =============================
C
      SUBROUTINE PLOAD
C
      COMMON /CONTR/ TITLE(18),NP,NE,NB,NDF,NCN,NLD,NMAT,NSZF,LI
      COMMON CORD(170,2),NOP(300,4),IMAT(300),ORT(25,2),NBC(60),NFIX(60)
     1      ,R1(500),SK(500,90),THICK(300)
     2      ,R(3),SHEAR(300),PRESSURE(300)
      DIMENSION AINV(9,9),XM(9),FP(9)
C
C
      WRITE(*,600)
  600 FORMAT(1H ,'START SUBROUTINE PLOAD')
C
C ----------------------------------- READ ELEMENT NUMBER AND PRESSURE
C
      PTOTAL=0.0
      READ(35,*)
C
  165 CONTINUE
      READ(35,*)  NPRESS,PRESS
      WRITE(36,9) NPRESS,PRESS
      PRESSURE(NPRESS)=PRESS
C
C
      X1=CORD(NOP(NPRESS,1),1)
      Y1=CORD(NOP(NPRESS,1),2)
      X2=CORD(NOP(NPRESS,2),1)
      Y2=CORD(NOP(NPRESS,2),2)
      X3=CORD(NOP(NPRESS,3),1)
      Y3=CORD(NOP(NPRESS,3),2)
C
      CALL TRI_INT(AREA,X,Y,XY, X1,Y1,X2,Y2,X3,Y3)
C
      PTOTAL=PTOTAL+PRESS*AREA
C
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
      XM(1)=AREA*PRESS
      XM(2)=0.0
      XM(3)=0.0
      XM(4)=0.0
      XM(5)=-0.5*X*PRESS
      XM(6)=-0.5*XY*PRESS
      XM(7)=0.0
      XM(8)=-0.5*XY*PRESS
      XM(9)=-0.5*Y*PRESS
C
      DO 100 I=1,9
        FP(I)=0.0
  100 CONTINUE
C
      DO 110 I=1,9
        DO 120 J=1,9
            FP(I)=FP(I)+AINV(J,I)*XM(J)
  120   CONTINUE
  110 CONTINUE
C
      R1((NOP(NPRESS,1)-1)*NDF+1) =  R1((NOP(NPRESS,1)-1)*NDF+1)
     *                             + FP(1)
      R1((NOP(NPRESS,1)-1)*NDF+2) =  R1((NOP(NPRESS,1)-1)*NDF+2)
     *                             + FP(4)
      R1((NOP(NPRESS,1)-1)*NDF+3) =  R1((NOP(NPRESS,1)-1)*NDF+3)
     *                             + FP(7)
C
      R1((NOP(NPRESS,2)-1)*NDF+1) =  R1((NOP(NPRESS,2)-1)*NDF+1)
     *                             + FP(2)
      R1((NOP(NPRESS,2)-1)*NDF+2) =  R1((NOP(NPRESS,2)-1)*NDF+2)
     *                             + FP(5)
      R1((NOP(NPRESS,2)-1)*NDF+3) =  R1((NOP(NPRESS,2)-1)*NDF+3)
     *                             + FP(8)
C
      R1((NOP(NPRESS,3)-1)*NDF+1) =  R1((NOP(NPRESS,3)-1)*NDF+1)
     *                             + FP(3)
      R1((NOP(NPRESS,3)-1)*NDF+2) =  R1((NOP(NPRESS,3)-1)*NDF+2)
     *                             + FP(6)
      R1((NOP(NPRESS,3)-1)*NDF+3) =  R1((NOP(NPRESS,3)-1)*NDF+3)
     *                             + FP(9)
C
C ------------------------------ IF ELEMENT NUMBER NOT MAX. ELEMENT NE,
C                                GO BACK AND READ MORE
      IF (NPRESS.LT.NE) GO TO 165
    9 FORMAT(I10,F15.5)
C
C
      WRITE(36,680) PTOTAL
  680 FORMAT(1H ,'PTOTAL= ', G12.5)
C
      WRITE(*,650)
  650 FORMAT(1H ,'END SUBROUTINE PLOAD')
C
      RETURN
      END


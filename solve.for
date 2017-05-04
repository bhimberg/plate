C =========================================
C  SOLVE EQUATION USING BAND MATRIX METHOD
C =========================================
C
      SUBROUTINE SOLVE
C
      COMMON /CONTR/ TITLE(18),NP,NE,NB,NDF,NCN,NLD,NMAT,NSZF,LI
      COMMON CORD(170,2),NOP(300,4),IMAT(300),ORT(25,2),NBC(60),NFIX(60)
     1      ,R1(500),SK(500,90),THICK(300)
C
C
      WRITE(*,610)
  610 FORMAT(1H ,'START SUBROUTINE SOLVE')
C
C
      NBAND=90
C
C ------------------------------ REDUCE MATRIX
C
      DO 300 N=1,NSZF
        I=N
        DO 290 L=2,NBAND
          I=I+1
          IF (SK(N,L)) 240,290,240
  240     C=SK(N,L)/SK(N,1)
          J=0
            DO 270 K=L,NBAND
              J=J+1
              IF (SK(N,K)) 260,270,260
  260         SK(I,J)=SK(I,J)-C*SK(N,K)
  270       CONTINUE
  280     SK(N,L)=C
C
C ------------------------------ AND LOAD VECTOR FOR EACH EQUATION
C
          R1(I)=R1(I)-C*R1(N)
  290   CONTINUE
  300 R1(N)=R1(N)/SK(N,1)
C
C ------------------------------ BACK-SUBSTITUTION
C
      N=NSZF
  350 N=N-1
      IF (N) 500,500,360
  360 L=N
      DO 400 K=2,NBAND
        L=L+1
        IF (SK(N,K)) 370,400,370
  370 R1(N)=R1(N)-SK(N,K)*R1(L)
C ------------------------------ R1(N) <= DISPLACEMENTS
  400 CONTINUE
      GO TO 350
C
  500 RETURN
      END


C =======================================
C  MAIN PROGRAM OF FINITE ELEMENT METHOD
C =======================================
C
      COMMON /CONTR/ TITLE(18),NP,NE,NB,NDF,NCN,NLD,NMAT,NSZF,LI
      COMMON CORD(900,2),NOP(900,4),IMAT(900),ORT(25,2),NBC(90),NFIX(90)
     1      ,R1(2700),SK(2700,180),THICK(900)
     2      ,R(3),SHEAR(900)
C
C
      NCN=3
C
C ----------------------------- READ INPUT GEOMETRY AND PROPERTY
C
      CALL GDATA
      NSZF=NP*NDF
      WRITE(*,645) NSZF
  645 FORMAT(1H , I7)
C
C ----------------------------- READ LOAD
C
      CALL LOAD
      CALL PLOAD
C
C ----------------------------- FORM THEN SOLVE SIMULTANEOUS EQUATIONS
C
      CALL FORMK
      CALL SOLVE
C
C ----------------------------- OUTPUT
C
      CALL OUT
C
      STOP
      END


C =======================================
C  MAIN PROGRAM OF FINITE ELEMENT METHOD
C =======================================
C
      COMMON /CONTR/ TITLE(18),NP,NE,NB,NDF,NCN,NLD,NMAT,NSZF,LI
      COMMON CORD(170,2),NOP(300,4),IMAT(300),ORT(25,2),NBC(60),NFIX(60)
     1      ,R1(500),SK(500,90),THICK(300)
     2      ,R(3),SHEAR(300)
C
C
      NCN=3
C
C ----------------------------- READ INPUT GEOMETRY AND PROPERTY
C
      CALL GDATA
      NSZF=NP*NDF
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


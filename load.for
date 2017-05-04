C =================================================
C  LOAD VECTOR SUBROUTINE OF FINITE ELEMENT METHOD
C =================================================
C
      SUBROUTINE LOAD
C
      COMMON /CONTR/ TITLE(18),NP,NE,NB,NDF,NCN,NLD,NMAT,NSZF,LI
      COMMON CORD(900,2),NOP(900,4),IMAT(900),ORT(25,2),NBC(90),NFIX(90)
     1      ,R1(2700),SK(2700,180),THICK(900)
     2      ,R(3),SHEAR(900)
C
C
      WRITE(*,600)
  600 FORMAT(1H ,'START SUBROUTINE LOAD')
C
C -------------------------------------- ZERO LOAD ARRAY
C
      DO 160 J=1,NSZF
        R1(J)=0.0
  160 CONTINUE
C
      READ(35,*)
  165 CONTINUE
      READ(35,*)  NQ,(R(K),K=1,NDF)
      WRITE(36,9) NQ,(R(K),K=1,NDF)
C
      DO 170 K=1,NDF
          IC=(NQ-1)*NDF+K
          R1(IC)=R(K)+R1(IC)
  170 CONTINUE
C
C ----------------------------------- IF NODE NUMBER NOT MAX. NODE NP,
C                                     GO BACK AND READ MORE
      IF (NQ.LT.NP) GO TO 165
    9 FORMAT(I10,3F10.2)
C
      WRITE(*,650)
  650 FORMAT(1H ,'END SUBROUTINE LOAD')
C
      RETURN
      END


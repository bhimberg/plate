C ================================================
C  DATA INPUT SUBROUTINE OF FINITE ELEMENT METHOD
C ================================================
C
      SUBROUTINE GDATA
C
      COMMON /CONTR/ TITLE(18),NP,NE,NB,NDF,NCN,NLD,NMAT,NSZF,LI
      COMMON CORD(900,2),NOP(900,4),IMAT(900),ORT(25,2),NBC(90),NFIX(90)
     1      ,R1(2700),SK(2700,180),THICK(900)
     2      ,R(3),SHEAR(900)
      LOGICAL THERE
C
      WRITE(*,610)
  610 FORMAT(1H ,'START SUBROUTINE GDATA')
C
C -------------------------------- OPEN FILE
C
      OPEN(35,FILE='INPUT.DAT')
      OPEN(36,FILE='OUTPUT.DAT',STATUS='UNKNOWN')
      INQUIRE(FILE='fem.dat',EXIST=THERE)
      OPEN(37,FILE='fem.dat',STATUS='UNKNOWN',ACCESS='APPEND')
  611 FORMAT('#  nodes  elems                 w             thick',
     1            '             young           poisson',
     1            '            radius          pressure')
  612 FORMAT('# PIMCID: 123456789')
      IF (.NOT. THERE) THEN
        WRITE(37,612)
        WRITE(37,611)
      ENDIF
C
C --------------------------------- READ AND PRINT TILTLE AND CONTROL
C
      READ(35,*)
      READ(35,7) TITLE
      WRITE(36,100) TITLE
      READ(35,*)
      READ(35,*)  NP,NE,NB,NMAT
                  NLD=1
                  NDF=3
                  I1 =0
      WRITE(36,1) NP,NE,NB,NMAT
C
C -------------------------------- READ AND PRINT MATERIAL DATA
C
      READ(35,*)
      READ(35,*) ( N,( ORT(N,I),I=1,2),L=1,NMAT)
      WRITE(36,108)
      WRITE(36,8)( N,( ORT(N,I),I=1,2),L=1,NMAT)
C
C -------------------------------- READ NODAL POINT DATA
C
      READ(35,*)
      READ(35,*)( N,(CORD(N,I),I=1,2),L=1,NP )
C
C -------------------------------- READ ELEMENT DATA
C
      READ(35,*)
      READ(35,*)( N,(NOP(N,M),M=1,3),THICK(N),IMAT(N),SHEAR(N),L=1,NE)
C
C -------------------------------- READ BOUNDARY DATA
C
      READ(35,*)
      READ(35,*) (NBC(I),NFIX(I),I=1,NB)
      WRITE(*,600)
  600 FORMAT(1H ,'END OF DATA READING')
  480 IF(I1.NE.0) GO TO 500
C
C -------------------------------- PRINT INPUT DATA
C
      WRITE(*,620)
  620 FORMAT(1H ,'START INPUT DATA WRITING')
      WRITE(36,102)
      WRITE(36,2)( N,( CORD(N,I),I=1,2),N=1,NP)
      WRITE(36,103)
      WRITE(36,3)( N,(NOP(N,M),M=1,3),THICK(N),IMAT(N),SHEAR(N),N=1,NE )
      WRITE(36,104)
      WRITE(36,4) (NBC(I),NFIX(I),I=1,NB)
C
  500 CONTINUE
    1 FORMAT(7I5)
    2 FORMAT(I10,2F10.3)
    3 FORMAT(4I5,F10.3,I5,F10.3)
    4 FORMAT(2I5)
    7 FORMAT(18A4)
    8 FORMAT(I10,2F10.2)
  100 FORMAT(1H ,18A4)
  102 FORMAT(1H ,'NODAL POINTS' )
  103 FORMAT(1H ,'ELEMENTS'     )
  104 FORMAT(1H ,'BOUNDARY CONDITIONS' )
  108 FORMAT(1H ,'MATERIAL PROPERTIES' )
C
C
      WRITE(*,630)
  630 FORMAT(1H ,'END OF SUBROUTINE GDATA')
C
C
      RETURN
      END


      SUBROUTINE MAINV1(A,N1,DET)
C
      DIMENSION A(N1,N1),INDEX(100)
      INTEGER PIVR
C
      DET=1.0
      N=N1
      DO 100 K=1,N
         PIV=0.0
         PIVR=0
         DO 110 I=K,N
            W=ABS(A(I,K))
            IF (PIV.GE.W) GO TO 110
            PIV=W
            PIVR=I
  110    CONTINUE
         PIV=A(PIVR,K)
         INDEX(K)=PIVR
         IF (PIVR.EQ.K) GO TO 130
         DO 120 J=1,N
            W=A(PIVR,J)
            A(PIVR,J)=A(K,J)
  120    A(K,J)=W
         DET=-DET
  130    DET=DET*PIV
         A(K,K)=1.0
         DO 140 J=1,N
  140    A(K,J)=A(K,J)/PIV
         DO 150 I=1,N
            IF (I.EQ.K) GO TO 150
            W=A(I,K)
            A(I,K)=0.0
            DO 160 J=1,N
  160       A(I,J)=A(I,J)-A(K,J)*W
  150    CONTINUE
  100 CONTINUE
      DO 200 K=1,N-1
         K1=N-K
         INDEXK=INDEX(K1)
         IF (INDEXK.EQ.K1) GO TO 200
         DO 210 I=1,N
            W=A(I,INDEXK)
            A(I,INDEXK)=A(I,K1)
  210    A(I,K1)=W
  200 CONTINUE
      RETURN
      END


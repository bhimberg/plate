C
C ================================
C  CALCULATE INTEGRAL IN TRIANGLE
C ================================
C
C
      SUBROUTINE TRI_INT(AREA,X,Y,XY, X1,Y1,X2,Y2,X3,Y3)
C
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
      X=AREA/12.0*(X1A*X1A+X2A*X2A+X3A*X3A)
      Y=AREA/12.0*(Y1A*Y1A+Y2A*Y2A+Y3A*Y3A)
      XY=AREA/12.0*(X1A*Y1A+X2A*Y2A+X3A*Y3A)
C
      RETURN
      END


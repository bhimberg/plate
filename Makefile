FC = gfortran
RM = rm -rf

# name program and source files
PROG ?= plate.e
SOURCE = formk.for gdata.for load.for main.for mainv1.for out.for pload.for solve.for tri_int.for

# Parse SOURCE
OBJS = ${SOURCE:.for=.o}

COMPILE = ${FC} -c
LINK = ${FC} ${OBJS} -o ${PROG}

# Link Objects
${PROG}: ${OBJS}
	${LINK}

# Compile Objects
formk.o: formk.for
	${COMPILE} formk.for

gdata.o: gdata.for
	${COMPILE} gdata.for

load.o: load.for
	${COMPILE} load.for

main.o: main.for
	${COMPILE} main.for

mainv1.o: mainv1.for
	${COMPILE} mainv1.for

out.o: out.for
	${COMPILE} out.for

pload.o: pload.for
	${COMPILE} pload.for

solve.o: solve.for
	${COMPILE} solve.for

tri_int.o: tri_int.for
	${COMPILE} tri_int.for

clean:
	${RM} ${PROG} ${OBJS}

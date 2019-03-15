#  Copyright 2009 Anthony Stone and Aleksandar Donev

#  This file is part of f03gl.
#
#  f03gl is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  any later version.
#
#  f03gl is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with f03gl (see file COPYING). If not, see
#  <http://www.gnu.org/licenses/>.

#  Libraries for OpenGL, including GLUT, GLU and OpenGL
ifdef OS
  F90GLUTLIB := -lfreeglut -lopengl32 -lglu32
else
  F90GLUTLIB := -lglut -lGL -lGLU
endif

ifndef COMPILER
  COMPILER := gfortran
endif
FC=${COMPILER}
ifeq (${COMPILER},nagfor)
#  Nag nagfor compiler, version 5.2
  FFLAGS    := $(DEBUG) -f2003 -colour -gline -DNAGF95 -DF2003 -DOPENGL
  LIBRARIES := ${OGLLIBDIR} ${X11LIBDIR} -L/usr/local/lib${BITS}
  LIBS      := ${F90GLUTLIB} ${X11LIB} -lpthread -ldl
endif

ifeq (${COMPILER},gfortran)
#  Gfortran version 4.5.0
  FFLAGS    := $(DEBUG) -DOPENGL -fno-range-check
  LIBS      := ${F90GLUTLIB}
endif

ifeq (${COMPILER},ifort)
#  ifort compiler, version 11.1.059 or later.
  FFLAGS    := $(DEBUG) -DOPENGL
  LIBRARIES := ${OGLLIBDIR} ${X11LIBDIR} -L/usr/local/lib${BITS}
  LIBS      := ${F90GLUTLIB} ${X11LIB} -lpthread -ldl
endif

#  If you use OpenGLUT or FreeGlut, change this variable and adjust
#  the libraries appropriately.
# GLUT      := glut
# GLUT      := openglut
GLUT      := freeglut

MODULES    = GLUT_fonts.o OpenGL_${GLUT}.o OpenGL_glu.o OpenGL_gl.o 


all: sphere stars blender scube modview plotfunc

%.o: %.f90
	${FC} ${FFLAGS} -c $<

blender modview plotfunc scube sphere stars : %: %.f90 ${MODULES} force
	${FC} ${FFLAGS} -c $<
	${FC} $@.o ${MODULES} ${LIBS} -o $@
	./$@

OpenGL%.mod: OpenGL%.f90
	${FC} ${FFLAGS} -c $<

force:

OpenGL_${GLUT}.o OpenGL_glu.o: OpenGL_gl.o

clean:
	-rm -f *.mod *.o sphere stars blender scube modview plotfunc
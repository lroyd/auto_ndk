# define target platform
SET(CMAKE_SYSTEM_NAME Linux)

#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)

SET(TOOLCHAIN_DIR "T0")

# specify the cross compiler
SET(CMAKE_C_COMPILER   ${TOOLCHAIN_DIR}/arm-linux-androideabi-gcc)
SET(CMAKE_CXX_COMPILER ${TOOLCHAIN_DIR}/arm-linux-androideabi-g++)

# where is the target environment 
SET(CMAKE_FIND_ROOT_PATH  ${TOOLCHAIN_DIR})

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


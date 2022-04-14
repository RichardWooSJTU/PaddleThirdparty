
if(NOT "/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3-stamp/extern_eigen3-gitinfo.txt" IS_NEWER_THAN "/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3-stamp/extern_eigen3-gitclone-lastrun.txt")
  message(STATUS "Avoiding repeated git clone, stamp file is up to date: '/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3-stamp/extern_eigen3-gitclone-lastrun.txt'")
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E remove_directory "/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/bin/git"  clone --no-checkout "https://gitlab.com/libeigen/eigen.git" "extern_eigen3"
    WORKING_DIRECTORY "/dev/workspace/Paddle/build/third_party/eigen3/src"
    RESULT_VARIABLE error_code
    )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once:
          ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://gitlab.com/libeigen/eigen.git'")
endif()

execute_process(
  COMMAND "/usr/bin/git"  checkout f612df273689a19d25b45ca4f8269463207c4fee --
  WORKING_DIRECTORY "/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: 'f612df273689a19d25b45ca4f8269463207c4fee'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "/usr/bin/git"  submodule update --recursive --init 
    WORKING_DIRECTORY "/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3"
    RESULT_VARIABLE error_code
    )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy
    "/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3-stamp/extern_eigen3-gitinfo.txt"
    "/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3-stamp/extern_eigen3-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/dev/workspace/Paddle/build/third_party/eigen3/src/extern_eigen3-stamp/extern_eigen3-gitclone-lastrun.txt'")
endif()


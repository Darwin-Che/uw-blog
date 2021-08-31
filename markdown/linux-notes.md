# Tools Commands Summary

## ShadowSocks configuration

```
$ pip3 -m install setuptools
$ pip3 -m install git+https://github.com/shadowsocks/shadowsocks.git@master
// config file begin
{
  "server": "0.0.0.0",
  "port_password": {
    "10325": "******1",
    "10326": "******2"
  },
  "timeout": 300,
  "method": "rc4-md5"
}
/ config file end
$ ssserver -c configfile -d start/stop/restart
```

## SSH key-gen

```
# local
# ~/.ssh/config

# Host alias
#     HostName 12.23.34.45
#     Port 22
#     User root
# Host alias2
#     ....

ssh alias
ssh-keygen -t rsa

# create ~/.ssh in the server
scp id_rsa.pub root@12.23.34.45:~/.ssh/authorized_keys
```

## Ubuntu Firewall 

```
ufw status
ufw allow 22
ufw deny 22
ufw reload
ufw enable
```

## Git

```
# local commands
git init
git status
git add *
git commit -m "my first commit"

# interact with server
git pull
git fetch
git -u push origin my-branch
git rebase

# version control
git log
git reflog
git checkout
git reset
git reset --hard HEAD@{2}

# branches
git branch 
git branch my-branch
git checkout master
// delete branch locally
git branch -d my-branch
// delete branch remotely
git push origin --delete my-branch
// merge to master
git checkout master
git merge my-branch
vim .gitignore

# save credentials
git config --global credential.helper store
```

## Python and envs

```
$ brew install zlib sqlite
$ export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib"
$ export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"

$ brew install pyenv 
$ pyenv install 3.7.3
$ pyenv global 3.7.3
$ pyenv version

// include these in the bash config file
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
// end

$ python -m pip install --user ...
$ python -m pip install virtualenvwrapper

// include these in the bash config file 
export WORKON_HOME=~/.virtualenvs
mkdir -p $WORKON_HOME
. ~/.pyenv/versions/3.7.3/bin/virtualenvwrapper.sh
// end

$ mkvirtualenv test1
$ ls $WORKON_HOME
$ workon
$ deactivate
$ rmvirtualenv test1

// source from 
// https://opensource.com/article/19/5/python-3-default-mac
// https://opensource.com/article/19/6/python-virtual-environments-mac
```

## CMake

```sh
$ cd target_dir
$ cmake source_dir # generator build system
$ cmake --build . # compile and link

```

Common commands

```cmake
set()
unset()
option()
configure_file()
if() endif()
function() endfunction()
add_subdirectory()
list(APPEND )
add_executable()
set_target_properties()
target_compile_definitions()
target_link_libraries()
target_include_directories()
target_compile_features()
add_library()
check_symbol_exists()
add_custom_command()

install()
include()

enable_testing()
add_test()
set_tests_properties()
```

```
VERSION 1.2
SOVERSION
Tutorial_VERSION_MAJOR
Tutorial_VERSION_MINOR
CMAKE_CXX_STANDARD
CMAKE_CXX_STANDARD_REQUIRED
ON / OFF
EXTRA_LIBS
EXTRA_INCLUDES
PROJECT_SOURCE_DIR
PROJECT_BINARY_DIR
CMAKE_CURRENT_SOURCE_DIR
CMAKE_CURRENT_BINARY_DIR
PUBLIC / INTERFACE / PRIVATE / STATIC
TARGETS / TARGET
FILES
DESTINATION
PROPERTIES 
PASS_REGULAR_EXPRESSION
InstallRequiredSystemLibraries
CheckSymbolExists
CPACK_RESOURCE_FILE_LICENSE
CPACK_PACKAGE_VERSION_MAJOR
CPACK_PACKAGE_VERSION_MINOR
CACHE
OUTPUT
COMMAND 
DEPENDS
PROPERTIES
POSITION_INDEPENDENT_CODE
${BUILD_SHARED_LIBS}
CMAKE_DEBUG_POSTFIX
DEBUG_POSTFIX
CMAKE_BUILD_TYPE
```



file "CMakeList.txt"

```cmake
cmake_minimum_required(VERSION 3.10)

# set the project name
project(Tutorial VERSION 1.1)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# use ifdef/ifndef USE_MYMATH in .h/.cpp files 
# add "#cmakedefine USE_MYMATH" to .in file, make sure "configure" is after "option" 
# can change value in terminal "-DUSE_MYMATH=OFF"
option(USE_MYMATH "Use tutorial provided math implementation" ON)

# TutorialConfig.h.in should contain
# #define Tutorial_VERSION_MAJOR @Tutorial_VERSION_MAJOR@
# #define Tutorial_VERSION_MINOR @Tutorial_VERSION_MINOR@
configure_file(TutorialConfig.h.in TutorialConfig.h)

if(USE_MYMATH)
  add_subdirectory(MathFunctions)
  list(APPEND EXTRA_LIBS MathFunctions)
  ## can remove following line if " target_include_directories" in subfolder
  ## list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")
endif()

# add the executable
add_executable(Tutorial tutorial.cxx)

target_link_libraries(Tutorial PUBLIC 
					 ## MathFunctions 
					 ${EXTRA_LIBS}
					 )

target_include_directories(Tutorial PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          ## "${PROJECT_SOURCE_DIR}/MathFunctions"
                          ## can remove following line if " target_include_directories" in subfolder
                          ## ${EXTRA_INCLUDES}
                          )
          
install(TARGETS Tutorial DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/TutorialConfig.h"
  	   DESTINATION include
       )
################
###### following is testing section
################
enable_testing()

# does the application run
add_test(NAME Runs COMMAND Tutorial 25)

# does the usage message work?
add_test(NAME Usage COMMAND Tutorial)
set_tests_properties(Usage
  PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number"
  )

# define a function to simplify adding tests
function(do_test target arg result)
  add_test(NAME Comp${arg} COMMAND ${target} ${arg})
  set_tests_properties(Comp${arg}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result}
    )
endfunction(do_test)

# do a bunch of result based tests
do_test(Tutorial 4 "4 is 2")
do_test(Tutorial 9 "9 is 3")
do_test(Tutorial 5 "5 is 2.236")
do_test(Tutorial 7 "7 is 2.645")
do_test(Tutorial 25 "25 is 5")
do_test(Tutorial -25 "-25 is [-nan|nan|0]")
do_test(Tutorial 0.0001 "0.0001 is 0.01")

## distribution
include(InstallRequiredSystemLibraries)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set(CPACK_PACKAGE_VERSION_MAJOR "${Tutorial_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${Tutorial_VERSION_MINOR}")
include(CPack)

// source from 
// https://cmake.org/cmake/help/latest/guide/tutorial/index.html
```

File "MathFunctions/CMakeList.txt"

```cmake
add_library(MathFunctions mysqrt.cxx)

## this can be included in subfolder CMakeList.txt to eliminate some other code in top level
target_include_directories(MathFunctions
          				  INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
          				  )
          				  
include(CheckSymbolExists)
check_symbol_exists(log "math.h" HAVE_LOG)
check_symbol_exists(exp "math.h" HAVE_EXP)
if(NOT (HAVE_LOG AND HAVE_EXP))
  unset(HAVE_LOG CACHE)
  unset(HAVE_EXP CACHE)
  set(CMAKE_REQUIRED_LIBRARIES "m")
  check_symbol_exists(log "math.h" HAVE_LOG)
  check_symbol_exists(exp "math.h" HAVE_EXP)
  if(HAVE_LOG AND HAVE_EXP)
    target_link_libraries(MathFunctions PRIVATE m)
  endif()
endif()


install(TARGETS MathFunctions DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)

```

File "mysqrt.cxx"

```c++
#include <cmath>
#include <iostream>

#include "MathFunctions.h"

// a hack square root calculation using simple operations
double mysqrt(double x)
{
  if (x <= 0) {
    return 0;
  }

  // if we have both log and exp then use them
#if defined(HAVE_LOG) && defined(HAVE_EXP)
  double result = exp(log(x) * 0.5);
  std::cout << "Computing sqrt of " << x << " to be " << result
            << " using log and exp" << std::endl;
#else
  double result = x;

  // do ten iterations
  for (int i = 0; i < 10; ++i) {
    if (result <= 0) {
      result = 0.1;
    }
    double delta = x - (result * result);
    result = result + 0.5 * delta / result;
    std::cout << "Computing sqrt of " << x << " to be " << result << std::endl;
  }
#endif
  return result;
}

```

CMakeList for adding curstom command

```cmake
add_executable(MakeTable MakeTable.cxx)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Table.h
  COMMAND MakeTable ${CMAKE_CURRENT_BINARY_DIR}/Table.h
  DEPENDS MakeTable
  )

add_library(MathFunctions
            mysqrt.cxx
            ${CMAKE_CURRENT_BINARY_DIR}/Table.h
            )

target_include_directories(MathFunctions
          INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
          PRIVATE ${CMAKE_CURRENT_BINARY_DIR}
          )
```

## Vim Plugins

```
mkdir -p ~/.vim/pack/myplugin/start
git clone ... ~/.vim/pack/myplugin/start/myplugin
vim -u NONE -c "helptags ~/.vim/pack/myplugin/start/myplugin/doc" -c q


vim-obsession
nerdtree			https://github.com/preservim/nerdtree
```

## Tmux Plugins

```
git clone ~/.tmux_myplugins
run-shell ~/.tmux_myplugins/tmux-resurrect/resurrect.tmux
```




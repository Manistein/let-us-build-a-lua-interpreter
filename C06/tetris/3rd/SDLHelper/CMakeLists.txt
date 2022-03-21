cmake_minimum_required(VERSION 3.5.1)

# set the project name
project(sdlhelper)

# add the dll/so
add_library(sdlhelper MODULE sdlhelper.c)

IF (WIN32)
  SET(SDLLIB ${CMAKE_CURRENT_SOURCE_DIR}/../CLibs/SDL2.lib)
  target_link_libraries(sdlhelper ${SDLLIB})

  SET(DUMMYLUA_LIB ${CMAKE_CURRENT_SOURCE_DIR}/../../dummylua/dummylua.lib)
  target_link_libraries(sdlhelper ${DUMMYLUA_LIB})

  target_compile_definitions(sdlhelper PRIVATE _WINDOWS_PLATFORM_=1)
  target_compile_definitions(sdlhelper PRIVATE _CRT_SECURE_NO_WARNINGS=1)
ELSE()
  target_link_libraries(sdlhelper m)
  target_link_libraries(sdlhelper dl)
ENDIF()

SET(DUMMYLUA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../dummylua)
SET(SDL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../SDL)
target_include_directories(sdlhelper PUBLIC
                          "${DUMMYLUA_DIR}/common"
                          "${DUMMYLUA_DIR}/clib"
                          "${DUMMYLUA_DIR}/compiler"
                          "${DUMMYLUA_DIR}/vm"
                          "${DUMMYLUA_DIR}/test"
                          "${SDL_DIR}/include"
                          )
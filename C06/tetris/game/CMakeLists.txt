cmake_minimum_required(VERSION 3.5.1)

# set the project name
project(game)

# add the dll/so
add_executable(game main.c)

IF (WIN32)
  SET(SDLLIB ${CMAKE_CURRENT_SOURCE_DIR}/../3rd/CLibs/SDL2.lib)
  target_link_libraries(game ${SDLLIB})

  SET(DUMMYLUA_LIB ${CMAKE_CURRENT_SOURCE_DIR}/../dummylua/dummylua.lib)
  target_link_libraries(game ${DUMMYLUA_LIB})

  find_library(sdldll NAMES SDL2 HINTS ${CMAKE_CURRENT_SOURCE_DIR}/../3rd/CLibs/)
  set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR})
  file(COPY ${sdldll} DESTINATION ${EXECUTABLE_OUTPUT_PATH})

  target_compile_definitions(game PRIVATE _WINDOWS_PLATFORM_=1)
  target_compile_definitions(game PRIVATE _CRT_SECURE_NO_WARNINGS=1)
ELSE()
  target_link_libraries(game m)
  target_link_libraries(game dl)
ENDIF()

SET(DUMMYLUA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../dummylua)
SET(SDL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../3rd/SDL)
target_include_directories(game PUBLIC
                          "${DUMMYLUA_DIR}/common"
                          "${DUMMYLUA_DIR}/clib"
                          "${DUMMYLUA_DIR}/compiler"
                          "${DUMMYLUA_DIR}/vm"
                          "${DUMMYLUA_DIR}/test"
                          "${SDL_DIR}/include"
                          )
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bin)

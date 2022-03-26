cmake_minimum_required(VERSION 3.5.1)

# set the project name
project(game)

add_executable(${PROJECT_NAME} main.cpp)

# OpenGL
find_package(OpenGL REQUIRED)
set(EXTERNAL ${CMAKE_CURRENT_SOURCE_DIR}/../3rd/gldepends/external)

include_directories(
  ${EXTERNAL}/AntTweakBar-1.16/include/
  ${EXTERNAL}/glfw-3.1.2/include/
  ${EXTERNAL}/glm-0.9.7.1/
  ${EXTERNAL}/glew-1.13.0/include/
  ${EXTERNAL}/assimp-3.0.1270/include/
  ${EXTERNAL}/bullet-2.81-rev2613/src/
  .
)

add_definitions(
  -DTW_STATIC
  -DTW_NO_LIB_PRAGMA
  -DTW_NO_DIRECT3D
  -DGLEW_STATIC
  -D_CRT_SECURE_NO_WARNINGS
)

IF (WIN32)
  SET(DUMMYLUA_LIB ${CMAKE_CURRENT_SOURCE_DIR}/../dummylua/dummylua.lib)
  target_link_libraries(${PROJECT_NAME} ${DUMMYLUA_LIB})

  SET(GLLIB ${CMAKE_CURRENT_SOURCE_DIR}/../3rd/clibs/windows)
  SET(ALL_GL_LIBS
    ${GLLIB}/glfw3.lib
    ${GLLIB}/GLEW_1130.lib
    ${GLLIB}/ANTTWEAKBAR_116_OGLCORE_GLFW.lib
    opengl32.lib
  )
  target_link_libraries(${PROJECT_NAME} ${ALL_GL_LIBS})

  target_compile_definitions(${PROJECT_NAME} PRIVATE _WINDOWS_PLATFORM_=1)
  target_compile_definitions(${PROJECT_NAME} PRIVATE _CRT_SECURE_NO_WARNINGS=1)
ELSE()
  target_link_libraries(${PROJECT_NAME} m)
  target_link_libraries(${PROJECT_NAME} dl)
ENDIF()

SET(DUMMYLUA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../dummylua)
target_include_directories(${PROJECT_NAME} PUBLIC
                          "${DUMMYLUA_DIR}/common"
                          "${DUMMYLUA_DIR}/clib"
                          "${DUMMYLUA_DIR}/compiler"
                          "${DUMMYLUA_DIR}/vm"
                          "${DUMMYLUA_DIR}/test"
                          )

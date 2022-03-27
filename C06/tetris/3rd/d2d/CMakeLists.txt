cmake_minimum_required(VERSION 3.5.1)

# set the project name
project(d2d)

add_library(${PROJECT_NAME} MODULE main.cpp render.h render.cpp)

SET(DUMMYLUA_LIB ${CMAKE_CURRENT_SOURCE_DIR}/../../dummylua/dummylua.lib)
target_link_libraries(${PROJECT_NAME} ${DUMMYLUA_LIB})
target_link_libraries(${PROJECT_NAME} d2d1.lib Dwrite.lib)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy
  $<TARGET_FILE_DIR:${PROJECT_NAME}>/${PROJECT_NAME}.dll
  ${CMAKE_CURRENT_SOURCE_DIR}/../clibs)

target_compile_definitions(${PROJECT_NAME} PRIVATE _WINDOWS_PLATFORM_=1)
target_compile_definitions(${PROJECT_NAME} PRIVATE _CRT_SECURE_NO_WARNINGS=1)

SET(DUMMYLUA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../dummylua)
target_include_directories(${PROJECT_NAME} PUBLIC
                          "${DUMMYLUA_DIR}/common"
                          "${DUMMYLUA_DIR}/clib"
                          "${DUMMYLUA_DIR}/compiler"
                          "${DUMMYLUA_DIR}/vm"
                          "${DUMMYLUA_DIR}/test"
                          )

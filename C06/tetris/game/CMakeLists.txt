cmake_minimum_required(VERSION 3.5.1)

# set the project name
project(game)

add_executable(${PROJECT_NAME} WIN32 main.cpp logic.h logic.cpp)

IF (WIN32)
  SET(DUMMYLUA_LIB ${CMAKE_CURRENT_SOURCE_DIR}/../dummylua/dummylua.lib)
  target_link_libraries(${PROJECT_NAME} ${DUMMYLUA_LIB})

  target_compile_definitions(${PROJECT_NAME} PRIVATE _WINDOWS_PLATFORM_=1)
  target_compile_definitions(${PROJECT_NAME} PRIVATE _CRT_SECURE_NO_WARNINGS=1)

  add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
    ${CMAKE_CURRENT_SOURCE_DIR}/../3rd/clibs/d2d1.dll
    $<TARGET_FILE_DIR:${PROJECT_NAME}>)
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

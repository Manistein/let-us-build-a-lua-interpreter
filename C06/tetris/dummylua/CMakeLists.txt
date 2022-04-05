cmake_minimum_required(VERSION 3.5.1)

# set the project name
project(dummylua)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
file(GLOB COMMON_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/common/*.h)
file(GLOB CLIB_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/clib/*.h)
file(GLOB COMPILER_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/compiler/*.h)
file(GLOB VM_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/vm/*.h)
file(GLOB TEST_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/test/*.h)
set(INC ${COMMON_HEADER} ${CLIB_HEADER} ${COMPILER_HEADER} ${VM_HEADER})

file(GLOB COMMON_SRC ${CMAKE_CURRENT_SOURCE_DIR}/common/*.c)
file(GLOB CLIB_SRC ${CMAKE_CURRENT_SOURCE_DIR}/clib/*.c)
file(GLOB VM_SRC ${CMAKE_CURRENT_SOURCE_DIR}/vm/*.c)
file(GLOB COMPILER_SRC ${CMAKE_CURRENT_SOURCE_DIR}/compiler/*.c)
file(GLOB TEST_SRC ${CMAKE_CURRENT_SOURCE_DIR}/test/*.c)

set(SRC ${COMMON_SRC} ${CLIB_SRC} ${VM_SRC} ${COMPILER_SRC} ${TEST_SRC})
set(MAIN main.c)

# add the dll/so
add_library(dummylua STATIC ${SRC} ${INC})
# add_executable(dummylua main.c ${SRC} ${INC})

IF(NOT WIN32)
    target_link_libraries(dummylua m)
    target_link_libraries(dummylua dl)
ENDIF()

IF (WIN32)
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${COMMON_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${CLIB_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${VM_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${COMPILER_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${TEST_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${MAIN})

    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${CLIB_HEADER})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${COMMON_HEADER})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${COMPILER_HEADER})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${VM_HEADER})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${TEST_HEADER})

	target_compile_definitions(dummylua PRIVATE _WINDOWS_PLATFORM_=1)
    target_compile_definitions(dummylua PRIVATE _CRT_SECURE_NO_WARNINGS=1)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
     COMMAND ${CMAKE_COMMAND} -E copy
     $<TARGET_FILE_DIR:${PROJECT_NAME}>/dummylua.lib
     ${CMAKE_CURRENT_SOURCE_DIR})
ENDIF()

target_include_directories(dummylua PUBLIC
                          "${CMAKE_CURRENT_SOURCE_DIR}/common"
                          "${CMAKE_CURRENT_SOURCE_DIR}/clib"
                          "${CMAKE_CURRENT_SOURCE_DIR}/compiler"
                          "${CMAKE_CURRENT_SOURCE_DIR}/vm"
                          "${CMAKE_CURRENT_SOURCE_DIR}/test"
                          )
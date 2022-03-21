cmake_minimum_required(VERSION 3.5.1)

# set the project name
project(dummylua)

set(COMMON_SRC common/luabase.c common/luadebug.c common/luainit.c common/luamem.c 
common/luaobject.c common/luastate.c common/luastring.c common/luatable.c 
common/luatm.c common/lualoadlib.c)
set(CLIB_SRC clib/luaaux.c)
set(VM_SRC vm/luado.c vm/luagc.c vm/luavm.c vm/luafunc.c vm/luaopcodes.c)
set(COMPILER_SRC compiler/luazio.c compiler/lualexer.c compiler/luaparser.c compiler/luacode.c)
set(TEST_SRC test/p1_test.c test/p2_test.c test/p3_test.c test/p4_test.c test/p5_test.c
	test/p6_test.c test/p7_test.c test/p8_test.c test/p9_test.c test/p10_test.c test/p11_test.c 
	test/p12_test.c test/p13_test.c)
set(SRC ${COMMON_SRC} ${CLIB_SRC} ${VM_SRC} ${TEST_SRC} ${COMPILER_SRC})
set(MAIN_SRC main.c)

# add the executable
add_executable(dummylua main.c ${SRC})

# add the dll/so
# add_library(dummylua MODULE ${SRC} loadlib.c)

IF(NOT WIN32)
	target_link_libraries(dummylua m)
    target_link_libraries(dummylua dl)
ENDIF()

IF (WIN32)
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${MAIN_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${COMMON_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${CLIB_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${VM_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${TEST_SRC})
    source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${COMPILER_SRC})

	  target_compile_definitions(dummylua PRIVATE _WINDOWS_PLATFORM_=1)
    target_compile_definitions(dummylua PRIVATE _CRT_SECURE_NO_WARNINGS=1)
ENDIF()

target_include_directories(dummylua PUBLIC
                          "${CMAKE_CURRENT_SOURCE_DIR}/common"
                          "${CMAKE_CURRENT_SOURCE_DIR}/clib"
                          "${CMAKE_CURRENT_SOURCE_DIR}/compiler"
                          "${CMAKE_CURRENT_SOURCE_DIR}/vm"
                          "${CMAKE_CURRENT_SOURCE_DIR}/test"
                          )
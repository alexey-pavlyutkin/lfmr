cmake_minimum_required( VERSION 3.13 )

#
# define path for GTest as external project
#
set( external_dir ${PROJECT_SOURCE_DIR}/external )
set( gtest_dir ${external_dir}/googletest )
set( gtest_cmake ${gtest_dir}/CMakeLists.txt )

if ( NOT EXISTS ${gtest_cmake} )
    #
    # make sure ./external folder exists and does not contain gtest folder
    #
    file( MAKE_DIRECTORY ${external_dir} )
    file( REMOVE_RECURSE ${gtest_dir} )

    #
    # gonna use Git to download Boost from Github
    #
    find_package( Git )
    if ( NOT Git_FOUND )
        message( FATAL_ERROR "Unable to locate Git package!" )
    endif()

    #
    # download GTest
    #
    execute_process(
        COMMAND ${GIT_EXECUTABLE} clone --depth=1 --branch=master --recurse-submodules --shallow-submodules https://github.com/google/googletest
        WORKING_DIRECTORY ${external_dir}
        TIMEOUT 14400
        RESULT_VARIABLE git_result
    )

    if ( NOT git_result EQUAL 0 )
        message( FATAL_ERROR "Unable to download GTest library!" )
    endif()
endif()

#
# suppress GMock project
#
option( BUILD_GMOCK OFF )
option( INSTALL_GTEST OFF )

#
# add GTest project
#
add_subdirectory( ${gtest_dir} )
include( GoogleTest )
set_target_properties( gtest gtest_main PROPERTIES FOLDER external )
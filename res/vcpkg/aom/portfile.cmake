# NASM is required to build AOM
vcpkg_find_acquire_program(NASM)
get_filename_component(NASM_EXE_PATH ${NASM} DIRECTORY)
vcpkg_add_to_path(${NASM_EXE_PATH})

# Perl is required to build AOM
vcpkg_find_acquire_program(PERL)
get_filename_component(PERL_PATH ${PERL} DIRECTORY)
vcpkg_add_to_path(${PERL_PATH})

if(DEFINED ENV{USE_AOM_391})
    vcpkg_from_git(
        OUT_SOURCE_PATH SOURCE_PATH
        URL "https://aomedia.googlesource.com/aom"
        REF 8ad484f8a18ed1853c094e7d3a4e023b2a92df28 # 3.9.1
        PATCHES
            aom-uninitialized-pointer.diff
            aom-avx2.diff
            aom-install.diff
    )
else()
    vcpkg_from_git(
        OUT_SOURCE_PATH SOURCE_PATH
        URL "https://aomedia.googlesource.com/aom"
        REF 10aece4157eb79315da205f39e19bf6ab3ee30d0 # 3.12.1
        PATCHES
            aom-uninitialized-pointer.diff
            # aom-avx2.diff
            # Can be dropped when https://bugs.chromium.org/p/aomedia/issues/detail?id=3029 is merged into the upstream
            aom-install.diff
    )
endif()

set(aom_target_cpu "")
set(aom_extra_flags "")
if(VCPKG_TARGET_IS_UWP OR (VCPKG_TARGET_IS_WINDOWS AND VCPKG_TARGET_ARCHITECTURE MATCHES "^arm"))
    # UWP + aom's assembler files result in weirdness and build failures
    # Also, disable assembly on ARM and ARM64 Windows to fix compilation issues.
    set(aom_target_cpu "-DAOM_TARGET_CPU=generic")
endif()

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm" AND VCPKG_TARGET_IS_LINUX)
  set(aom_target_cpu "-DENABLE_NEON=OFF")
endif()

if(VCPKG_TARGET_IS_IOS)
    # Fix iOS arm64 cross-compilation issues with aom:
    # 1. __chkstk_darwin is macOS-only; -fno-stack-check prevents calls to it.
    # 2. feenableexcept is a GNU extension unavailable on iOS; HAVE_FEXCEPT=0 skips it.
    # 3. Xcode 16+ treats implicit-function-declaration as error; suppress via -Wno-error.
    # 4. CMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY avoids link errors in try_compile.
    # 5. ENABLE_NEON_DOTPROD/I8MM=OFF prevents ASM detection issues on iOS.
    # 6. CONFIG_RUNTIME_CPU_DETECT=0 disables runtime CPU detection (not needed on iOS).
    # Note: -fno-stack-check already prevents __chkstk_darwin calls, so CONFIG_SIZE_LIMIT
    #   is not needed (and would require DECODE_HEIGHT/WIDTH_LIMIT to be set).
    set(aom_target_cpu "-DAOM_TARGET_CPU=arm64")
    set(aom_extra_flags
        "-DCMAKE_C_FLAGS=-mios-version-min=13.0 -fno-stack-check -fno-stack-protector -Wno-error=implicit-function-declaration"
        "-DCMAKE_CXX_FLAGS=-mios-version-min=13.0 -fno-stack-check -fno-stack-protector -Wno-error=implicit-function-declaration"
        "-DCMAKE_OSX_DEPLOYMENT_TARGET=13.0"
        "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY"
        "-DHAVE_FEXCEPT=0"
        "-DENABLE_NEON_DOTPROD=OFF"
        "-DENABLE_NEON_I8MM=OFF"
        "-DCONFIG_RUNTIME_CPU_DETECT=0"
    )
endif()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${aom_target_cpu}
        ${aom_extra_flags}
        -DENABLE_DOCS=OFF
        -DENABLE_EXAMPLES=OFF
        -DENABLE_TESTDATA=OFF
        -DENABLE_TESTS=OFF
        -DENABLE_TOOLS=OFF
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

vcpkg_fixup_pkgconfig()

if(VCPKG_TARGET_IS_WINDOWS)
  vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/aom.pc" " -lm" "")
  if(NOT VCPKG_BUILD_TYPE)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/aom.pc" " -lm" "")
  endif()
endif()

# Move cmake configs
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

# Remove duplicate files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include
                    ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_fixup_pkgconfig()

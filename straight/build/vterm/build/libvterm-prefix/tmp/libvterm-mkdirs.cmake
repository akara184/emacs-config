# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/akara184/.emacs.d/straight/build/vterm/build/libvterm-prefix/src/libvterm"
  "/home/akara184/.emacs.d/straight/build/vterm/build/libvterm-prefix/src/libvterm-build"
  "/home/akara184/.emacs.d/straight/build/vterm/build/libvterm-prefix"
  "/home/akara184/.emacs.d/straight/build/vterm/build/libvterm-prefix/tmp"
  "/home/akara184/.emacs.d/straight/build/vterm/build/libvterm-prefix/src/libvterm-stamp"
  "/home/akara184/.emacs.d/straight/build/vterm/build/libvterm-prefix/src"
  "/home/akara184/.emacs.d/straight/build/vterm/build/libvterm-prefix/src/libvterm-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/akara184/.emacs.d/straight/build/vterm/build/libvterm-prefix/src/libvterm-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/akara184/.emacs.d/straight/build/vterm/build/libvterm-prefix/src/libvterm-stamp${cfgdir}") # cfgdir has leading slash
endif()

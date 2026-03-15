cmake_minimum_required(VERSION 3.18)

include($ENV{FPRIME_FRAMEWORK_PATH}/cmake/FPrime.cmake)

add_fprime_subdirectory(Top/Stage9Clean36Top)
add_fprime_subdirectory(Components/LinuxMain)
add_fprime_subdirectory(Components/Stage9MotorBridge)
add_fprime_subdirectory(Deployments/Stage9Clean36)

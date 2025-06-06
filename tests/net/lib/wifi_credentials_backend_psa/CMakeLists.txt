#
# Copyright (c) 2024 Nordic Semiconductor ASA
#
# SPDX-License-Identifier: Apache-2.0
#

cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(wifi_credentials_test)

FILE(GLOB app_sources src/*.c)
target_sources(app PRIVATE ${app_sources})

target_sources(app
  PRIVATE
  ${ZEPHYR_BASE}/subsys/net/lib/wifi_credentials/wifi_credentials_backend_psa.c
)

zephyr_include_directories(${ZEPHYR_BASE}/subsys/testsuite/include)
zephyr_include_directories(${ZEPHYR_BASE}/subsys/net/lib/wifi_credentials/)
zephyr_include_directories(${ZEPHYR_TRUSTED_FIRMWARE_M_MODULE_DIR}/interface/include/)
zephyr_include_directories(${ZEPHYR_BASE}/../modules/crypto/mbedtls/include/)

target_compile_options(app
  PRIVATE
  -DCONFIG_WIFI_CREDENTIALS_MAX_ENTRIES=2
  -DCONFIG_WIFI_CREDENTIALS_SAE_PASSWORD_LENGTH=128
  -DCONFIG_WIFI_CREDENTIALS_LOG_LEVEL=4
)

set_property(
	SOURCE ${ZEPHYR_BASE}/subsys/net/lib/wifi_credentials/wifi_credentials_backend_psa.c
	PROPERTY COMPILE_FLAGS "-include ${CMAKE_CURRENT_SOURCE_DIR}/src/normalized_crypto.h"
)

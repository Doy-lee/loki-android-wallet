cmake_minimum_required(VERSION 3.4.1)
message(STATUS ABI_INFO = ${ANDROID_ABI})

add_library( monerujo
             SHARED
             src/main/cpp/monerujo.cpp)

set(ANDROID_ARCH ${ANDROID_ABI})
if (ANDROID_ARCH STREQUAL "armeabi-v7a")
  set(ANDROID_ARCH arm)
endif()

set(LOKI_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/../external-libs/build/monero/include)
set(LOKI_LIBS_DIR ${CMAKE_SOURCE_DIR}/../external-libs/build/monero/${ANDROID_ARCH}/lib)
set(EXTERNAL_LIBS_DIR ${CMAKE_SOURCE_DIR}/../external-libs/build/${ANDROID_ARCH}/lib)

############
# libsqlite
############

add_library(sqlite STATIC IMPORTED)
set_target_properties(sqlite PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libsqlite3.a)

############
# libunbound
############

add_library(unbound STATIC IMPORTED)
set_target_properties(unbound PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libunbound.a)

############
# libsodium
############

add_library(sodium STATIC IMPORTED)
set_target_properties(sodium PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libsodium.a)

############
# OpenSSL
############

add_library(crypto STATIC IMPORTED)
set_target_properties(crypto PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libcrypto.a)

add_library(ssl STATIC IMPORTED)
set_target_properties(ssl PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libssl.a)

############
# Boost
############

add_library(boost_chrono STATIC IMPORTED)
set_target_properties(boost_chrono PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libboost_chrono.a)

add_library(boost_date_time STATIC IMPORTED)
set_target_properties(boost_date_time PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libboost_date_time.a)

add_library(boost_filesystem STATIC IMPORTED)
set_target_properties(boost_filesystem PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libboost_filesystem.a)

add_library(boost_program_options STATIC IMPORTED)
set_target_properties(boost_program_options PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libboost_program_options.a)

add_library(boost_regex STATIC IMPORTED)
set_target_properties(boost_regex PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libboost_regex.a)

add_library(boost_serialization STATIC IMPORTED)
set_target_properties(boost_serialization PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libboost_serialization.a)

add_library(boost_system STATIC IMPORTED)
set_target_properties(boost_system PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libboost_system.a)

add_library(boost_thread STATIC IMPORTED)
set_target_properties(boost_thread PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libboost_thread.a)

add_library(boost_wserialization STATIC IMPORTED)
set_target_properties(boost_wserialization PROPERTIES IMPORTED_LOCATION ${EXTERNAL_LIBS_DIR}/libboost_wserialization.a)

#############
# Monero
#############

add_library(wallet_api STATIC IMPORTED)
set_target_properties(wallet_api PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libwallet_api.a)

add_library(wallet STATIC IMPORTED)
set_target_properties(wallet PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libwallet.a)

add_library(cryptonote_core STATIC IMPORTED)
set_target_properties(cryptonote_core PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libcryptonote_core.a)

add_library(cryptonote_basic STATIC IMPORTED)
set_target_properties(cryptonote_basic PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libcryptonote_basic.a)

add_library(mnemonics STATIC IMPORTED)
set_target_properties(mnemonics PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libmnemonics.a)

add_library(common STATIC IMPORTED)
set_target_properties(common PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libcommon.a)

add_library(cncrypto STATIC IMPORTED)
set_target_properties(cncrypto PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libcncrypto.a)

add_library(ringct STATIC IMPORTED)
set_target_properties(ringct PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libringct.a)

add_library(ringct_basic STATIC IMPORTED)
set_target_properties(ringct_basic PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libringct_basic.a)

add_library(blockchain_db STATIC IMPORTED)
set_target_properties(blockchain_db PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libblockchain_db.a)

add_library(lmdb STATIC IMPORTED)
set_target_properties(lmdb PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/liblmdb.a)

add_library(easylogging STATIC IMPORTED)
set_target_properties(easylogging PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libeasylogging.a)


add_library(epee STATIC IMPORTED)
set_target_properties(epee PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libepee.a)

add_library(checkpoints STATIC IMPORTED)
set_target_properties(checkpoints PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libcheckpoints.a)

add_library(device STATIC IMPORTED)
set_target_properties(device PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libdevice.a)

add_library(device_trezor STATIC IMPORTED)
set_target_properties(device_trezor PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libdevice_trezor.a)

add_library(multisig STATIC IMPORTED)
set_target_properties(multisig PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libmultisig.a)

add_library(version STATIC IMPORTED)
set_target_properties(version PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libversion.a)

add_library(net STATIC IMPORTED)
set_target_properties(net PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/libnet.a)

add_library(randomx STATIC IMPORTED)
set_target_properties(randomx PROPERTIES IMPORTED_LOCATION ${LOKI_LIBS_DIR}/librandomx.a)

#add_library(rpc_base STATIC IMPORTED)
#set_target_properties(rpc_base PROPERTIES IMPORTED_LOCATION
#        ${EXTERNAL_LIBS_DIR}/monero/lib/${ANDROID_ARCH}/librpc_base.a)

#############
# System
#############

find_library( log-lib log )
include_directories(${LOKI_INCLUDE_DIR})

message(STATUS EXTERNAL_LIBS_DIR :  ${EXTERNAL_LIBS_DIR})

target_link_libraries(  monerujo

                        wallet_api
                        wallet
                        cryptonote_core
                        cryptonote_basic
                        mnemonics
                        ringct
                        ringct_basic
                        net
                        common
                        cncrypto
                        blockchain_db
                        lmdb
                        easylogging
                        unbound
                        epee
                        checkpoints
                        device
                        device_trezor
                        multisig
                        version
                        randomx
#                        rpc_base
                        boost_chrono
                        boost_date_time
                        boost_filesystem
                        boost_program_options
                        boost_regex
                        boost_serialization
                        boost_system
                        boost_thread
                        boost_wserialization
                        sqlite
                        ssl
                        crypto
                        sodium

                       ${log-lib}
                       )

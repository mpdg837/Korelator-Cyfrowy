# TCL File Generated by Component Editor 18.1
# Sat Apr 22 22:16:59 CEST 2023
# DO NOT MODIFY


# 
# Conclover "Conclover" v1.0
#  2023.04.22.22:16:59
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Conclover
# 
set_module_property DESCRIPTION ""
set_module_property NAME Conclover
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME Conclover
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL conclover
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file conclove.v VERILOG PATH conclover/conclove.v TOP_LEVEL_FILE
add_fileset_file conclove_MA.v VERILOG PATH conclover/conclove_MA.v
add_fileset_file conclove_core.v VERILOG PATH conclover/conclove_core.v
add_fileset_file conclove_multi.v VERILOG PATH conclover/conclove_multi.v
add_fileset_file conclove_registers.v VERILOG PATH conclover/conclove_registers.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock csi_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset rsi_reset_n reset_n Input 1


# 
# connection point s0
# 
add_interface s0 avalon end
set_interface_property s0 addressUnits WORDS
set_interface_property s0 associatedClock clock
set_interface_property s0 associatedReset reset
set_interface_property s0 bitsPerSymbol 8
set_interface_property s0 burstOnBurstBoundariesOnly false
set_interface_property s0 burstcountUnits WORDS
set_interface_property s0 explicitAddressSpan 0
set_interface_property s0 holdTime 0
set_interface_property s0 linewrapBursts false
set_interface_property s0 maximumPendingReadTransactions 0
set_interface_property s0 maximumPendingWriteTransactions 0
set_interface_property s0 readLatency 0
set_interface_property s0 readWaitTime 1
set_interface_property s0 setupTime 0
set_interface_property s0 timingUnits Cycles
set_interface_property s0 writeWaitTime 0
set_interface_property s0 ENABLED true
set_interface_property s0 EXPORT_OF ""
set_interface_property s0 PORT_NAME_MAP ""
set_interface_property s0 CMSIS_SVD_VARIABLES ""
set_interface_property s0 SVD_ADDRESS_GROUP ""

add_interface_port s0 avs_s0_write write Input 1
add_interface_port s0 avs_s0_read read Input 1
add_interface_port s0 avs_s0_address address Input 5
add_interface_port s0 avs_s0_writedata writedata Input 32
add_interface_port s0 avs_s0_readdata readdata Output 32
set_interface_assignment s0 embeddedsw.configuration.isFlash 0
set_interface_assignment s0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point m1
# 
add_interface m1 avalon start
set_interface_property m1 addressUnits SYMBOLS
set_interface_property m1 associatedClock clock
set_interface_property m1 associatedReset reset
set_interface_property m1 bitsPerSymbol 8
set_interface_property m1 burstOnBurstBoundariesOnly false
set_interface_property m1 burstcountUnits WORDS
set_interface_property m1 doStreamReads false
set_interface_property m1 doStreamWrites false
set_interface_property m1 holdTime 0
set_interface_property m1 linewrapBursts false
set_interface_property m1 maximumPendingReadTransactions 0
set_interface_property m1 maximumPendingWriteTransactions 0
set_interface_property m1 readLatency 0
set_interface_property m1 readWaitTime 1
set_interface_property m1 setupTime 0
set_interface_property m1 timingUnits Cycles
set_interface_property m1 writeWaitTime 0
set_interface_property m1 ENABLED true
set_interface_property m1 EXPORT_OF ""
set_interface_property m1 PORT_NAME_MAP ""
set_interface_property m1 CMSIS_SVD_VARIABLES ""
set_interface_property m1 SVD_ADDRESS_GROUP ""

add_interface_port m1 avm_m1_write write Output 1
add_interface_port m1 avm_m1_read read Output 1
add_interface_port m1 avm_m1_waitrequest waitrequest Input 1
add_interface_port m1 avm_m1_readdatavalid readdatavalid Input 1
add_interface_port m1 avm_m1_address address Output 16
add_interface_port m1 avm_m1_writedata writedata Output 32
add_interface_port m1 avm_m1_readdata readdata Input 32



GIT_ROOT 	= $(shell git rev-parse --show-toplevel)
SCRIPT_DIR 	= $(GIT_ROOT)/scripts/quartus

# device part
PART = EP2C35F672C7
# device family
FAMILY = Cyclone II
# project name
PROJECT = hack
# top level name
TOP = top
# verilog source files
VERILOG += $(GIT_ROOT)/rtl/ps2/ps2_debounce.sv
VERILOG += $(GIT_ROOT)/rtl/ps2/ps2_scancode2ascii.sv
VERILOG += $(GIT_ROOT)/rtl/ps2/ps2_host.sv
VERILOG += $(GIT_ROOT)/fpga/de2/uart/uart_baud.sv
VERILOG += $(GIT_ROOT)/fpga/de2/uart/uart_tx.sv
VERILOG += $(GIT_ROOT)/fpga/de2/top.sv
# verilog define
DEFINE = DE2
# sdc files
SDC	= $(PWD)/timing.sdc
# pin assignment files
PIN = $(PWD)/pin.tcl
# project output directory
OUT_DIR ?= outputs

include $(GIT_ROOT)/scripts/quartus/makefile.mk
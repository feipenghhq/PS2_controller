# -------------------------------------------------------------------
# Copyright 2025 by Heqing Huang (feipenghhq@gamil.com)
# -------------------------------------------------------------------
#
# Project: Hack on FPGA
# Author: Heqing Huang
# Date Created: 06/13/2025
#
# -------------------------------------------------------------------
# Basic Test for hack_top
# -------------------------------------------------------------------

import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock
from PS2DeviceBFM import PS2DeviceBFM

async def init(dut, period = 10):
    """
    Initialize the environment: setup clock, load the hack rom and reset the design
    """
    # start clock
    cocotb.start_soon(Clock(dut.clk, period, units = 'ns').start()) # clock
    # generate reset
    dut.rst_n.value = 0
    await Timer(5, units="ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

async def check(dut, golden):
    """
    check the received data
    """
    for data in golden:
        await RisingEdge(dut.valid)
        assert (dut.scan_code.value == data)


@cocotb.test()
async def ps_test(dut):
    """
    PS2 test
    """
    data = [0xde, 0xad, 0xbe, 0xef]
    BFM = PS2DeviceBFM(dut.ps2_clk, dut.ps2_data)
    await init(dut)
    cocotb.start_soon(check(dut, data))
    for d in data:
        await BFM.send(d)
    await Timer(100, units='ns')

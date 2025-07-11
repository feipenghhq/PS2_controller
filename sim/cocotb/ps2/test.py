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
from cocotb.triggers import FallingEdge, RisingEdge, Timer
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

async def check_scancode(dut, golden):
    """
    check the received data
    """
    for data in golden:
        await RisingEdge(dut.valid)
        await FallingEdge(dut.clk)
        assert (dut.scan_code.value == data)

async def check_ascii(dut, golden):
    """
    check the received data
    """
    for value, pressed in golden:
        await RisingEdge(dut.ascii_valid)
        await FallingEdge(dut.clk)
        assert (dut.ascii.value == value), f"Get: {dut.ascii.value}, Expected: {value}"
        assert (dut.pressed.value == pressed)


async def test(dut, data, ascii_golden):
    BFM = PS2DeviceBFM(dut.ps2_clk, dut.ps2_data)
    await init(dut)
    cocotb.start_soon(check_scancode(dut, data))
    cocotb.start_soon(check_ascii(dut, ascii_golden))
    for d in data:
        await BFM.send(d)
    await Timer(100, units='ns')

@cocotb.test()
async def test_basic(dut):
    """
    Test basic keys
    """
    data = [0x1C, 0xF0, 0x1C, 0x1B] # a, s
    ascii_golden = [(0x61, 1), (0x61, 0), (0x73, 1)]
    await test(dut, data, ascii_golden)

@cocotb.test()
async def test_key_with_E0(dut):
    """
    Test keys start with E0
    """
    data = [0x1C, 0xF0, 0x1C, 0x1B] # right arrow
    ascii_golden = [(0x61, 1), (0x61, 0), (0x73, 1)]
    await test(dut, data, ascii_golden)
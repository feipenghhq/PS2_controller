# -------------------------------------------------------------------
# Copyright 2025 by Heqing Huang (feipenghhq@gamil.com)
# -------------------------------------------------------------------
#
# Project: PS2 Controller
# Author: Heqing Huang
# Date Created: 07/09/2025
#
# -------------------------------------------------------------------
# PS2 Device BFM
# -------------------------------------------------------------------

from cocotb.triggers import Timer

class PS2DeviceBFM:

    def __init__(self, ps2_clk, ps2_data, period=10):
        """
        Args:
            ps2_clk : DUT ps2_clk signal
            ps2_data : DUT ps2_data signal
            period : ps2_clk period (in us)
        """
        self.ps2_clk = ps2_clk
        self.ps2_data = ps2_data
        self.period=period
        # default value park at high level
        self.ps2_clk.value = 1
        self.ps2_data.value = 1


    async def send(self, code):
        """
        Sent a Scancode
        """
        parity = self.calc_odd_parity(code)
        # send start condition
        await self._bit(0)
        # send the scan code
        for i in range(8):
            bit = code & 0x1        # lsb is sent first
            await self._bit(bit)
            code = code >> 1
        # send the parity
        await self._bit(parity)
        # send the stop condition
        await self._bit(1)

    async def _bit(self, bit):
        """
        Send 1 bit of information
        """
        self.ps2_data.value = bit
        await Timer(self.period/2, units="us")
        self.ps2_clk.value = 0
        await Timer(self.period/2, units="us")
        self.ps2_clk.value = 1

    def calc_odd_parity(self, byte):
        return 0 if bin(byte).count('1') % 2 else 1

# 32-Point FFT Hardware Design

A digital hardware project implementing a **32-point Fast Fourier Transform (FFT)** in Verilog. The design is verified using MATLAB models and simulation tools, and synthesized for FPGA using Xilinx Vivado and Questasim.

## 📌 Project Overview

This project aims to implement a **32-point complex FFT** using Verilog with efficient area utilization. Two architectures were developed:

- **Multi-Stage Architecture**: Each of the 5 stages uses dedicated MAC units.
- **MAC Reuse Architecture**: A more area-efficient version that reuses 16 MAC units across all stages.

Both designs were synthesized and tested on a **Xilinx XCZU440FLGA2892-2 FPGA**.

---

## ⚙️ Key Features

- **Complex, Signed Input Support**
- **Fixed-Point Representation (Q8.8)**
- **MAC Reuse Architecture for Area Efficiency**
- **Twiddle Factor ROM with Feedback Control**
- **Testbench Verification and MSE Analysis**
- **Synthesized on Xilinx Vivado 2020.2**
- **Simulated on Questasim 2021**

---

## 🧠 Algorithm Summary

The project implements the **Cooley-Tukey FFT algorithm** using Decimation-In-Frequency (DIF):

\[
X_K = E_K + W_N^K O_K
\]

Where:
- \(E_K\) and \(O_K\) are even and odd indexed sub-FFTs.
- \(W_N^K\) is the twiddle factor.

### 📐 Fixed-Point Precision

- Input: 8-bit (4 integer, 4 fraction)
- Output: 16-bit (1 sign, 7 integer, 8 fraction)
- Error validated via MATLAB vs Hardware MSE comparison.

---

## 🏗️ Architecture Diagrams

### Traditional Multi-Stage FFT
![Multi-Stage Architecture](images/multi_stage_architecture.png)  
*Each stage uses 16 dedicated MAC units.*

### MAC Reuse Architecture
![MAC Reuse Architecture](images/mac_reuse_architecture.png)  
*Only 16 MAC units are reused across all 5 FFT stages using control logic and feedback.*

#### Control Logic Overview
![Control Unit Diagram](images/control_unit.png)  
*Controls ISL (input select), stage advancement (SB), and valid output flag.*

#### Routing Network
![Routing Network](images/routing_network.png)  
*Handles input/output permutation and butterfly mapping.*

---

## 📊 Resource Utilization (on Xilinx XCZU440)

| Metric           | Multi-Stage    | MAC Reuse     | Improvement |
|------------------|----------------|---------------|-------------|
| CLBs             | 1370 (0.43%)   | 1135 (0.36%)  | ↓ 17.15%    |
| LUTs (Logic)     | 6864 (0.27%)   | 5777 (0.23%)  | ↓ 15.83%    |
| DSP Blocks       | 320            | 64            | ↓ 80%       |

---

## ⏱️ Timing Summary (100 MHz Clock)

| Architecture     | WNS (Setup) | Hold Slack |
|------------------|-------------|------------|
| Multi-Stage      | 1.425 ns    | 0.03 ns    |
| MAC Reuse        | 1.666 ns    | 0.027 ns   |

---

## 🧪 Testing Methodology

- MATLAB model (`fft_butterfly_32.m`) generates golden reference.
- Verilog DUT input/output compared with MATLAB outputs.
- MSE is calculated and logged.
- Tested in:
  - **Pre-synthesis**: Functional simulation via Questasim
  - **Post-synthesis**: Timing-correct simulation via Vivado

---

## 📁 Directory Structure


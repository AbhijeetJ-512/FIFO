# Asynchronous FIFO (First-In, First-Out) – Verilog Implementation

This module implements an **Asynchronous FIFO** buffer using Verilog HDL. It is designed for systems where **read and write operations occur under different clock domains**, ensuring robust and reliable data transfer across asynchronous boundaries.

Such designs are essential in high-performance systems involving clock domain crossing (CDC), enabling safe communication without metastability or data loss.

![asynchronous_fifo](/assets/Asynchronous_FIFO.png)

---

## 🔧 Module: `asynchronous_fifo`

### ➤ Parameters

| Name         | Default | Description                          |
|--------------|---------|--------------------------------------|
| `DEPTH`      | `8`     | Depth (number of FIFO entries)       |
| `DATA_WIDTH` | `8`     | Width of each data word in bits      |

---

### ➤ Ports

| Port Name   | Direction | Width         | Description                                   |
|-------------|-----------|---------------|-----------------------------------------------|
| `wclk`      | Input     | 1-bit         | Write domain clock                            |
| `rclk`      | Input     | 1-bit         | Read domain clock                             |
| `rst_n`     | Input     | 1-bit         | Asynchronous active-low reset                 |
| `w_en`      | Input     | 1-bit         | Write enable                                  |
| `r_en`      | Input     | 1-bit         | Read enable                                   |
| `data_in`   | Input     | DATA_WIDTH    | Data input to be written into the FIFO        |
| `data_out`  | Output    | DATA_WIDTH    | Data output read from the FIFO                |
| `full`      | Output    | 1-bit         | FIFO full status flag                         |
| `empty`     | Output    | 1-bit         | FIFO empty status flag                        |

---

## ⚙️ Functionality Overview

The Asynchronous FIFO operates with **Different read and write clocks**, incorporating:

- **Binary and Gray-coded pointers** for robust address generation
- **Dual clock-domain pointer synchronizers** to prevent metastability
- **Dedicated pointer handler modules** (`w_ptr_handler`, `r_ptr_handler`)
- **FIFO memory** module (`fifo_mem`) for storing data entries

---

## ✅ Key Features
- Clock-domain crossing support
- Gray code pointer implementation
- Accurate `full` and `empty` detection
- Modular design enabling reuse and scalability
- Suitable for SoC and FPGA-based data interfacing applications

--- 

## 🔄 Applications
- High-speed UART/AXI Stream interfaces
- Processor-to-peripheral communication bridges
- Multi-clock domain DSP pipelines
- FPGA-based data acquisition systems
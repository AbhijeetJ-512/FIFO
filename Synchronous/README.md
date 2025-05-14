# Synchronous FIFO (First-In, First-Out) – Verilog Implementation

This module implements a **Synchronous FIFO** buffer using Verilog HDL. It is used to temporarily store data where both read and write operations are controlled by the **same clock domain**. This FIFO design is suitable for digital systems requiring reliable and straightforward data queuing mechanisms.

![synchronous_fifo](/assets/Synchronous_FIFO.png)

---

## 🔧 Module: `synchronous_fifo`

### ➤ Parameters

| Name         | Default | Description                        |
|--------------|---------|------------------------------------|
| `DEPTH`      | `10`    | Depth (number of FIFO entries)     |
| `DATA_WIDTH` | `32`    | Width of each data word in bits    |

### ➤ Ports

| Port Name   | Direction | Width         | Description                        |
|-------------|-----------|---------------|------------------------------------|
| `clk`       | Input     | 1-bit         | Clock signal                       |
| `rst_n`     | Input     | 1-bit         | Active-low reset                   |
| `w_en`      | Input     | 1-bit         | Write enable                       |
| `r_en`      | Input     | 1-bit         | Read enable                        |
| `data_in`   | Input     | DATA_WIDTH    | Data to be written into FIFO       |
| `data_out`  | Output    | DATA_WIDTH    | Data read from FIFO                |
| `full`      | Output    | 1-bit         | FIFO full status flag              |
| `empty`     | Output    | 1-bit         | FIFO empty status flag             |

---

## ⚙️ Functionality

The FIFO operates as a **circular buffer**, using:

- `w_ptr`: write pointer
- `r_ptr`: read pointer
- `count`: counter to track FIFO occupancy

### Key Behaviors

- On `w_en`, data is written to FIFO if not `full`
- On `r_en`, data is read from FIFO if not `empty`
- `count` keeps track of how many elements are stored
- `full` and `empty` flags are derived from `count`

---

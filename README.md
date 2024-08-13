# GEMM

## Overview

The GEMM module accelerates matrix multiplication using a Systolic Array. Each Processing Element (PE) in the array performs a Multiply-Accumulate (MAC) operation.

## Key Features

- **Parallel Processing:** The systolic array's PEs perform multiple operations simultaneously, unlike a CPU.
- **Efficient Data Handling:** Intermediate results are stored in PE registers and written to a Global Buffer, reducing off-chip memory usage.
- **SRAM Interface:** Supports A, B, and C SRAM Buffers to optimize memory access.

## Controller

The controller manages data flow by:

- Scheduling data from global buffers A and B
- Executing computations with PEs
- Writing results to buffer C over multiple clock cycles

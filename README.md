# FPGA Music Player with Embedded PicoBlaze Processor

## Project Overview
This project implements a **Simple IPod** on an FPGA board using Verilog HDL.  
It interfaces with on-board **Flash memory**, a **keyboard**, and **audio output**, and integrates an **embedded PicoBlaze processor** to perform **real-time digital signal processing (DSP)** — specifically, an **averaging filter** that measures signal strength and displays it on LEDs.

The design demonstrates fundamental concepts of **finite state machines (FSMs)**, **hardware–software co-design**, and **peripheral interfacing**, culminating in a small but complete embedded audio system.

---

## Features
### 🎧 Audio Playback
- Reads 16-bit (or optionally 8-bit) audio samples from on-board Flash memory.
- Streams data to the DE1-SoC’s **audio D/A converter** at 22 kHz sampling rate.
- Supports **play**, **pause**, **forward**, **backward**, and **reset** controls via the keyboard.

### 🎹 Keyboard Interface
- PS/2 keyboard controls playback:
  - `E` → Play  
  - `D` → Stop  
  - `B` → Reverse playback  
  - `F` → Forward playback  
  - `R` → Restart

### Embedded Processor (PicoBlaze)
- Performs real-time averaging over 256 consecutive samples.
- Displays signal strength using **LED bar visualization**.
- Demonstrates a hybrid hardware/software control architecture.

### Clock and Control
- Uses a **frequency divider** (27 MHz → 22 kHz) for sampling rate control.
- Synchronizes asynchronous domains with edge-detection logic.
- Speed adjustment through on-board keys:
  - `KEY0` → Increase playback speed  
  - `KEY1` → Decrease playback speed  
  - `KEY2` → Reset speed to normal

---

## Design Concepts
This project brings together several core hardware design ideas:
- **FSM Design:** Structured control of Flash memory and playback logic.
- **Bus Protocols:** Avalon-MM signaling for Flash read operations.
- **Embedded Processing:** Offloading DSP tasks to PicoBlaze.
- **Clock Domain Crossing:** Synchronizing asynchronous data domains.
- **Digital Filtering:** Implementing averaging as a simple low-pass filter.

---

## Simulation and Testing
- **Quartus Prime** used for synthesis, timing analysis, and SignalTap debugging.
- **ModelSim-Altera** used for FSM and clock-divider simulation.
- Real-time testing performed using:
  - Flash memory loaded with `american_hero_song.hex`
  - Keyboard input via PS/2 interface
  - Audio output via Line-Out jack

---

## LED Strength Meter
The PicoBlaze interrupt routine computes the **average of 256 absolute sample values** and updates the LED display accordingly:
- LED bar fills **from left to right** based on average magnitude.
- Implements division by 256 through bit shifting (power-of-two optimization).
- Demonstrates embedded DSP principles using integer arithmetic.

---

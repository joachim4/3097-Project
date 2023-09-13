# Acoustic Triangulation using Time Difference of Arrival and a Distributed Sensor Network
# EEE3097S Project

## Introduction

This project implements an Acoustic Triangulation system using the Time Difference of Arrival (TDoA) technique and a distributed sensor network. The system consists of four microphones placed at the corners of an A1 grid paper, which can capture sound signals from a sound source placed anywhere within the grid. The captured audio data is processed by two Raspberry Pi devices to calculate cross-correlation and time differences of arrival, enabling the estimation of the sound source's location. MATLAB is utilized for most of the calculations in this project.

The primary objectives of this project are:
- Accurate localization of a sound source within the grid.
- Demonstrating the feasibility of TDoA-based sound source localization in a low-cost, distributed sensor network.

## Hardware Setup

### Components Required
- Four microphones
- Two Raspberry Pi devices
- A1 grid paper
- Sound source (e.g., a speaker)
- Cables and connectors
- Power supply for Raspberry Pi devices

### Hardware Configuration
1. Place the four microphones at the corners of the A1 grid paper.
2. Connect the microphones to the Raspberry Pi devices. You may need an external ADC for analog microphone inputs.
3. Ensure the Raspberry Pi devices are connected to a power source and have internet connectivity if required.


## Software Setup

### Raspberry Pi Configuration
1. Install the necessary libraries on the Raspberry Pi, including Python libraries for audio input and output.
2. Set up network communication between the Raspberry Pi devices for data exchange.

### MATLAB Environment
1. Install MATLAB on a computer.
2. Create MATLAB scripts for cross-correlation and TDoA calculations.
3. Ensure that MATLAB can communicate with the Raspberry Pi devices for data retrieval.

## Usage

1. Power on the Raspberry Pi devices.
2. Run the MATLAB scripts for data acquisition, cross-correlation, and TDoA calculations.
3. The estimated sound source location will be displayed or saved as an output.

## Contributing

Contributions to this project are welcome. To contribute, follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your changes to your fork.
5. Submit a pull request to the main repository.

Please adhere to the project's coding standards and guidelines.

**Disclaimer:** This project is for educational and experimental purposes. It may require adjustments and further development for specific applications. Use it responsibly and consider local regulations regarding sound and data privacy.

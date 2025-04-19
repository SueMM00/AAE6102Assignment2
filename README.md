# AAE6102Assignment2

# Project Tasks Overview

This repository contains MATLAB implementations supporting advanced navigation and data filtering processes. The primary components include sky region masking and weighted position estimation integrated with integrity monitoring.

# Task 1: A Comparative Analysis of GNSS Techniques for Smartphone Navigation

Global Navigation Satellite Systems (GNSS) have become integral to modern smartphone-based navigation. While standard GNSS provides positioning with an accuracy of approximately 5–10 meters, the demands of emerging applications—such as augmented reality, autonomous vehicles, and lane-level navigation—require significantly higher precision. 

This paper presents a comparative analysis of four advanced GNSS positioning techniques with particular focus on their applicability to smartphone platforms:

- Differential GNSS (DGNSS)
- Real-Time Kinematic (RTK)
- Precise Point Positioning (PPP)
- PPP-RTK (Precise Point Positioning with Real-Time Kinematic corrections)

---

##  1. Differential GNSS (DGNSS)

### Methodology
DGNSS enhances positioning accuracy by utilizing correction data from ground-based reference stations. These stations, located at precisely known coordinates, calculate real-time errors in satellite-derived positions and transmit correction messages to nearby receivers. This technique primarily relies on code-phase corrections.

### Advantages
- **Improved Accuracy**: Reduces standard GNSS error margins to approximately 1–3 meters.
- **Low System Complexity**: Requires minimal computational power and can be implemented efficiently on mobile devices.
- **Modest Bandwidth Requirements**: Correction data is relatively lightweight, making it suitable for real-time applications.

### Limitations
- **Limited Precision**: As it depends on code-phase measurements, it cannot achieve sub-meter or centimeter-level accuracy.
- **Infrastructure Dependency**: Requires proximity (typically within 100 km) to a reference station.
- **Urban Limitations**: Performance can degrade in urban canyons due to multipath interference.

### Smartphone Suitability
DGNSS is suitable for general-purpose navigation on smartphones, especially those equipped with dual-frequency GNSS chips. However, its accuracy is insufficient for high-precision applications.

---

##  2. Real-Time Kinematic (RTK)

### Methodology
RTK is a high-precision technique that leverages both code-phase and carrier-phase GNSS measurements. By receiving real-time corrections from a base station or a network (typically via NTRIP), the receiver can resolve integer ambiguities to achieve centimeter-level positioning.

### Advantages
- **High Accuracy**: Achieves real-time positioning within 1–2 cm.
- **Low Latency**: Rapid convergence and high update rates make it suitable for dynamic environments.

### Limitations
- **Data Dependency**: Requires continuous access to a base station or correction service via a stable data connection.
- **High Computational Load**: Integer ambiguity resolution is resource-intensive.
- **Limited Smartphone Compatibility**: Most smartphones do not support direct carrier-phase data processing.

### Smartphone Suitability
RTK provides exceptional accuracy but is currently impractical for widespread smartphone use due to hardware limitations and infrastructure demands.

---

##  3. Precise Point Positioning (PPP)

### Methodology
PPP enhances position accuracy by using precise satellite orbit and clock corrections provided by global reference networks. It employs dual-frequency carrier-phase observations and atmospheric delay models to correct GNSS errors without requiring a local base station.

### Advantages
- **Global Applicability**: Functions without dependence on local infrastructure.
- **Infrastructure-Free Accuracy**: Provides decimeter-level accuracy once convergence is achieved.

### Limitations
- **Extended Convergence Time**: Requires 10–30 minutes to reach full precision due to ambiguity resolution challenges.
- **Computational Requirements**: Demands significant processing capability, which can strain mobile devices.
- **Limited Real-Time Application**: Poor suitability for time-sensitive or fast-moving scenarios.

### Smartphone Suitability
PPP is well-suited for static or post-processed applications but is currently suboptimal for real-time smartphone navigation.

---

##  4. PPP-RTK (Hybrid Approach)

### Methodology
PPP-RTK combines the global correction capabilities of PPP with regional real-time corrections similar to RTK. This hybrid approach uses precise satellite data along with regional atmospheric and satellite bias corrections, typically delivered via cloud-based services.

### Advantages
- **High Precision and Fast Convergence**: Offers accuracy comparable to RTK with convergence times under 2 minutes.
- **Scalability**: Suitable for wide-scale deployment without local base stations.
- **Cloud Integration**: Compatible with modern data-driven infrastructures.

### Limitations
- **Connectivity Requirement**: Depends on reliable internet access for real-time correction data.
- **Ecosystem Immaturity**: Still under development, with limited support across commercial smartphones.
- **Moderate Processing Demands**: Less than RTK but still higher than basic GNSS or DGNSS.

### Smartphone Suitability
PPP-RTK is a promising solution for next-generation smartphone navigation, offering a viable balance of scalability, accuracy, and convergence speed.

---

##  Summary Table

| Technique   | Accuracy     | Convergence Time | Infrastructure Requirement | Smartphone Feasibility      |
|-------------|--------------|------------------|-----------------------------|------------------------------|
| DGNSS       | ~1–3 meters  | Seconds          | Local base station          | High                         |
| RTK         | ~1–2 cm      | Seconds–Minutes  | Base station + data link    | Low                          |
| PPP         | ~10–50 cm    | 10–30 minutes    | None                        | Medium (limited by hardware)|
| PPP-RTK     | ~5–20 cm     | 1–2 minutes      | Cloud-based correction      | Emerging (promising)         |

---

##  Conclusion

Each GNSS technique evaluated in this report presents unique trade-offs in terms of accuracy, infrastructure dependency, convergence speed, and suitability for integration into smartphones. 

- **DGNSS** is currently the most practical for consumer-grade smartphone navigation due to its simplicity and acceptable accuracy.
- **RTK** delivers superior precision but is constrained by hardware and infrastructure requirements.
- **PPP** offers global coverage without local infrastructure but suffers from delayed convergence.
- **PPP-RTK** stands out as a promising hybrid, combining the scalability of PPP with the rapid accuracy of RTK.

As dual-frequency GNSS chipsets and cloud-based correction services become more common in smartphones, **PPP-RTK is likely to emerge as the most viable high-precision GNSS solution** for mobile platforms in the near future.

---

##  Use of AI

Model: Self-created ChatGPT 4o: Subu
Prompt:
"Write a short essay (500–1000 words) comparing the pros and cons for the following GNSS techniques: Differential GNSS (DGNSS), Real-Time Kinematic (RTK), Precise Point Positioning (PPP), and PPP-RTK for smartphone navigation."

"Give more details on the method and explain why they have such pros and cons."

"Make it to a short essay that clearly compares those GNSS techniques with pros and cons and reasons."

"Make it into readme.md format."

"Make the content more like an easily read essay."

"Make it more academic."
Comment (the reason for using this model): It’s great for reasoning and answering questions.
Chatroom link (if any): https://chatgpt.com/share/e/68021efb-3e70-800a-85ba-f346b4b6e3e2

---


# Task 2: Sky Mask Filtering

- **File:** `applySkymaskFilter.m`  
- **Function:** `applySkymaskFilter`  
- **Description:**  
  This function is a critical component of the **postnavigation phase**. This function is designed based on the method of Non-Line-of-Sight (NLOS). It applies a sky mask to isolate the sky region from input data such as satellite azimuth and elevation angles collected during navigation. By filtering out non-sky elements, it helps produce **cleaner and more relevant data** for downstream processing.

- **Key Features:**
  - Masking and filtering of irrelevant environmental components
  - Enhances the reliability of subsequent computations

- **Role in Workflow:**
  The filtered sky data output from this function is used to inform and refine subsequent tasks—particularly the WLS positioning process in Task 3.

---

# Task 3: Weighted Least Squares (WLS) Positioning & RAIM Integration

- **File:** `WLSPos.m`  
- **Functionality:**
  - Executes **Weighted Least Squares (WLS)** calculations
  - Integrates **Receiver Autonomous Integrity Monitoring (RAIM)** to evaluate and ensure the reliability of positioning results

- **Description:**  
  The `WLSPos.m` file is responsible for optimizing position estimates by leveraging WLS algorithms. It operates on data refined through the `applySkymaskFilter` process, allowing for more accurate and noise-resilient calculations. The inclusion of the **RAIM algorithm** further strengthens system integrity by detecting and mitigating potential positioning errors.

- **Key Features:**
  - Built-in RAIM for integrity monitoring and error detection

- **Role in Workflow:**
  This function is typically called **after sky masking**, using the cleaner input data to enhance accuracy and integrity in the computed navigation solution.



# Task 4: Challenges of LEO Communication Satellites for GNSS Navigation

## Introduction

Low Earth Orbit (LEO) satellites have become a staple in communication systems, offering advantages such as high data transfer speeds and low latency. However, when it comes to using them for Global Navigation Satellite System (GNSS) navigation, they present a set of unique challenges. This document aims to analyze why LEO satellites are widely used for communication but face difficulties in navigation applications.

## Why LEO Satellites are Popular in Communication

**High Data Transfer and Low Latency:** Due to their proximity to the Earth's surface (orbiting at altitudes typically between 160 - 2000 kilometers), LEO satellites enable fast data transfer rates. The shorter signal path reduces latency, making them ideal for applications like satellite-based internet services.

**Strong Signal Strength:** Their closeness to ground-based users means that the signal strength can be relatively robust, facilitating efficient communication over short distances.

**Global Coverage Constellations:** By deploying a constellation of LEO satellites, global communication coverage can be achieved, catering to a wide range of users and applications.

## Challenges for GNSS Navigation

### 1. Satellite Visibility and Coverage

**Challenge:** LEO satellites have a short orbital period of approximately 90 minutes. This rapid movement results in intermittent visibility for ground-based receivers. For accurate navigation, a continuous view of multiple satellites is necessary, but LEO satellites quickly move out of the receiver's line of sight.

**Reason:** The Earth's curvature and the limited angular range of the receiver's antenna play a significant role. As the satellite moves beyond the antenna's effective range, the signal cannot be received, leading to gaps in positioning data.

### 2. Signal Propagation Issues

#### Multipath Effects

**Challenge:** In urban or complex terrains, LEO satellite signals are more likely to experience multipath effects. Signals can bounce off buildings, terrain, and other structures before reaching the receiver. These reflected signals interfere with the direct signal, causing errors in measuring the signal's arrival time, which is crucial for calculating the distance between the satellite and the receiver.

**Reason:** The close proximity of LEO satellites to the Earth's surface increases the probability of signal reflections. Shorter signal paths mean that multiple reflections can occur within a short time interval, complicating signal processing.

#### Atmospheric and Ionospheric Interference

**Challenge:** As LEO satellite signals pass through the Earth's atmosphere and ionosphere, they are subject to interference. Atmospheric turbulence can cause fluctuations in the refractive index of the air, altering the signal's phase and amplitude. In the ionosphere, charged particles can refract, scatter, and delay the signals, introducing errors in navigation calculations.

**Reason:** The density and composition of the atmosphere and ionosphere vary with altitude, latitude, time of day, and solar activity. LEO satellites operate in an environment where these variations can have a significant impact on signal propagation.

### 3. Constellation Design and Management

**Challenge:** Achieving global navigation coverage with LEO satellites requires a large constellation. Designing, deploying, and managing such a constellation is a complex and costly task. Coordinating the orbits, frequencies, and operations of numerous satellites to avoid interference and ensure consistent performance is extremely difficult.

**Reason:** The orbital dynamics of LEO satellites are complex due to the Earth's gravitational field and atmospheric drag. Frequent orbit adjustments are needed to maintain the desired orbital positions. Additionally, the limited frequency spectrum requires careful planning to prevent interference between satellites and other communication systems.

### 4. Integration with Existing GNSS Infrastructure

**Challenge:** Existing GNSS receivers are optimized for satellites in Medium Earth Orbit (MEO) or Geostationary Orbit (GEO). These receivers are designed to work with specific signal characteristics such as frequencies, modulation schemes, and orbital dynamics. Adapting them to work with LEO satellites, which have different signal characteristics, requires significant hardware and software modifications.

**Reason:** The higher Doppler shift of LEO satellite signals, caused by their rapid motion, demands that receivers have a wider Doppler tracking range. The different modulation formats used by LEO satellites may also require changes to the demodulation algorithms in the receiver's software.

## Conclusion

While LEO satellites offer significant advantages in communication, their application in GNSS navigation is hindered by several challenges. Overcoming these challenges will require innovative solutions in satellite design, signal processing, and receiver technology to fully utilize the potential of LEO satellites for navigation purposes.

##  Use of AI

Model: Doubao
Prompt:
"Low Earth Orbit (LEO) satellites are widely used for communication purposes but present unique challenges when utilized for navigation. Write a short essay (500–1000 words) discussing: The difficulties and challenges of using LEO communication satellites for GNSS navigation."

"give more details on the unique challenges and provide technical reasons behind the difficulties"

"make it to 500-1000 words"

"show the discussion to analyse the challenges of LEO communication satellites, why it is widely used for communication purposes but has unique challenges for navigation"

"make it to readme.md format"

Comment (the reason for using this model): It can be plugged in to the web and is good for reasoning.
Chatroom link (if any): [https://chatgpt.com/share/e/68021efb-3e70-800a-85ba-f346b4b6e3e2](https://www.doubao.com/thread/wd75ab8456278bc2d)



# Task 5: GNSS and Its Role in GNSS Radio Occultation (GNSS-RO)

GNSS serves as the fundamental cornerstone for GNSS Radio Occultation (GNSS-RO), significantly influencing its operation, data collection, and the diverse applications it supports. Here's a detailed exploration of how GNSS impacts GNSS-RO and the key usages of this powerful remote sensing technique.

## The Role of GNSS in GNSS-RO

### Signal Source

GNSS satellites, such as those from GPS, GLONASS, Galileo, and BeiDou, continuously broadcast radio signals that form the basis of GNSS-RO measurements. These signals, with their precisely defined frequencies and modulation schemes, act as probes that penetrate the Earth's atmosphere and ionosphere. As the signals travel through these layers, they interact with the varying density of gases in the atmosphere and charged particles in the ionosphere, undergoing refraction, scattering, and absorption. The resulting changes in the signal's phase, amplitude, and time delay carry information about the physical properties of the medium through which they have passed.

### Timing and Positioning Reference

GNSS provides an extremely accurate time reference through its onboard atomic clocks. This precise timing is critical for GNSS-RO, as it allows for accurate measurement of the time it takes for the signal to travel from the satellite to the receiver. By comparing the transmission time (known from the satellite's clock) with the reception time (measured by the receiver), the time delay can be determined with high precision. Additionally, GNSS offers accurate positioning information for both the satellites and the receivers involved in the occultation process. This spatial information is essential for reconstructing the signal's path through the atmosphere and ionosphere, enabling the calculation of vertical profiles of various parameters.

## Impact of GNSS on GNSS-RO

### Enhanced Data Quality and Quantity

The large constellations of GNSS satellites ensure a high number of potential occultation events. With multiple satellites in view at any given time and location, GNSS-RO can collect a vast amount of data globally. This extensive data collection improves the spatial and temporal coverage of measurements, providing a more comprehensive understanding of the atmosphere and ionosphere. Moreover, the high - quality signals from GNSS satellites, along with their precise timing and positioning capabilities, lead to more accurate and reliable measurements, enhancing the overall quality of the data obtained through GNSS-RO.

### Increased Reliability and Consistency

GNSS is a well - established and highly reliable system. Its global coverage and the redundancy provided by multiple satellite constellations make GNSS-RO a robust remote sensing technique. The consistent operation of GNSS satellites over time allows for long - term monitoring of the atmosphere and ionosphere, enabling the detection of trends and changes. This reliability and consistency are crucial for applications such as climate research, where long - term, stable data sets are required to draw meaningful conclusions about environmental changes.

## Usage of GNSS Radio Occultation (GNSS-RO)

### Meteorology and Weather Forecasting

GNSS-RO measurements provide high - resolution vertical profiles of temperature, pressure, and humidity in the atmosphere. These profiles are invaluable for improving weather forecasting models. In regions where traditional weather observation data is scarce, such as over the oceans or in remote areas, GNSS-RO data can fill in the gaps and improve the accuracy of initial conditions in numerical weather prediction models. By accurately representing the state of the atmosphere, GNSS-RO helps in predicting the development and movement of weather systems, including storms, fronts, and cyclones, leading to more accurate and timely weather forecasts.

### Climate Science

GNSS-RO data is used to study long - term climate trends. The stable and consistent nature of GNSS-RO measurements over time makes it an ideal tool for monitoring changes in the atmosphere. Scientists can analyze decades of data to detect trends in temperature profiles, humidity distribution, and other atmospheric parameters. This information is essential for understanding the mechanisms of climate change, validating climate models, and assessing the impact of human activities on the climate system.

### Space Weather Monitoring

The ionosphere, which is affected by solar activity, can cause disruptions to radio communications, satellite navigation, and power grids. GNSS-RO can measure the electron density in the ionosphere with high precision. By continuously monitoring the ionosphere using GNSS-RO, scientists can detect ionospheric disturbances caused by solar flares, coronal mass ejections, and other space weather events. This early detection allows for the issuance of timely warnings, enabling operators of critical infrastructure to take preventive measures to minimize the impact of space weather on their systems.

### Atmospheric Research

GNSS-RO data contributes to a wide range of atmospheric research topics. It helps in studying the dynamics of the atmosphere, such as the movement of air masses, the formation of jets, and the development of atmospheric waves. Additionally, by analyzing the changes in the refractive index of the atmosphere measured by GNSS-RO, scientists can investigate the distribution and behavior of trace gases, which are important for understanding air quality and the Earth's climate - chemical processes.

##  Use of AI

Model: Doubao
Prompt:
"Task 5 – GNSS Remote Sensing
GNSS is not only used for positioning and navigation but also has significant applications in remote sensing. Write a short essay (500–1000 words) discussing the impact of GNSS in remote sensing. Please select one of the following topics covered in the lecture to discuss:

GNSS Reflectometry (GNSS-R)
GNSS Interferometric Reflectometry (GNSS-IR)
GNSS Radio Occultation (GNSS-RO)
Ionosphere mapping based GNSS ground station
GNSS seismology"

"discuss how important is GNSS and how it is used for remote sensing such as GNSS Radio Occultation (GNSS-RO)"

"discuss deeply on the method of GNSS Radio Occultation (GNSS-RO), and the important usage of GNSS Radio Occultation (GNSS-RO)"

"GNSS is not only used for positioning and navigation, talk about the impact of GNSS in the application of GNSS Radio Occultation (GNSS-RO)"

"discuss deeply on how GNSS helps in achieving GNSS Radio Occultation (GNSS-RO) for those functions"

"focus more talking about GNSS's role, its impact on GNSS radio occultation (GNSS-RO), and the usage of GNSS radio occultation (GNSS-RO)"

Comment (the reason for using this model): It can be plugged in to the web and is good for reasoning.
Chatroom link (if any): https://www.doubao.com/thread/w2abaf99670e76577

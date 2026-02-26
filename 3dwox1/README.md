# Sindoh 3DWOX 1 — PrusaSlicer Configuration Guide

Complete step-by-step instructions for configuring **PrusaSlicer 2.9.x** to produce correct gcode for the **Sindoh 3DWOX 1 (3DFF-222)** FDM printer, matching the output quality of the OEM **3DWOX Desktop** slicer.

---

## Table of Contents

- [Printer Overview](#printer-overview)
- [Prerequisites](#prerequisites)
- [Step 1 — Create a New Printer Profile](#step-1--create-a-new-printer-profile)
- [Step 2 — Printer Settings](#step-2--printer-settings)
  - [General](#21-general)
  - [Custom Bed Shape](#22-custom-bed-shape)
  - [Extruder 1](#23-extruder-1)
  - [Start G-code](#24-start-g-code)
  - [End G-code](#25-end-g-code)
- [Step 3 — Print Settings](#step-3--print-settings)
  - [Layers and Perimeters](#31-layers-and-perimeters)
  - [Infill](#32-infill)
  - [Speed](#33-speed)
  - [Support Material & Bed Adhesion](#34-support-material--bed-adhesion)
- [Step 4 — Filament Settings (PLA)](#step-4--filament-settings-pla)
  - [Temperature](#41-temperature)
  - [Cooling](#42-cooling)
  - [Retraction (Filament Overrides)](#43-retraction-filament-overrides)
- [Step 5 — Save Your Profiles](#step-5--save-your-profiles)
- [Verification — 1 cm Calibration Cube](#verification--1-cm-calibration-cube)
- [Settings Reference Table](#settings-reference-table)
- [Known Limitations & Notes](#known-limitations--notes)

---

## Printer Overview

| Spec | Value |
|------|-------|
| **Model** | Sindoh 3DWOX 1 (3DFF-222) |
| **Printer Type** | Cartesian FDM |
| **Extruder Type** | Bowden |
| **Nozzle Diameter** | 0.4 mm |
| **Filament Diameter** | 1.75 mm |
| **Build Volume** | 200 × 200 × 185 mm |
| **Heated Bed** | Yes |
| **OEM Slicer** | 3DWOX Desktop 1.4.2213.1 |

---

## Prerequisites

- **PrusaSlicer 2.9.x** or later installed ([download here](https://www.prusa3d.com/page/prusaslicer_424/))
- Sindoh 3DWOX 1 connected and functional
- PLA filament (1.75 mm) loaded

> **Tip:** Switch PrusaSlicer to **Expert** mode before starting. Go to **Configuration → Mode → Expert** to expose all settings referenced in this guide.

---

## Step 1 — Create a New Printer Profile

1. Open PrusaSlicer
2. Go to **Configuration → Configuration Wizard**
3. On the **Other Vendors** page, skip everything — we'll configure manually
4. Click **Finish**
5. In the **Printer** dropdown (top center), select **Add/Remove Presets → Add a Printer**
6. Start from a generic **RepRap** preset if available, or any FFF preset
7. Name the printer profile: **`3DWOX 1`**

---

## Step 2 — Printer Settings

Navigate to the **Printer Settings** tab (the wrench icon).

### 2.1 General

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Bed shape** | Rectangular 200 × 200 mm | *Printer Settings → General → Bed shape* |
| **Max print height** | `185` mm | *Printer Settings → General → Max print height* |
| **G-code flavor** | `RepRap (Marlin/Sprinter/Repetier)` | *Printer Settings → General → G-code flavor* |
| **Extruders** | `1` | *Printer Settings → General → Extruders* |
| **Supports remaining times** | Unchecked | *Printer Settings → General* |

### 2.2 Custom Bed Shape

1. Click the **Set** button next to *Bed shape*
2. Select **Rectangular**
3. Set **Size X** = `200`, **Size Y** = `200`
4. Set **Origin X** = `0`, **Origin Y** = `0`
5. Click **OK**

This produces the bed shape: `0x0, 200x0, 200x200, 0x200`

### 2.3 Extruder 1

Navigate to *Printer Settings → Extruder 1*:

| Setting | Value | Notes |
|---------|-------|-------|
| **Nozzle diameter** | `0.4` mm | |
| **Retraction → Length** | `6` mm | **Critical** — Bowden tube requires long retraction |
| **Retraction → Lift Z** | `0` mm | OEM does not use Z-hop |
| **Retraction → Speed** | `30` mm/s | Matches OEM exactly |
| **Retraction → Deretraction speed** | `0` (same as retraction) | |
| **Retraction → Minimum travel after retraction** | `1.5` mm | Matches OEM |
| **Retraction → Retract on layer change** | Unchecked | |
| **Retraction → Wipe while retracting** | Unchecked | |

> ⚠️ **Why 6 mm retraction?** The 3DWOX 1 uses a **Bowden extruder** with a PTFE tube between the drive gear and hot end. The default PrusaSlicer value of 2 mm is for direct-drive extruders and will cause severe stringing on this printer. The OEM slicer uses 6 mm — match it.

### 2.4 Start G-code

Navigate to *Printer Settings → Custom G-code → Start G-code*.

**Delete** the default content and paste:

```gcode
G28 ; Home all axes
G1 Z5 F5000 ; Lift nozzle
M190 S[first_layer_bed_temperature] ; Wait for bed temp
M109 S[first_layer_temperature] ; Wait for extruder temp
G92 E0 ; Reset extruder
G1 E10 F200 ; Prime the nozzle
```

**Line-by-line explanation:**

| Line | Command | Purpose |
|------|---------|---------|
| 1 | `G28` | Homes all axes (X, Y, Z) to their endstops |
| 2 | `G1 Z5 F5000` | Raises the nozzle 5 mm to prevent bed scratching during heating |
| 3 | `M190 S[first_layer_bed_temperature]` | Heats the bed and **waits** until target temp is reached. Uses PrusaSlicer variable for temperature |
| 4 | `M109 S[first_layer_temperature]` | Heats the nozzle and **waits** until target temp is reached. Uses PrusaSlicer variable for temperature |
| 5 | `G92 E0` | Resets the extruder position counter to zero |
| 6 | `G1 E10 F200` | Extrudes 10 mm of filament slowly to prime the nozzle before printing |

**Differences from OEM start gcode:**

The OEM 3DWOX Desktop slicer uses this sequence:

```gcode
M140 S60       ; Heat bed (no wait)
M104 T0 S200   ; Heat nozzle (no wait)
M107            ; Fan off
G200            ; Nozzle cleaning (proprietary)
G21             ; Metric units
G90             ; Absolute positioning
G92 E-20        ; Set extruder position
M190 S60        ; Wait for bed temp
M109 T0 S200    ; Wait for nozzle temp
G28             ; Home
G0 F9000 Z3.00  ; Lift
```

> **Note:** `G200` is a **proprietary 3DWOX command** that triggers an automatic nozzle cleaning/wiping routine built into the printer hardware. This command is not supported by PrusaSlicer or standard RepRap firmware. We replace it with a simple filament prime (`G1 E10 F200`). The OEM also homes *after* heating, while our sequence homes first for safety.

### 2.5 End G-code

Navigate to *Printer Settings → Custom G-code → End G-code*.

**Delete** the default content and paste:

```gcode
M104 S0 ; Turn off nozzle heater
M140 S0 ; Turn off bed heater
G1 X0 Y200 F3000 ; Move print head out of the way
M84 ; Disable stepper motors
```

**Line-by-line explanation:**

| Line | Command | Purpose |
|------|---------|---------|
| 1 | `M104 S0` | Sets the nozzle heater target to 0 °C (turns it off) |
| 2 | `M140 S0` | Sets the bed heater target to 0 °C (turns it off) |
| 3 | `G1 X0 Y200 F3000` | Moves the print head to the front-left corner so you can easily remove the print |
| 4 | `M84` | Disables all stepper motors so the axes can be moved freely by hand |

**Differences from OEM end gcode:**

The OEM slicer ends with only `M2` (program end), which is a legacy command that halts execution. Our version is more explicit and safer — it ensures heaters are off, the head is parked, and motors are released.

---

## Step 3 — Print Settings

Navigate to the **Print Settings** tab (the layers icon). Name this profile **`3DWOX 1`**.

### 3.1 Layers and Perimeters

Navigate to *Print Settings → Layers and perimeters*:

#### Layer Height

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Layer height** | `0.20` mm | *Layers and perimeters → Layer height* |
| **First layer height** | `0.20` mm | *Layers and perimeters → First layer height* |

> **Why 0.20 mm?** The OEM slicer uses 0.20 mm layer height. This provides a good balance of quality and speed for the 3DWOX 1's 0.4 mm nozzle. PrusaSlicer defaults may be set to 0.30 mm — change this to match OEM output.

#### Vertical Shells (Perimeters)

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Perimeters** | `2` | *Layers and perimeters → Perimeters* |
| **Spiral vase** | Unchecked | |

> The OEM uses 2 perimeters with 0.4 mm width = 0.8 mm total wall thickness. PrusaSlicer defaults to 3 perimeters — reduce to 2 to match.

#### Horizontal Shells

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Top solid layers** | `4` | *Layers and perimeters → Top solid layers* |
| **Bottom solid layers** | `4` | *Layers and perimeters → Bottom solid layers* |

> The OEM uses 0.8 mm top/bottom thickness. At 0.2 mm layer height, that's 4 layers each.

#### Quality

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Perimeter generator** | `Arachne` or `Classic` | *Layers and perimeters → Quality → Perimeter generator* |
| **Seam position** | `Aligned` | *Layers and perimeters → Quality → Seam position* |
| **External perimeters first** | Unchecked | *Layers and perimeters → Quality* |

> **Arachne** is PrusaSlicer's variable-width perimeter generator — it generally produces better results than Classic. The OEM slicer uses a fixed-width approach closer to Classic. Either works; **Arachne** is recommended for PrusaSlicer.

#### Extrusion Width

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Default extrusion width** | `0.4` mm | *Print Settings → Advanced → Extrusion width → Default* |
| **First layer** | `0.4` mm | *Print Settings → Advanced → Extrusion width → First layer* |
| **Perimeters** | `0.4` mm | *Print Settings → Advanced → Extrusion width → Perimeters* |
| **External perimeters** | `0.4` mm | *Print Settings → Advanced → Extrusion width → External perimeters* |
| **Infill** | `0.4` mm | *Print Settings → Advanced → Extrusion width → Infill* |
| **Solid infill** | `0.4` mm | *Print Settings → Advanced → Extrusion width → Solid infill* |
| **Top solid infill** | `0.4` mm | *Print Settings → Advanced → Extrusion width → Top solid infill* |
| **Support material** | `0.35` mm | *Print Settings → Advanced → Extrusion width → Support material* |

> The OEM slicer uses 0.4 mm (nozzle diameter) for all extrusion widths. PrusaSlicer defaults to 0.45 mm, which slightly over-extrudes compared to OEM output.

### 3.2 Infill

Navigate to *Print Settings → Infill*:

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Fill density** | `15`% | *Infill → Fill density* |
| **Fill pattern** | `Grid` | *Infill → Fill pattern* |
| **Top fill pattern** | `Monotonic` | *Infill → Top fill pattern* |
| **Bottom fill pattern** | `Monotonic` | *Infill → Bottom fill pattern* |
| **Fill angle** | `45`° | *Infill → Advanced → Fill angle* |
| **Infill/perimeters overlap** | `15`% | *Infill → Advanced → Infill/perimeters overlap* |

> The OEM uses 15% infill with "Automatic" pattern (a grid variant). PrusaSlicer's **Grid** is the closest match. The OEM also uses 15% infill/perimeter overlap.

### 3.3 Speed

Navigate to *Print Settings → Speed*:

#### Print Speed

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Perimeters** | `40` mm/s | *Speed → Speed for print moves → Perimeters* |
| **Small perimeters** | `25` mm/s | *Speed → Speed for print moves → Small perimeters* |
| **External perimeters** | `40` mm/s | *Speed → Speed for print moves → External perimeters* |
| **Infill** | `40` mm/s | *Speed → Speed for print moves → Infill* |
| **Solid infill** | `40` mm/s | *Speed → Speed for print moves → Solid infill* |
| **Top solid infill** | `40` mm/s | *Speed → Speed for print moves → Top solid infill* |
| **Gap fill** | `20` mm/s | *Speed → Speed for print moves → Gap fill* |
| **Bridges** | `40` mm/s | *Speed → Speed for print moves → Bridges* |

> **OEM behavior:** The 3DWOX Desktop slicer uses the same speed (40 mm/s) for all print moves except first layer. The settings for Infill, Top/Bottom, Outer Wall, and Inner Wall speeds are all 0 in the OEM header, meaning they all default to the base Print Speed of 40 mm/s. Set all PrusaSlicer speeds to 40 mm/s to match.

#### Other Speed Settings

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Travel** | `130` mm/s | *Speed → Speed for non-print moves → Travel* |
| **First layer speed** | `10` mm/s | *Speed → Speed for print moves → First layer speed* |
| **First layer speed over raft** | `30` mm/s | *Speed → Speed for print moves → First layer speed over raft* |

> The OEM uses 130 mm/s travel speed and 10 mm/s first layer speed. PrusaSlicer defaults are 100 mm/s and 20 mm/s respectively.

#### Auto Speed (leave at default)

| Setting | Value |
|---------|-------|
| **Max print speed** | `80` mm/s |
| **Max volumetric speed** | `0` (unlimited) |

### 3.4 Support Material & Bed Adhesion

Navigate to *Print Settings → Support material*:

#### Support

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Generate support material** | Unchecked | *Support material → Generate support material* |

> The OEM calibration cube gcode has no support. Enable as needed per model.

#### Raft (Bed Adhesion)

The OEM slicer defaults to **Raft** adhesion. To match:

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Raft layers** | `4` | *Support material → Raft → Raft layers* |
| **Raft contact distance** | `0.25` mm | *Support material → Raft → Raft contact distance* |
| **Raft expansion** | `2` mm | *Support material → Raft → Raft expansion* |
| **First layer density** | `90`% | *Support material → Raft → First layer density* |
| **First layer expansion** | `3` mm | *Support material → Raft → First layer expansion* |

The OEM raft structure is:

| Raft Layer | Thickness | Line Width | Speed |
|------------|-----------|------------|-------|
| Base (1 layer) | 0.300 mm | 1.0 mm | 10 mm/s |
| Interface (1 layer) | 0.270 mm | 0.4 mm | 10 mm/s |
| Surface (2 layers) | 0.200 mm | 0.4 mm | 10 mm/s |

> **Alternative:** If you prefer to use a **Skirt** instead of Raft (simpler, uses less material), set **Raft layers** to `0` and configure:
>
> | Setting | Value | Menu Path |
> |---------|-------|-----------|
> | **Skirts** | `1` | *Print Settings → Skirt and brim → Loops (minimum)* |
> | **Distance from object** | `6` mm | *Print Settings → Skirt and brim → Distance from brim/object* |
> | **Skirt height** | `1` layer | *Print Settings → Skirt and brim → Skirt height* |

---

## Step 4 — Filament Settings (PLA)

Navigate to the **Filament Settings** tab (the spool icon). Name this profile **`3DWOX 1 PLA`**.

### 4.1 Temperature

Navigate to *Filament Settings → Filament*:

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Nozzle — First layer** | `200` °C | *Filament → Temperature → Nozzle → First layer* |
| **Nozzle — Other layers** | `200` °C | *Filament → Temperature → Nozzle → Other layers* |
| **Bed — First layer** | `60` °C | *Filament → Temperature → Bed → First layer* |
| **Bed — Other layers** | `60` °C | *Filament → Temperature → Bed → Other layers* |

### 4.2 Cooling

Navigate to *Filament Settings → Cooling*:

#### Fan Settings

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Keep fan always on** | Unchecked | *Cooling → Fan settings* |
| **Enable auto cooling** | Checked | *Cooling → Enable auto cooling* |
| **Min fan speed** | `50`% | *Cooling → Fan settings → Min* |
| **Max fan speed** | `50`% | *Cooling → Fan settings → Max* |
| **Bridge fan speed** | `100`% | *Cooling → Fan settings → Bridges* |
| **Disable fan for first** | `3` layers | *Cooling → Fan settings → Disable fan for the first* |

> **OEM behavior:** The 3DWOX Desktop uses 50% for both regular and max fan speed, reaching full operation at 0.6 mm height. PrusaSlicer doesn't have a "full on at height" setting — use "disable fan for first N layers" instead. At 0.2 mm layer height, 0.6 mm ≈ 3 layers.

#### Cooling Thresholds

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Slowdown if layer print time is below** | `5` sec | *Cooling → Cooling thresholds → Enable fan if layer print time is below* |
| **Min print speed** | `10` mm/s | *Cooling → Cooling thresholds → Min print speed* |

### 4.3 Retraction (Filament Overrides)

By default, retraction is controlled by Printer Settings. You can optionally override per filament in *Filament Settings → Filament overrides*. For PLA on this Bowden printer, ensure these match:

| Setting | Value | Notes |
|---------|-------|-------|
| **Retraction length** | `6` mm | Already set in Printer Settings — leave filament override blank to inherit |
| **Retraction speed** | `30` mm/s | Already set in Printer Settings — leave filament override blank to inherit |

If you want filament-specific overrides (e.g., for PETG or ABS), check the override boxes and enter appropriate values.

### 4.4 Filament Properties

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Diameter** | `1.75` mm | *Filament → Filament → Diameter* |
| **Extrusion multiplier** | `1` | *Filament → Filament → Extrusion multiplier* |
| **Filament type** | `PLA` | *Filament → Filament → Type* |

---

## Step 5 — Save Your Profiles

1. **Printer profile:** In the Printer Settings tab, click the save icon (💾) next to the profile dropdown. Name it **`3DWOX 1`**
2. **Print profile:** In the Print Settings tab, click the save icon. Name it **`3DWOX 1`**
3. **Filament profile:** In the Filament Settings tab, click the save icon. Name it **`3DWOX 1 PLA`**

To export a complete config bundle for sharing:

1. Go to **File → Export → Export Config Bundle**
2. Save as `3DWOX1.ini`

---

## Verification — 1 cm Calibration Cube

To verify your configuration matches the OEM slicer output:

1. **Download or create** a 10 × 10 × 10 mm calibration cube STL
2. **Import** it into PrusaSlicer (File → Import → Import STL)
3. **Slice** with the profiles you just configured
4. **Compare output** to the reference OEM gcode at `gcode/1cm Cubed  - 3DWOX Desktop.gcode`

### What to Check

| Aspect | Expected Value |
|--------|---------------|
| **Total model layers** | 50 (10 mm ÷ 0.2 mm) |
| **Raft layers** | 4 (if raft enabled) |
| **Perimeters per layer** | 2 (inner + outer) |
| **Fill pattern** | Grid at 45° |
| **Estimated print time** | ~8 min (varies slightly) |
| **Estimated filament** | ~286 mm / ~0.9 g |

---

## Settings Reference Table

Complete settings at a glance — all values matched to OEM 3DWOX Desktop 1.4.2213.1 output:

### Printer Settings

| Setting | Value |
|---------|-------|
| Bed size | 200 × 200 mm |
| Max height | 185 mm |
| Nozzle diameter | 0.4 mm |
| G-code flavor | RepRap |
| Retraction length | 6 mm |
| Retraction speed | 30 mm/s |
| Retraction min travel | 1.5 mm |
| Retraction Z-hop | 0 mm |

### Print Settings

| Setting | Value |
|---------|-------|
| Layer height | 0.20 mm |
| First layer height | 0.20 mm |
| Perimeters | 2 |
| Top solid layers | 4 |
| Bottom solid layers | 4 |
| Fill density | 15% |
| Fill pattern | Grid |
| Fill angle | 45° |
| Extrusion width (all) | 0.4 mm |
| Perimeter speed | 40 mm/s |
| External perimeter speed | 40 mm/s |
| Infill speed | 40 mm/s |
| Solid infill speed | 40 mm/s |
| Top solid infill speed | 40 mm/s |
| Travel speed | 130 mm/s |
| First layer speed | 10 mm/s |
| Raft layers | 4 |
| Raft contact distance | 0.25 mm |
| Raft expansion | 2 mm |

### Filament Settings (PLA)

| Setting | Value |
|---------|-------|
| Diameter | 1.75 mm |
| Nozzle temp | 200 °C |
| Bed temp | 60 °C |
| Min fan speed | 50% |
| Max fan speed | 50% |
| Disable fan first layers | 3 |
| Slowdown below layer time | 5 sec |
| Min print speed | 10 mm/s |

---

## Known Limitations & Notes

### Proprietary G-code: `G200` (Nozzle Cleaning)

The OEM 3DWOX Desktop slicer issues a `G200` command during startup. This is a **proprietary Sindoh command** that triggers an automatic nozzle cleaning/wiping routine using hardware built into the printer. **PrusaSlicer cannot replicate this command.** The workaround is the `G1 E10 F200` prime line in the Start G-code, which extrudes a small amount of filament to clear the nozzle.

### Proprietary G-code: `M532` (Progress Tracking)

The OEM slicer uses `M532 L<n>` to report layer progress to the printer's display. PrusaSlicer does not generate this command. The printer will still print correctly — the progress display on the LCD may just not update during PrusaSlicer prints.

### Proprietary G-code: `M2` (Program End)

The OEM uses `M2` as the only end-of-print command. This is a legacy "program end" instruction. Our End G-code is more explicit and reliable, turning off heaters, parking the head, and releasing motors.

### Bowden Extruder Retraction

The 3DWOX 1 uses a **Bowden extruder** (PTFE tube between drive gear and nozzle). This requires significantly higher retraction distances (6 mm) compared to direct-drive printers (1–2 mm). If you experience stringing, you may increase retraction up to 7 mm. If you experience under-extrusion after retractions, reduce to 5 mm.

### Homing Sequence

The OEM slicer homes the printer **after** heating the bed and nozzle. Our PrusaSlicer start gcode homes **before** heating for safety — this prevents the nozzle from dragging across the bed while cold. Both approaches work; the PrusaSlicer approach is considered safer practice.

### Perimeter Generator: Arachne vs Classic

PrusaSlicer offers the **Arachne** variable-width perimeter generator, which the OEM slicer does not have. Arachne generally produces better results for thin walls and complex geometries. Use it unless you need exact line-by-line gcode matching with the OEM output, in which case switch to **Classic**.

### Print Bed Positioning

The OEM slicer positions prints slightly off-center at approximately X:105, Y:100. PrusaSlicer centers prints at X:100, Y:100 by default. This minor offset has no practical impact on print quality.

### Raft vs Skirt

The OEM slicer defaults to **Raft** bed adhesion (4 extra layers printed under your model for adhesion). This uses extra filament and time but provides reliable adhesion on the stock 3DWOX build surface. Test your prints with just a **Skirt** first — if adhesion is good, you'll save material and time. Switch back to Raft if you experience adhesion issues, especially with larger prints or non-PLA filaments.

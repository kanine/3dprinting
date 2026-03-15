# Sindoh 3DWOX 1 — PrusaSlicer Configuration Guide

Complete step-by-step instructions for configuring **PrusaSlicer 2.9.x** to produce correct gcode for the **Sindoh 3DWOX 1 (3DFF-222)** FDM printer, matching the output quality of the OEM **3DWOX Desktop** slicer.

---

## Table of Contents

- [Printer Overview](#printer-overview)
- [Prerequisites](#prerequisites)
- [Quick-Start Checklist](#quick-start-checklist)
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
  - [Filament Properties](#44-filament-properties)
- [Step 5 — Save Your Profiles](#step-5--save-your-profiles)
- [Verification — 1 cm Calibration Cube](#verification--1-cm-calibration-cube)
- [Settings Reference Table](#settings-reference-table)
- [Known Limitations & Notes](#known-limitations--notes)
- [Open Filament Mode](#open-filament-mode)

---

## Printer Overview

The Sindoh 3DWOX 1 is sold under two brand names with slightly different specifications:

| Spec | Sindoh 3DWOX 1 | Mimaki 3DFF-222 |
|------|----------------|-----------------|
| **Printer Type** | Cartesian FDM | Cartesian FDM |
| **Extruder Type** | Bowden | Bowden |
| **Nozzle Diameter** | 0.4 mm | 0.4 mm |
| **Filament Diameter** | 1.75 mm | 1.75 mm |
| **Build Volume** | 200 × 200 × 185 mm | 210 × 200 × 195 mm |
| **Layer Pitch Range** | — | 0.05–0.40 mm |
| **Build Speed Range** | — | 10–200 mm/s |
| **Heated Bed** | Yes | Yes |
| **OEM Slicer** | 3DWOX Desktop 1.4.2213.1 | 3DWOX Desktop 1.4.2213.1 |

> **Mimaki variant:** If you have the Mimaki-branded 3DFF-222, use the larger build volume (210 × 200 × 195 mm) when setting bed shape and max print height. All other settings in this guide are identical.

---

## Prerequisites

- **PrusaSlicer 2.9.x** or later installed ([download from prusa3d.com](https://www.prusa3d.com/page/prusaslicer_424/))
- Sindoh 3DWOX 1 (or Mimaki 3DFF-222) connected and functional
- PLA filament (1.75 mm) loaded
- Open Filament Mode enabled if using third-party filament (see [Open Filament Mode](#open-filament-mode))

> **Tip:** Switch PrusaSlicer to **Expert** mode before starting: **Configuration → Mode → Expert**. This exposes all settings referenced in this guide.

---

## Quick-Start Checklist

The most critical deviations from PrusaSlicer defaults — fix these first:

| # | What to change | PrusaSlicer default | Correct value |
|---|---------------|---------------------|---------------|
| 1 | Retraction length | 2 mm | **6 mm** (Bowden extruder) |
| 2 | Retraction speed | 40 mm/s | **30 mm/s** |
| 3 | Layer height | 0.30 mm | **0.20 mm** |
| 4 | Perimeters (walls) | 3 | **2** |
| 5 | Infill density | 11% | **15%** |
| 6 | Infill pattern | Stars | **Grid** |
| 7 | Extrusion width (all) | 0.45 mm | **0.40 mm** |
| 8 | Travel speed | 100 mm/s | **130 mm/s** |
| 9 | First layer speed | 20 mm/s | **10 mm/s** |
| 10 | External perimeter speed | 30% (≈12 mm/s) | **40 mm/s** |
| 11 | Fan speed | 35–100% | **50% min/max** |
| 12 | Bed adhesion | Skirt | **Raft (4 layers)** |

---

## Step 1 — Create a New Printer Profile

1. Open PrusaSlicer
2. Go to **Configuration → Configuration Wizard**
3. On the **Other FFF** page, select nothing — we configure manually
4. On the **Other SLA** page, select nothing
5. Click through the remaining pages and click **Finish**
6. In the **Printers** tab, click the **new preset** icon in the toolbar (blank page icon — *not* "Add physical printer", which is for network connections)
7. Start from a generic **RepRap** or **FFF** preset
8. Name the printer profile: **`3DWOX 1`** (or **`3DFF-222`** for the Mimaki variant)

---

## Step 2 — Printer Settings

Navigate to the **Printer Settings** tab (wrench icon).

### 2.1 General

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Bed shape** | Rectangular 200 × 200 mm *(or 210 × 200 mm for Mimaki)* | *Printer Settings → General → Bed shape* |
| **Max print height** | `185` mm *(or `195` mm for Mimaki)* | *Printer Settings → General → Max print height* |
| **G-code flavor** | `RepRap (Marlin/Sprinter/Repetier)` | *Printer Settings → General → G-code flavor* |
| **Extruders** | `1` | *Printer Settings → General → Extruders* |
| **Supports remaining times** | Unchecked | *Printer Settings → General* |

### 2.2 Custom Bed Shape

1. Click the **Set** button next to *Bed shape*
2. Select **Rectangular**
3. Set **Size X** = `200`, **Size Y** = `200` *(210 × 200 for Mimaki)*
4. Set **Origin X** = `0`, **Origin Y** = `0`
5. Click **OK**

### 2.3 Extruder 1

Navigate to *Printer Settings → Extruder 1*:

| Setting | Value | Notes |
|---------|-------|-------|
| **Nozzle diameter** | `0.4` mm | |
| **Retraction → Length** | `6` mm | **Critical** — Bowden tube requires long retraction; PrusaSlicer defaults to 2 mm (wrong for this printer) |
| **Retraction → Lift Z** | `0` mm | OEM does not use Z-hop |
| **Retraction → Speed** | `30` mm/s | OEM uses 30 mm/s; PrusaSlicer defaults to 40 mm/s |
| **Retraction → Deretraction speed** | `0` (same as retraction speed) | |
| **Retraction → Minimum travel after retraction** | `1.5` mm | Matches OEM |
| **Retraction → Retract on layer change** | Unchecked | |
| **Retraction → Wipe while retracting** | Unchecked | |

> **Why 6 mm retraction?** The 3DWOX 1 uses a **Bowden extruder** — the drive gear is remote from the hot end, connected by a PTFE tube. This tube allows filament to compress and slack during moves. The OEM slicer uses 6 mm retraction to compensate; the PrusaSlicer default of 2 mm is sized for direct-drive printers and will cause severe stringing. If you still get stringing, increase to 7 mm. If you get under-extrusion after retractions, decrease to 5 mm.

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
| 2 | `G1 Z5 F5000` | Raises nozzle 5 mm before heating to prevent bed contact |
| 3 | `M190 S[first_layer_bed_temperature]` | Heats bed and **waits** until target is reached; uses PrusaSlicer variable |
| 4 | `M109 S[first_layer_temperature]` | Heats nozzle and **waits** until target is reached; uses PrusaSlicer variable |
| 5 | `G92 E0` | Resets extruder position counter to zero |
| 6 | `G1 E10 F200` | Extrudes 10 mm of filament at slow speed to prime the nozzle |

**OEM start sequence (for reference):**

```gcode
M140 S60       ; Heat bed (no wait)
M104 T0 S200   ; Heat nozzle (no wait)
M107            ; Fan off
G200            ; Nozzle cleaning (proprietary — cannot be replicated)
G21             ; Metric units
G90             ; Absolute positioning
G92 E-20        ; Set extruder position
M190 S60        ; Wait for bed temp
M109 T0 S200    ; Wait for nozzle temp
G28             ; Home (AFTER heating)
G0 F9000 Z3.00  ; Lift
```

> **Note:** `G200` is a **proprietary Sindoh command** that triggers a built-in nozzle cleaning/wiping routine. PrusaSlicer cannot replicate it. The `G1 E10 F200` prime line is the best alternative. The OEM also homes *after* heating; our sequence homes *before* for safety.

### 2.5 End G-code

Navigate to *Printer Settings → Custom G-code → End G-code*.

**Delete** the default content and paste:

```gcode
M104 S0 ; Turn off nozzle heater
M140 S0 ; Turn off bed heater
G1 X0 Y200 F3000 ; Park print head at front-left
M84 ; Disable stepper motors
```

**Line-by-line explanation:**

| Line | Command | Purpose |
|------|---------|---------|
| 1 | `M104 S0` | Sets nozzle heater target to 0 °C (off) |
| 2 | `M140 S0` | Sets bed heater target to 0 °C (off) |
| 3 | `G1 X0 Y200 F3000` | Parks head at front-left corner for easy print removal |
| 4 | `M84` | Releases all stepper motors so axes can be moved freely |

> The OEM slicer uses only `M2` (legacy program-end command). Our sequence is more explicit and reliable.

---

## Step 3 — Print Settings

Navigate to the **Print Settings** tab (layers icon). Name this profile **`3DWOX 1`**.

### 3.1 Layers and Perimeters

Navigate to *Print Settings → Layers and perimeters*:

#### Layer Height

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Layer height** | `0.20` mm | *Layers and perimeters → Layer height* |
| **First layer height** | `0.20` mm | *Layers and perimeters → First layer height* |

> **Why 0.20 mm?** The OEM slicer uses 0.20 mm. PrusaSlicer defaults to 0.30 mm, which produces coarser, faster prints. Set both layer height and first layer height to 0.20 mm to match. At 0.20 mm, a 10 mm tall object produces exactly 50 layers.

#### Vertical Shells (Perimeters)

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Perimeters** | `2` | *Layers and perimeters → Perimeters* |
| **Spiral vase** | Unchecked | |

> The OEM uses 2 perimeters at 0.4 mm width = 0.8 mm total wall thickness. PrusaSlicer defaults to 3 perimeters (1.35 mm total) — reduce to 2 to match.

#### Horizontal Shells

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Top solid layers** | `4` | *Layers and perimeters → Top solid layers* |
| **Bottom solid layers** | `4` | *Layers and perimeters → Bottom solid layers* |

> The OEM uses 0.8 mm top/bottom thickness. At 0.20 mm layer height: 0.8 ÷ 0.2 = 4 solid layers each. PrusaSlicer defaults to 3 — increase to 4.

#### Quality

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Perimeter generator** | `Arachne` | *Layers and perimeters → Quality → Perimeter generator* |
| **Seam position** | `Aligned` | *Layers and perimeters → Quality → Seam position* |
| **External perimeters first** | Unchecked | *Layers and perimeters → Quality* |

> **Arachne** is PrusaSlicer's variable-width perimeter generator and generally outperforms Classic for thin walls and complex geometry. Use **Classic** only if you need exact gcode matching with the OEM output.

#### Extrusion Width

Navigate to *Print Settings → Advanced → Extrusion width*:

| Setting | Value | Notes |
|---------|-------|-------|
| **Default extrusion width** | `0.4` mm | PrusaSlicer defaults to 0.45 mm — set to nozzle diameter |
| **First layer** | `0.4` mm | |
| **Perimeters** | `0.4` mm | |
| **External perimeters** | `0.4` mm | |
| **Infill** | `0.4` mm | |
| **Solid infill** | `0.4` mm | |
| **Top solid infill** | `0.4` mm | |
| **Support material** | `0.35` mm | Slightly narrower for easier support removal |

> The OEM uses 0.4 mm (nozzle diameter) for all widths. PrusaSlicer defaults to 0.45 mm, which slightly over-extrudes relative to OEM output. Set all to 0.4 mm.

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

> The OEM uses 15% infill with a grid-like pattern at 45°. PrusaSlicer defaults to 11% with a Stars pattern — correct both. **Grid** is the closest match to the OEM automatic pattern.

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

> **OEM behaviour:** The 3DWOX Desktop uses 40 mm/s for all print moves. Crucially, it does **not** slow down external perimeters — the PrusaSlicer default of 30% for external perimeters (≈12 mm/s) is wrong for this printer. Set external perimeters to 40 mm/s.

#### Other Speed Settings

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Travel** | `130` mm/s | *Speed → Speed for non-print moves → Travel* |
| **First layer speed** | `10` mm/s | *Speed → Speed for print moves → First layer speed* |
| **First layer speed over raft** | `10` mm/s | *Speed → Speed for print moves → First layer speed over raft* |

> The OEM uses 130 mm/s travel (PrusaSlicer defaults to 100 mm/s) and 10 mm/s first layer (PrusaSlicer defaults to 20 mm/s). Both matter for matching OEM output quality.

#### Auto Speed (leave at defaults)

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

> Enable as needed per model. The OEM calibration cube gcode uses no support.

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

> **Raft vs Skirt:** The OEM defaults to raft because the stock 3DWOX bed surface benefits from the extra adhesion area. Test without raft first — if adhesion is good, use a **Skirt** instead (saves material and time). If you experience adhesion failures, especially for larger prints or non-PLA filaments, switch back to Raft.
>
> To use a Skirt instead: set **Raft layers** to `0`, then configure *Print Settings → Skirt and brim*: **Loops** = `1`, **Distance from object** = `6` mm, **Skirt height** = `1` layer.

---

## Step 4 — Filament Settings (PLA)

Navigate to the **Filament Settings** tab (spool icon). Name this profile **`3DWOX 1 PLA`**.

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

> **OEM behaviour:** The 3DWOX Desktop runs the fan at 50% and reaches full operation at 0.6 mm print height. At 0.2 mm layer height, 0.6 mm = 3 layers, so disabling for the first 3 layers matches. Set both min and max to 50% — the OEM does not vary fan speed dynamically. PrusaSlicer defaults (35% min / 100% max) over-cool the print at 100% and under-cool at 35%.

#### Cooling Thresholds

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Slowdown if layer print time is below** | `5` sec | *Cooling → Cooling thresholds → Slowdown if layer print time below* |
| **Min print speed** | `10` mm/s | *Cooling → Cooling thresholds → Min print speed* |

### 4.3 Retraction (Filament Overrides)

Retraction is controlled by Printer Settings (section 2.3). Leave filament overrides blank to inherit those values. You only need to set filament-level overrides if using different filament types (PETG, ABS, etc.) that require different retraction.

| Setting | Inherited value | Notes |
|---------|----------------|-------|
| **Retraction length** | `6` mm | Set in Printer Settings — do not override here unless changing filament type |
| **Retraction speed** | `30` mm/s | Set in Printer Settings — do not override here unless changing filament type |

### 4.4 Filament Properties

| Setting | Value | Menu Path |
|---------|-------|-----------|
| **Diameter** | `1.75` mm | *Filament → Filament → Diameter* |
| **Extrusion multiplier** | `1.00` | *Filament → Filament → Extrusion multiplier* |
| **Filament type** | `PLA` | *Filament → Filament → Type* |

---

## Step 5 — Save Your Profiles

1. **Printer profile:** In the Printer Settings tab, click the save icon (💾) next to the profile dropdown. Name it **`3DWOX 1`**
2. **Print profile:** In the Print Settings tab, click the save icon. Name it **`3DWOX 1`**
3. **Filament profile:** In the Filament Settings tab, click the save icon. Name it **`3DWOX 1 PLA`**

To export a config bundle for backup or sharing:

1. **File → Export → Export Config Bundle**
2. Save as `3DWOX1.ini`

---

## Verification — 1 cm Calibration Cube

Print a 10 × 10 × 10 mm calibration cube to verify your configuration:

1. **Download or create** a 10 × 10 × 10 mm cube STL
2. **Import** it into PrusaSlicer: *File → Import → Import STL*
3. **Slice** with the profiles you just configured
4. **Compare** the estimated print stats in the preview panel

### Expected Output (with Raft enabled)

| Aspect | Expected Value |
|--------|---------------|
| **Total model layers** | 50 (10 mm ÷ 0.2 mm) |
| **Raft layers** | 4 |
| **Total layers** | 54 |
| **Perimeters per layer** | 2 |
| **Fill pattern** | Grid at 45° |
| **Estimated print time** | ~8 min |
| **Estimated filament** | ~286 mm / ~0.9 g |

> Compare against the reference OEM gcode at `gcode/1cm Cubed  - 3DWOX Desktop.gcode` for detailed gcode-level comparison.

---

## Settings Reference Table

All values matched to OEM 3DWOX Desktop 1.4.2213.1 output:

### Printer Settings

| Setting | Value |
|---------|-------|
| Bed size | 200 × 200 mm *(210 × 200 mm for Mimaki 3DFF-222)* |
| Max height | 185 mm *(195 mm for Mimaki 3DFF-222)* |
| G-code flavor | RepRap (Marlin/Sprinter/Repetier) |
| Nozzle diameter | 0.4 mm |
| Retraction length | 6 mm |
| Retraction speed | 30 mm/s |
| Retraction min travel | 1.5 mm |
| Retraction Z-hop | 0 mm (disabled) |

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
| Extrusion width (all) | 0.40 mm |
| Perimeter speed | 40 mm/s |
| External perimeter speed | 40 mm/s |
| Infill speed | 40 mm/s |
| Solid infill speed | 40 mm/s |
| Top solid infill speed | 40 mm/s |
| First layer speed | 10 mm/s |
| Travel speed | 130 mm/s |
| Raft layers | 4 |
| Raft contact distance | 0.25 mm |
| Raft expansion | 2 mm |
| Infill/perimeters overlap | 15% |

### Filament Settings (PLA)

| Setting | Value |
|---------|-------|
| Diameter | 1.75 mm |
| Nozzle temp | 200 °C |
| Bed temp | 60 °C |
| Min fan speed | 50% |
| Max fan speed | 50% |
| Bridge fan speed | 100% |
| Disable fan first layers | 3 |
| Slowdown below layer time | 5 sec |
| Min print speed | 10 mm/s |

---

## Known Limitations & Notes

### Proprietary G-code: `G200` (Nozzle Cleaning)

The OEM 3DWOX Desktop slicer issues a `G200` command during startup. This is a **proprietary Sindoh command** that triggers an automatic nozzle cleaning/wiping routine using hardware built into the printer. **PrusaSlicer cannot replicate this command.** The workaround is the `G1 E10 F200` prime line in the Start G-code. The quality difference is minor for most prints.

### Proprietary G-code: `M532` (Progress Tracking)

The OEM slicer uses `M532 L<n>` to report layer progress to the printer's LCD display. PrusaSlicer does not generate this command. The printer will print correctly — only the LCD progress display may not update during PrusaSlicer prints.

### Proprietary G-code: `M2` (Program End)

The OEM uses `M2` as the only end-of-print command. This is a legacy "program end" instruction. The End G-code in this guide is more explicit and reliable: it ensures heaters are off, parks the head, and releases stepper motors.

### Bowden Extruder Retraction

The 3DWOX 1 uses a **Bowden extruder** (drive gear remote from hot end, connected via PTFE tube). Bowden setups require significantly higher retraction distances than direct-drive printers:

| Retraction | Value | When to use |
|------------|-------|-------------|
| Minimum | 5 mm | If you see under-extrusion after retractions |
| Default (OEM) | **6 mm** | Start here |
| Maximum | 7 mm | If you still see stringing |

### Perimeter Generator: Arachne vs Classic

PrusaSlicer's **Arachne** variable-width generator generally produces better results than the OEM slicer's classic fixed-width approach, especially for thin walls and complex shapes. Switch to **Classic** only if you require exact gcode line-by-line matching with OEM output.

### Homing Sequence

The OEM slicer homes **after** heating bed and nozzle. This guide homes **before** heating, which prevents the nozzle from dragging across the bed while cold. Both produce the same print quality; the pre-heat home is considered safer.

### Print Bed Positioning

The OEM slicer positions prints at approximately X:98, Y:93 (slightly off-centre). PrusaSlicer centres prints at X:100, Y:100. This minor offset has no practical impact on print quality.

### Raft vs Skirt

The OEM defaults to Raft because the stock 3DWOX flexible metal bed surface benefits from the extra adhesion area. Raft also makes part removal easier — flex the bed slightly to separate the raft, then the raft peels off the part. If you have good first-layer adhesion without raft, skirt uses less material and time.

---

## Open Filament Mode

The Mimaki 3DFF-222 variant officially restricts filament to Mimaki genuine PLA cartridges (enforced via IC chip). The Sindoh variant is also restricted to Sindoh-branded filament by default. **Open Filament Mode** disables this restriction and allows any 1.75 mm filament.

### Unlock Procedure

Via the printer's touchscreen control panel:

1. Navigate to **Settings**
2. Tap **XYZ**
3. Tap **XYZ** at the top of the screen **3 times** rapidly
4. Tap the **PLA material title** at the **bottom-left** of the screen **once**

All 4 presses must be done quickly. If the menu does not appear, try again — do it slightly faster.

Once unlocked, the **Open Material** setting will be available in the 4th settings window on the control panel.

> Source: [Reddit community thread on Open Filament Mode](https://www.reddit.com/r/3Dprinting/comments/ze71fn/comment/mqq7wr2/)

### After Enabling Open Filament Mode

- All PrusaSlicer settings in this guide remain valid
- You may need to adjust temperatures for non-PLA filaments (see section 4.1)
- For non-PLA filaments, override retraction in Filament Settings (section 4.3) as appropriate:
  - **PETG:** 200–230 °C nozzle / 70–85 °C bed / 5–7 mm retraction
  - **ABS:** 220–250 °C nozzle / 100–110 °C bed / 5–7 mm retraction

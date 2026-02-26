# Copilot Instructions — PrusaSlicer 3D Printer Configuration Project

## Project Purpose

This project helps users configure **PrusaSlicer** to produce gcode output that matches (or intentionally improves upon) the output of proprietary/OEM slicers for various 3D printers. Configuration is validated by comparing gcode output for a standardized **1×1×1 cm calibration cube** test print.

## Methodology

1. **Reference gcode** from the OEM/proprietary slicer is stored in `gcode/` with the naming convention: `1cm Cubed - <SlicerName>.gcode`
2. **PrusaSlicer gcode** is stored alongside it: `1cm Cubed - Prusa3DSlicer.gcode`
3. Differences between the two are analyzed to derive the correct PrusaSlicer profile settings.
4. Final deliverables are step-by-step configuration guides per printer.

## Supported Printers

| Printer | OEM Slicer | OEM Gcode File | Status |
|---------|-----------|----------------|--------|
| Sindoh 3DWOX 1 (3DFF-222) | 3DWOX Desktop 1.4.2213.1 | `1cm Cubed  - 3DWOX Desktop.gcode` | In progress |

## Reference Analysis: Sindoh 3DWOX 1 vs PrusaSlicer

### OEM Slicer Settings (3DWOX Desktop 1.4.2213.1)

Extracted from the gcode header comments:

| Setting | Value |
|---------|-------|
| Layer Height | 0.200 mm |
| Wall Thickness | 0.800 mm (2 perimeters × 0.4 mm nozzle) |
| Nozzle Size | 0.400 mm |
| Infill Density | 15% |
| Infill Pattern | Automatic (grid-like) |
| Print Speed | 40 mm/s |
| Travel Speed | 130 mm/s |
| First Layer Speed | 10 mm/s |
| Nozzle Temperature | 200 °C |
| Bed Temperature | 60 °C |
| Filament | PLA, 1.75 mm diameter |
| Retraction | Enabled — 6.0 mm at 30 mm/s |
| Retraction Min Travel | 1.5 mm |
| Combing | All |
| Bed Adhesion | **Raft** (4 layers: 1 base, 1 interface, 2 surface) |
| Raft Base | 0.300 mm thick, 1.0 mm line width, 10 mm/s |
| Raft Interface | 0.270 mm thick, 0.4 mm line width, 10 mm/s |
| Raft Surface | 0.200 mm thick, 0.4 mm line width, 10 mm/s, 2 layers |
| Raft Air Gap (first layer) | 0.250 mm |
| Raft Extra Margin | 2.0 mm |
| Cooling Fan | On — 50% regular / 50% max, full at 0.6 mm height |
| Min Layer Time | 5 sec |
| Min Speed | 10 mm/s |
| Support | None |
| Estimated Print Time | 8 min 13 sec |
| Estimated Filament | 286 mm (0.9 g) |
| Total Layers | 50 (model) + 4 (raft) = 54 |
| Print Dimensions | 10×10×10 mm |
| Build Plate Position | X:98, Y:93 (offset from origin) |

### Current PrusaSlicer Settings (Profile: `3dWox1`)

Extracted from the gcode footer metadata:

| Setting | Value |
|---------|-------|
| PrusaSlicer Version | 2.9.4 |
| Layer Height | 0.300 mm |
| First Layer Height | 0.350 mm |
| Perimeters | 3 |
| Perimeter Width | 0.45 mm |
| External Perimeter Width | 0.45 mm |
| Infill Width | 0.45 mm |
| Top Infill Width | 0.40 mm |
| First Layer Width | 0.42 mm |
| Infill Density | 11% |
| Infill Pattern | Stars |
| Fill Angle | 45° |
| Perimeter Speed | 40 mm/s |
| External Perimeter Speed | 30% (of perimeter speed = 12 mm/s) |
| Infill Speed | 50 mm/s |
| Solid Infill Speed | 20 mm/s |
| Top Solid Infill Speed | 15 mm/s |
| First Layer Speed | 20 mm/s |
| Travel Speed | 100 mm/s |
| Nozzle Temp | 200 °C |
| Bed Temp | 60 °C |
| Filament | PLA, 1.75 mm |
| Retraction | 2 mm at 40 mm/s |
| Min Travel Before Retract | 2 mm |
| Bed Adhesion | **Skirt** (1 line, 6 mm distance) |
| Raft Layers | 0 |
| Cooling Fan | Min 35% / Max 100%, disabled first 3 layers |
| Fan Below Layer Time | 60 sec |
| Slowdown Below Layer Time | 5 sec |
| Min Print Speed | 10 mm/s |
| Perimeter Generator | Arachne |
| Seam Position | Aligned |
| Top Solid Layers | 3 |
| Bottom Solid Layers | 3 |
| G-code Flavor | RepRap |
| Bed Size | 200×200 mm |
| Max Print Height | 185 mm |

### Key Differences (OEM → PrusaSlicer)

| Parameter | 3DWOX Desktop | PrusaSlicer | Impact |
|-----------|--------------|-------------|--------|
| **Layer Height** | 0.20 mm | 0.30 mm | More layers, finer detail in OEM; PrusaSlicer prints faster but coarser |
| **Perimeters/Walls** | 2 (0.8mm total) | 3 (1.35mm total) | PrusaSlicer has thicker walls — consider reducing to 2 |
| **Infill %** | 15% | 11% | OEM uses slightly more infill |
| **Infill Pattern** | Auto/Grid | Stars | Different fill geometry |
| **Bed Adhesion** | Raft (4 layers) | Skirt only | **Major difference** — OEM uses raft by default |
| **Retraction Distance** | 6.0 mm | 2.0 mm | OEM retracts much more — Bowden vs direct drive consideration |
| **Retraction Speed** | 30 mm/s | 40 mm/s | OEM slower retraction |
| **First Layer Speed** | 10 mm/s | 20 mm/s | OEM is more conservative on first layer |
| **Travel Speed** | 130 mm/s | 100 mm/s | OEM travels faster |
| **Fan Speed** | 50% / 50% | 35% / 100% | Different cooling strategies |
| **Fan Disable Layers** | Full at 0.6mm height | Disabled first 3 layers | Different ramp-up |
| **External Perimeter Speed** | Same as print speed | 30% of perimeter speed | OEM doesn't slow outer walls |
| **Extrusion Width** | 0.4 mm (nozzle size) | 0.45 mm | PrusaSlicer over-extrudes width slightly |

### Gcode Structure Differences

| Aspect | 3DWOX Desktop | PrusaSlicer |
|--------|--------------|-------------|
| **Start Gcode** | `M140`/`M104` (async heat), `G200` (nozzle clean), `G92 E-20`, `M190`/`M109` (wait), `G28` | `G28`, `G1 Z5`, `M190`/`M109` (wait), `G92 E0`, `G1 E10` (prime) |
| **Home Timing** | Homes AFTER heating | Homes BEFORE heating |
| **Nozzle Priming** | `G200` nozzle cleaning routine | `G1 E10 F200` manual prime |
| **End Gcode** | `M2` (program end) | `M104 S0`, `M140 S0`, `G1 X0 Y200`, `M84` |
| **Layer Comments** | `;LAYER:N`, `;TYPE:WALL-INNER/WALL-OUTER/SKIN` | `;LAYER_CHANGE`, `;TYPE:Perimeter/External perimeter/Solid infill` |
| **Progress Tracking** | `M532 L<n>` (layer progress) | None |
| **Extruder Selection** | `T0` explicit, `;EXTRUDER : 0` comments | Implicit |
| **Thumbnail** | Base64-encoded PNG in header | None configured |
| **Print Positioning** | Offset center (X:98, Y:93) | Centered on bed (X:100, Y:100) |

### Start Gcode for 3DWOX 1

The OEM slicer uses a specific startup sequence. The current PrusaSlicer start gcode is:

```gcode
G28 ; Home all axes
G1 Z5 F5000 ; Lift nozzle
M190 S[first_layer_bed_temperature] ; Wait for bed temp
M109 S[first_layer_temperature] ; Wait for extruder temp
G92 E0 ; Reset extruder
G1 E10 F200 ; Prime the nozzle
```

The OEM sequence is:

```gcode
M140 S60       ; Heat bed (no wait)
M104 T0 S200   ; Heat nozzle (no wait)
M107            ; Fan off
G200            ; Nozzle cleaning (3DWOX-specific)
G21             ; Metric units
G90             ; Absolute positioning
G92 E-20        ; Set extruder position
M190 S60        ; Wait for bed temp
M109 T0 S200    ; Wait for nozzle temp
G28             ; Home
G0 F9000 Z3.00  ; Lift
```

> **Note:** `G200` is a proprietary 3DWOX command for nozzle cleaning. PrusaSlicer cannot replicate this, so manual priming (`G1 E10`) is used instead.

### End Gcode for 3DWOX 1

The OEM uses only `M2` (program end). The PrusaSlicer end gcode should include:

```gcode
M104 S0 ; Turn off nozzle heater
M140 S0 ; Turn off bed heater
G1 X0 Y200 F3000 ; Move print head out of the way
M84 ; Disable stepper motors
```

## How to Respond to Future Prompts

When asked to create a PrusaSlicer configuration for a new printer:

1. **Compare the gcode files** in `gcode/` — OEM slicer output vs PrusaSlicer output.
2. **Extract all slicer settings** from headers/footers of both files.
3. **Identify every difference** and document in a table format like above.
4. **Generate step-by-step PrusaSlicer configuration instructions** covering:
   - Printer Settings (bed size, nozzle, firmware flavor, start/end gcode)
   - Print Settings (layers, perimeters, infill, speeds, supports)
   - Filament Settings (temperatures, retraction, cooling)
5. **Flag proprietary gcode commands** that cannot be replicated (like `G200`).
6. **Recommend profile names** using the printer model name.
7. **Note any tradeoffs** where PrusaSlicer settings intentionally deviate from OEM for better results.

When asked to refine an existing configuration:

1. Re-read both gcode files for the given printer.
2. Focus on the specific area the user wants to change.
3. Provide the exact PrusaSlicer menu path (e.g., *Print Settings → Infill → Fill density*).
4. Explain the impact of the change.

## File Conventions

- **Gcode files**: `gcode/<Model Name> - <Slicer>.gcode`
- **Configuration guides**: `guides/<PrinterModel>-prusaslicer-setup.md`
- **PrusaSlicer config bundles**: `profiles/<PrinterModel>.ini`
- **This file**: `.github/copilot-instructions.md` — automatically loaded by GitHub Copilot

## Important Notes

- The 3DWOX 1 (3DFF-222) uses a **Bowden extruder**, which explains the high 6mm retraction in OEM settings. The PrusaSlicer profile currently uses 2mm, which is typical for direct drive. **This should be increased for Bowden setups.**
- The OEM slicer defaults to **raft adhesion**, suggesting the stock bed surface may benefit from it. Users should test with and without raft.
- The OEM slicer uses **0.2mm layer height** while PrusaSlicer is set to **0.3mm**. When precision-matching OEM output, use 0.2mm.
- PrusaSlicer's **Arachne perimeter generator** may produce different wall patterns than the OEM slicer's classic approach.
- The OEM slicer centers the print at approximately **(X:105, Y:100)** on the build plate, slightly offset from true center.

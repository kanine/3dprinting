# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This is a **PrusaSlicer configuration knowledge base** for specific 3D printers. The goal is to configure PrusaSlicer to produce gcode equivalent to each printer's proprietary/OEM slicer. Configuration is validated by comparing gcode output for a standardized **1×1×1 cm calibration cube**.

## Repository Structure

- `gcode/` — Reference gcode files. Naming: `<Model Name> - <Slicer>.gcode`
- `guides/` — Step-by-step PrusaSlicer configuration guides per printer *(planned)*
- `profiles/` — PrusaSlicer `.ini` config bundles per printer *(planned)*
- `<printer-model>/README.md` — Per-printer configuration guide (current format)
- `.github/copilot-instructions.md` — Detailed methodology and reference analysis

## How to Work on This Project

### Adding a new printer

1. Generate a 1×1×1 cm calibration cube with both the OEM slicer and PrusaSlicer.
2. Store gcode in `gcode/` following the naming convention above.
3. Compare gcode headers/footers to extract all settings from both slicers.
4. Document all differences in a table (see `.github/copilot-instructions.md` for the format).
5. Write a step-by-step PrusaSlicer guide covering: Printer Settings, Print Settings, Filament Settings.
6. Flag any proprietary gcode commands that cannot be replicated (e.g., `G200` on the 3DWOX 1).

### Refining an existing configuration

1. Re-read both gcode files for the printer.
2. Focus on the specific area to change.
3. Always provide the exact PrusaSlicer menu path (e.g., *Print Settings → Infill → Fill density*).
4. Explain the impact of each setting change.

## Supported Printers

| Printer | OEM Slicer | Status |
|---------|-----------|--------|
| Sindoh 3DWOX 1 (3DFF-222) | 3DWOX Desktop 1.4.2213.1 | In progress — see `3dwox1/README.md` |

## Key Technical Context

### Sindoh 3DWOX 1

- **Bowden extruder**: requires 6 mm retraction (OEM default); PrusaSlicer profile currently uses 2 mm (must be corrected)
- **Proprietary gcode**: `G200` (nozzle cleaning) and `M532` (layer progress) cannot be replicated in PrusaSlicer
- **Final startup approach**: uses OEM-required header metadata, post-heat homing, and a front-edge prime line instead of `G200`
- **OEM defaults**: 0.2 mm layer height, 15% infill, 4-layer raft bed adhesion, 40 mm/s print speed, 130 mm/s travel
- **Critical PrusaSlicer deviations to correct**: layer height (0.3→0.2 mm), perimeters (3→2), retraction (2→6 mm), bed adhesion (skirt→raft)
- The full OEM vs PrusaSlicer settings comparison and start/end gcode are documented in `.github/copilot-instructions.md`

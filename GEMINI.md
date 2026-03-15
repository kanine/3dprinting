# GEMINI.md - Project Context

This repository is a **PrusaSlicer configuration knowledge base** designed to help users achieve OEM-quality results using PrusaSlicer on specific 3D printers.

## Project Overview

The project focuses on reverse-engineering proprietary/OEM slicer settings (like Sindoh's **3DWOX Desktop**) and replicating them within **PrusaSlicer**. Validation is performed by comparing the gcode output of both slicers for a standardized **1×1×1 cm calibration cube**.

### Main Technologies
- **Slicers:** PrusaSlicer (target), 3DWOX Desktop (OEM reference).
- **Hardware:** Sindoh 3DWOX 1 (3DFF-222) FDM Printer.
- **Formats:** G-code (`.gcode`), Markdown documentation (`.md`).

---

## Directory Structure

- `gcode/` — Reference and experimental gcode files.
  - `1cm Cubed - 3DWOX Desktop.gcode`: Reference output from the OEM slicer.
  - `1cm Cubed - Prusa3DSlicer.gcode`: Current output from PrusaSlicer for comparison.
- `3dwox1/` — Printer-specific documentation.
  - `README.md`: Comprehensive step-by-step PrusaSlicer setup guide for the Sindoh 3DWOX 1.
- `.github/`
  - `copilot-instructions.md`: Detailed technical methodology, setting-by-setting comparison tables, and reference analysis.
- `CLAUDE.md` — Project purpose and contribution guidelines.

---

## Technical Context: Sindoh 3DWOX 1

### Key Configuration Insights
- **Bowden Extruder:** Requires high retraction (**6.0 mm** at 30 mm/s). PrusaSlicer defaults often use 2 mm (direct drive), which causes stringing.
- **Proprietary G-code:**
  - `G200`: OEM nozzle cleaning routine (cannot be replicated, replaced with a front-edge prime line after homing).
  - `M532`: Layer progress tracking (not supported by PrusaSlicer, purely cosmetic).
- **Bed Adhesion:** OEM defaults to a **4-layer Raft**.
- **Speeds:** 40 mm/s print speed, 130 mm/s travel. OEM does not slow down for external perimeters.

### Critical Settings for 3DWOX 1
| Setting | Value | Notes |
|---------|-------|-------|
| Layer Height | 0.20 mm | Matches OEM precision |
| Retraction | 6.0 mm | **Crucial** for Bowden tube |
| Perimeters | 2 | 0.8 mm wall thickness |
| Adhesion | Raft | 4 layers recommended |

---

## Development Workflow

1.  **Generate:** Create gcode for a 1cm cube using both the OEM slicer and PrusaSlicer.
2.  **Compare:** Analyze gcode headers/footers to identify differences in layers, speeds, retraction, and custom start/end code.
3.  **Document:** Update the comparison table in `.github/copilot-instructions.md`.
4.  **Refine:** Update the printer-specific guide (e.g., `3dwox1/README.md`) with the corrected PrusaSlicer menu paths.
5.  **Validate:** Re-slice and compare until the PrusaSlicer output matches or improves upon the OEM baseline.

---

## Reference Material

- **Start G-code:** Uses the finalized 3DWOX1 startup header, heat-wait sequence, homing, and a front-edge prime line to replace the proprietary `G200` command.
- **End G-code:** Explicitly shuts off heaters and moves the head to `Y200` for easy print removal.

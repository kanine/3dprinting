# Mimaki 3DFF-222 Specifications

This is the Mimaki-branded variant of the Sindoh 3D WOX 1, sold under the model name **3DFF-222**.
Source: Mimaki product datasheet DB20304-04 (August 2022).

## Technical Specifications

| Specification | Value |
|---------------|-------|
| Printer type | FFF technology molding method (Laminated solution type) |
| No. of nozzles | Single nozzle |
| Nozzle diameter | 0.4 mm |
| Maximum build size (W × D × H) | **210 × 200 × 195 mm** |
| Layer pitch | 0.05 to 0.40 mm |
| Filament | Mimaki genuine PLA filament only |
| Filament diameter | 1.75 mm |
| Build speed | **10 to 200 mm/s** |
| Filament supply | Filament supplied automatically to automatic cartridge nozzle |
| Bed leveling | Semi-Auto leveling system |
| GUI | 5-inch full-touch screen |
| LED lamp | Integrated |
| Monitoring camera | From PCs, smartphones and tablets via Wi-Fi connection |
| Interface | USB 2.0, Ethernet, Wi-Fi, USB memory |
| Slicing software | Dedicated slicing software (3DWOX Desktop Software) |
| Supported extensions | STL, PLY, OBJ, G-code (RepRap), AMF |
| Unit size (W × D × H) | 421 × 433 × 439 mm |
| Weight | 15 kg |
| Noise level | 45 dB |

## Key Features

- **Automatic filament supply** — Filament reels insert into a dedicated cartridge and slide into the main unit; filament feeds to the nozzle automatically. Includes automatic filament cutting.
- **Flexible metal bed** — Formed objects are removed by slightly bending the bed, eliminating the need for scrapers. Bed also has thermostatic (heated) functions.
- **HEPA filter** — High-efficiency particulate air filter prevents contaminated air from being discharged during printing.
- **Remote monitoring** — Built-in camera and LED lamp allow monitoring via mobile app over Wi-Fi.
- **Bed leveling assist** — Automatically measures table horizontal errors and provides adjustment instructions on the colour monitor.
- **Silent operation** — High-performance motor drivers reduce noise to 45 dB.

## Available Filament Colours (Mimaki genuine PLA, 700 g with IC chip)

| Colour | Part Code |
|--------|-----------|
| Black | MMK3DPPBK-R |
| White | MMK3DPPWH-R |
| Green | MMK3DPPGR-R |
| Gray | MMK3DPPGY-R |
| Pink | MMK3DPPPI-R |
| Purple | MMK3DPPPP-R |
| Red | MMK3DPPRE-R |
| Blue | MMK3DPPBL-R |
| Yellow | MMK3DPPYE-R |

## Notes for PrusaSlicer Configuration

- **Build volume**: The Mimaki 3DFF-222 has a slightly larger build volume (210 × 200 × 195 mm) than the Sindoh 3DWOX 1 (200 × 200 × 185 mm). Set bed size to 210 × 200 mm and max print height to 195 mm when configuring for this variant.
- **Build speed**: Official range is 10–200 mm/s. The OEM slicer defaults to 40 mm/s print speed and 130 mm/s travel speed, both well within this range.
- **Filament**: Officially restricted to Mimaki genuine PLA only (enforced via IC chip in cartridge). However, **Open Filament Mode** can be unlocked via a hidden menu sequence on the printer's control panel, allowing third-party filament — confirmed working. See `README.md` (§ "Putting in Open Filament Mode") for the unlock steps.
- **Gcode flavour**: Supports RepRap G-code (as listed under supported extensions).

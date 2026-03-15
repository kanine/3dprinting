# 3DWOX 1 — Start & End G-code Reference

Detailed comparison of the OEM **3DWOX Desktop** startup/shutdown sequences versus the **PrusaSlicer** sequences used in this configuration, with explanation of every difference.

---

## Start G-code

### OEM (3DWOX Desktop)

```gcode
M140 S60       ; Heat bed (no wait)
M104 T0 S200   ; Heat nozzle (no wait)
M107            ; Fan off
G200            ; Nozzle cleaning (proprietary)
G21             ; Metric units
G90             ; Absolute positioning
G92 E-20        ; Set extruder position to -20
M190 S60        ; Wait for bed to reach temp
M109 T0 S200    ; Wait for nozzle to reach temp
G28             ; Home all axes
G0 F9000 Z3.00  ; Lift nozzle 3 mm
```

### PrusaSlicer (this config)

```gcode
;PRINTER_MODEL: 3DFF-222
;CARTRIDGE_COUNT_TOTAL: 1
;CARTRIDGE_USED_STATE: T
;USEDNOZZLE: 1
;Filament_Material : {filament_type[0]}     ; required by 3DWOX cartridge validator
;MATERIAL: {filament_type[0]}              ; required by 3DWOX cartridge validator
;MATERIAL_CARTRIDGE_0: {filament_type[0]}  ; required by 3DWOX cartridge validator
;TOTAL_RAFTLAYER: 0                        ; firmware metadata
T0                                         ; select extruder
G90                                        ; absolute coordinates
M300 S440 P300                             ; beep 1 - sequence started
M117 Starting...
M140 S[first_layer_bed_temperature]        ; set bed temp (no wait)
M190 S[first_layer_bed_temperature]        ; wait for bed temp
M104 S[first_layer_temperature]            ; set nozzle temp (no wait)
M109 S[first_layer_temperature]            ; wait for nozzle temp
M300 S440 P300                             ; beep 2 - temps reached
M117 Homing...
G28                                        ; home all axes
M300 S440 P300                             ; beep 3 - homing complete
G1 Z0.28 F5000                             ; move to prime-line height
G90                                        ; absolute coordinates
M82                                        ; absolute extruder mode
G92 E0
G1 Y3 F2400
G1 X{(print_bed_max[0]-print_bed_min[0]) / 2} E40 F500
G92 E0
G1 E-0.2 F3000
G1 X{((print_bed_max[0]-print_bed_min[0]) / 2) + 1} F4000
G92 E0
M117 Printing...
M300 S440 P300                             ; beep 4 - ready to print
```

> This configuration replaces the proprietary `G200` wipe with a standard front-edge prime line, leaving the extruder reset and ready for the sliced toolpath.

---

## Start G-code — Line by Line Comparison

### Heating strategy

| OEM | PrusaSlicer | Why different |
|-----|-------------|---------------|
| `M140 S60` then `M104 T0 S200` (no-wait) | `M140 S[first_layer_bed_temperature]` then later `M104 S[first_layer_temperature]` | Both sequences begin with non-blocking heater commands, but our version uses slicer variables instead of hardcoded PLA temperatures. |
| `M190 S60` + `M109 T0 S200` (wait) later | `M190 S[first_layer_bed_temperature]` + `M109 S[first_layer_temperature]` (wait) | Both sequences still wait for full bed and nozzle temperature before homing or printing. |

> **PrusaSlicer variables:** `[first_layer_bed_temperature]` and `[first_layer_temperature]` are automatically substituted with the values from your filament profile at slice time. This means the start gcode works correctly for any filament profile without editing — e.g. switching from PLA+ (220°C) to PETG (230°C) requires no gcode change.

---

### Homing sequence

| OEM | PrusaSlicer | Why different |
|-----|-------------|---------------|
| `G28` occurs **after** heating | `G28` occurs **after** heating | The finalized startup now matches the OEM ordering more closely: full bed/nozzle heat first, then homing, then priming. |

---

### Fan off (`M107`)

| OEM | PrusaSlicer | Why different |
|-----|-------------|---------------|
| Explicit `M107` | Not included | Modern firmware defaults the fan to off at startup. `M107` is redundant but harmless. Our cooling settings handle fan behaviour from the filament profile. |

---

### Nozzle cleaning (`G200`)

| OEM | PrusaSlicer | Why different |
|-----|-------------|---------------|
| `G200` — triggers a built-in hardware cleaning/wiping routine on the 3DWOX 1 | Front-edge purge line (`G1 Y3`, `G1 X... E40`, slight retract) | `G200` is a **proprietary Sindoh command** — it is not standard RepRap G-code and cannot be sent from PrusaSlicer. The hardware routine it triggers moves the nozzle to a dedicated wipe pad built into the printer. There is no way to replicate this from PrusaSlicer. The front-edge prime line is the best standard alternative and leaves the extruder in a clean known state with `G92 E0`. |

---

### Metric units and absolute positioning (`G21` / `G90`)

| OEM | PrusaSlicer | Why different |
|-----|-------------|---------------|
| `G21` (metric) and `G90` (absolute) explicitly set | `G90` included, `G21` omitted | `G90` is kept explicitly in this config, while `G21` is still omitted because modern firmware already defaults to metric units. |

---

### Extruder position reset

| OEM | PrusaSlicer | Why different |
|-----|-------------|---------------|
| `G92 E-20` — sets extruder position to **-20** | Multiple `G92 E0` resets around the prime line | The OEM uses `-20` as a pre-load value that works in conjunction with the `G200` nozzle cleaning routine. Since we cannot use `G200`, we reset to `0`, extrude the purge line explicitly, perform a tiny retract, and reset to `0` again so the print starts from a clean extruder state. |

---

### Nozzle lift after homing

| OEM | PrusaSlicer | Why different |
|-----|-------------|---------------|
| `G0 F9000 Z3.00` — lifts 3 mm at 9000 mm/min (150 mm/s) | `G1 Z0.28 F5000` — moves directly to the first-layer purge height | Instead of lifting away and relying on a skirt, this sequence drops immediately to the intended first-layer height so the prime line is laid down under real printing conditions. |

---

## End G-code

### OEM (3DWOX Desktop)

```gcode
M2    ; Program end (legacy halt)
```

### PrusaSlicer (this config)

```gcode
{if max_layer_z < max_print_height}G1 Z{z_offset+min(max_layer_z+2, max_print_height)} F600 ; Lower bed slightly away from nozzle{endif}
G1 X5 Y{print_bed_max[1]*0.95} F{travel_speed*60} ; Move head to front of bed
{if max_layer_z < max_print_height-10}G1 Z{z_offset+min(max_layer_z+70, max_print_height-10)} F600 ; Lower bed to present print{endif}
{if max_layer_z < max_print_height*0.6}G1 Z{max_print_height*0.6} F600 ; Lower bed to minimum access height{endif}
M140 S0 ; turn off heatbed
M104 S0 ; turn off nozzle
M84 ; disable motors
```

> Adapted from Anycubic Kobra 2 Plus end gcode. On the 3DWOX 1 the **bed moves down** when Z increases, so all Z moves lower the bed to present the print — identical gcode, opposite physical motion to the Kobra.

---

## End G-code — Line by Line Comparison

| OEM | PrusaSlicer | Why different |
|-----|-------------|---------------|
| `M2` — legacy "program end" command, halts execution | Conditional Z moves + explicit heater shutdown | `M2` does not explicitly turn off heaters or present the print. Our sequence is fully explicit. |
| — | `G1 Z{...+2}` then `G1 Z{...+70}` | Lowers the bed in two steps — small initial drop to clear the nozzle before XY travel, then a larger drop to fully present the print. On the 3DWOX 1 the bed moves down when Z increases. Conditional logic ensures the bed never tries to exceed `max_print_height`. |
| — | `G1 X5 Y{95% of bed}` | Parks head at the front of the bed using slicer variables — works correctly regardless of bed size. The OEM does not park the head. |
| — | `M140 S0` + `M104 S0` | Explicitly turns off both heaters. Safer and more reliable than relying on `M2` firmware behaviour. |
| — | `M84` | Releases all stepper motors. The OEM `M2` halt may or may not release motors depending on firmware. |

---

## Summary of Key Decisions

| Decision | What we do | Why |
|----------|-----------|-----|
| Home before heating | No | Final validated sequence heats first, then homes, then primes |
| Hardcoded temperatures | No — use slicer variables | Profile-independent — works for any filament without editing gcode |
| Replicate `G200` | No — impossible | Proprietary command; use a front-edge prime line instead |
| Explicit heater shutdown | Yes | More reliable than relying on `M2` to handle it |
| Park head at end | Yes (`X5`, `Y95% of bed`) | Prevents heat damage to top surface and improves print access |

---

## Proprietary Commands Reference

| Command | Purpose | Replicable? |
|---------|---------|-------------|
| `G200` | Automatic nozzle cleaning/wipe using built-in hardware pad | No — proprietary Sindoh only |
| `M532 L<n>` | Reports current layer number to the LCD progress display | No — layer progress bar will not update during PrusaSlicer prints |
| `M2` | Legacy program end / halt | Replaced with explicit shutdown sequence |

STATECH INDUSTRIES - FULL MACHINE DASHBOARD

This package contains Lua files only.

Included peripherals are based on the screenshots you supplied:

AE2:
- ae2:charger_0
- ae2:controller_0
- ae2:drive_0

Modern Industrialization:
- modern_industrialization:laser_engraver_0
- modern_industrialization:electric_wiremill_0
- modern_industrialization:electric_mixer_0
- modern_industrialization:electric_cutting_machine_0
- modern_industrialization:electric_compressor_0
- modern_industrialization:chemical_reactor_0
- modern_industrialization:assembler_0
- modern_industrialization:polarizer_0

Extended Industrialization:
- extended_industrialization:electric_bending_machine_0
- extended_industrialization:electric_alloy_smelter_0

INSTALL:

Upload dashboard.lua and scan_all.lua to GitHub.

At CraftOS>:

    wget <RAW_DASHBOARD_URL> dashboard
    wget <RAW_SCAN_URL> scan_all

Test:

    scan_all

Run:

    dashboard

The dashboard is READ-ONLY. It does not use pushItems, pullItems,
pushFluid, or pullFluid.

Energy is read only for the AE2 Charger and Controller because those
are the devices for which your screenshots explicitly showed the
energy_storage capability.

Fluid-capable MI machines show the number of occupied fluid tanks,
not the fluid amount, because your screenshots showed the `tanks`
method but did not yet establish the exact returned tank structure.

If a device says OFFLINE, verify its exact peripheral name with the
original scanner. The dashboard intentionally uses the names shown
in your screenshots.

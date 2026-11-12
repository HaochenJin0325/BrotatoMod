# BrotatoMod-EndlessUnlimitedPickupRange

Based on **Untargetable — Unlimited Pickup Range 2.1.3** ([Steam Workshop item 2951545839](https://steamcommunity.com/sharedfiles/filedetails/?id=2951545839)). It retains the source mod's features and enables them only in Endless mode after the first 20 waves (starting at wave 21).

## Retained behavior

- Press `F` to toggle the magnet on or off; the state is shared across players, matching the source mod.
- When enabled, pickup range is set to the source mod's large range and nearby pickups are attracted every 0.1 seconds.
- The source mod's level-up material bonus based on pickup-range stat is retained.
- Leaving Endless wave 21+ restores the player's regular pickup range and hides the magnet status label.

The normal run and Endless waves 1–20 keep vanilla pickup behavior. Disable the original Workshop mod while using this variant; enabling both leaves unlimited pickup active before wave 21. The source mod's manifest requires ModLoader 6.3.0; this repack is configured for this project’s ModLoader 6.2.0 and Brotato 1.2.0.1.

## Package

`builds/BrotatoMod-EndlessUnlimitedPickupRange-1.0.0.zip`
# BrotatoMod Steam Workshop Preview Image Guide

Use this guide when creating or revising a Steam Workshop preview image for any Mod in this repository. The goal is a recognizable, consistent BrotatoMod collection whose illustrations sit naturally beside Brotato's hand-painted 2D art.

## Shared visual identity

- Create original illustrations with a warm, hand-painted 2D roguelike feel: chunky forms, slightly irregular dark-brown ink outlines, soft brush texture, and a restrained worn-paper grain.
- Keep the shared palette earthy: charcoal brown and taupe backgrounds, warm cream highlights, with muted mustard, olive, dusty red, and blue accents.
- Use one clear focal subject in the lower two-thirds. A small potato adventurer can recur when it helps explain the Mod, but vary pose and supporting objects to fit that Mod's function.
- Keep weapon, item, and effect symbols simple enough to read at thumbnail size. Do not draw crowded interface panels or tiny labels.
- Match the reference mood, not exact game artwork. Do not copy the game's logo, characters, UI screenshots, or existing art assets.

## Layout and typography

- Use a square 1:1 canvas. Generate a high-resolution square master, then export a 512×512 final preview.
- Reserve roughly the top 22% as a dark, low-detail title band. Keep the focal art below it.
- Add the title after image generation so spelling stays exact. Center it in uppercase, using a heavy sans-serif display face, warm cream fill, and a short dark-brown shadow or outline.
- Add one thin muted-gold underline below the title. Keep the title treatment and spacing consistent across Mods.
- Use a concise display title, normally one or two lines. When a Mod ID is long, shorten the visible title to its main feature instead of shrinking the type until it becomes hard to read.
- Do not add extra taglines, tiny feature lists, or text baked into the generated illustration.

## Content rules

- Show the Mod's main feature accurately. For example, AllStartingWeapons should visibly communicate a broad choice of weapon types at run start.
- Keep the image readable when reduced to a small Workshop tile. Favor one hero and a few large, distinct supporting icons.
- Avoid suggesting unavailable DLC, unsupported mechanics, or gameplay changes the Mod does not make.
- Avoid photorealism, glossy 3D renders, anime styling, neon-heavy palettes, busy scenery, watermarks, and unrelated props.
- Use original art. If a game screenshot is supplied, treat it only as a reference for general mood and composition unless the user explicitly asks to use it as source material.

## Generation prompt template

```text
Use case: ads-marketing
Asset type: square Steam Workshop preview illustration for a Brotato Mod
Primary request: Show <the Mod's main feature accurately>.
Scene/backdrop: warm charcoal-brown and taupe painted game-world background, subtle worn-paper texture.
Subject: <one clear focal subject> with <a few large symbols/props directly related to the Mod>.
Style/medium: original hand-painted 2D indie roguelike illustration, chunky simple shapes, slightly irregular dark-brown ink outlines, soft brush grain; broadly compatible with Brotato's approachable painted art without copying existing assets.
Composition/framing: square 1:1; focal subject in the lower two-thirds; reserve the top 22% as a clean dark title band.
Color palette: charcoal, taupe, warm cream, with restrained muted mustard, olive, dusty red, and blue accents.
Text (verbatim): none; title will be typeset afterward.
Constraints: original artwork, readable at thumbnail size, one clear focal subject, no logos, no screenshot/UI, no watermark, no border, no text or lettering.
```

## Export and naming

- Save the final image inside its own Mod folder as `mods/<ModFolder>/preview.jpg`.
- Export as square 512×512 JPG and keep it below 1 MB for Workshop compatibility. Steam's UGC preview image documentation specifies a 1 MB limit: [ISteamUGC](https://partner.steamgames.com/doc/api/ISteamUGC).
- Keep the preview separate from the Mod's `package-root`; it is Workshop artwork, not an in-game asset.
- Preserve the generated high-resolution master outside the packaged Mod if an editable source is useful. Do not replace an existing preview silently; use a versioned sibling until the new one is selected.

## Current reference

`mods/AllStartingWeapons/preview.jpg` establishes the first reference: centered cream potato adventurer, a fan of distinct weapon cards, dark textured upper title band, cream uppercase title, and a muted-gold underline.

`mods/DiscountedRerolls/preview.jpg` extends the reference with feature-specific shop and upgrade refresh symbols plus a reduced coin pile, while keeping the same title treatment, painted texture, and palette.

`mods/EndlessUnlimitedPickupRange/preview.jpg` uses an infinity motif, a magnet, and distant pickups in motion to express its Endless-only long-range pickup behavior, with the shared title band and palette.

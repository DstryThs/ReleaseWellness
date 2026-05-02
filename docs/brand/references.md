# Reference sites

Sites the practitioner pointed to during design discovery. Each entry captures **what specifically she liked** so we don't accidentally copy unrelated things. Treat these as feature/treatment references, not as overall design templates.

## 1. [jareebasgall.com](https://www.jareebasgall.com/)

**Status:** full design inspiration — multiple elements she liked.

**What she likes:**
- **Textured background.** A subtle paper / grain feel across the page rather than a flat color.
- **Scroll-linked background motion.** Decorative branches/florals drift as the user scrolls — a soft parallax effect tied to scroll position, not autoplay.
- **Torn-paper image treatment.** Photos shown with rough, torn-edge masks rather than clean rectangles.

**What to translate, not copy:**
- The reference site's motif is **floral**. Hers should stay **nature-based** (leaves, branches, forest, water, light). Apply the same torn-edge / parallax treatment to nature imagery.

**Build notes:**
- **Texture:** subtle SVG noise overlay (`<feTurbulence>`), a small repeating PNG, or a faint paper texture image. Aim for ~3–5% intensity — present, not loud.
- **Parallax / scroll motion:** use `transform: translateY(...)` driven by scroll, not `top`/`background-position`, for GPU-friendly animation. Modern browsers support CSS scroll-driven animations natively (`animation-timeline: scroll()`); IntersectionObserver + `requestAnimationFrame` is the bulletproof fallback. **Wrap all scroll-driven motion in `@media (prefers-reduced-motion: reduce)` to disable it** — important for a therapy audience that may include visitors with vestibular sensitivities or trauma-related motion triggers.
- **Torn-paper effect:** options are (a) SVG mask with a hand-drawn torn edge applied to `<img>`, (b) pre-cut PNGs with transparent torn edges (simplest, but locks the shape per asset), or (c) `mask-image` with a torn-edge SVG. Option (a) gives the most flexibility.

## 2. [saltwatermassage.com](https://saltwatermassage.com/)

**Status:** **NOT a full inspiration site** — referenced for a single feature only.

**What she likes:**
- The **ambient video background** in the "Saltwater Experience" section. She wants the same treatment applied to one section of her site, using **her own video clip**.

**Build notes:**
- Section-level background `<video>` with `muted`, `autoplay`, `loop`, `playsinline`, and a `poster` image so the section is never blank during load.
- Compress aggressively. Target ≤ 3–5 MB for a ~10–15 second loop; use H.264 MP4 + WebM. Consider serving a smaller bitrate or falling back to the poster image on `prefers-reduced-data`, slow connections, and `prefers-reduced-motion: reduce`.
- Pause the video when the section is off-screen (IntersectionObserver) to save battery and CPU.
- A subtle dark overlay on top usually helps any text in the section stay legible — confirm contrast against whatever clip she provides.
- **Open question:** does she have a clip yet? If not, this section can't ship until we have one. We may want to plan a shoot or pick a stock clip that matches the brand (forest light, water, leaves moving in wind).

## Cross-cutting takeaways

Two themes that show up across both references and our existing brand work:
1. **Soft, ambient motion** — branches drifting, video looping. Nothing flashy or fast. Movement should feel like *breathing*, not like a pitch deck.
2. **Natural texture over flat color** — paper grain, real-world video, photo edges that aren't perfectly clean. Avoid the look of a sterile SaaS landing page.

Both of these reinforce decisions already in [visual-style.md](visual-style.md) (warm cream backgrounds, atmospheric photography, generous whitespace).

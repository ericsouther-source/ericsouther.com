# ericsouther.com

The site for Eric Souther, video artist and toolmaker. One hand written page,
no build step, no framework, no dependencies to install.

## What is here

| File | What it is |
|---|---|
| `index.html` | The whole site. All CSS and JS inline. Hash routed, so `#/about`, `#/cv`, `#/work/<slug>`. |
| `cv-data.js` | `window.CV`, 32 sections and 681 entries. Feeds the CV page and the News page's Recent and Grants sections. |
| `work-assets.js` | `window.WORK_ASSETS`, per work image and video manifests. |
| `Eric-Souther-CV.pdf` | The download behind the CV button. |
| `previews/make-gifs.sh` | Builds looping GIF previews from source video with a two pass ffmpeg palette. |
| `.nojekyll` | Tells GitHub Pages to serve the files as they are. |

## Running it locally

Open `index.html` in a browser. That is the whole workflow. For an exact match to
production, serve it instead so relative paths behave identically:

    python3 -m http.server 8000

Then open http://localhost:8000

## Deploying

Push to `main`. GitHub Pages serves the repo root.

## Adding a work

Works live in the `allWorks` array inside `index.html`, ordered newest to oldest.
The numbering in the grid comes from array position, not from the `sort` field, so
insert a new work where it belongs chronologically rather than appending it.

    {slug:"myslug", wix:"<wix media id>" or thumb:"<image url>",
     title:"Title", year:"2026", sort:2026, medium:"Single channel video",
     tags:["Signal Processing"], vimeo:"123456789",
     spec:"Single channel video, 9min, 3840x2160, 2026",
     credits:"", statement:["First paragraph.","Second paragraph."]},

Set `hidden:true` to keep a work in the file but off the site entirely: out of the
grid, out of the counts, out of prev and next, unreachable by URL.

The project page hero is the Vimeo player itself, so `vimeo` is what leads. If a
work has no `vimeo` the first video in its asset pack leads instead, and if it has
no video at all the hero falls back to a still.

## Adding a screening or exhibition

Upcoming dates are the `upcomingNews` array in `index.html` and drop off by
themselves once the end date passes. Recent work and grants are read out of
`cv-data.js` automatically, so past events need no maintenance at all.

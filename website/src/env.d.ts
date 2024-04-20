/// <reference path="../node_modules/@astrojs/starlight/virtual.d.ts"/>
/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />
/// <reference types="astro/astro-jsx" />

import "astro/astro-jsx";

interface Window {
  Alpine: import("alpinejs").Alpine;
}

declare global {
  namespace JSX {
    type Element = HTMLElement;
    type IntrinsicElements = astroHTML.JSX.IntrinsicElements;
  }
}

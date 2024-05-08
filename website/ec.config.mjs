import { defineEcConfig } from "@astrojs/starlight/expressive-code";

import { pluginLineNumbers } from "@expressive-code/plugin-line-numbers";
import { pluginCollapsibleSections } from "@expressive-code/plugin-collapsible-sections";

export default defineEcConfig({
  styleOverrides: {
    codeFontSize: "12px",
  },
  plugins: [pluginLineNumbers(), pluginCollapsibleSections()],
});

import { defineEcConfig } from "@astrojs/starlight/expressive-code";

import { pluginLineNumbers } from "@expressive-code/plugin-line-numbers";

export default defineEcConfig({
  plugins: [pluginLineNumbers()],
});

import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

import tailwind from "@astrojs/tailwind";

// https://astro.build/config
export default defineConfig({
  integrations: [
    starlight({
      title: "Reactter",
      logo: {
        src: "./src/assets/reactter.svg",
      },
      customCss: ["./src/styles/tailwind.css", "./src/styles/custom.css"],
      defaultLocale: "root",
      locales: {
        root: {
          label: "English",
          lang: "en",
        },
        es: {
          label: "Español",
        },
      },
      social: {
        github: "https://github.com/2devs-team/reactter",
      },
      sidebar: [
        {
          label: "Guides",
          items: [
            // Each item here is one entry in the navigation menu.
            {
              label: "Example Guide",
              link: "/guides/example/",
            },
          ],
        },
        {
          label: "Reference",
          autogenerate: {
            directory: "reference",
          },
        },
      ],
    }),
    tailwind({
      applyBaseStyles: false,
    }),
  ],
});

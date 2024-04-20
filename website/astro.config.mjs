import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import tailwind from "@astrojs/tailwind";
import alpinejs from "@astrojs/alpinejs";

import icon from "astro-icon";

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
      components: {
        Card: "./src/components/Card.astro",
        SiteTitle: "./src/components/SiteTitle.astro",
        ThemeProvider: "./src/components/ThemeProvider.astro",
        ThemeSelect: "./src/components/ThemeSelect.astro",
      },
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
          label: "Start here",
          translations: {
            es: "Comienza aquí",
          },
          items: [
            {
              label: "Overview",
              link: "/overview",
              translations: {
                es: "Introducción",
              },
            },
            {
              label: "Getting Started",
              link: "/getting_started",
              translations: {
                es: "Empezando",
              },
            },
          ],
        },
        {
          label: "Core Concepts",
          translations: {
            es: "Conceptos básicos",
          },
          autogenerate: {
            directory: "core_concepts",
          },
        },
        {
          label: "Classes",
          translations: {
            es: "Clases",
          },
          autogenerate: {
            directory: "classes",
          },
        },
        {
          label: "Methods",
          translations: {
            es: "Métodos",
          },
          items: [
            {
              label: "To manage states",
              translations: {
                es: "Para gestionar estados",
              },
              link: "/methods/shortcuts_to_manage_state",
            },
            {
              label: "To manage instances",
              translations: {
                es: "Para gestionar instancias",
              },
              link: "/methods/shortcuts_to_manage_effects",
            },
            {
              label: "To manage events",
              translations: {
                es: "Para gestionar eventos",
              },
              link: "/methods/shortcuts_to_manage_events",
            },
            {
              label: "Memo",
              link: "/methods/memo",
            },
          ],
        },
        {
          label: "For Flutter",
          translations: {
            es: "Para Flutter",
          },
          autogenerate: {
            directory: "for_flutter",
          },
        },
      ],
    }),
    tailwind({
      applyBaseStyles: false,
    }),
    alpinejs(),
    icon(),
  ],
});

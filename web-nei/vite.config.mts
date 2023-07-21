import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import svgrPlugin from "vite-plugin-svgr";
import viteTsconfigPaths from "vite-tsconfig-paths";
import { ViteImageOptimizer } from "vite-plugin-image-optimizer";

import { visualizer } from "rollup-plugin-visualizer";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    viteTsconfigPaths(),
    react(),
    svgrPlugin(),
    ViteImageOptimizer({}),
    visualizer(),
  ],
  build: {
    outDir: "build",
  },
});

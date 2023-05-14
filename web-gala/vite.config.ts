import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  base: '/gala',
})


// export default defineConfig(({ command, mode, ssrBuild }) => {
//   if (command === "serve") {
//     // dev specific config
//     return {
//       plugins: [react()],
//     };
//   } else {
//     // build specific config
//     return {
//       plugins: [react()],
//     };
//   }
// });

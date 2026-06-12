import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  base: '/build-pc/',
  build: {
    outDir: path.resolve(__dirname, '../src/main/resources/static/build-pc'),
    emptyOutDir: true,
  }
})

import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  build: {
    chunkSizeWarningLimit: 1800,
    rollupOptions: {
      output: {
        manualChunks: {
          game: ['phaser'],
          react: ['react', 'react-dom'],
        },
      },
    },
  },
  server: {
    port: 5173,
    proxy: {
      '/api': process.env.VITE_API_PROXY_TARGET ?? 'http://localhost:8000',
      '/ws': {
        target: process.env.VITE_WS_PROXY_TARGET ?? 'ws://localhost:8000',
        ws: true,
      },
    },
  },
});

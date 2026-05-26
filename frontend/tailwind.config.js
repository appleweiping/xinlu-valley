/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        town: {
          bg: '#1a1a2e',
          panel: '#16213e',
          accent: '#e94560',
          soft: '#f8e8d4',
          mint: '#a8e6cf',
          lavender: '#dcd6f7',
          peach: '#ffb7b2',
          cream: '#ffeaa7',
        },
      },
      fontFamily: {
        pixel: ['"Press Start 2P"', 'monospace'],
      },
    },
  },
  plugins: [],
};

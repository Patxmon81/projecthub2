/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        bg: {
          primary: 'var(--color-bg-primary)',
          surface: 'var(--color-bg-surface)',
          hover: 'var(--color-bg-hover)',
        },
        border: {
          subtle: 'var(--color-border-subtle)',
        },
        accent: {
          primary: '#6366F1',
          success: '#10B981',
          danger: '#EF4444',
          warning: '#F59E0B',
        },
        text: {
          primary: 'var(--color-text-primary)',
          secondary: 'var(--color-text-secondary)',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'Fira Code', 'monospace'],
      },
      borderRadius: {
        card: '12px',
        input: '8px',
      },
    },
  },
  plugins: [],
}

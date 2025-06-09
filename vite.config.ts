import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import reloadOnChange from 'vite-plugin-full-reload';

export default defineConfig({
  plugins: [
    react(),
    RubyPlugin(),
    reloadOnChange(['config/routes.rb', 'app/serializers/*.rb'], { delay: 200 }),
  ],
});

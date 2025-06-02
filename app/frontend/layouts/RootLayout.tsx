import '@mantine/core/styles.css';
import '@mantine/notifications/styles.css';

import { createTheme, MantineProvider } from '@mantine/core';
import { PropsWithChildren } from 'react';
import { Notifications } from '@mantine/notifications';
import { FlashLayout } from './FlashLayout';

const theme = createTheme({
  defaultRadius: 'md',
});

export function RootLayout({ children }: PropsWithChildren) {
  return (
    <MantineProvider>
      <Notifications />
      <FlashLayout>{children}</FlashLayout>
    </MantineProvider>
  );
}

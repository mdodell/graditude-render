import '@mantine/core/styles.layer.css';
import '@mantine/notifications/styles.layer.css';

import { createTheme, MantineProvider } from '@mantine/core';
import { PropsWithChildren } from 'react';
import { Notifications } from '@mantine/notifications';
import { FlashLayout } from './FlashLayout';

const theme = createTheme({
  defaultRadius: 'md',
});

export function RootLayout({ children }: PropsWithChildren) {
  return (
    <MantineProvider theme={theme}>
      <Notifications autoClose={3000} />
      <FlashLayout>{children}</FlashLayout>
    </MantineProvider>
  );
}

import '@mantine/core/styles.css';
import '@mantine/notifications/styles.css';

import { createTheme, MantineProvider } from '@mantine/core';
import { PropsWithChildren, useEffect } from 'react';
import { Notifications } from '@mantine/notifications';
import { FlashLayout } from './FlashLayout';
import { router } from '@inertiajs/react';

const theme = createTheme({
  defaultRadius: 'md',
});

export function RootLayout({ children }: PropsWithChildren) {
  useEffect(() => {
    console.log('Setting up router event listeners');
    router.on('start', (event) => {
      console.log('Navigation event:', event);
    });

    router.on('before', (event) => {
      console.log('Navigation event:', event);
    });

    return () => {
      router.on('finish', (event) => {
        console.log('Navigation event:', event);
      });
    };
  }, []);

  return (
    <MantineProvider theme={theme}>
      <Notifications autoClose={4000} />
      <FlashLayout>{children}</FlashLayout>
    </MantineProvider>
  );
}

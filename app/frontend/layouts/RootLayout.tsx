import '@mantine/core/styles.layer.css';
import '@mantine/notifications/styles.layer.css';

import {
  createTheme,
  defaultVariantColorsResolver,
  MantineProvider,
  Modal,
  VariantColorsResolver,
} from '@mantine/core';
import { PropsWithChildren } from 'react';
import { Notifications } from '@mantine/notifications';
import { FlashLayout } from './FlashLayout';

const variantColorResolver: VariantColorsResolver = (input) => {
  const defaultResolvedColors = defaultVariantColorsResolver(input);
  // const parsedColor = parseThemeColor({
  //   color: input.color || input.theme.primaryColor,
  //   theme: input.theme,
  // });

  // Add new variants support
  if (input.variant === 'danger') {
    return {
      background: 'var(--mantine-color-red-9)',
      hover: 'var(--mantine-color-red-8)',
      color: 'var(--mantine-color-white)',
      border: 'none',
    };
  }

  return defaultResolvedColors;
};

const theme = createTheme({
  defaultRadius: 'md',
  variantColorResolver,
  components: {
    AppShell: {
      defaultProps: {
        header: {
          height: 70,
        },
        padding: 'md',
      },
    },
    AppShellMain: {
      defaultProps: {
        bg: 'var(--mantine-color-gray-0)',
      },
    },
    AppShellNavbar: {
      defaultProps: {
        p: 'md',
      },
    },
    Modal: Modal.extend({
      styles: {
        title: {
          fontWeight: 'var(--mantine-h2-font-weight)',
        },
      },
    }),
  },
});

export function RootLayout({ children }: PropsWithChildren) {
  return (
    <MantineProvider theme={theme}>
      <Notifications autoClose={3000} />
      <FlashLayout>{children}</FlashLayout>
    </MantineProvider>
  );
}

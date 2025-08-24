import '@mantine/core/styles.layer.css';
import '@mantine/notifications/styles.layer.css';

import {
  AppShellHeader,
  createTheme,
  defaultVariantColorsResolver,
  MantineProvider,
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
    AppShellNavbar: {
      defaultProps: {
        p: 'md',
      },
    },
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

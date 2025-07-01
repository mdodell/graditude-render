import { Image } from '@mantine/core';
import logoBlue from '/assets/logo-blue.svg';
import logoWhite from '/assets/logo-white.svg';
import { useMantineColorScheme } from '@mantine/core';
import classes from './AppLogo.module.css';
import { router } from '@inertiajs/react';
import { root_path } from '../../../routes';

export function AppLogo() {
  const { colorScheme } = useMantineColorScheme();
  return (
    <Image
      onClick={() => router.visit(root_path())}
      className={classes.logo}
      src={colorScheme === 'dark' ? logoWhite : logoBlue}
      alt="Logo"
    />
  );
}

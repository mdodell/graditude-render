import { router } from '@inertiajs/react';

import { Avatar, Button, Menu, useMantineColorScheme } from '@mantine/core';
import { IconSettings, IconLogout, IconMoon, IconSun, IconTrash } from '@tabler/icons-react';
import { usePage } from '@inertiajs/react';
import { PageProps } from '../../../types/inertia';
import { logout_path, settings_account_path } from '../../../routes';
import classes from './UserMenu.module.css';

export function UserMenu() {
  const { colorScheme, setColorScheme } = useMantineColorScheme({
    keepTransitions: true,
  });

  const {
    props: {
      auth: {
        session: { id },
      },
    },
  } = usePage<PageProps>();

  return (
    <Menu closeOnItemClick={false}>
      <Menu.Target>
        <Avatar name="Mitchell Dodell" color="blue" className={classes.user} />
      </Menu.Target>
      <Menu.Dropdown>
        <Menu.Label>Settings</Menu.Label>
        <Menu.Item
          leftSection={
            colorScheme === 'dark' ? (
              <IconSun size={16} stroke={1.5} />
            ) : (
              <IconMoon size={16} stroke={1.5} />
            )
          }
          onClick={() => {
            setColorScheme(colorScheme === 'dark' ? 'light' : 'dark');
          }}
        >
          {colorScheme === 'dark' ? 'Light Mode' : 'Dark Mode'}
        </Menu.Item>
        <Menu.Item
          leftSection={<IconSettings size={16} stroke={1.5} />}
          onClick={() => router.visit(settings_account_path())}
        >
          Account settings
        </Menu.Item>
        <Menu.Item
          leftSection={<IconLogout size={16} stroke={1.5} />}
          onClick={() => router.delete(logout_path({ id }))}
        >
          Logout
        </Menu.Item>
        <Menu.Divider />
      </Menu.Dropdown>
    </Menu>
  );
}

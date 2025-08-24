import { Divider } from '@mantine/core';

import { ActionIcon } from '@mantine/core';

import { AppShell, Box, Group } from '@mantine/core';
import { AppLogo } from '../AppLogo/AppLogo';
import { IconBell } from '@tabler/icons-react';
import { UserMenu } from '../UserMenu/UserMenu';

export function Header() {
  return (
    <AppShell.Header px="md">
      <Group h="100%" align="center" justify="space-between">
        <Box w={125} pt="sm">
          <AppLogo />
        </Box>
        <Group>
          <ActionIcon variant="transparent" color="gray">
            <IconBell stroke={1.5} size={18} />
          </ActionIcon>
          <Divider orientation="vertical" />
          <UserMenu />
        </Group>
      </Group>
    </AppShell.Header>
  );
}

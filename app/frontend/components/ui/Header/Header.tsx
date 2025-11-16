import { Divider } from '@mantine/core';

import { ActionIcon } from '@mantine/core';

import { AppShell, Box, Group } from '@mantine/core';
import { AppLogo } from '../AppLogo/AppLogo';
import { IconBell } from '@tabler/icons-react';
import { UserMenu } from '../UserMenu/UserMenu';
import { usePage } from '@inertiajs/react';
import { PageProps } from '../../../types/inertia';

export function Header() {
  const {
    props: { auth },
  } = usePage<PageProps>();

  const id = auth.session?.id;

  return (
    <AppShell.Header px="md">
      <Group h="100%" align="center" justify="space-between">
        <Box w={125} pt="sm">
          <AppLogo />
        </Box>
        {id && (
          <Group>
            <ActionIcon variant="transparent" color="gray">
              <IconBell stroke={1.5} size={18} />
            </ActionIcon>
            <Divider orientation="vertical" />
            <UserMenu id={id} />
          </Group>
        )}
      </Group>
    </AppShell.Header>
  );
}

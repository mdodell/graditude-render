import { usePage } from '@inertiajs/react';
import { ActionIcon, AppShell, Divider, Group, NavLink, Text, Box } from '@mantine/core';
import { IconBell, IconCalendar, IconMessage } from '@tabler/icons-react';
import { IconHome } from '@tabler/icons-react';
import { PropsWithChildren } from 'react';
import classes from './DashboardLayout.module.css';
import { UserMenu } from '../../components/ui/UserMenu';
import { AppLogo } from '../../components/ui/AppLogo/AppLogo';

const navbarLinks = [
  {
    label: 'Home',
    links: [
      { label: 'Dashboard', href: '/', icon: <IconHome stroke={1.5} size={18} /> },
      { label: 'Chat', href: '/chat', icon: <IconMessage stroke={1.5} size={18} /> },
      { label: 'Calendar', href: '/calendar', icon: <IconCalendar stroke={1.5} size={18} /> },
    ],
  },
];

export function DashboardLayout({ children, ...props }: PropsWithChildren) {
  const { url } = usePage();
  return (
    <AppShell
      header={{ height: 70 }}
      navbar={{
        width: 300,
        breakpoint: 'sm',
        collapsed: { mobile: true },
      }}
      padding="md"
    >
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

      <AppShell.Navbar p="md">
        <AppShell.Section className={classes.section}>Organization</AppShell.Section>
        <AppShell.Section>
          {navbarLinks.map((section) => (
            <>
              <Text c="dimmed" mt="sm" tt="uppercase" fw={600} style={{ letterSpacing: '1.25px' }}>
                {section.label}
              </Text>
              {section.links.map((link) => {
                const isActive = url === link.href;
                return (
                  <NavLink
                    active={url === link.href}
                    key={link.label}
                    leftSection={link.icon}
                    label={link.label}
                    href={link.href}
                    variant="light"
                    fw={isActive ? 'bold' : 400}
                  />
                );
              })}
            </>
          ))}
        </AppShell.Section>
      </AppShell.Navbar>

      <AppShell.Main>{children}</AppShell.Main>
    </AppShell>
  );
}

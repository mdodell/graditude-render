import { usePage } from '@inertiajs/react';
import { AppShell, Text } from '@mantine/core';
import { IconCalendar, IconMessage } from '@tabler/icons-react';
import { IconHome } from '@tabler/icons-react';
import { PropsWithChildren } from 'react';
import classes from './DashboardLayout.module.css';
import { Header } from '../../components/ui/Header';
import { SideNavItem } from '../../components/ui/SideNav/SideNavItem';

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

export function DashboardLayout({ children }: PropsWithChildren) {
  const { url } = usePage();
  return (
    <AppShell navbar={{ width: 300, breakpoint: 'md' }}>
      <Header />
      <AppShell.Navbar>
        <AppShell.Section className={classes.section}>Organization</AppShell.Section>
        <AppShell.Section>
          {navbarLinks.map((section) => (
            <>
              <Text
                key={section.label}
                c="dimmed"
                mt="sm"
                tt="uppercase"
                fw={600}
                style={{ letterSpacing: '1.25px' }}
              >
                {section.label}
              </Text>
              {section.links.map((link) => {
                const isActive = url === link.href;
                return <SideNavItem key={link.label} {...link} active={isActive} />;
              })}
            </>
          ))}
        </AppShell.Section>
      </AppShell.Navbar>

      <AppShell.Main>{children}</AppShell.Main>
    </AppShell>
  );
}

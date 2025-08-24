import { NavLink } from '@mantine/core';

interface SideNavItemProps {
  label: string;
  href: string;
  icon: React.ReactNode;
  active: boolean;
}

export function SideNavItem({ label, href, icon, active }: SideNavItemProps) {
  return (
    <NavLink
      active={active}
      key={label}
      leftSection={icon}
      label={label}
      href={href}
      variant="light"
      fw={active ? 'bold' : 400}
    />
  );
}

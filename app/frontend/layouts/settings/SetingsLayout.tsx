import { AppShell, Paper, Tabs } from '@mantine/core';
import { Header } from '../../components/ui/Header';
import { PropsWithChildren } from 'react';
import classes from './SettingsLayout.module.css';

export const SettingsLayout = ({ children }: PropsWithChildren) => {
  return (
    <AppShell navbar={{ collapsed: { mobile: true } }}>
      <Header />
      <AppShell.Main>
        <Tabs defaultValue="gallery" orientation="vertical" classNames={{ list: classes.list }}>
          <Tabs.List>
            <Tabs.Tab value="profile">Personal information</Tabs.Tab>
            <Tabs.Tab value="security">Security</Tabs.Tab>
            <Tabs.Tab value="danger">Danger Zone</Tabs.Tab>
          </Tabs.List>
          <Tabs.Panel value="profile">{children}</Tabs.Panel>
          <Tabs.Panel value="security">{children}</Tabs.Panel>
          <Tabs.Panel value="danger">{children}</Tabs.Panel>
        </Tabs>
      </AppShell.Main>
    </AppShell>
  );
};

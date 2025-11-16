import { AppShell, AppShellMain, Button, Flex, Title, Text, Group } from '@mantine/core';
import { PropsWithChildren } from 'react';
import { Header } from '../../components/ui/Header';
import { IconPlus, IconUsers } from '@tabler/icons-react';
import { router } from '@inertiajs/react';
import { new_organization_path } from '../../routes';

export function OrganizationsLayout({ children }: PropsWithChildren) {
  const handleCreateOrganization = () => {
    router.visit(new_organization_path());
  };

  return (
    <>
      <AppShell navbar={{ width: 0, breakpoint: 'lg' }}>
        <Header />
        <AppShellMain>
          <Flex justify="space-between" align="center">
            <Flex direction="column">
              <Title order={3}>Organizations</Title>
              <Text c="dimmed">Manage and discover college organizations</Text>
            </Flex>

            <Group>
              <Button leftSection={<IconUsers size={14} />} variant="outline">
                Join Organization
              </Button>
              <Button leftSection={<IconPlus size={14} />} onClick={handleCreateOrganization}>
                Create Organization
              </Button>
            </Group>
          </Flex>
          {children}
        </AppShellMain>
      </AppShell>
    </>
  );
}

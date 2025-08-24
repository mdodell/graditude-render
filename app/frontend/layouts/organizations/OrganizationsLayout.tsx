import { AppShell, Button, Flex, Title } from '@mantine/core';
import { PropsWithChildren } from 'react';
import { Header } from '../../components/ui/Header';
import { IconPlus } from '@tabler/icons-react';
import { router } from '@inertiajs/react';
import { new_organization_path } from '../../routes';

export function OrganizationsLayout({ children }: PropsWithChildren) {
  const handleCreateOrganization = () => {
    router.visit(new_organization_path());
  };

  return (
    <AppShell navbar={{ width: 0, breakpoint: 'lg' }}>
      <Header />
      <AppShell.Main>
        <Flex justify="space-between" align="center">
          <Title>Organizations</Title>
          <Button rightSection={<IconPlus />} onClick={handleCreateOrganization}>
            Create Organization
          </Button>
        </Flex>
        {children}
      </AppShell.Main>
    </AppShell>
  );
}

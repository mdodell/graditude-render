import { AppPage } from '../../types/inertia';
import { router } from '@inertiajs/react';
import { AppShell, AppShellMain, Flex, Title, Group, Button, Grid, Text } from '@mantine/core';
import { IconUsers, IconPlus } from '@tabler/icons-react';
import { useState } from 'react';
import { JoinOrganizationModal } from '../../components/organizations/JoinOrganizationModal';
import { Header } from '../../components/ui/Header';
import { new_organization_path } from '../../routes';
import { Organization } from '../../types/serializers';
import { OrganizationTile } from '../../components/organizations/OrganizationTile';

interface OrganizationsIndexProps {
  organizations: Organization[];
}

const OrganizationsIndex: AppPage<OrganizationsIndexProps> = ({ organizations }) => {
  const handleCreateOrganization = () => {
    router.visit(new_organization_path());
  };

  const [joinOrganizationModalOpened, setJoinOrganizationModalOpened] = useState(false);

  return (
    <>
      <JoinOrganizationModal
        opened={joinOrganizationModalOpened}
        onClose={() => setJoinOrganizationModalOpened(false)}
        organizations={organizations}
      />
      <AppShell navbar={{ width: 0, breakpoint: 'lg' }}>
        <Header />
        <AppShellMain>
          <Flex justify="space-between" align="center">
            <Flex direction="column">
              <Title order={3}>Organizations</Title>
              <Text c="dimmed">Manage and discover college organizations</Text>
            </Flex>

            <Group>
              <Button
                leftSection={<IconUsers size={14} />}
                variant="outline"
                onClick={() => setJoinOrganizationModalOpened(true)}
              >
                Join Organization
              </Button>
              <Button leftSection={<IconPlus size={14} />} onClick={handleCreateOrganization}>
                Create Organization
              </Button>
            </Group>
          </Flex>
          <Grid>
            {organizations.map((organization) => (
              <Grid.Col span={12} key={organization.id}>
                <OrganizationTile organization={organization} />
              </Grid.Col>
            ))}
          </Grid>
        </AppShellMain>
      </AppShell>
    </>
  );
};

export default OrganizationsIndex;

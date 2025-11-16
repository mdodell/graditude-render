import { Modal, Stack, Tabs, Text, TextInput } from '@mantine/core';
import { Organization } from '../../../types/serializers';
import { OrganizationTile } from '../OrganizationTile';
import { IconKey, IconSearch } from '@tabler/icons-react';
import { OrganizationInviteCodeInput } from './OrganizationInviteCodeInput';

interface JoinOrganizationModalProps {
  opened: boolean;
  onClose: () => void;
  organizations: Organization[];
}

export function JoinOrganizationModal({
  opened,
  onClose,
  organizations,
}: JoinOrganizationModalProps) {
  return (
    <Modal opened={opened} onClose={onClose} title="Join Organization">
      <Text c="dimmed">Find and join organizations at your college or use an invitation code</Text>

      <Tabs variant="pills" defaultValue="organizations">
        <Tabs.List mb="md">
          <Tabs.Tab value="organizations" leftSection={<IconSearch size={16} />}>
            Browse Organizations
          </Tabs.Tab>
          <Tabs.Tab value="invitation-codes" leftSection={<IconKey size={16} />}>
            Use Invitation Code
          </Tabs.Tab>
        </Tabs.List>
        <Tabs.Panel value="organizations">
          <Stack>
            <TextInput placeholder="Search for an organization by name" />
            {organizations.map((organization) => (
              <OrganizationTile size="compact" key={organization.id} organization={organization} />
            ))}
          </Stack>
        </Tabs.Panel>

        <Tabs.Panel value="invitation-codes">
          <Stack>
            <OrganizationInviteCodeInput />
          </Stack>
        </Tabs.Panel>
      </Tabs>
    </Modal>
  );
}

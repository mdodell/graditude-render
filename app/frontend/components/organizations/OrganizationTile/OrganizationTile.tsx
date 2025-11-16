import { Card, Text, Title } from '@mantine/core';
import { Organization } from '../../../types/serializers';

interface OrganizationTileProps {
  organization: Organization;
  size?: 'compact' | 'default';
}

export function OrganizationTile({ organization, size = 'default' }: OrganizationTileProps) {
  return (
    <Card withBorder>
      <Card.Section inheritPadding>
        <Title order={3}>{organization.name}</Title>
        <Text c="dimmed">{organization.colleges.map((college) => college.name).join(', ')}</Text>
      </Card.Section>
    </Card>
  );
}

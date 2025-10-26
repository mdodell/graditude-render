import { router } from '@inertiajs/react';
import { Button, Paper, Title, Stack, Box, Flex, Text, Stepper } from '@mantine/core';
import { PropsWithChildren } from 'react';
import { IconArrowLeft } from '@tabler/icons-react';

const STEPS = ['details', 'college', 'description', 'review'] as const;

interface OrganizationsCreationLayoutProps extends PropsWithChildren {
  step?: string;
}

export const OrganizationsCreationLayout = ({
  children,
  step = 'details',
}: OrganizationsCreationLayoutProps) => {
  const getStepIndex = (stepName: string) => {
    return STEPS.indexOf(stepName as (typeof STEPS)[number]);
  };

  return (
    <Flex bg="gray.1" h="100vh" w="100vw" justify="center" align="center" direction="column">
      <Button
        display="fixed"
        variant="light"
        leftSection={<IconArrowLeft size={12} />}
        onClick={() => router.visit('/organizations')}
      >
        Back to organizations
      </Button>
      <Box mb="md" ta="center">
        <Title order={2}>Create New Organization</Title>
        <Text c="dimmed">Join thousands of college organizations using Graditude</Text>
      </Box>

      <Paper
        shadow="xs"
        p="xl"
        radius="md"
        withBorder
        miw={{
          xs: '95%',
          md: 900,
        }}
        maw="90%"
      >
        <Stepper active={getStepIndex(step)} size="md" mb="md">
          <Stepper.Step label="Details" />
          <Stepper.Step label="College" />
          <Stepper.Step label="Description" />
          <Stepper.Step label="Review" />
        </Stepper>
        <Stack gap="md">{children}</Stack>
      </Paper>
    </Flex>
  );
};

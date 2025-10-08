import { AppPage } from '../../types/inertia';
import { useForm, router } from '@inertiajs/react';
import {
  TextInput,
  Textarea,
  Button,
  Paper,
  Title,
  Stack,
  Group,
  Box,
  Flex,
  Text,
  Stepper,
} from '@mantine/core';
import { notifications } from '@mantine/notifications';
import { Organization } from '../../types/serializers';
import { PropsWithChildren, useState } from 'react';
import { IconArrowLeft } from '@tabler/icons-react';

type OrganizationFormData = Pick<Organization, 'name' | 'domain' | 'description'>;

const STEPS = ['Details', 'College', 'Description', 'Review'] as const;

export const OrganizationsCreationLayout = ({ children }: PropsWithChildren) => {
  const [active, setActive] = useState<(typeof STEPS)[number]>(STEPS[0]);
  const nextStep = () =>
    setActive((active) =>
      STEPS.indexOf(active) < STEPS.length - 1 ? STEPS[STEPS.indexOf(active) + 1] : active,
    );
  const prevStep = () =>
    setActive((active) => (STEPS.indexOf(active) > 0 ? STEPS[STEPS.indexOf(active) - 1] : active));

  const { data, setData, post, processing, errors, reset } = useForm<OrganizationFormData>({
    name: '',
    domain: '',
    description: '',
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    post('/organizations', {
      onSuccess: () => {
        notifications.show({
          title: 'Success!',
          message: 'Organization created successfully',
          color: 'green',
        });
        reset();
      },
      onError: () => {
        notifications.show({
          title: 'Error',
          message: 'Failed to create organization. Please check the form.',
          color: 'red',
        });
      },
    });
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
        <form onSubmit={handleSubmit} noValidate={true}>
          <Stepper active={STEPS.indexOf(active)} size="md" mb="md">
            <Stepper.Step label="Details" />
            <Stepper.Step label="College" />
            <Stepper.Step label="Description" />
            <Stepper.Step label="Review" />
          </Stepper>
          <Stack gap="md">
            {children}
            <Group justify={active !== STEPS[0] ? 'space-between' : 'flex-end'} mt="md">
              {active !== STEPS[0] && (
                <Button variant="light" onClick={prevStep}>
                  Previous
                </Button>
              )}
              {active !== STEPS[STEPS.length - 1] && (
                <Button type="submit" loading={processing}>
                  {active === STEPS[STEPS.length - 1] ? 'Create Organization' : 'Next'}
                </Button>
              )}
            </Group>
          </Stack>
        </form>
      </Paper>
    </Flex>
  );
};

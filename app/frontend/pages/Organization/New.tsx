import { AppPage } from '../../types/inertia';
import { OrganizationsLayout } from '../../layouts/organizations/OrganizationsLayout';
import { useForm } from '@mantine/form';
import { TextInput, Textarea, Button, Paper, Title, Stack, Group } from '@mantine/core';
import { router } from '@inertiajs/react';
import { notifications } from '@mantine/notifications';

interface OrganizationFormData extends Record<string, any> {
  name: string;
  domain: string;
  description: string;
}

const OrganizationsNew: AppPage = () => {
  const form = useForm<OrganizationFormData>({
    mode: 'uncontrolled',
    initialValues: {
      name: '',
      domain: '',
      description: '',
    },
    validate: {
      name: (value) => {
        if (!value.trim()) return 'Organization name is required';
        if (value.length < 2) return 'Organization name must be at least 2 characters';
        if (value.length > 100) return 'Organization name must be less than 100 characters';
        return null;
      },
      domain: (value) => {
        if (!value.trim()) return 'Domain is required';
        // Basic domain validation
        const domainRegex =
          /^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
        if (!domainRegex.test(value)) return 'Please enter a valid domain';
        return null;
      },
      description: (value) => {
        if (value && value.length > 250) return 'Description must be less than 250 characters';
        return null;
      },
    },
  });

  const handleSubmit = (values: OrganizationFormData) => {
    router.post(
      '/organizations',
      { organization: values },
      {
        onSuccess: () => {
          notifications.show({
            title: 'Success!',
            message: 'Organization created successfully',
            color: 'green',
          });
        },
        onError: (errors: any) => {
          // Handle server-side validation errors
          if (errors.organization?.name) form.setFieldError('name', errors.organization.name);
          if (errors.organization?.domain) form.setFieldError('domain', errors.organization.domain);
          if (errors.organization?.description)
            form.setFieldError('description', errors.organization.description);

          notifications.show({
            title: 'Error',
            message: 'Failed to create organization. Please check the form.',
            color: 'red',
          });
        },
      },
    );
  };

  return (
    <OrganizationsLayout>
      <Paper shadow="xs" p="xl" radius="md" withBorder>
        <Title order={2} mb="lg">
          Create New Organization
        </Title>

        <form onSubmit={form.onSubmit(handleSubmit)}>
          <Stack gap="md">
            <TextInput
              label="Organization Name"
              placeholder="Enter organization name"
              required
              key={form.key('name')}
              {...form.getInputProps('name')}
            />

            <TextInput
              label="Domain"
              placeholder="example.com"
              required
              key={form.key('domain')}
              {...form.getInputProps('domain')}
              description="Enter the primary domain for your organization"
            />

            <Textarea
              label="Description"
              placeholder="Brief description of your organization (optional)"
              key={form.key('description')}
              {...form.getInputProps('description')}
              description="Maximum 250 characters"
              maxLength={250}
              rows={3}
            />

            <Group justify="flex-end" mt="md">
              <Button variant="light" onClick={() => router.visit('/organizations')}>
                Cancel
              </Button>
              <Button type="submit">Create Organization</Button>
            </Group>
          </Stack>
        </form>
      </Paper>
    </OrganizationsLayout>
  );
};

export default OrganizationsNew;

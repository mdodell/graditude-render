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
  Grid,
} from '@mantine/core';
import { notifications } from '@mantine/notifications';
import { Organization } from '../../types/serializers';
import { useState } from 'react';
import { IconArrowLeft } from '@tabler/icons-react';
import { OrganizationsCreationLayout } from '../../layouts/organizations/OrganizationsCreationLayout';

type OrganizationFormData = Pick<Organization, 'name' | 'domain' | 'description'>;

const OrganizationsNew: AppPage = () => {
  const [active, setActive] = useState(0);
  const nextStep = () => setActive((current) => (current < 2 ? current + 1 : current));
  const prevStep = () => setActive((current) => (current > 0 ? current - 1 : current));

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
    <OrganizationsCreationLayout>
      <TextInput
        label="Organization Name"
        placeholder="Enter organization name"
        required
        value={data.name}
        onChange={(e) => setData('name', e.target.value)}
        error={errors.name}
      />
    </OrganizationsCreationLayout>
  );
};

export default OrganizationsNew;

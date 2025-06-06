import { Button, Grid, PasswordInput } from '@mantine/core';
import { useForm, usePage } from '@inertiajs/react';

import { AuthLayout } from '../layouts/auth/AuthLayout';
import { identity_password_reset_path } from '../routes';

export default function ResetPassword() {
  const { sid } = usePage<{ props: { sid: string } }>().props;

  const { setData, patch, processing, errors } = useForm({
    password: '',
    password_confirmation: '',
    sid: sid as string,
  });

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    patch(identity_password_reset_path());
  };

  return (
    <AuthLayout title="Reset Password" description="Reset Password" handleSubmit={handleSubmit}>
      <Grid.Col span={12}>
        <PasswordInput
          required
          label="New password"
          placeholder="New password"
          onChange={(e) => setData('password', e.currentTarget.value)}
          error={errors.password}
          disabled={processing}
        />
      </Grid.Col>
      <Grid.Col span={12}>
        <PasswordInput
          required
          label="Confirm new password"
          placeholder="Confirm new password"
          onChange={(e) => setData('password_confirmation', e.currentTarget.value)}
          error={errors.password_confirmation}
          disabled={processing}
        />
      </Grid.Col>
      <Grid.Col span={12}>
        <Button type="submit" loading={processing} disabled={processing}>
          Reset password
        </Button>
      </Grid.Col>
    </AuthLayout>
  );
}

import { Button, Center, Grid, Group, TextInput, Text, rem } from '@mantine/core';
import { AuthLayout } from '../../layouts/auth/AuthLayout';
import { Link } from '../../components/ui/link';
import { identity_password_reset_path, login_path } from '../../routes';
import { IconArrowLeft } from '@tabler/icons-react';
import { useForm } from '@inertiajs/react';
import { useSpinDelay } from 'spin-delay';
import classes from './RequestForgotPassword.module.css';

export default function RequestForgotPassword() {
  const { data, setData, post, processing, errors } = useForm({
    email: '',
  });

  const loading = useSpinDelay(processing, { delay: 100, minDuration: 200 });

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    post(identity_password_reset_path());
  };

  return (
    <>
      <AuthLayout
        title="Forgot Password"
        description="Enter your email to reset your password"
        handleSubmit={handleSubmit}
      >
        <Grid.Col span={12}>
          <TextInput
            required
            name="email"
            value={data.email}
            disabled={processing}
            error={errors.email}
            label="Your email"
            placeholder="graditude@graditudebeta.org"
            onChange={(e) => setData('email', e.target.value)}
          />
        </Grid.Col>
        <Group className={classes.controls} w="100%" justify="space-between" mt="md">
          <Link underline="never" href={login_path()} c="dimmed" className={classes.control}>
            <Center>
              <IconArrowLeft size={12} stroke={1.5} />
              <Text ml={rem('4px')}>Back to the login page</Text>
            </Center>
          </Link>
          <Button type="submit" loading={loading} disabled={loading} className={classes.control}>
            Send password reset email
          </Button>
        </Group>
      </AuthLayout>
    </>
  );
}

import { Head, useForm } from '@inertiajs/react';
import { Button, Grid, PasswordInput, TextInput, Text } from '@mantine/core';
import { AuthLayout } from '../layouts/auth/AuthLayout';
import { Link } from '../components/ui/link';
import { login_path, sign_up_path } from '../routes';
import { useSpinDelay } from 'spin-delay';

export default function Register() {
  const { data, setData, post, processing, errors } = useForm({
    email: '',
    password: '',
    password_confirmation: '',
  });

  const loading = useSpinDelay(processing, { delay: 100, minDuration: 200 });

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    post(sign_up_path());
  };

  return (
    <>
      <Head title="Register" />
      <AuthLayout
        title="Join Graditude"
        description={
          <>
            Already have an account? <Link href={login_path()}>Sign in</Link>
          </>
        }
        handleSubmit={handleSubmit}
      >
        <Grid.Col span={12}>
          <TextInput
            required
            label="Email"
            name="email"
            placeholder="you@example.com"
            value={data.email}
            onChange={(e) => setData('email', e.target.value)}
            disabled={loading}
            error={errors.email}
          />
        </Grid.Col>
        <Grid.Col span={12}>
          <PasswordInput
            required
            label="Password"
            name="password"
            type="password"
            placeholder="Create a password"
            value={data.password}
            disabled={loading}
            onChange={(e) => setData('password', e.target.value)}
            error={errors.password}
          />
        </Grid.Col>
        <Grid.Col span={12}>
          <PasswordInput
            required
            label="Confirm Password"
            name="password_confirmation"
            type="password"
            placeholder="Confirm your password"
            value={data.password_confirmation}
            disabled={loading}
            onChange={(e) => setData('password_confirmation', e.target.value)}
            error={errors.password_confirmation}
          />
        </Grid.Col>
        <Grid.Col span={12}>
          <Button type="submit" disabled={loading} loading={loading} fullWidth>
            Create Account
          </Button>
        </Grid.Col>
      </AuthLayout>
    </>
  );
}

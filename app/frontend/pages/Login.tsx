import { Head, useForm, usePage } from '@inertiajs/react';
import { Button, Checkbox, Grid, Group, PasswordInput, TextInput } from '@mantine/core';
import { AuthLayout } from '../layouts/auth/AuthLayout';
import { Link } from '../components/ui/link';
import { login_path, register_path } from '../routes';
import { useSpinDelay } from 'spin-delay';

export default function Login() {
  const { email, password, remember_me } = usePage<{
    email: string;
    password: string;
    remember_me: boolean;
  }>().props;

  const { data, setData, post, processing, errors } = useForm({
    email,
    password,
    remember_me,
  });

  const loading = useSpinDelay(processing, { delay: 100, minDuration: 200 });

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    post(login_path());
  };

  return (
    <>
      <Head title="Login" />
      <AuthLayout
        title="Welcome back!"
        description={
          <>
            Do not have an account? <Link href={register_path()}>Sign up</Link>
          </>
        }
        handleSubmit={handleSubmit}
      >
        <Grid.Col span={12}>
          <TextInput
            required
            label="Email"
            name="email"
            placeholder="graditude@graditudebeta.org"
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
            placeholder="Your password"
            value={data.password}
            disabled={loading}
            onChange={(e) => setData('password', e.target.value)}
            error={errors.password}
          />
        </Grid.Col>
        <Grid.Col span={12}>
          <Group w="100%" justify="space-between">
            <Checkbox
              label="Remember me"
              name="remember_me"
              onChange={(e) => setData('remember_me', e.currentTarget.checked)}
            />
            <Button type="submit" disabled={loading} loading={loading}>
              Login
            </Button>
          </Group>
        </Grid.Col>
      </AuthLayout>
    </>
  );
}

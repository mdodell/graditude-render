import { Head, useForm, usePage } from '@inertiajs/react';
import { Button, Grid, PasswordInput, TextInput } from '@mantine/core';
import { AuthLayout } from '../layouts/auth/AuthLayout';
import { Link } from '../components/ui/link';
import { login_path, sign_up_path } from '../routes';

export default function Login() {
  const { email, password } = usePage<{ email: string; password: string }>().props;

  const { data, setData, post, processing, errors } = useForm({
    email,
    password,
  });

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
            Do not have an account? <Link href={sign_up_path()}>Sign up</Link>
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
            disabled={processing}
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
            disabled={processing}
            onChange={(e) => setData('password', e.target.value)}
            error={errors.password}
          />
        </Grid.Col>
        <Grid.Col span={12}>
          <Button type="submit" disabled={processing} fullWidth>
            Login
          </Button>
        </Grid.Col>
      </AuthLayout>
    </>
  );
}

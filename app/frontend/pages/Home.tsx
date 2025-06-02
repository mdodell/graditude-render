import { router, usePage } from '@inertiajs/react';
import { Button } from '@mantine/core';
import { logout_path } from '../routes';

export default function Home() {
  const { auth } = usePage<{ auth: { session: { id: string } } }>().props;
  return <Button onClick={() => router.delete(logout_path({ id: auth.session.id }))}>Home</Button>;
}

// AppHead.jsx
import { Head } from '@inertiajs/react';

interface AppHeadProps {
  title: string;
  description?: string;
  children?: React.ReactNode;
}

export default function AppHead({ title, description = 'Graditude', children }: AppHeadProps) {
  return (
    <>
      <Head>
        <title>{title}</title>
        <meta head-key="description" name="description" content={description} />
      </Head>
      {children}
    </>
  );
}

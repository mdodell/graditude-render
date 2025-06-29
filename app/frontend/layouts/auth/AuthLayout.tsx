import { Flex, Paper, Title, Text, Grid } from '@mantine/core';
import { PropsWithChildren, ReactEventHandler, ReactNode } from 'react';

interface AuthLayoutProps {
  handleSubmit: ReactEventHandler;
  title: string;
  description: ReactNode;
}

export function AuthLayout({
  children,
  title,
  description,
  handleSubmit,
}: PropsWithChildren<AuthLayoutProps>) {
  return (
    <Flex h="100dvh" justify="center" align="center" direction="column" mx="md">
      <Title ta="center">{title}</Title>
      <Text c="dimmed">{description}</Text>
      <Paper withBorder shadow="xs" p="xl" radius="md" mt="xl">
        <form noValidate onSubmit={handleSubmit}>
          <Grid>{children}</Grid>
        </form>
      </Paper>
    </Flex>
  );
}

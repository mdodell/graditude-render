import { Box, Flex, Paper, Title, Text, Grid } from '@mantine/core';
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
    <Flex h="100vh" justify="center" align="center" direction="column">
      <Title ta="center">{title}</Title>
      <Text c="dimmed">{description}</Text>
      <Paper withBorder shadow="xs" p="xl" radius="md" mt="xl" miw={400}>
        <form noValidate onSubmit={handleSubmit}>
          <Grid>{children}</Grid>
        </form>
      </Paper>
    </Flex>
  );
}

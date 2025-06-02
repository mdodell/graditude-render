import { Link as InertiaLink, InertiaLinkProps } from '@inertiajs/react';
import { Anchor } from '@mantine/core';

export function Link({ children, size, ...props }: InertiaLinkProps) {
  return (
    <Anchor component={InertiaLink} {...props}>
      {children}
    </Anchor>
  );
}

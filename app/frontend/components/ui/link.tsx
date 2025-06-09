import { Link as InertiaLink, InertiaLinkProps } from '@inertiajs/react';
import { Anchor, AnchorProps } from '@mantine/core';

export function Link({ children, ...props }: AnchorProps & InertiaLinkProps) {
  return (
    <Anchor component={InertiaLink} {...props}>
      {children}
    </Anchor>
  );
}

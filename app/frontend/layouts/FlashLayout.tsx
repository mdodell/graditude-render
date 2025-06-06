import { PropsWithChildren } from 'react';
import { useFlash } from '../hooks/useFlash';

export function FlashLayout({ children }: PropsWithChildren) {
  useFlash();
  return <>{children}</>;
}

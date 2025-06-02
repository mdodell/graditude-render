import { router, usePage } from '@inertiajs/react';
import { notifications } from '@mantine/notifications';
import { useEffect, useState } from 'react';

type Flash = {
  alert?: string;
  notice?: string;
};

const emptyFlash: Flash = {};

export const useFlash = () => {
  const { flash } = usePage<{ flash: Flash }>().props;
  const [currentFlash, setCurrentFlash] = useState<Flash>(emptyFlash);

  useEffect(() => {
    setCurrentFlash(flash);
  }, [flash]);

  router.on('start', () => {
    setCurrentFlash(emptyFlash);
  });

  useEffect(() => {
    if (currentFlash) {
      if (currentFlash.alert) {
        notifications.show({
          title: 'Default notification',
          message: currentFlash.alert,
        });
      }
      if (currentFlash.notice) {
        notifications.show({
          title: 'Default notification',
          message: currentFlash.notice,
        });
      }
    }
  }, [currentFlash]);
};

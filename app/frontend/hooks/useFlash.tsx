import { router, usePage } from '@inertiajs/react';
import { notifications } from '@mantine/notifications';
import { IconAlertCircle, IconCheck } from '@tabler/icons-react';
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
        const alertIcon = <IconAlertCircle size={20} />;
        notifications.show({
          icon: alertIcon,
          message: currentFlash.alert,
          color: 'red',
          withBorder: true,
        });
      }
      if (currentFlash.notice) {
        const checkIcon = <IconCheck size={20} />;
        notifications.show({
          icon: checkIcon,
          message: currentFlash.notice,
          color: 'green',
          withBorder: true,
        });
      }
    }
  }, [currentFlash]);
};

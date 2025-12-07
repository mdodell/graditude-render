import { Loader, LoadingOverlay } from '@mantine/core';
import { AppPage } from '../../types/inertia';
import { useEffect } from 'react';
import { router } from '@inertiajs/react';
import { update_invitation_path } from '../../routes';

const Show: AppPage<{ invitation: any }> = (props) => {
  const { invitation } = props;

  useEffect(() => {
    router.patch(update_invitation_path(invitation.token));
  }, []);

  return <Loader />;
};

export default Show;

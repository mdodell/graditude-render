import { Button, Stack, TextInput } from '@mantine/core';
import { useState } from 'react';
import { router } from '@inertiajs/react';
import { notifications } from '@mantine/notifications';
import { invitation_acceptance_path } from '../../../routes';

export function OrganizationInviteCodeInput() {
  const [inviteCode, setInviteCode] = useState('');
  const [loading, setLoading] = useState(false);

  const handleJoinWithCode = async () => {
    if (!inviteCode.trim()) {
      notifications.show({
        title: 'Error',
        message: 'Please enter an invitation code',
        color: 'red',
      });
      return;
    }

    setLoading(true);

    try {
      router.put(
        invitation_acceptance_path(inviteCode.trim()),
        {},
        {
          onSuccess: () => {
            setInviteCode('');
          },
          onFinish: () => {
            setLoading(false);
          },
        },
      );
    } catch {
      notifications.show({
        title: 'Error',
        message: 'An unexpected error occurred',
        color: 'red',
      });
      setLoading(false);
    }
  };

  return (
    <Stack>
      <TextInput
        placeholder="Enter an invitation code"
        description="Code format: XXXX-XXXX-XXXX"
        label="Invitation Code"
        value={inviteCode}
        onChange={(e) => setInviteCode(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === 'Enter') {
            handleJoinWithCode();
          }
        }}
      />

      <Button
        variant="gradient"
        gradient={{ from: 'blue', to: 'cyan', deg: 90 }}
        onClick={handleJoinWithCode}
        loading={loading}
        disabled={!inviteCode.trim()}
      >
        Join with code
      </Button>
    </Stack>
  );
}

import { AppPage } from '../../types/inertia';
import { OrganizationsLayout } from '../../layouts/organizations/OrganizationsLayout';
import { Form } from '@inertiajs/react';
import { Button, TextInput } from '@mantine/core';
import { organization_invitations_path } from '../../routes';
import { Organization } from '../../types/serializers';

const Show: AppPage<{ organization: Organization }> = (props) => {
  const { organization } = props;
  return (
    <OrganizationsLayout>
      <Form action={organization_invitations_path(organization.id)} method="post">
        {({ errors, processing }) => (
          <>
            <TextInput label="Email" name="invitation.email" error={errors.email} />
            <Button type="submit" loading={processing}>
              Invite
            </Button>
          </>
        )}
      </Form>
    </OrganizationsLayout>
  );
};

export default Show;

import { AppPage } from '../../types/inertia';
import { OrganizationsLayout } from '../../layouts/organizations/OrganizationsLayout';

const OrganizationsIndex: AppPage = (props) => {
  console.log({ props });
  return <OrganizationsLayout>Test</OrganizationsLayout>;
};

export default OrganizationsIndex;

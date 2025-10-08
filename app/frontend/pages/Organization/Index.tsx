import { AppPage } from '../../types/inertia';
import { OrganizationsLayout } from '../../layouts/organizations/OrganizationsLayout';

const OrganizationsIndex: AppPage = () => {
  console.log('    OrganizationsIndex');
  return <OrganizationsLayout>Test</OrganizationsLayout>;
};

export default OrganizationsIndex;

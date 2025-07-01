import { DashboardLayout } from '../layouts/app/DashboardLayout';
import { AppPage } from '../types/inertia';
import AppHead from '../components/meta/AppHead';

const Home: AppPage = () => {
  return (
    <DashboardLayout>
      <AppHead title="Home" />
      TODO: Add home page content
    </DashboardLayout>
  );
};

export default Home;

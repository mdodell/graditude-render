import { AppPage } from '../../types/inertia';
import { useForm, router } from '@inertiajs/react';
import { useState, useEffect } from 'react';
import { useDebouncedValue, useIntersection } from '@mantine/hooks';
import { new_organization_path } from '../../routes';
import {
  TextInput,
  Textarea,
  Button,
  Stack,
  Group,
  Text,
  Combobox,
  useCombobox,
  Pill,
  PillsInput,
  ScrollArea,
  Card,
} from '@mantine/core';
import { notifications } from '@mantine/notifications';
import { Organization } from '../../types/serializers';
import { OrganizationsCreationLayout } from '../../layouts/organizations/OrganizationsCreationLayout';

type OrganizationFormData = Pick<Organization, 'name' | 'domain' | 'description'> & {
  college_ids?: number[];
};

interface OrganizationsNewProps {
  organization: Organization;
  step: string;
  colleges?: Array<{ id: number; name: string }>;
  pagy?: {
    page: number;
    pages: number;
    next: number | null;
    prev: number | null;
    count: number;
  };
  errors?: Record<string, string>;
}

const OrganizationsNew: AppPage<OrganizationsNewProps> = ({
  organization,
  step,
  colleges = [],
  pagy,
  errors = {},
}) => {
  const { data, setData, processing } = useForm<OrganizationFormData>({
    name: organization?.name || '',
    domain: organization?.domain || '',
    description: organization?.description || '',
    college_ids: organization?.colleges?.map((c: { id: number }) => c.id) || [],
  });

  const [searchQuery, setSearchQuery] = useState('');
  const [debouncedSearchQuery] = useDebouncedValue(searchQuery, 300);
  const [allColleges, setAllColleges] = useState<Array<{ id: number; name: string }>>(
    colleges || [],
  );
  const combobox = useCombobox({
    onDropdownClose: () => combobox.resetSelectedOption(),
  });

  const { ref, entry } = useIntersection({
    root: null,
    threshold: 0.1,
  });

  // Search effect using debounced value
  useEffect(() => {
    router.get(
      `${new_organization_path()}/college?search=${debouncedSearchQuery}`,
      {},
      {
        preserveState: true,
        preserveScroll: true,
        only: ['colleges', 'pagy'],
        onSuccess: (page) => {
          const newColleges = (page.props.colleges as OrganizationsNewProps['colleges']) || [];

          // Always preserve selected colleges
          const selectedColleges = allColleges.filter((college) =>
            data.college_ids?.includes(college.id),
          );

          // Combine selected colleges with new search results, avoiding duplicates
          const combinedColleges = [...selectedColleges];
          newColleges.forEach((newCollege: { id: number; name: string }) => {
            if (!combinedColleges.some((existing) => existing.id === newCollege.id)) {
              combinedColleges.push(newCollege);
            }
          });

          setAllColleges(combinedColleges);
        },
      },
    );
  }, [debouncedSearchQuery, router]);

  // Intersection effect for infinite scroll
  useEffect(() => {
    if (entry?.isIntersecting && pagy?.next) {
      loadMoreColleges();
    }
  }, [entry?.isIntersecting, pagy?.next]);

  const loadMoreColleges = () => {
    if (pagy?.next) {
      router.get(
        `${new_organization_path()}/college?page=${pagy.next}&search=${searchQuery}`,
        {},
        {
          preserveState: true,
          preserveScroll: true,
          only: ['colleges', 'pagy'],
          onSuccess: (page) => {
            // Append new colleges to existing ones
            const newColleges = (page.props.colleges as Array<{ id: number; name: string }>) || [];
            setAllColleges((prev) => [...prev, ...newColleges]);
          },
        },
      );
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    router.patch(
      `${new_organization_path()}/${step}`,
      {
        organization: data,
      },
      {
        onError: () => {
          notifications.show({
            title: 'Error',
            message: 'Please check the form for errors.',
            color: 'red',
          });
        },
      },
    );
  };

  const renderStepContent = () => {
    switch (step) {
      case 'details':
        return (
          <Stack gap="md">
            <TextInput
              label="Organization Name"
              placeholder="Enter organization name"
              required
              value={data.name}
              onChange={(e) => setData('name', e.target.value)}
              error={errors.name}
            />
            <TextInput
              label="Domain"
              placeholder="example.com"
              required
              value={data.domain}
              onChange={(e) => setData('domain', e.target.value)}
              error={errors.domain}
            />
          </Stack>
        );

      case 'college':
        return (
          <Stack gap="md">
            <Text size="sm" c="dimmed">
              Select the colleges associated with this organization
            </Text>

            <Combobox
              store={combobox}
              onOptionSubmit={(value) => {
                const collegeId = parseInt(value);
                const isSelected = data.college_ids?.includes(collegeId);

                if (isSelected) {
                  setData(
                    'college_ids',
                    (data.college_ids || []).filter((id) => id !== collegeId),
                  );
                } else {
                  setData('college_ids', [...(data.college_ids || []), collegeId]);
                  // Reset search after selection to show all colleges again
                  setSearchQuery('');
                }
                // Don't close dropdown to allow multiple selections
                // combobox.closeDropdown();
              }}
            >
              <Combobox.Target>
                <PillsInput
                  label="Colleges"
                  onClick={() => combobox.openDropdown()}
                  onFocus={() => combobox.openDropdown()}
                  onBlur={() => combobox.closeDropdown()}
                >
                  <Pill.Group>
                    {data.college_ids?.map((id) => {
                      const college = allColleges.find((c) => c.id === id);
                      return college ? (
                        <Pill
                          key={id}
                          withRemoveButton
                          onRemove={() => {
                            setData(
                              'college_ids',
                              (data.college_ids || []).filter((collegeId) => collegeId !== id),
                            );
                          }}
                        >
                          {college.name}
                        </Pill>
                      ) : null;
                    })}
                  </Pill.Group>
                </PillsInput>
              </Combobox.Target>

              <Combobox.Dropdown>
                <Combobox.Search
                  placeholder="Search colleges..."
                  value={searchQuery}
                  onChange={(event) => {
                    setSearchQuery(event.currentTarget.value);
                  }}
                />
                <Combobox.Options>
                  <ScrollArea.Autosize mah={200} type="scroll">
                    {allColleges.filter((college) => !data.college_ids?.includes(college.id))
                      .length > 0 ? (
                      allColleges
                        .filter((college) => !data.college_ids?.includes(college.id))
                        .map((college) => (
                          <Combobox.Option key={college.id} value={college.id.toString()}>
                            {college.name}
                          </Combobox.Option>
                        ))
                    ) : (
                      <Text size="sm" c="dimmed" ta="center" p="md">
                        No colleges found
                      </Text>
                    )}
                    {pagy?.next && (
                      <div ref={ref}>
                        <Text size="sm" c="dimmed" ta="center" p="xs">
                          Loading more colleges...
                        </Text>
                      </div>
                    )}
                  </ScrollArea.Autosize>
                </Combobox.Options>
              </Combobox.Dropdown>
            </Combobox>

            {errors.colleges && (
              <Text c="red" size="sm">
                {errors.colleges}
              </Text>
            )}
          </Stack>
        );

      case 'description':
        return (
          <Stack gap="md">
            <Textarea
              label="Description"
              placeholder="Describe your organization..."
              value={data.description}
              onChange={(e) => setData('description', e.target.value)}
              error={errors.description}
              minRows={4}
            />
          </Stack>
        );

      case 'review':
        return (
          <Stack gap="md">
            <Card withBorder padding="md">
              <Stack gap="sm">
                <Text fw={500}>Organization Details</Text>
                <Text size="sm">
                  <strong>Name:</strong> {data.name}
                </Text>
                <Text size="sm">
                  <strong>Domain:</strong> {data.domain}
                </Text>
                <Text size="sm">
                  <strong>Colleges:</strong>{' '}
                  {allColleges
                    .filter((c) => data.college_ids?.includes(c.id))
                    .map((c) => c.name)
                    .join(', ')}
                </Text>
                <Text size="sm">
                  <strong>Description:</strong> {data.description || 'No description provided'}
                </Text>
              </Stack>
            </Card>
          </Stack>
        );

      default:
        return null;
    }
  };

  return (
    <OrganizationsCreationLayout step={step}>
      <form onSubmit={handleSubmit} noValidate>
        {renderStepContent()}
        <Group justify="space-between" mt="md">
          {step !== 'details' && (
            <Button
              variant="light"
              onClick={() => router.visit(`${new_organization_path()}/${getPreviousStep(step)}`)}
            >
              Previous
            </Button>
          )}
          <Button type="submit" loading={processing}>
            {step === 'review' ? 'Create Organization' : 'Next'}
          </Button>
        </Group>
      </form>
    </OrganizationsCreationLayout>
  );
};

const getPreviousStep = (currentStep: string): string => {
  const steps = ['details', 'college', 'description', 'review'];
  const currentIndex = steps.indexOf(currentStep);
  return currentIndex > 0 ? steps[currentIndex - 1] : steps[0];
};

export default OrganizationsNew;

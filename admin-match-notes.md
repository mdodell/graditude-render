## Admin Matching

### Mentor

< belongs to program
< belongs to user - name, email

- job role
- capacity of # of mentees
- company
- industry
- bio
- school?

### Mentee

< belongs to program
< belongs to user - name, email

- goals: ["resume review", "mock interviewing"] - fixed list
- major/minors
- bio
- school?

Matching Statuses:

- matched - both have agreed to be matched
- pending - one of mentor/mentee to agree to the match
- saved - hasn't been sent off yet
- unmatched - one of these mentorships has been rejected

Program:

- name
- start_date
- end_date

:belongs_to organization
:has_many mentees
:has_many mentors
:has_many admins -> must be a MEMNBER of the organization

Match:
:has_one mentor
:has_one mentee

- mentee_status: pending, rejected, matched
- mentor_status: pending, rejected, matched

# CSV Seeding for Colleges

This directory contains CSV files used for seeding college data into the database.

## File Structure

- `colleges.csv` - Main colleges data file
- `README.md` - This documentation file

## CSV Format

Your `colleges.csv` file should have the following columns (case-insensitive):

| Column | Required | Description             | Example                   |
| ------ | -------- | ----------------------- | ------------------------- |
| `name` | Yes      | College/University name | "Harvard University"      |
| `url`  | No       | College website URL     | "https://www.harvard.edu" |

### Alternative Column Names

The importer also recognizes these alternative column names:

- `college_name` or `institution_name` for `name`
- `website` or `web_site` for `url`

## Usage

### 1. Place your CSV file

Put your colleges CSV file in this directory as `colleges.csv`

### 2. Run the seeding

```bash
# Seed only colleges
bin/rails db:seed:colleges

# Or seed everything (including colleges if CSV exists)
bin/rails db:seed
```

### 3. Custom filename

If you want to use a different filename:

```bash
bin/rails "db:seed:colleges[your_file.csv]"
```

## Features

- **Idempotent**: Running multiple times won't create duplicates
- **Error handling**: Skips invalid rows and reports errors
- **Flexible column mapping**: Supports various column name formats
- **Validation**: Ensures data integrity with model validations
- **Progress reporting**: Shows detailed import statistics

## Example CSV

```csv
name,url
Harvard University,https://www.harvard.edu
Stanford University,https://www.stanford.edu
Massachusetts Institute of Technology,https://www.mit.edu
```

## Troubleshooting

- **File not found**: Ensure your CSV is in `db/seeds/csv/` directory
- **Missing data**: Check that required columns (name) have data
- **Invalid URLs**: URL column should contain valid URLs starting with http:// or https://
- **Duplicate names**: College names must be unique

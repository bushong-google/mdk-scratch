# Version Bump Action

This reusable GitHub Action automatically bumps the version in `pyproject.toml` based on the specified release type (`major`, `minor`, or `patch`). It commits the new version and opens a pull request for review.

## Inputs

| Input                 | Required | Default      | Description                          |
|-----------------------|----------|-------------|--------------------------------------|
| `service_name`        | ✅        | -           | The name of the service        |
| `release_type`        | ❌        | `patch`     | Type of version bump (major, minor, or patch)|
| github-token          | ✅       | -            |GitHub token for authentication to create a pull request.

GitHub token for authentication to create a pull request.

## How It Works

1. Reads the current version from `pyproject.toml` inside the service directory.
2. Increments the version based on the selected release type:
    - **Major**: `1.2.3 → 2.0.0`
    - **Minor**: `1.2.3 → 1.3.0`
    - **Patch**: `1.2.3 → 1.2.4`
3. Updates `pyproject.toml` with the new version.
4. Commits and pushes the version update to a new branch (`release-version-update-<service_name>`).
5. Creates a pull request to merge the changes into the `main` branch.

## Usage Example

```yaml
jobs:
  bump-version:
    runs-on: [self-hosted, onprem-k8s-arc, lnx-amd64]
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Run Version Bump
        uses: ./.github/actions/bump_version
        with:
          service_name: "pipeline_executor"
          release-type: "patch"
          github-token: "${{ secrets.GITHUB_TOKEN }}"
```

## Example `pyproject.toml` Before and After

Before Running the Action

```
[project]
name = "pipeline_executor"
version = "0.1.0"
```

After Running the Action (Patch Update)

```
[project]
name = "pipeline_executor"
version = "0.1.1"
```

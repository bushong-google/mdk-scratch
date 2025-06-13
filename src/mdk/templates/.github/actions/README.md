# Version Bump Action

This GitHub Action automatically bumps the version in `version.txt` based on the specified release type (`major`, `minor`, or `patch`).

## Usage

To use this action in your workflow:

```yaml
jobs:
  bump-version:
    runs-on: [self-hosted, onprem-k8s-arc, lnx-amd64]
    steps:
      - name: Bump Version
        uses: actions/version-bump@v1
        with:
          release-type: "patch"

# Generate Image Version

This reusable GitHub Action generates a version tag for Docker images using:
- **Current Date (YYYY-MM-DD)**
- **Short Git Commit SHA (abcdefg)**

## Outputs

| Output         | Description                                |
|---------------|--------------------------------------------|
| `image_version` | Generated version format: `YYYY-MM-DD-shortSHA` |

## Usage Example

```yaml
jobs:
  version:
    runs-on: [self-hosted, onprem-k8s-arc, lnx-amd64]
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Generate Image Version
        id: set-version
        uses: ./.github/actions/generate-image-version

      - name: Print Version
        run: echo "Generated Version: ${{ steps.set-version.outputs.image_version }}"

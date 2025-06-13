# Docker Build Action

This reusable GitHub Action builds a Docker image and allows optional build arguments.

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `image_tag` | ✅ | - | The full image tag (e.g., `gcr.io/my-project/my-app:latest`). |
| `build_context` | ❌ | `.` | The Docker build context (default is current directory). |
| `dockerfile` | ✅ | - | The relative path to the Dockerfile. |
| `build_args` | ❌ | `""` | Optional build arguments (comma-separated, e.g., `"ARG1=value1,ARG2=value2"`). |

## Usage Example

```yaml
jobs:
  build:
    runs-on: [self-hosted, onprem-k8s-arc, lnx-amd64]
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Build Docker Image
        uses: ./.github/actions/docker_build
        with:
          image_tag: "gcr.io/my-project/my-app:latest"
          dockerfile: "docker/Dockerfile.prod"
          build_args: "ENV=production,DEBUG=false"

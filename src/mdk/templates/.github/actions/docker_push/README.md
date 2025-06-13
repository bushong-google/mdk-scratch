# Docker Push Action

This reusable GitHub Action pushes a Docker image to a specified repository.

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `image_tag` | ✅ | - | The full image tag for the Docker push (e.g., `gcr.io/my-project/my-app:latest`). |
| `remote_repository` | ✅ | - | The remote repository where the image will be pushed. |
| `registry_auth` | ❌ | `""` | Optional authentication command (e.g., `'gcloud auth configure-docker'`). |

## Usage Example

```yaml
jobs:
  push:
    runs-on: [self-hosted, onprem-k8s-arc, lnx-amd64]
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Authenticate with GCP
        uses: google-github-actions/auth@v1
        with:
          credentials_json: ${{ secrets.GCP_SA_KEY }}

      - name: Push Docker Image
        uses: ./.github/actions/docker_push
        with:
          image_tag: "gcr.io/my-project/my-app:latest"
          remote_repository: "gcr.io/my-project/my-app:latest"
          registry_auth: "gcloud auth configure-docker"

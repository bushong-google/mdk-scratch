# Cloud Run Deploy Action

This reusable GitHub Action deploys a container image to Google Cloud Run.

## Inputs

| Input                 | Required | Default      | Description                          |
|-----------------------|----------|-------------|--------------------------------------|
| `gcp_project_id`      | ✅        | -           | GCP Project ID                      |
| `service_name`        | ✅        | -           | Cloud Run Service Name              |
| `region`             | ✅        | `us-central1` | GCP Region for deployment        |
| `image_url`          | ✅        | -           | Full URL of the container image     |
| `allow_unauthenticated` | ❌        | `true`      | Allow unauthenticated access       |

## Secrets

| Secret       | Required | Description                           |
|-------------|----------|--------------------------------------|
| `GCP_SA_KEY` | ✅        | GCP Service Account Key JSON |

## Usage Example

```yaml
jobs:
  deploy:
    runs-on: [self-hosted, onprem-k8s-arc, lnx-amd64]
    steps:
      - name: Deploy to Cloud Run
        uses: ./.github/actions/cloud_run_deploy
        with:
          gcp_project_id: "my-gcp-project"
          service_name: "my-app"
          region: "us-central1"
          image_url: "gcr.io/my-gcp-project/my-app:latest"
        env:
          GCP_SA_KEY: ${{ secrets.GCP_SA_KEY }}

# helm-app

Helm chart for Kubernetes application with continuous delivery integration.

This chart packages Kubernetes resources and integrates with the Application
Delivery API for automated deployments. The GitHub Actions workflow packages the
chart and uploads it to the Converix platform via presigned URLs.

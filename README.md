# kubernetes-accent

Runs your [Accent](https://www.accent.reviews/) instance in Kubernetes

## Usage

```bash
# Modify Dockerfile.
GOOGLE_API_CLIENT_ID="<your token>"
CANONICAL_HOST="hostname, but without https:// in front
API_HOST="https://your-api-host.example.com"
API_WS_HOST="wss://your-api-host.example.com"

# Start postgres
helm install --set postgresqlPassword=secretpassword,postgresqlDatabase=my-database stable/postgresql

# Run migrations
kubectl exec -it accent-kubernetes bash

# Accent Variables
MIX_ENV=prod 
PORT=4000 
DATABASE_URL="postgres://postgres:password@postgres/accent"
RESTRICTED_DOMAIN="Put your domain here to prevent people without an email on that domain from creating projects" \

# Setup email..

# Create a service and an ingress
```

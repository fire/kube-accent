# kubernetes-accent

Runs your [Accent](https://www.accent.reviews/) instance in Kubernetes

## Usage

```bash
# Start postgres
helm install --set postgresqlPassword=secretpassword,postgresqlDatabase=my-database stable/postgresql

# Run migrations
kubectl exec -it accent-kubernetes bash

MIX_ENV=prod PORT=4000 WEBAPP_PORT=4200 DATABASE_URL="postgres://postgres:password@postgres/accent" \
mix ecto.setup

# Accent Variables
MIX_ENV=prod 
PORT=4000 
WEBAPP_PORT=4200    
DATABASE_URL="postgres://postgres:password@postgres/accent"
GOOGLE_API_CLIENT_ID="<your token>"
CANONICAL_HOST="hostname, but without https:// in front
API_HOST="https://your-api-host.example.com"
API_WS_HOST="wss://your-api-host.example.com"
RESTRICTED_DOMAIN="Put your domain here to prevent people without an email on that domain from creating projects" \

# Create a service and an ingress
```

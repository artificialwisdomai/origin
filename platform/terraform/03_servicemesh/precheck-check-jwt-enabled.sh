###
#
# Check for third-party jwt token support
#
# https://istio.io/latest/docs/ops/best-practices/security/#configure-third-party-service-account-tokens

kubectl get --raw /api/v1 | jq '.resources[] | select(.name | index("serviceaccounts/token"))'

# Using compartments

Compartments are the fundamental IAM feature used by Oracle Cloud to isolate cloud resources. Compartments
can have children in a tree structure, or be simpler with a depth of one. We use the `engineering` compartment
to house all engineering work.

Anything in production is housed in `production`.

During development, compartments are an awesome way to start over. Simply delete the compartment you were working
in, and all resources within the compartment are deleted.

# Create a compartmnet

This will create a compartment for you within the `engineering`.

```console
parent_compartment=$(oci iam compartment list --query 'data[?name==`"engineering"`].{compartment_id: "id"}' --output json | jq -r '.[0].compartment_id')
oci iam compartment create --name $(whoami)-$(date +%Y%m%d) --description "development compartment" --compartment-id ${parent_compartment}
```

# Delete a compartment

Replace the OCID with the compartment id you wish to delete. Never delete `engineering`.

```console
oci iam compartment delete --compartment-id ocid1.compartment.oc1..aaaaaaaayh4wcewcyj4ns3no4eu6eyfwj3ncaexs73mz2c35cfdwv4xfeejq
```

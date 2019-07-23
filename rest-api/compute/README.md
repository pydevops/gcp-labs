
## Listing
If you have `jq` installed, then run the `list*.sh` scripts like below
```
./list_zones.sh | jq -C . | less -R
```
would color the json output beautifully with pagination. 

## GCE instance creation and deletion
We will try to create an instance that allows HTTP inbound traffic on port 80. 

* `create_instance_rest.txt` is a json dump of the REST API of [insert instance](https://cloud.google.com/compute/docs/reference/rest/v1/instances/insert) and [firewall rule insert](https://cloud.google.com/compute/docs/reference/rest/v1/firewalls/insert)
* Based on the json dump above, templates below are created:
    * `insert_template.json` is the template used for creating an instance.
    * `firewall_rule_template.json` is the template used for creating the firewall rule allowing HTTP.
* `create_instance.sh` to create an instance called `demo` by default
* `delete_instance.sh` to delete the instance.
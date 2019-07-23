## Listing
If you have `jq` installed, then run the `list*.sh` scripts like below
```
./list_clusters.sh us-west1-c | jq -C . | less -R
```
would color the json output beautifully with pagination. 

## GKE cluster creation and deletion

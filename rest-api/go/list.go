// Copyright 2017 Google Inc. All rights reserved.
// Use of this source code is governed by the Apache 2.0
// license that can be found in the LICENSE file.

// Command listclusters lists all clusters and their node pools for a given project and zone.
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"

	"golang.org/x/net/context"
	"golang.org/x/oauth2/google"

	compute "google.golang.org/api/compute/v1"
	container "google.golang.org/api/container/v1"
)

var (
	projectID = flag.String("project", "", "Project ID")
	zone      = flag.String("zone", "", "Compute zone")
)

func main() {
	flag.Parse()

	if *projectID == "" {
		fmt.Fprintln(os.Stderr, "missing -project flag")
		flag.Usage()
		os.Exit(2)
	}
	if *zone == "" {
		fmt.Fprintln(os.Stderr, "missing -zone flag")
		flag.Usage()
		os.Exit(2)
	}

	ctx := context.Background()

	// See https://cloud.google.com/docs/authentication/.
	// Use GOOGLE_APPLICATION_CREDENTIALS environment variable to specify
	// a service account key file to authenticate to the API.
	hc, err := google.DefaultClient(ctx, container.CloudPlatformScope)
	if err != nil {
		log.Fatalf("Could not get authenticated client: %v", err)
	}

	containerSvc, err := container.New(hc)
	if err != nil {
		log.Fatalf("Could not initialize gke client: %v", err)
	}

	if err := listClusters(containerSvc, *projectID, *zone); err != nil {
		log.Fatal(err)
	}

	computeSvc, err := compute.New(hc)
	if err != nil {
		log.Fatalf("Unable to create Compute service: %v", err)
	}

	instanceList, err := computeSvc.Instances.List(*projectID, *zone).Do()
	if err != nil {
		log.Fatalf("Unable to list compute instances: %v", err)
	}
	for _, instance := range instanceList.Items {
		//PrettyPrint(instance)
		fmt.Printf("%q %s tags:", instance.Name, instance.Status)
		for _, tag := range instance.Tags.Items {
			fmt.Printf("%s,", tag)
		}
		fmt.Println()
	}

}

func listClusters(svc *container.Service, projectID, zone string) error {
	list, err := svc.Projects.Zones.Clusters.List(projectID, zone).Do()
	if err != nil {
		return fmt.Errorf("failed to list clusters: %v", err)
	}
	for _, v := range list.Clusters {
		fmt.Printf("Cluster %q (%s) master_version: v%s\n", v.Name, v.Status, v.CurrentMasterVersion)

		poolList, err := svc.Projects.Zones.Clusters.NodePools.List(projectID, zone, v.Name).Do()
		if err != nil {
			return fmt.Errorf("failed to list node pools for cluster %q: %v", v.Name, err)
		}
		for _, np := range poolList.NodePools {
			fmt.Printf("  -> Pool %q (%s) machineType=%s node_version=v%s autoscaling=%v\n", np.Name, np.Status,
				np.Config.MachineType, np.Version, np.Autoscaling != nil && np.Autoscaling.Enabled)

		}
	}
	return nil
}
func PrettyPrint(v interface{}) {
	b, _ := json.MarshalIndent(v, "", "  ")
	fmt.Println(string(b))
}

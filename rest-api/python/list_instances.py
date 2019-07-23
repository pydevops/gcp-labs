#!/usr/bin/env python

import argparse
import googleapiclient.discovery
from pprint import pprint

compute = googleapiclient.discovery.build('compute', 'v1')

def list_instances(project, zone):

    result = compute.instances().list(project=project, zone=zone).execute()
    return result['items']

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('project_id', help='Your Google Cloud project ID.')
    parser.add_argument(
        '--zone',
        default='us-central1-f',
        help='Compute Engine zone to deploy to.')
    parser.add_argument(
        '--name', default='demo-instance', help='New instance name.')

    args = parser.parse_args()

    pprint(list_instances(args.project_id, args.zone))
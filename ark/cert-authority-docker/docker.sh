#!/bin/bash

docker build -t ca_service .

# Start a container, mounting your CSRs as a shared volume
docker run --name ca_service --rm -v "${PWD}"/csr:/tmp/ca-service/csr -it ca_service bash

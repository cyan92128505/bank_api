#!/bin/bash

DESCRIPTION=${1}

migrate create -ext sql -dir deployment/migration/postgresql/ -format "20060102150405" $DESCRIPTION

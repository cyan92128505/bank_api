#!/usr/bin/env bash

set -e
cd $( cd $(dirname $0) ; pwd -P )

function usage () {
	cat <<EOS
To execute pre-defined commands with Docker.
Usage:
	$(basename $0) <Command> [args...]
Command:
EOS
	egrep -o "^\s*function.*#cmd.*" $(basename $0) | sed "s/^[ \t]*function//" | sed "s/[ \(\)\{\}]*#cmd//" \
	    | awk '{CMD=$1; $1=""; printf "\t%-16s%s\n", CMD, $0}'
}

function help() { #cmd help

}

function generate() { #cmd generate $@
    printf "enter the generate table name:"
	  read TABLE
    migrate create -ext sql -dir '../deployment/migration/postgresql/' $TABLE
}

function up () { #cmd up
  migrate -path '/migrations/' -database "postgres://postgres:postgres@db:5432/postgres?sslmode=disable&x-multi-statement=true" up
}

function down () { #cmd up
  migrate -path '/migrations/' -database "postgres://postgres:postgres@db:5432/postgres?sslmode=disable&x-multi-statement=true" down
}

if [ $# -eq 0 ] ; then
	usage
else
	export COMPOSE_HTTP_TIMEOUT=600
	CMD=$1
	shift
	$CMD $@
fi
#!/bin/bash

cd $(dirname $0)

is_migrate=$1

# Converting alphaneumeric to number.
PREVIOUS_APP_VERSION=`echo $PREVIOUS_APP_VERSION | cut -d "v" -f2`

function migration() {
    ls -la /opt/openreplay/openreplay
    db=$1

    # Checking if previous app version is set.
    if [[ $PREVIOUS_APP_VERSION == "" ]]; then
        echo "Previous app version to be migrated is not set. Rerun using --set fromVersion=v1.3.5"
        exit 100
    fi

    if [[ $FORCE_MIGRATION == "true" ]]; then
        echo "Forcing db migration from $PREVIOUS_APP_VERSION to $CHART_APP_VERSION"
    elif [[ $PREVIOUS_APP_VERSION == $CHART_APP_VERSION ]]; then
        echo "No application version change. Not upgrading."
        exit 0
    fi

    # Checking migration versions
    cd /opt/openreplay/openreplay/scripts/helm
    migration_versions=(`ls -l db/init_dbs/$db | grep -E ^d | awk -v number=${PREVIOUS_APP_VERSION} '$NF > number {print $NF}' | grep -v create`)
    echo "Migration version: ${migration_versions[*]}"
    # Can't pass the space seperated array to ansible for migration. So joining them with ,
    joined_migration_versions=$(IFS=, ; echo "${migration_versions[*]}")
    
    cd -

    case "$1" in
        postgresql)
            /bin/bash postgresql.sh migrate $joined_migration_versions
            ;;
        minio)
            /bin/bash minio.sh migrate $joined_migration_versions
            ;;
        clickhouse)
            /bin/bash clickhouse.sh migrate $joined_migration_versions
            ;;
        kafka)
            /bin/bash kafka.sh migrate $joined_migration_versions
            ;;
        *)
            echo "Unknown operation for db migration; exiting."
            exit 1
            ;;
        esac
}

function init(){
    case $1 in
        postgresql)
            /bin/bash postgresql.sh init
            ;;
        minio)
            /bin/bash minio.sh migrate $migration_versions
            ;;
        clickhouse)
            /bin/bash clickhouse.sh init
            ;;
        kafka)
            /bin/bash kafka.sh init
            ;;
        *)
            echo "Unknown operation for db init; exiting."
            exit 1
            ;;

    esac
}

if [[ $FORCE_MIGRATION == "true" ]]; then
    is_migrate=true
fi

# dbops.sh true(upgrade) clickhouse
case "$is_migrate" in
    "false")
        init $2
        ;;
    "true")
        migration $2
        ;;
    *)
        echo "Unknown operation for db migration; exiting."
        exit 1
        ;;
esac

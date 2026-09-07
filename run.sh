#!/bin/bash

if [ ! -d "./misc" ]; then
    echo "directory './misc' doesn't exist. Create and paste there the right files.";
    exit 1;
fi

docker compose up --build -d;

chmod +x ./copy.sh; ./copy.sh;

docker stop ds-pico-setup;
docker rm ds-pico-setup;

echo "Successfully completed!";

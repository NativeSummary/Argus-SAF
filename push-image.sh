#!/bin/bash

docker tag jnsaf nativesummary/jnsaf
docker push nativesummary/jnsaf
docker rmi nativesummary/jnsaf

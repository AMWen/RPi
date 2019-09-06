swift build --destination /Library/Developer/Destinations/arm64-5.0-RELEASE.json
docker build --tag localhost:6000/cscix65g/e16server:latest .
docker push localhost:6000/cscix65g/e16server:latest

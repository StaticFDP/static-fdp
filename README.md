# static-fdp
a FAIR Data Point backed by static content

See the [documentation](docs/fdp-layout.html).

## Triggering indexing

You can trigger an FDP index to crawl your FDP with an HTTP POST with either a JSON payload or a URL-encoded (like from an HTML form) payload.

### JSON

This requires a JSON payload with a single element: `clientUrl`.
To ask an FDP index `FDP_INDEX` to crawl some FDP starting at `START`, the unix utility `curl` can send a message à la:

`curl -X POST '{"clinentUrl": "START"}' -H 'content-type: application/json' FDP_INDEX`

For instance, pinging an FDP index running on localhost, you could use curl to trigger indexing of `https://fhir-smoker.fdpcloud.org/index`:

``` sh
curl -X POST -d '{"clientUrl": "https://fhir-smoker.fdpcloud.org/index"}' -H 'content-type: application/json' http://localhost:8080/
```

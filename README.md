# static-fdp
a FAIR Data Point backed by static content

See the [documentation](docs/fdp-layout.html).

## Triggering indexing

You can trigger an FDP index to crawl your FDP with an HTTP POST with either a JSON payload or a URL-encoded (like from an HTML form) payload.
Specifically, to ask an FDP index `FDP_INDEX` to crawl some FDP starting at `START`, the unix utility `curl` can send a message à la:

### JSON

This requires a JSON payload with a single element: `clientUrl`.

`curl -X POST -d '{"clinentUrl": "START"}' -H 'content-type: application/json' FDP_INDEX`

For instance, pinging an FDP index running on localhost, you could use curl to trigger indexing of `https://fhir-smoker.fdpcloud.org/index`:

``` sh
curl -X POST -d '{"clientUrl": "https://fhir-smoker.fdpcloud.org/index"}' -H 'content-type: application/json' http://localhost:8080/
```

### x-form-urlencoded

It's a little simpler to use the x-form-urlencoded payload, not because it rolls off the tongue but because it's a default behavior in curl so the `-H 'content-type: application/x-form-urlencoded'` isn't required.

`curl -X POST -d 'clientUrl=START' FDP_INDEX`

For instance, pinging an FDP index running on localhost, you could use curl to trigger indexing of `https://fhir-smoker.fdpcloud.org/index`:

``` sh
curl -X POST -d "clientUrl=https://fhir-smoker.fdpcloud.org/index" http://localhost:8080/
```

### Web form

A Web browser submitting a CGI Web form will also send `application/x-form-urlencoded` so you can use a simple web form like:

``` HTML
<form action="your-server-endpoint" method="POST">
    <label for="clientUrl">Client URL:</label>
    <input type="text" id="clientUrl" name="clientUrl" value="https://fhir-smoker.fdpcloud.org/index" readonly>
    <br><br>
    <button type="submit">Submit</button>
</form>
```

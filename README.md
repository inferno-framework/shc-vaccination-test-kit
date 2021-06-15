# SMART Health Cards Vaccination Test Kit

This is a collection of tests for the [SMART Health Cards: Vaccination & Testing
Implementation
Guide](http://build.fhir.org/ig/dvci/vaccine-credential-ig/branches/main/) using
the [Inferno FHIR testing
tool](https://github.com/inferno-community/inferno-core).

**NOTE:** These tests are implemented against the `0.5.0-rc` build of the IG.

It is highly recommended that you use [Docker](https://www.docker.com/) to run
these tests so that you don't have to configure ruby and the FHIR validator
service.

## Instructions

- Clone this repo.
- Run `docker-compose build` in this repo.
- Run `docker-compose pull` in this repo.
- Run `docker-compose up` in this repo.
- Navigate to `http://localhost:4567`. The IPS test suite will be available.

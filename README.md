# SMART Health Cards Vaccination Test Kit

This is a collection of tests for the [SMART Health Cards: Vaccination & Testing
Implementation
Guide](http://build.fhir.org/ig/dvci/vaccine-credential-ig/branches/main/) using
the [Inferno FHIR testing
tool](https://github.com/inferno-community/inferno-core).

**NOTE:** These tests are implemented against the `0.5.0-rc` build of the IG.

It is highly recommended that you use [Docker](https://www.docker.com/) to run
these tests so that you don't have to configure ruby and the HL7® FHIR®
validator service.

## Instructions

- Clone this repo.
- Run `docker-compose build` in this repo.
- Run `docker-compose pull` in this repo.
- Run `docker-compose run inferno bundle exec rake db:migrate` to set up the
  database.
- Run `docker-compose up` in this repo.
- Navigate to `http://localhost:4567`. The IPS test suite will be available.

## License
Copyright 2022 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

## Trademark Notice

HL7, FHIR and the FHIR [FLAME DESIGN] are the registered trademarks of Health
Level Seven International and their use does not constitute endorsement by HL7.

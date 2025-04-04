## Overview

The Cancer Pathology Data Sharing (CPDS) Data Access Test Suite verifies the ability of
clinical systems to make [US Core](http://hl7.org/fhir/us/core/STU5.0.1/)
data accessible to other systems per the
STU 1.0.1 version of the HL7® FHIR® [Cancer Pathology Data Sharing IG](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/).

## Scope

The CPDS IG requires that both [Laboratory Information System (LIS)](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-pathology-lab-information-system.html)
and [Electronic Health Record (EHR)](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-central-cancer-registry-reporting-ehr-pathology.html) 
systems support "searching and retrieval of resources using US Core APIs". This test suite
verifies that a system exposes the full list of US Core v5 APIs and profiles.

Other capabilities that the CPDS IG requires of these systems are currently out of scope
for this test suite, including
- EHR requirements around ServiceRequest creation.
- LIS requirements around DiagnosticReport creation.

## Test Methodology

Inferno will simulate a FHIR client using the search and read API required by the
[Laboratory Information System (LIS)](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-pathology-lab-information-system.html)
and [Electronic Health Record (EHR)](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-central-cancer-registry-reporting-ehr-pathology.html) CapabilityStatements.
Through a combination of tester input and details returned by the searches it makes, Inferno will
attempt to search for and read resources conforming to each profile. This includes
- Testing required search parameter combinations and verifying that the results returned are appropriate.
- For each must support element, observing an instance with that element populated.
- For each must support reference element, verifying that a populated reference can be resolved.

## Running the tests 

### Quick Start

The minimal amount of information Inferno needs to run these tests includes the following inputs:
- **FHIR Endpoint**: URL of the system's FHIR endpoint.
- **OAuth Credentials / Access Token** (optional): If needed, a token that Inferno will include in the `Authorization`
  HTTP header in the form `Bearer <input value>` on each request it makes to the system under test
- **Patient IDs**: Comma separated list of patient IDs. Inferno will use these when building searches.

### Demonstration

If you would like to try out the tests using the [Inferno Reference Server](https://inferno.healthit.gov/reference-server) 
([code](https://github.com/inferno-framework/inferno-reference-server)) as the system under test,
use the "Inferno Reference Server" preset.

## Current Limitations

### Report generation and data access differences

The CPDS STU 1.0.1 IG contains mismatches between the profiles made available through
the [EHR Data Access API](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-central-cancer-registry-reporting-ehr-pathology.html)
and those that need to be included in [cancer pathology reports](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-exchange-bundle.html),
both in terms of:
- **The number of profiles**: The [EHR Capability Statement](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-central-cancer-registry-reporting-ehr-pathology.html)
requires support for US Core STU 5 APIs which can return instances conforming to up to [45 profiles](https://www.hl7.org/fhir/us/core/STU5/profiles-and-extensions.html) while the [Pathology Cancer Exchange Bundle profile](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-exchange-bundle.html)
requires explicit support for only 6 profiles. Strictly speaking, the US Core IG does not require implementing systems to support APIs that
return all US Core profiles. However, the CPDS IG does not provide explicit guidance on which resource types and profiles to support
either in the Capability Statement or through the scope of entries to include in the report Bundle (see the **Extra Bundle entries**
limitation on the report generation suite for details).
- **Which profiles**: The [Pathology Cancer Exchange Bundle profile](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-exchange-bundle.html)
requires entry conformance to specific profiles for which there are no APIs defined in the CPDS [EHR Capability Statement](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-central-cancer-registry-reporting-ehr-pathology.html)
or the referenced [US Core Server CapabilityStatement](https://www.hl7.org/fhir/us/core/STU5/CapabilityStatement-us-core-server.html).
For example, the report requires [US Pathology Specimen profile](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-specimen.html)
but the [EHR Capability Statement](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-central-cancer-registry-reporting-ehr-pathology.html)
does not require support for a Specimen resource API directly the referenced version of US Core ([STU 5](https://www.hl7.org/fhir/us/core/STU5/profiles-and-extensions.html))
does not define a profile or API for the Specimen resource type. Additionally, for resource types for which US Core does define APIs, e.g.,
[DiagnosticReport](https://hl7.org/fhir/us/core/STU5.0.1/StructureDefinition-us-core-diagnosticreport-note.html),
CPDS doesn't explicitly indicate the need for EHRs to support the CPDS-specific profile in their APIs,
e.g., for [US Pathology DiagnosticReport](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-diagnostic-report.html).

Currently this report generation suite and the data access suite test the requirements indicated in the
IG, including API support for all US Core Profiles, despite the mismatch and their potential to cause
interoperability issues or extra implementation burden. Future versions of this test suite may update this
approach based on community feedback and IG updates.

### Limited authentication and authorization options

This test suite currently provides only one option for testers to adjust the requests that Inferno makes
so that the system under test can identify Inferno as the requestor. If the **Access Token** input is populated, 
the provided value will be placed in the HTTP `Authorization` header with the prefix `Bearer `.
Support for Inferno to obtain bearer tokens using SMART on FHIR workflows or other auth schemes may be added
in the future based on community feedback.
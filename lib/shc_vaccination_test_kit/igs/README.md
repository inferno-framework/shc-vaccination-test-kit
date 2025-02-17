# Note on this IGs folder

This IGs folder contains two files:

* shc-vaccination-1.0.0-updated.tgz
* cards.smarthealth.terminology-0.1.0.tgz

Using the `hl7.fhir.uv.shc-vaccination#1.0.0` directly causes validator initialization error because
the `hl7.fhir.uv.shc-vaccination#1.0.0` ig depends on `cards.smarthealth.terminology` ig which is
incorrectly registered in FHIR package registry.

This is a temporary solution before IG author fixes the registry URL.

Here is how to create/upates these file.
1. Download sch-vaccination package.tgz from [here](https://build.fhir.org/ig/HL7/fhir-shc-vaccination-ig/package.tgz), and save as shc-vaccination-1.0.0-updated.tgz to the igs folder.
2. Download cards.smarthealth.terminology pacakge.tgz from [here](https://build.fhir.org/ig/dvci/shc-terminology/branches/master/package.tgz), and save as cards.smarthealth.terminology-0.1.0.tgz into the igs folder
3. Uppack shc-vaccination-1.0.0-updated.tgz. On MacOs, you can use command `tar -xvf shc-vaccination-1.0.0-updated.tgz`
4. Go to the package folder
5. Open ImplementationGuide-hl7.fhir.uv.shc-vaccination.json, change
```
    {
      "id": "cards_smarthealth_terminology",
      "uri": "https://terminology.smarthealth.cards/ImplementationGuide/cards.smarthealth.terminology",
      "packageId": "cards.smarthealth.terminology",
      "version": "current"
    }
```
to
```
    {
      "id": "cards_smarthealth_terminology",
      "uri": "https://terminology.smarthealth.cards/ImplementationGuide/cards.smarthealth.terminology",
      "packageId": "cards.smarthealth.terminology",
      "version": "0.1.0"
    }
```
6. Open package.json, change
```
    "cards.smarthealth.terminology" : "current"
```
to
```
    "cards.smarthealth.terminology" : "0.1.0"
```
7. Save both files.
8. Update shc-vaccination-1.0.0-updated.tgz. On MacOS, you can use command line `tar -czf shc-vaccination-1.0.0-updated.tgz package`
8. Update `lib/shc_vaccination_test_kit.rb`, change
```
    fhir_resource_validator do
      igs 'hl7.fhir.uv.shc-vaccination#0.6.2'
```
to
```
    fhir_resource_validator do
      igs('igs/cards.smarthealth.terminology-0.1.0.tgz', 'igs/shc-vaccination-1.0.0-updated.tgz')
```
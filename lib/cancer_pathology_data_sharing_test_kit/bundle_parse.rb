module CancerPathologyDataSharingTestKit
  module BundleParse
    extend Forwardable

    def unresolved_references
      @unresolved_references ||= []
    end

    def clear_unresolved_references
      @unresolved_references = []
    end

    # ResourcesTypes in Slicing with Profiles
    PE_BUNDLE_SLICE_RESOURCES = {
      'Patient' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient',
      'Encounter' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter',
      'DiagnosticReport' => 'https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-diagnostic-report.html',
      'Specimen' => 'http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-specimen',
      'ServiceRequest' => 'http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-service-request',
      'PractitionerRole' => 'http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-related-practitioner-role'
    }

    def pe_bundle_resource_types
      PE_BUNDLE_SLICE_RESOURCES.keys()
    end


    # Method for translating received bundle into a hash of resources
    def parse_bundle(bundle)
      # TODO: For now, use ResourceType as Key, but determine if profile is indeed better?
      # But with openslicing, we don't have too many options here...
      parsed_bundle ||= {}
      bundle.entry.each do |entry|
        current_resource = entry.resource
        unless current_resource.is_a?(FHIR::Reference)
          # Not a reference, then just add the resoure to parsed bundle
          parsed_bundle[current_resource.resourceType] ||= []
          parsed_bundle[current_resource.resourceType] << current_resource
        end
      end

      return parsed_bundle
    end

    # Only returns the resources from the parsed bundle that match Pathology Exchange type
    def filter_exchange_bundle_resources(parsed_bundle)
      parsed_bundle.select { |key| pe_bundle_resource_types.include?(key) }
    end

    def find_resource_in_bundle(reference, bundle)
      bundle.entry.find { |res| res.resource.id == reference.split('/').last && res.resource.resourceType == reference.split('/').first }&.resource
    end
  end
end

module CancerPathologyDataSharingTestKit
  module ValidationTest
    DAR_CODE_SYSTEM_URL = 'http://terminology.hl7.org/CodeSystem/data-absent-reason'.freeze
    DAR_EXTENSION_URL = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason'.freeze

    def perform_strict_validation_test(resourceType = resource_type,
                                resources,
                                profile_url,
                                profile_version,
                                skip_if_empty: true)
                                                       
      skip_if skip_if_empty && resources.blank?,
              "No #{resourceType} resources conforming to the #{profile_url} profile were returned"

      omit_if resources.blank?,
              "No #{resourceType} resources provided so the #{profile_url} profile does not apply"

      profile_with_version = "#{profile_url}|#{profile_version}"
      resources.each do |resource|
        resource_is_valid?(resource: resource, profile_url: profile_with_version)
        check_for_dar(resource)
      end

      errors_found = messages.any? { |message| message[:type] == 'error' }

      assert !errors_found, "Resource does not conform to the profile #{profile_with_version}"
    end

    def check_for_dar(resource)
      unless scratch[:dar_code_found]
        resource.each_element do |element, meta, _path|
          next unless element.is_a?(FHIR::Coding)

          check_for_dar_code(element)
        end
      end

      unless scratch[:dar_extension_found]
        check_for_dar_extension(resource)
      end
    end

    def check_for_dar_code(coding)
      return unless coding.code == 'unknown' && coding.system == DAR_CODE_SYSTEM_URL

      scratch[:dar_code_found] = true
      output dar_code_found: 'true'
    end

    def check_for_dar_extension(resource)
      return unless resource.source_contents&.include? DAR_EXTENSION_URL

      scratch[:dar_extension_found] = true
      output dar_extension_found: 'true'
    end


    def perform_validation_test(resourceType = resource_type,
      resources,
      profile_url,
      profile_version)

      return if resources.blank?                 

      profile_with_version = "#{profile_url}|#{profile_version}"
      conforms = false
      resources.each do |resource|
        conforms = true if resource_is_valid?(resource: resource, profile_url: profile_with_version)
      end

      assert conforms, "One of the attached bundless does not contain #{resourceType} that conforms to the profile #{profile_with_version}"
    end

  end
end

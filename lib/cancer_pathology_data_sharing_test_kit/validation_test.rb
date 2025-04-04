module CancerPathologyDataSharingTestKit
  module ValidationTest
    DAR_CODE_SYSTEM_URL = 'http://terminology.hl7.org/CodeSystem/data-absent-reason'.freeze
    DAR_EXTENSION_URL = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason'.freeze

    CARDINALITY_RESTRICTIONS = {
      'exactly_one' =>
        ['==', 1,
         'There must be exactly one (1) %<resource_type>s resource per bundle. Bundle `%<bundle_id>s` has %<resources_length>s resource(s)'],
      'no_more_than_one' =>
        ['<=', 1,
         'There must be no more than one (1) %<resource_type>s resource per bundle. Bundle `%<bundle_id>s` has %<resources_length>s resource(s)'],
      'at_least_one' =>
        ['>=', 1,
         'There must be at least one (1) %<resource_type>s resource per bundle. Bundle `%<bundle_id>s` has %<resources_length>s resource(s)']
    }.freeze

    def perform_strict_validation_test(the_resource_type = resource_type, # rubocop:disable Metrics/CyclomaticComplexity,Style/OptionalArguments
                                       bundle_id,
                                       resources,
                                       profile_url,
                                       profile_version,
                                       skip_if_empty: true,
                                       restriction: nil)
      if !restriction.nil? && !resources.length.public_send(CARDINALITY_RESTRICTIONS[restriction][0], CARDINALITY_RESTRICTIONS[restriction][1])
        messages << {
          type: 'error',
          message: format(CARDINALITY_RESTRICTIONS[restriction][2], resource_type: resource_type, bundle_id: bundle_id,
                                                                    resources_length: resources.length)
        }
        return true
      end

      skip_if skip_if_empty && resources.blank?,
              "No #{the_resource_type} resources in bundle `#{bundle_id}` were provided so the #{profile_url} profile does not apply"

      if resources.blank?
        messages << {
          type: 'info',
          message: "No #{the_resource_type} resources in bundle `#{bundle_id}` were provided so the #{profile_url} profile does not apply"
        }
        return false
      end

      not_valid = false
      profile_with_version = "#{profile_url}|#{profile_version}"
      resources.each do |resource|
        not_valid == true unless resource_is_valid?(resource: resource, profile_url: profile_with_version)
        check_for_dar(resource)
      end

      if not_valid
        messages << {
          type: 'error',
          message: "At least one of the #{the_resource_type} resource(s) in bundle `#{bundle_id}` does not " \
                   "conform to the profile #{profile_with_version}"
        }
      end

      not_valid
    end

    def check_for_dar(resource)
      unless scratch[:dar_code_found]
        resource.each_element do |element, _meta, _path|
          next unless element.is_a?(FHIR::Coding)

          check_for_dar_code(element)
        end
      end

      return if scratch[:dar_extension_found]

      check_for_dar_extension(resource)
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

    def check_for_errors(invalid_bundles)
      assert invalid_bundles.empty?, "Issues found in Bundle(s): #{invalid_bundles.join(', ')}"
      assert messages.none? { |message| message[:type] == 'error' }, 'Non-conformant instances detected.'
    end
  end
end

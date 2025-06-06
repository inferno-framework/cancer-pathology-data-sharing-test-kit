require_relative 'primitive_type'

module CancerPathologyDataSharingTestKit
  module FHIRResourceNavigation
    DAR_EXTENSION_URL = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason'.freeze
    PRIMITIVE_DATA_TYPES = FHIR::PRIMITIVES.keys

    def resolve_path(elements, path)
      elements = Array.wrap(elements)
      return elements if path.blank?

      paths = path.split(/(?<!hl7)\./)
      segment = paths.first
      remaining_path = paths.drop(1).join('.')

      elements.flat_map do |element|
        child = get_next_value(element, segment)
        resolve_path(child, remaining_path)
      end.compact
    end

    def find_a_value_at(element, path, include_dar: false, &block) # rubocop:disable Metrics/CyclomaticComplexity
      return nil if element.nil?

      elements = Array.wrap(element)
      if path.empty?
        unless include_dar
          elements = elements.reject do |el|
            el.respond_to?(:extension) && el.extension.any? { |ext| ext.url == DAR_EXTENSION_URL }
          end
        end

        return elements.find(&block) if block_given?

        return elements.first
      end

      path_segments = path.split(/(?<!hl7)\./)

      segment = path_segments
        .shift
        .delete_suffix('[x]')
        .gsub(/^class$/, 'local_class')
        .gsub(/^method$/, 'local_method')
        .gsub('[x]:', ':')
        .to_sym
      no_elements_present =
        elements.none? do |element| # rubocop:disable Lint/ShadowingOuterLocalVariable
          child = get_next_value(element, segment)
          child.present? || child == false
        end
      return nil if no_elements_present

      remaining_path = path_segments.join('.')
      elements.each do |element| # rubocop:disable Lint/ShadowingOuterLocalVariable
        child = get_next_value(element, segment)
        element_found =
          if block_given?
            find_a_value_at(child, remaining_path, include_dar: include_dar, &block)
          else
            find_a_value_at(child, remaining_path, include_dar: include_dar)
          end
        return element_found if element_found.present? || element_found == false
      end

      nil
    end

    def get_next_value(element, property)
      extension_url = property[/(?<=where\(url=').*(?='\))/]
      if extension_url.present?
        element.url == extension_url ? element : nil
      elsif property.to_s.include?(':') && !property.to_s.include?('url')
        find_slice_via_discriminator(element, property)

      else
        value = element.send(property)
        primitive_value = get_primitive_type_value(element, property, value)
        primitive_value.present? ? primitive_value : value
      end
    rescue NoMethodError
      nil
    end

    def get_primitive_type_value(element, property, value)
      source_value = element.source_hash["_#{property}"]

      return nil unless source_value.present?

      primitive_value = CancerPathologyDataSharingTestKit::PrimitiveType.new(source_value)
      primitive_value.value = value
      primitive_value
    end

    def find_slice_via_discriminator(element, property) # rubocop:disable Metrics/CyclomaticComplexity
      element_name = property.to_s.split(':')[0].gsub(/^class$/, 'local_class').gsub(/^method$/, 'local_method')
      slice_name = property.to_s.split(':')[1].gsub(/^class$/, 'local_class').gsub(/^method$/, 'local_method')
      if metadata.present?
        slice_by_name = metadata.must_supports[:slices].find { |slice| slice[:slice_name] == slice_name }
        discriminator = slice_by_name[:discriminator]
        slices = Array.wrap(element.send(element_name))
        slices.find do |slice|
          case discriminator[:type]
          when 'patternCodeableConcept'
            slice_value = discriminator[:path].present? ? slice.send(discriminator[:path].to_s)&.coding : slice.coding
            slice_value&.any? { |coding| coding.code == discriminator[:code] && coding.system == discriminator[:system] }
          when 'patternCoding'
            slice_value = discriminator[:path].present? ? slice.send(discriminator[:path]) : slice
            slice_value&.code == discriminator[:code] && slice_value&.system == discriminator[:system]
          when 'patternIdentifier'
            slice.identifier.system == discriminator[:system]
          when 'value'
            values = discriminator[:values].map { |value| value.merge(path: value[:path].split('.')) }
            verify_slice_by_values(slice, values)
          when 'type'
            case discriminator[:code]
            when 'Date'
              begin
                Date.parse(slice)
              rescue ArgumentError # rubocop:disable Metrics/BlockNesting
                false
              end
            when 'DateTime'
              begin
                DateTime.parse(slice)
              rescue ArgumentError # rubocop:disable Metrics/BlockNesting
                false
              end
            when 'String'
              slice.is_a? String
            else
              if slice.is_a? FHIR::Bundle::Entry # rubocop:disable Metrics/BlockNesting
                slice.resource.resourceType == discriminator[:code]
              else
                slice.is_a? FHIR.const_get(discriminator[:code])
              end
            end
          when 'requiredBinding'
            discriminator[:path].present? ? slice.send(discriminator[:path].to_s).coding : slice.coding
            slice_value { |coding| discriminator[:values].include?(coding.code) }
          end
        end
      else # rubocop:disable Style/EmptyElse
        # TODO: Error handling for if this file doesn't have access to metadata for some reason (begin/rescue with StandardError?)
      end
    end

    def verify_slice_by_values(element, value_definitions) # rubocop:disable Metrics/CyclomaticComplexity
      path_prefixes = value_definitions.map { |value_definition| value_definition[:path].first }.uniq
      path_prefixes.all? do |path_prefix|
        value_definitions_for_path =
          value_definitions
            .select { |value_definition| value_definition[:path].first == path_prefix }
            .each { |value_definition| value_definition[:path].shift }
        find_a_value_at(element, path_prefix) do |el_found|
          child_element_value_definitions, current_element_value_definitions =
            value_definitions_for_path.partition { |value_definition| value_definition[:path].present? }

          current_element_values_match =
            current_element_value_definitions
              .all? { |value_definition| value_definition[:value] == el_found }

          child_element_values_match =
            if child_element_value_definitions.present?
              verify_slice_by_values(el_found, child_element_value_definitions)
            else
              true
            end
          current_element_values_match && child_element_values_match
        end
      end
    end
  end
end

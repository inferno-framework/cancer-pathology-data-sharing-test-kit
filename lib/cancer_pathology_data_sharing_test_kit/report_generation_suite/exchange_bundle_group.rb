require_relative 'exchange_bundle/content_bundle_must_support_test'
require_relative 'exchange_bundle/content_bundle_validation_test'
module CancerPathologyDataSharingTestKit
  class MustSupportGroup < Inferno::TestGroup
    title 'Content Exchange Bundle Group'
    id :exchange_bundle_group
    description %()


    test from: :content_bundle_validation_test
    test from: :content_bundle_must_support_test
    

  end
end
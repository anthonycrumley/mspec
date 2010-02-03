require 'mspec/guards/guard'

class FeatureGuard < SpecGuard
  def match?
    @parameters.all? { |f| MSpec.feature_enabled? f }
  end
end

class Object
  # Provides better documentation in the specs by
  # naming sets of features that work together as
  # a whole. Examples include :encoding, :fiber,
  # :continuation, :fork.
  #
  # Usage example:
  #
  #   with_feature :encoding do
  #     # specs for a method that provides aspects
  #     # of the encoding feature
  #   end
  #
  # Multiple features must all be enabled for the
  # guard to run:
  #
  #   with_feature :one, :two do
  #     # these specs will run if features :one AND
  #     # :two are enabled.
  #   end
  #
  # The implementation must explicitly enable a feature
  # by adding code like the following to the .mspec
  # configuration file:
  #
  #   MSpec.enable_feature :encoding
  #
  def with_feature(*features)
    g = FeatureGuard.new(*features)
    g.name = :with_feature
    yield if g.yield?
  ensure
    g.unregister
  end
end
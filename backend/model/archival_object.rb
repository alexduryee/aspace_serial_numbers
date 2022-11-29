require 'securerandom'

class ArchivalObject < Sequel::Model(:archival_object)

	def before_validation
		if !self.component_id
			self.component_id = Sequence.get("component_mss_id")
		end
	end

	def validate
		validates_unique([:root_record_id, :ref_id],
			:message => "An Archival Object Ref ID must be unique to its resource")
		validates_unique([:component_id], :message => "MSS ID must be unique")
		map_validation_to_json_property([:root_record_id, :ref_id], :ref_id)
		super
	end
end
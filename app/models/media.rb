class Media < ActiveRecord::Base
	belongs_to :message
  before_save :identification_complete, if: "newly_described?"

def newly_described?
	logger.info "checking if new"
	self.described_at.nil?
end

def identification_complete
	self.described_at = Time.now
	self.message.identify(description)
end


end

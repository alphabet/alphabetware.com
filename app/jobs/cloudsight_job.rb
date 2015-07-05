class CloudsightJob < ActiveJob::Base
  queue_as :default

  def perform(record, depth)
    # Do something later
  end
end

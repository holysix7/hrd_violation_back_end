class HrdViolationFile < ActiveRecord::Base
  belongs_to :hrd_violation, class_name: "HrdViolation", foreign_key: "hrd_violation_id", optional: true
end

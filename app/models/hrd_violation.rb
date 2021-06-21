class HrdViolation < ApplicationRecord
  belongs_to :violator, :class_name => 'SysAccount', :foreign_key => "violator_id"
  belongs_to :enforcer, :class_name => 'SysAccount', :foreign_key => "enforcer_id"
  belongs_to :whitness, :class_name => 'SysAccount', :foreign_key => "whitness_id", optional: true
  belongs_to :approved_1, :class_name => 'SysAccount', :foreign_key => "approve_1_by", optional: true
  belongs_to :approved_2, :class_name => 'SysAccount', :foreign_key => "approve_2_by", optional: true
  belongs_to :approved_3, :class_name => 'SysAccount', :foreign_key => "approve_3_by", optional: true
  belongs_to :penalty_first, :class_name => 'HrdViolationPenalty', :foreign_key => "penalty_first_id", optional: true
  belongs_to :penalty_second, :class_name => 'HrdViolationPenalty', :foreign_key => "penalty_second_id", optional: true
end

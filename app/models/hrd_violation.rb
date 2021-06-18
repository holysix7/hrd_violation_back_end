class HrdViolation < ApplicationRecord
  belongs_to :violator, :class_name => 'SysAccount', :foreign_key => "violator_id"
  belongs_to :enforcer, :class_name => 'SysAccount', :foreign_key => "enforcer_id"
  belongs_to :whitness, :class_name => 'SysAccount', :foreign_key => "whitness_id"
end

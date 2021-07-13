class SysAccount < ApplicationRecord
  has_many :hrd_violations
  has_many :hrd_employee_absences
end

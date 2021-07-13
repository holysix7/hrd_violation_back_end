class HrdEmployeeAbsence < ActiveRecord::Base
  belongs_to :hrd_employee, :class_name => 'HrdEmployee', :foreign_key => "hrd_employee_id", optional: true
  belongs_to :hrd_employee_absence_type, :class_name => 'HrdEmployeeAbsenceType', :foreign_key => "hrd_employee_absence_type_id", optional: true
  belongs_to :approved_1, :class_name => 'SysAccount', :foreign_key => "approve_1_by", optional: true
  belongs_to :approved_2, :class_name => 'SysAccount', :foreign_key => "approve_2_by", optional: true
  belongs_to :approved_3, :class_name => 'SysAccount', :foreign_key => "approve_3_by", optional: true
  
  belongs_to :hrd_file_doc, :class_name => 'HrdFileDoc', :foreign_key => "hrd_file_doc_id", optional: true
end

class V1::HrdsController < ApplicationController
  before_action :token_jwt 

  def index
    sys_plant_id  = params[:sys_plant_id]
    begin_date    = params[:begin_date]
    end_date      = params[:end__date]
    absences      = HrdEmployeeAbsence.where(:sys_plant_id  => sys_plant_id, :begin_date => begin_date .. end_date).includes(:hrd_file_doc, :hrd_employee, :approved_1, :approved_2, :approved_3)
    record        = []
    absences.each do |absence| 
      array = {
        id: absence.id,
        hrd_employee_id: absence.hrd_employee_id,
        hrd_employee_name: absence.hrd_employee.present? ? absence.hrd_employee.name : nil,
        hrd_employee_absence_type_id: absence.hrd_employee_absence_type_id,
        hrd_employee_absence_type_name: absence.hrd_employee_absence_type.present? ? absence.hrd_employee_absence_type.name : nil,
        description: absence.description,
        status: absence.status,
        begin_date: absence.begin_date,
        end_date: absence.end_date,
        created_at: absence.created_at,
        created_by: absence.created_by,
        approve_1_at: absence.approve_1_at,
        approve_1_by: absence.approve_1_by,
        approve_2_at: absence.approve_2_at,
        approve_2_by: absence.approve_2_by,
        approve_3_at: absence.approve_3_at,
        approve_3_by: absence.approve_3_by,
        cancel_approve_1_at: absence.cancel_approve_1_at,
        cancel_approve_1_by: absence.cancel_approve_1_by,
        cancel_approve_2_at: absence.cancel_approve_2_at,
        cancel_approve_2_by: absence.cancel_approve_2_by,
        cancel_approve_3_at: absence.cancel_approve_3_at,
        cancel_approve_3_by: absence.cancel_approve_3_by,
        hrd_file_doc: {
          id: absence.hrd_file_doc.present? ? absence.hrd_file_doc.id : nil ,
          title: absence.hrd_file_doc.present? ? absence.hrd_file_doc.title : nil,
          hrd_file_doc_description: absence.hrd_file_doc.present? ? absence.hrd_file_doc.description : nil,
          file_name: absence.hrd_file_doc.present? ? absence.hrd_file_doc.file_name : nil,
        }
      }
      record << array
    end
    if absences.present?
      status  = 'Success'
      code    = 200
      message = 'Success Get Data List Absences'
      data    = data  
    else 
      status  = 'Failed'
      code    = 400
      message = 'Failed Get Data List Absences'
      data    = []
    end
    render json: {
      status: status,
      code: code,
      message: message,
      data: record
    }
  end
  
  def show
    absence_id  = params[:id]
    absence     = HrdEmployeeAbsence.find_by(:id => absence_id)
    if absence.present?
      record      = {
        id: absence.id,
        hrd_employee_id: absence.hrd_employee_id,
        hrd_employee_name: absence.hrd_employee.present? ? absence.hrd_employee.name : nil,
        hrd_employee_absence_type_id: absence.hrd_employee_absence_type_id,
        hrd_employee_absence_type_name: absence.hrd_employee_absence_type.present? ? absence.hrd_employee_absence_type.name : nil,
        description: absence.description,
        status: absence.status,
        begin_date: absence.begin_date,
        end_date: absence.end_date,
        created_at: absence.created_at,
        created_by: absence.created_by,
        approve_1_at: absence.approve_1_at,
        approve_1_by: absence.approve_1_by,
        approve_2_at: absence.approve_2_at,
        approve_2_by: absence.approve_2_by,
        approve_3_at: absence.approve_3_at,
        approve_3_by: absence.approve_3_by,
        cancel_approve_1_at: absence.cancel_approve_1_at,
        cancel_approve_1_by: absence.cancel_approve_1_by,
        cancel_approve_2_at: absence.cancel_approve_2_at,
        cancel_approve_2_by: absence.cancel_approve_2_by,
        cancel_approve_3_at: absence.cancel_approve_3_at,
        cancel_approve_3_by: absence.cancel_approve_3_by,
        hrd_file_doc: {
          id: absence.hrd_file_doc.present? ? absence.hrd_file_doc.id : nil ,
          title: absence.hrd_file_doc.present? ? absence.hrd_file_doc.title : nil,
          hrd_file_doc_description: absence.hrd_file_doc.present? ? absence.hrd_file_doc.description : nil,
          file_name: absence.hrd_file_doc.present? ? absence.hrd_file_doc.file_name : nil,
        }
      }
    end
    if absence.present?
      status  = 'Success'
      code    = 200
      message = 'Success Show Data Absence'
      data    = record  
    else
      status  = 'Failed'
      code    = 400
      message = 'Failed Show Data Absence'
      data    = []
    end
    render json: {
      status: status,
      code: code,
      message: message,
      data: data
    }
  end

  def new
    types     = HrdEmployeeAbsenceType.all
    depts     = SysDepartment.all
    record    = {
      hrd_employee_absence_types: types,
      sys_departments: depts
    }
    if types.present? and depts.present?
      status  = 'Success'
      code    = 200
      message = 'Success Get Data List Types and Employees'
      data    = record  
    else
      status  = 'Failed'
      code    = 400
      message = 'Failed Get Data List Types and Employees'
      data    = []
    end
    render json: {
      status: status,
      code: code,
      message: message,
      data: data
    }
  end

  def create
    if params[:file].present? 
      hrd_file  = HrdFileDoc.new(
        sys_plant_id: params[:sys_plant_id],
        filename_original: params[:file].original_filename.to_s,
        path: params[:file].tempfile.to_path.to_s,
        ext: params[:file].original_filename.to_s.split('.')[1],
        file_name: params[:file].original_filename.to_s.split('.')[0],
        status: 'active',
        created_at: timeZone.strftime("%Y-%m-%d %H:%M:%S"),
        created_by: params[:hrd_employee_id]
      )
      hrd_file.hrd_employee_absences.build(
        sys_plant_id: params[:sys_plant_id],
        hrd_employee_id: params[:hrd_employee_id],
        hrd_file_doc_id: hrd_file.id,
        hrd_employee_absence_type_id: params[:hrd_employee_absence_type_id],
        day: params[:day],
        description: params[:description],
        status: 'new',
        begin_date: params[:begin_date],
        end_date: params[:end_date],
        created_at: timeZone.strftime("%Y-%m-%d %H:%M:%S"),
        created_by: params[:hrd_employee_id],
        updated_at: timeZone.strftime("%Y-%m-%d %H:%M:%S"),
        updated_by: params[:hrd_employee_id],
      )
      status  = 'Success'
      code    = 200
      message = 'Success Send Data Absence With Files'
      hrd_file.save
    else
      if params[:sys_plant_id].present? and params[:hrd_employee_id].present? and params[:day].present? and params[:description].present? and params[:begin_date].present? and params[:end_date].present?
        hrd_absence = HrdEmployeeAbsence.new(
          sys_plant_id: params[:sys_plant_id],
          hrd_employee_id: params[:hrd_employee_id],
          hrd_file_doc_id: nil,
          hrd_employee_absence_type_id: params[:hrd_employee_absence_type_id],
          day: params[:day],
          description: params[:description],
          status: 'new',
          begin_date: params[:begin_date],
          end_date: params[:end_date],
          created_at: timeZone.strftime("%Y-%m-%d %H:%M:%S"),
          created_by: params[:hrd_employee_id],
          updated_at: timeZone.strftime("%Y-%m-%d %H:%M:%S"),
          updated_by: params[:hrd_employee_id],
        )
        status  = 'Success'
        code    = 200
        message = 'Success Send Data Absence Without Files'
        hrd_absence.save
      else
        status  = 'Failed'
        code    = 200
        message = 'Failed Send Data Absence, Check Parameter: sys_plant_id, hrd_employee_id, day, description, begin_date, end_date'
      end
    end
    render json: {
      status: status,
      code: code,
      message: message
    }
  end

  def approve
    if params[:id].present?
      absence = HrdEmployeeAbsence.find_by(:id => params[:id])
      if absence.present? and params[:user_id].present? and params[:type_request].present? and params[:count_request].to_i > 0
        if params[:type_request] == 'Approve'
          absence.update(
            "updated_at"                            => timeZone.strftime("%Y-%m-%d %H:%M:%S"),
            "updated_by"                            => params[:user_id],
            "approve_#{params[:count_request]}_at".to_sym => timeZone.strftime("%Y-%m-%d %H:%M:%S"),
            "approve_#{params[:count_request]}_by".to_sym => params[:user_id]
          )
          status  = 'Success'
          code    = 200
          message = "Success Approve #{params[:count_request]} Data Absence With Id #{params[:id]} By User Id #{params[:user_id]}"
          data    = absence
        else
          absence.update(
            "updated_at"                                          => timeZone.strftime("%Y-%m-%d %H:%M:%S"),
            "updated_by"                                          => params[:user_id],
            "cancel_approve_#{params[:count_request]}_at".to_sym  => timeZone.strftime("%Y-%m-%d %H:%M:%S"),
            "cancel_approve_#{params[:count_request]}_by".to_sym  => params[:user_id],
            "approve_#{params[:count_request]}_at".to_sym         => nil,
            "approve_#{params[:count_request]}_by".to_sym         => nil
          )
          status  = 'Success'
          code    = 200
          message = "Success Approve #{params[:count_request]} Data Absence With Id #{params[:id]} By User Id #{params[:user_id]}"
          data    = absence
        end
      else
        response_status = "Failed"
        response_code = 400
        response_message = "Failed Approve/Cancel Data HRD Violation With Id #{id_violation}"
        response_data = []
      end
    else

    end
    render json: {
      status: status,
      code: code,
      message: message,
      message: data
    }
  end

  private 
  
  def token_jwt
    JsonWebToken.decode(request.headers["Authorization"])
  end

end

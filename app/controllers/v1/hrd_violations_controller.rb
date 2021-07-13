class V1::HrdViolationsController < ApplicationController
  before_action :token_jwt 

  def index
    #################################
    ## GET LIST VIOLATIONS BY DATE ##
    #################################
    data          = []
    sys_plant_id  = params[:sys_plant_id]
    start_date    = params[:start_date]
    end_date      = params[:end_date]
    violations    = HrdViolation.where(:sys_plant_id => sys_plant_id, :violation_date =>start_date .. end_date).includes(:violator, :penalty_first, :penalty_second, :enforcer, :whitness, :approved_1, :approved_2, :approved_3)
    violations.each do |violation| 
      array = {
        id: violation.id,
        sys_plant_id: violation.sys_plant_id,
        penalty_first_id: violation.penalty_first_id,
        penalty_first_name: violation.penalty_first.present? ? violation.penalty_first.name : nil,
        penalty_description: violation.penalty_description,
        penalty_second_id: violation.penalty_second_id,
        penalty_second_name: violation.penalty_second.present? ? violation.penalty_second.name : nil,
        penalty_description_second: violation.penalty_description_second,
        violator_id: violation.violator_id,
        violator_name: violation.violator.present? ? violation.violator.name : nil,
        violator_nik: violation.violator.present? ? violation.violator.user : nil,
        enforcer_id: violation.enforcer_id,
        enforcer_name: violation.enforcer.present? ? violation.enforcer.name : nil,
        enforcer_nik: violation.enforcer.present? ? violation.enforcer.user : nil,
        whitness_id: violation.whitness_id,
        whitness_name: violation.whitness.present? ? violation.whitness.name : nil,
        whitness_nik: violation.whitness.present? ? violation.whitness.user : nil,
        description: violation.description,
        violation_time: violation.violation_time.strftime("%H:%M"),
        violation_date: violation.violation_date,
        violation_status: violation.status,
        violation_status_case: violation.status_case,
        approve_1_at: violation.approve_1_at,
        approve_1_by: violation.approved_1.present? ? violation.approved_1.name : nil,
        approve_2_at: violation.approve_2_at,
        approve_2_by: violation.approved_2.present? ? violation.approved_2.name : nil,
        approve_3_at: violation.approve_3_at,
        approve_3_by: violation.approved_3.present? ? violation.approved_3.name : nil,
        # image: violation.hrd_violation_files.length() ? violation.hrd_violation_files.map { 
        #   |hrd_violation_file| {
        #   id: hrd_violation_file.id, 
        #   base64_full: hrd_violation_file.base64_full
        #   } 
        # } : nil
      }
      data << array
    end
    ##############################################################################
    #### Looping Object Because Need Object From Violator Class (sys_account) ####
    ##############################################################################
    if sys_plant_id.present? && start_date.present? && end_date.present?
      if violations.present?
        status = "Success",
        code = 200,
        message = "Success Get Data HRD Violations",
        data = data
      else
        status = "Failed",
        code = 401,
        message = "There's No Data HRD Violations",
        data = []
      end
    else
      status = "Failed",
      code = 402,
      message = "Failed Get Data HRD Violations, Check Parameters Again!",
      data = []
    end
    render json: {
      status: status,
      code: code,
      message: message,
      data: data.length > 0 ? data : []
    }
  end

  def show_violation
    violations    = HrdViolation.where(:id => params[:id])
    data = []
    violations.each do |violation| 
      array = {
        id: violation.id,
        sys_plant_id: violation.sys_plant_id,
        penalty_first_id: violation.penalty_first_id,
        penalty_first_name: violation.penalty_first.present? ? violation.penalty_first.name : nil,
        penalty_description: violation.penalty_description,
        penalty_second_id: violation.penalty_second_id,
        penalty_second_name: violation.penalty_second.present? ? violation.penalty_second.name : nil,
        penalty_description_second: violation.penalty_description_second,
        violator_id: violation.violator_id,
        violator_name: violation.violator.present? ? violation.violator.name : nil,
        violator_nik: violation.violator.present? ? violation.violator.user : nil,
        enforcer_id: violation.enforcer_id,
        enforcer_name: violation.enforcer.present? ? violation.enforcer.name : nil,
        enforcer_nik: violation.enforcer.present? ? violation.enforcer.user : nil,
        whitness_id: violation.whitness_id,
        whitness_name: violation.whitness.present? ? violation.whitness.name : nil,
        whitness_nik: violation.whitness.present? ? violation.whitness.user : nil,
        description: violation.description,
        violation_time: violation.violation_time.strftime("%H:%M"),
        violation_date: violation.violation_date,
        violation_status: violation.status,
        violation_status_case: violation.status_case,
        approve_1_at: violation.approve_1_at,
        approve_1_by: violation.approved_1.present? ? violation.approved_1.name : nil,
        approve_2_at: violation.approve_2_at,
        approve_2_by: violation.approved_2.present? ? violation.approved_2.name : nil,
        approve_3_at: violation.approve_3_at,
        approve_3_by: violation.approved_3.present? ? violation.approved_3.name : nil,
        image: violation.hrd_violation_files.length() ? violation.hrd_violation_files.map { 
          |hrd_violation_file| {
          id: hrd_violation_file.id, 
          base64_full: hrd_violation_file.base64_full
          } 
        } : nil
      }
      data << array
    end
    
    if violations.present?
      render json: {
        status: "Success",
        code: 200,
        message: "Success Show Data HRD Violation",
        data: data.first
      }
    end
  end

  def create
    violation = HrdViolation.new(
      sys_plant_id: params[:sys_plant_id],
      penalty_first_id: params[:penalty_first_id],
      penalty_description: params[:penalty_description],
      penalty_second_id: params[:penalty_second_id],
      penalty_description_second: params[:penalty_description_second],
      violator_id: params[:violator_id],
      enforcer_id: params[:enforcer_id],
      whitness_id: params[:whitness_id],
      description: params[:description],
      violation_time: params[:violation_time],
      violation_date: params[:violation_date],
      status: "new",
      status_case: "open",
      edit_lock_by: params[:violator_id],
      created_at: timeZone.strftime("%Y-%m-%d %H:%M:%S"),
      created_by: params[:violator_id],
      updated_at: timeZone.strftime("%Y-%m-%d %H:%M:%S"),
      updated_by: params[:violator_id],
    )
    # violation = HrdViolation.new(insert_validation)
    if params[:sys_plant_id].present? and params[:violator_id].present? and params[:enforcer_id].present? and params[:whitness_id].present? and params[:violation_time].present? and params[:violation_date].present?
      if params[:item_image].present?
        params[:item_image].each do |item| 
          violation.hrd_violation_files.build(
            status: 'active',
            created_by: item['created_by'],
            base64_full: item['base64_full']
          )
        end
        violation.save
      else
        render json: {
          status: 'Failed',
          code: 401,
          message: "Parent Didn't Save"
        }
      end
      render json: {
        status: "Success",
        code: 200,
        message: "Success Save Data HRD Violation",
        data: violation
      }
    else
      dataKurang = {
        sys_plant_id: params[:sys_plant_id],
        violator_id: params[:violator_id],
        enforcer_id: params[:enforcer_id],
        whitness_id: params[:whitness_id],
        violation_time: params[:violation_time],
        violation_date: params[:violation_date],
      }
      render json: {
        status: "Failed",
        code: 401,
        message: "Failed Save Data Violation, Check Parameter Sent.",
        data: violation
      }
    end
  end

  def approve
    id_violation = params[:id]
    if id_violation.present?
      dataViolation = HrdViolation.find_by(:id=> id_violation)
      if dataViolation.present?
        if params[:type] == 'Approve'
          dataViolation.update(
            updated_at: timeZone.strftime("%Y-%m-%d %H:%M:%S"),
            updated_by: params[:user_id],
            "approve_#{params[:approve]}_at".to_sym=> timeZone.strftime("%Y-%m-%d %H:%M:%S"),
            "approve_#{params[:approve]}_by".to_sym=> params[:user_id]
          )
          response_status = "Success"
          response_code = 200
          response_message = "Success Approve #{params[:approve]} Data HRD Violation With Id #{id_violation}"
          response_data = dataViolation
        else
          dataViolation.update(
            updated_at: timeZone.strftime("%Y-%m-%d %H:%M:%S"),
            updated_by: params[:user_id],
            "cancel_approve_#{params[:cancel]}_at".to_sym=> timeZone.strftime("%Y-%m-%d %H:%M:%S"),
            "cancel_approve_#{params[:cancel]}_by".to_sym=> params[:user_id],
            "approve_#{params[:approve]}_at".to_sym=> nil,
            "approve_#{params[:approve]}_by".to_sym=> nil
          )
          response_status = "Success"
          response_code = 200
          response_message = "Success Approve #{params[:approve]} Data HRD Violation With Id #{id_violation}"
          response_data = dataViolation
        end
      else
        response_status = "Failed"
        response_code = 401
        response_message = "Failed Approve Data HRD Violation With Id #{id_violation}"
        response_data = []
      end
    else
      response_status = "Failed"
      response_code = 401
      response_message = "Failed Approve Data HRD Violation, Id Violation was nil"
      response_data = []
    end
    render json: {
      status: response_status,
      code: response_code,
      message: response_message,
      data: response_data
    }
  end
  
  def get_penalties
    data    = HrdViolationPenalty.all
    if data.present?
      render json: {
        status: "Success",
        code: 200,
        message: "Success Get Data Penalties",
        data: data
      }
    else
      render json: {
        status: "Failed",
        code: 401,
        message: "There's No Data Penalties"
      }
    end
  end

  private 
  
  def token_jwt
    JsonWebToken.decode(request.headers["Authorization"])
  end

end

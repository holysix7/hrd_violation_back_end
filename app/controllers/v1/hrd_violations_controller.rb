class V1::HrdViolationsController < ApplicationController
  before_action :token_jwt 

  def index
    violations = HrdViolation.where(:sys_plant_id => params[:sys_plant_id])
    if(params[:sys_plant_id].present?)
      if violations.present?
        render json: {
          status: "Success",
          code: 200,
          message: "Success Get Data HRD Violations",
          data: violations
        }
      else
        render json: {
          status: "Failed",
          code: 401,
          message: "There's No Data HRD Violations"
        }
      end
    else
      render json: {
        status: "Failed",
        code: 402,
        message: "Failed Get Data HRD Violations, Check Sys Plant Id"
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

    if params[:sys_plant_id].present? and params[:violator_id].present? and params[:enforcer_id].present? and params[:enforcer_id].present? and params[:whitness_id].present? and params[:violation_time].present? and params[:violation_date].present?
      violation.save
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

  private 
  
  def token_jwt
    JsonWebToken.decode(request.headers["Authorization"])
  end
  # def insert_validation
  #   params.require(:violation_date).permit(:sys_plant_id, :violator_id, :enforcer_id, :whitness_id, :violation_time, :violation_date)
  # end

end

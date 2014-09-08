require 'RMagick'
class MonitorController < ApplicationController

  # before_filter :require_signed_in_user

  def get_last_reports
    last_reports = Array.new
    dis = MachineShop::DataSource.all({}, session[:auth_token])
    dis.to_a.each do |di|        
        last_reports << di['last_report']
    end

    json_data = {last_reports: dis}

    respond_to do |format|
      format.json { render json: json_data.to_json }
    end

  end

  def get_sample_payload_data
    payload = Array.new
    dis = MachineShop::DataSource.all({}, session[:auth_token])
    dis.to_a.each do |di|
        if di['last_report'].present?
            if di['last_report']['payload'].present?
                payload << di['last_report']['payload']
                break
            end
        end
    end

    json_data = {payload: payload[0]}

    respond_to do |format|
      format.json { render json: json_data.to_json }
    end
      
  end
end

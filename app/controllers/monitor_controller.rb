require 'RMagick'
class MonitorController < ApplicationController

  # before_filter :require_signed_in_user

  def get_last_reports
    last_reports = Array.new
    dis = MachineShop::DeviceInstance.all({}, session[:auth_token])
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
    dis = MachineShop::DeviceInstance.all({}, session[:auth_token])
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

  def get_colored_image_for_device

    puts "Returning image for #{params[:color]}"
    image_size = 12 
    circleX = 5
    circleY = 5
    radius = 5

    canvas = Magick::Image.new(image_size, image_size) { self.background_color = '#ffffff00' }
    canvas.format='PNG'
   
    gc = Magick::Draw.new
  
    gc.stroke(params[:color])
    gc.fill(params[:color])
    
    gc.stroke_width(1)
    gc.fill_opacity(1)

    # rmagick, instead of allowing one to specify a center and
    # radius, requires a dev to specify the center and then 
    # specify a *point on the perimeter*
    gc.circle(circleX, circleY, circleX - radius, circleX)
  
    gc.draw(canvas)
 
    send_data canvas.to_blob, :type => 'image/png',:disposition => 'inline'
  end

  def get_address_by_latlon()

    addresses = MachineShop::Mapping.geocode(
        {
          :latlng => params[:latlon],
          # :sensor => "false"
        }, session[:auth_token])

    respond_to do |format|
      format.json { render json: addresses.to_json }
    end
      
  end

end

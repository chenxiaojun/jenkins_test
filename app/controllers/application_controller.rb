class ApplicationController < ActionController::API

  protected
  def render_api_error(error_code, msg = nil)
    if error_code.between?(Constants::HttpErrorCode::HTTP_FAILED, Constants::HttpErrorCode::HTTP_MAX)
      head error_code, x_deshpro_msg: (msg.nil? ? Constants::ERROR_MESSAGES[error_code] : msg), content_type: 'application/json'
    else
      render 'common/error', locals: {api_result: ApiResult.new(error_code, msg)}
    end
  end

  def render_api_success
    render 'common/error', locals: {api_result: ApiResult.success}
  end
end
module Services
  module Account
    class MobileVerifyVcodeService
      include Serviceable
      include Constants::Error::Sign
      attr_accessor :mobile, :vcode

      def initialize(mobile, vcode)
        self.mobile = mobile
        self.vcode = vcode
      end

      def call
        # 检查手机格式是否正确
        return ApiResult.error_result(MOBILE_FORMAT_WRONG) unless UserValidator.mobile_valid?(mobile)

        # 判断验证码是否正确
        return ApiResult.error_result(VCODE_NOT_MATCH) if vcode != mobile[-4, 4]

        # 验证码正确
        ApiResult.success_result
      end
    end
  end
end

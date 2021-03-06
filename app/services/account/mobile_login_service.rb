module Services
  module Account
    class MobileLoginService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :mobile, :password

      def initialize(mobile, password)
        self.mobile = mobile
        self.password = password
      end

      def call
        # 检查手机号格式是否正确
        return ApiResult.error_result(MISSING_PARAMETER) if mobile.blank? || password.blank?

        user = User.by_mobile(mobile)
        # 判断该用户是否存在
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        salted_passwd = ::Digest::MD5.hexdigest(password + user.password_salt)
        unless salted_passwd.eql?(user.password)
          return ApiResult.error_result(PASSWORD_NOT_MATCH)
        end

        # 刷新上次访问时间
        user.touch_visit!

        # 生成用户令牌
        app_access_token = AppAccessToken.from_credential(CurrentRequestCredential, user.user_uuid)
        LoginResultHelper.call(user, app_access_token)
      end
    end
  end
end

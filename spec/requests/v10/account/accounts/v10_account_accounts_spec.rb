require 'rails_helper'

RSpec.describe "/v10/register (AccountsController)", :type => :request do
  let(:http_headers) do
    {
        ACCEPT: "application/json",
        HTTP_ACCEPT: "application/json"
    }
  end

  context "注册失败 传递不合法的注册类型" do
    it "应当返回 code: 1100002 (UNSUPPORTED_TYPE)" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "invalid", mobile: "13833337890" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100002)
    end
  end

  context "注册时传递过来的手机号码格式不正确 应当返回code=1100012" do
    it "手机号为空" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "mobile", mobile: "" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100012)
    end

    it "手机号小于11位" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "mobile", mobile: "1367878999" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100012)
    end

    it "手机号大于11位" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "mobile", mobile: "136787899990" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100012)
    end

    it "手机号格式不对" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "mobile", mobile: "12345678912" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100012)
    end
  end

  context "手机号码格式正确 注册成功" do
    it "应当返回code: 0" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "mobile", mobile: "13713662222" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(0)
      expect(json["data"]["user_id"]).to be_truthy
      expect(json["data"]["nick_name"].nil?).to be_falsey
      expect(json["data"]["gender"]).to eq(2)
      expect(json["data"]["mobile"]).to eq("13713662222")
      expect(json["data"]["email"].nil?).to be_falsey
      expect(json["data"]["avatar"].nil?).to be_falsey
      expect(json["data"]["reg_date"]).to be_truthy
      expect(json["data"]["last_visit"]).to be_truthy
    end
  end

  context "注册时传递过来的邮箱格式不正确 应当返回code=1100011" do
    it "邮箱格式不正确" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "email", email: "aqq.com", password: "test123" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100011)
    end

    it "邮箱格式不正确" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "email", email: "aqq@.com", password: "test123" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100011)
    end
  end

  context "邮箱格式正确 密码为空" do
    it "邮箱格式不正确" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "email", email: "aa@qq.com", password: "" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100015)
    end
  end

  context "邮箱注册成功" do
    it "应当返回code: 0" do
      post v10_register_url,
           headers: http_headers,
           params: { type: "email", email: "aa@qq.com", password: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(0)
      expect(json["data"]["user_id"]).to be_truthy
      expect(json["data"]["nick_name"].nil?).to be_falsey
      expect(json["data"]["gender"]).to eq(2)
      expect(json["data"]["mobile"].nil?).to be_falsey
      expect(json["data"]["email"]).to eq("aa@qq.com")
      expect(json["data"]["avatar"].nil?).to be_falsey
      expect(json["data"]["reg_date"]).to be_truthy
      expect(json["data"]["last_visit"]).to be_truthy
    end
  end
end
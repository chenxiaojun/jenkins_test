json.user_id      user.user_uuid
json.nick_name    user.nick_name.to_s
json.gender       user.gender
json.mobile       user.mobile.to_s
json.email        user.email.to_s
json.avatar       user.avatar_path.to_s
json.reg_date     user.reg_date.to_i
json.last_visit   user.last_visit.to_i
json.signature    user.signature.to_s

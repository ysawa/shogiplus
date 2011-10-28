# -*- coding: utf-8 -*-

require 'fakeweb'

FakeWeb.register_uri(
  :get,
  %r|^https://graph\.facebook\.com/oauth/access_token|,
  body: 'access_token=access_token&expires=5108'
)

FakeWeb.register_uri(
  :get,
  %r|^https://graph\.facebook\.com/\w+$|,
  body: <<-EOS
{
  "id": "123456789",
  "name": "Taro Tanaka",
  "first_name": "Taro",
  "last_name": "Tanaka",
  "link": "http://www.facebook.com/profile.php?id=123456789",
  "bio": "I am Taro Tanaka.",
  "gender": "male",
  "email": "taro@example.com",
  "timezone": 9,
  "locale": "ja_JP",
  "languages": [
    {
      "id": "109549852396760",
      "name": "Japanese"
    }
  ],
  "verified": true,
  "updated_time": "2011-10-04T14:09:12+0000",
  "type": "user"
}
EOS
)

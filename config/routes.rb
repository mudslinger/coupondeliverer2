Rails.application.routes.draw do

  #社内用トップメッセージ
  constraints host: 'topmessages.yamaokaya.com' do
    get '/wb/:type/:key(.:format)' => 'topmessages#show',as: :top_messages
  end
  constraints host: 'topmessages2.yamaokaya.com' do
    get '/wb/:type/:key(.:format)' => 'topmessages#show',as: :top_messages2
  end

  #クーポン配信
  constraints host: 'deliver.coupon.yamaokaya.com' do
    get 'cb/use/:coupon_code/:no(.:format)' => 'deliver#use'
  end
  constraints host: 'deliver2.coupon.yamaokaya.com' do
    get 'cb/use/:coupon_code/:no(.:format)' => 'deliver#use'
  end
end

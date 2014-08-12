Rails.application.routes.draw do

  get '/wb/:type/:key(.:format)' => 'topmessages#show',as: :top_messages
  get 'cb/use/:coupon_code/:no(.:format)' => 'deliver#use',as: :use_coupon

end

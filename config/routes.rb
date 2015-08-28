Rails.application.routes.draw do

  get '/wb/:type/:key(.:format)' => 'topmessages#show',as: :top_messages
  get '/wb/all(.:format)' => 'topmessages#show_all',as: :top_messages_all
  get 'cb/use/:coupon_code/:no(.:format)' => 'deliver#use',as: :use_coupon

end
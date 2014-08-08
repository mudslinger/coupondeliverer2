Rails.application.routes.draw do

  #クーポン配信
  get 'cb/use/:coupon_code/:no(.:format)' => 'deliver#use'

end

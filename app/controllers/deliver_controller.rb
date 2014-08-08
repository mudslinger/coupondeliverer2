class DeliverController < ApplicationController
  FAR_FEATURE = Time.mktime(2099, 12, 31).freeze
  layout false
  def use
    user_number = params[:no]
    @coupon_code = params[:coupon_code]
    coupon_name = nil
    #クーポンコードのフォーマット
    #[任意のコード]_cpn_yyyyMMdd
    begin
      ymd_str = @coupon_code.split('_cpn_').last
      coupon_name = @coupon_code.split('_cpn_').first
      ymd = Date.strptime(ymd_str,'%Y%m%d')
    rescue
      #十分な未来を指定
      ymd = FAR_FEATURE
    end
    @expired = 0.days.ago >= ymd + 1.days
    #使用履歴を保存
    # log(
    #   'blayn.coupon.use.history',
    #   {
    #     user_number: user_number,
    #     coupon_name: coupon_name,
    #     remote_ip: request.remote_ip
    #   }
    # ) if not @expired

  end
end

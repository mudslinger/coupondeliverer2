class TopmessagesController < ApplicationController
  layout false

  def show
    response.headers.except! 'X-Frame-Options'
    response.headers.except! 'Access-Control-Allow-Origin'
    response.headers.except! 'Access-Control-Allow-Headers'
    response.headers.except! 'Access-Control-Allow-Methods'
    
    response.headers["X-Frame-Options"] = 'ALLOW-FROM http://ec9.winboard.jp/'
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    response.headers["Access-Control-Allow-Methods"] = "GET"
    
    @type = params[:type].to_sym if  params[:type].present?
    @key = 0
    @key = params[:key].to_i if params[:key].present?
    
    list = TopMessage.articles(@type)
    @entry = list[@key]
    @prev_entry = @key == 0 ? nil : list[@key-1]
    @next_entry = @key < list.size ? list[@key+1] : nil
  end
end

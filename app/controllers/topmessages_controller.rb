class TopmessagesController < ApplicationController
  layout false

  def set_header(xframeOption)
    response.headers.except! 'X-Frame-Options'
    response.headers.except! 'Access-Control-Allow-Origin'
    response.headers.except! 'Access-Control-Allow-Headers'
    response.headers.except! 'Access-Control-Allow-Methods'
    
    response.headers["X-Frame-Options"] = xframeOption
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    response.headers["Access-Control-Allow-Methods"] = "GET"
  end

  def show    
    set_header 'ALLOW-FROM http://ec9.winboard.jp/'

    @type = params[:type].to_sym if  params[:type].present?
    @key = 0
    @key = params[:key].to_i if params[:key].present?
    
    list = TopMessage.articles(@type)
    @entry = list[@key]
    @prev_entry = @key == 0 ? nil : list[@key-1]
    @next_entry = @key < list.size ? list[@key+1] : nil
  end

  def show_all
    set_header 'ALLOW-FROM http://winboardkintai.yamaokaya.biz/'

    @types = {president: 0,md144: 0,notice:0,magazine:0}
    params.each do |k,v|
        @types[k.to_sym] = v.to_i if v =~ /[0-9]/
    end if params.present?
    puts @types
    @entries = @types.map { |k,v| 
        articles = TopMessage.articles(k)
        [   
            k,
            {
                current: articles[v],
                prev: v == 0 ? nil : articles[v-1],
                next: v < articles.size ? articles[v+1] : nil,
                idx: v
            }
            
        ]
    }.to_h
  end
end

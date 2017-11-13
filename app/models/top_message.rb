class TopMessage
  include ActiveModel::Model
  attr_accessor(
    :original_url,
    :entry_type,
    :title,
    :body,
    :created_at,
    :updated_at,
    :id
  )
  TYPES = {
    president: {
      name: "Microsoft.SharePoint.DataService.社長メッセージItem",
      uri: "https://yamaokaya1.sharepoint.com/_vti_bin/listdata.svc/社長メッセージ()"
    },
    md144: {
      name: "Microsoft.SharePoint.DataService.専務メッセージItem",
      uri: "https://yamaokaya1.sharepoint.com/_vti_bin/listdata.svc/専務メッセージ()"
    },
    magazine: {
      name: "Microsoft.SharePoint.DataService.社内報",
      uri: "https://yamaokaya1.sharepoint.com/_vti_bin/listdata.svc/社内報()"
    },
    notice: {
      name: "Microsoft.SharePoint.DataService.連絡通達Item",
      uri: "https://yamaokaya1.sharepoint.com/_vti_bin/listdata.svc/連絡通達()"
    }
  }.freeze

  def icon
    case self.entry_type
      when "Microsoft.SharePoint.DataService.社長メッセージItem"
        "wb/ymticon.png"
      when "Microsoft.SharePoint.DataService.専務メッセージItem"
        "wb/144icon.png"
      when "Microsoft.SharePoint.DataService.社内報Item"
        "wb/hqicon.png"
      when "Microsoft.SharePoint.DataService.連絡通達Item"
        "wb/hqicon.png"

    end
  end

  def src_uri
    "https://yamaokaya1.sharepoint.com/Lists/#{self.src_type}/DispForm.aspx?ID=#{self.id}"
  end

  def src_type
    case self.entry_type
      when "Microsoft.SharePoint.DataService.社長メッセージItem"
        "President"
      when "Microsoft.SharePoint.DataService.専務メッセージItem"
        "Md144"
      when "Microsoft.SharePoint.DataService.社内報Item"
        "Notify"
      when "Microsoft.SharePoint.DataService.連絡通達Item"
        "Magazine"
    end
  end

  def self.articles(type)
    Rails.cache.fetch(topmessage_type: type,expires_in: 4.minutes) do
      dtmp = Date.today.strftime('%Y-%m-%d')
      TopMessage.load("#{TYPES[type][:uri]}?$filter=公開日 gt DateTime'#{dtmp}'&$orderby=更新日時 desc&$top=50") if type == :president
      TopMessage.load("#{TYPES[type][:uri]}?$orderby=更新日時 desc&$top=50") unless type == :president 
    end
  end

  def self.load(uri)
    json = RestClient.get(
      URI::encode(uri),
      {
        :accept => "application/json",
        :Cookie => TopMessage.authenticate
      }
    )
    jsons = JSON.parse(json)["d"]
    #取得したデータを登録
    list = []
    return jsons.map do |j|
      type = j["__metadata"]["type"]
      local_id = j['ID']
      j["作成日時"] =~ /\/Date\(([0-9]+)\)\//
      local_created_at = ($1.to_i / 1000)
      j["更新日時"] =~ /\/Date\(([0-9]+)\)\//
      local_updated_at = ($1.to_i / 1000)
      TopMessage.new(
        original_url: j["__metadata"]["uri"],
        entry_type: j["__metadata"]["type"],
        title: j["タイトル"],
        body: j["本文"],
        created_at: local_created_at,
        updated_at: local_updated_at,
        id: j['ID']
      )
    end
  end

  def self.authenticate
    xml = RestClient.post(
      "https://login.microsoftonline.com/extSTS.srf",
      SPO_AUTHXML,
      content_type: "application/x-www-form-urlencoded",
      user_agent: 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)'
    )
    doc = ActiveSupport::XmlMini.parse(xml)
    token = doc['Envelope']['Body']['RequestSecurityTokenResponse']['RequestedSecurityToken']['BinarySecurityToken']['__content__']

    #tokenをキーにしてクッキーをゲット
    RestClient.post(
      "https://yamaokaya1.sharepoint.com/_forms/default.aspx?wa=wsignin1.0",
      token,
      {
        :content_type => "application/x-www-form-urlencoded",
        :user_agent => 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)'
      }
    ){ |response, request, result|
      if [301, 302, 307].include? response.code
        str = ""
        response.headers[:set_cookie].each do |s|
          str << s << "; " if s =~ /^FedAuth/
          str << s << "; " if s =~ /^rtFa/
        end
        return str
      end
    }
  end

  def new?
    Time.at(self.updated_at) > 3.days.ago
  end

end

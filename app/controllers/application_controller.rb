class ApplicationController < ActionController::Base
  include MakeSql

  protect_from_forgery with: :exception


  after_action :flash_to_headers#←非同期表示後のフラッシュメッセージ
      #
      # include MakeSql
  # include SqlMakr

  private
  ##########↓非同期表示後のフラッシュメッセージ
  def flash_to_headers
    return unless request.xhr?

    response.headers['X-Flash-Messages'] = flash_json

    # ページをリロードした際に flash メッセージが残ってしまうのを防ぐ。
    flash.discard
  end

  def flash_json
    flash.inject({}) do |hash, (type, message)|
      # XSS 対策を施す。
      message = "#{ERB::Util.html_escape(message)}"
      # 日本語のメッセージをレスポンスヘッダに含めるために URL エンコードしておく。
      message = URI.escape(message)
      hash[type] = message
      hash
    end.to_json
  end
  ##########↑非同期表示後のフラッシュメッセージ

end

module ApplicationHelper


  #モデル（あるいはそれが格納された変数（特にインスタンス変数を想定））の情報をもとに、
  #そのもととなる情報の日本語名を返す……エラーメッセージ表示などでの使用を想定
  def get_tablename_by_model(model_info)

    case model_info.model_name.name
      when "Task"
        return t('activerecord.models.task')
        #return "タスク"

      when "User"
        return t('activerecord.models.user')
        #return "ユーザー"
      # when "Task_tag"
      #   return "タスクラベル"
      # when "Tag"
      #   return "ラベル"

      else
        return  t('activerecord.models.no_model')
        # return "「get_tablename_by_model」で想定されていない種類のテーブル"

    end
  end

  #「自身の値」と「ラジオボックスの値」が一致しているかどうかを見て、そのラジオボックスをチェックすべきかどうか判断する
  def judge_radio_checkd(my_value,radio_value)
    if my_value == radio_value
      return  {:checked => true}
    else
      return {}
    end
  end

  #権限の有無をチェック
  #……画面のボタン表示判断やボタンを押した後の画面表示可否判断に使用する。
  def have_authorioty?(changeinfo_userid = nil)
    if logged_in? == false
      #そもそもログインしていなければ、F
      return false
    else
      #変更する情報の「ユーザーid」を持っていない場合→Tを返す
      #(この場合、ログインしているかどうかだけを判断)
      if changeinfo_userid == nil
        return true
      else
        #自分（＝ログインしるユーザー）のidが変更情報のidと一致すればT、異なればFを返す
        if current_user.id.to_s == changeinfo_userid.to_s
          return true
        else
          return false
        end
      end
    end
  end

end

module ApplicationHelper
  #モデル（あるいはそれが格納された変数（特にインスタンス変数を想定））の情報をもとに、
  #そのもととなる情報の日本語名を返す……エラーメッセージ表示などでの使用を想定
  def get_tablename_by_model(model_info)

    case model_info.model_name.name
      when "User"
        return "ユーザー"
      when "Task"
        return "タスク"
      when "Task_tag"
        return "タスクラベル"
      when "Tag"
        return "ラベル"
      else
        return "「get_tablename_by_model」で想定されていない種類のテーブル"
    end
  end
end

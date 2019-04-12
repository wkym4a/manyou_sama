class Task < ApplicationRecord

  ########↓バリデーション情報↓########

  #ユーザーIDは入力必須
  #……にする予定だが、対応するユーザーテーブルがまだ作成されていないので一時的にバリデーションを無効化しておく。
  #validates :user_id, presence: true
  
  validates :user_id, presence: true
  validates :name, presence: true  , length: {maximum:20}
  validates :content, length: {maximum:120}

  ########↑バリデーション情報↑########

  ########↓モデルについてのメソッド↓########

  ##--↓名称取得用↓--##

  #DBに登録してある「優先度」情報（integer型）から、対応する「優先度」名称を取得する
  #第二引数「return_type」について
  #         0:「S」「A」「B」「C」といった記号のみを返す
  #         1:「S……最優先」といった日本語による説明書きを含めた情報を返す
  def self.get_priority_name(n , return_type = 0)
    case n
    when 0 then
      if return_type==0
        return "S"
      else
        return "S……最優先"
      end

    when 1 then
      if return_type==0
        return "A"
      else
        return "A……重要"
      end

    when 2 then
      if return_type==0
        return "B"
      else
        return "B……通常"
      end

    when 3 then
      if return_type==0
        return "C"
      else
        return "C……後回し可能"
      end

    else
      return "「優先度」情報が不正です。"
    end

  end

  #DBに登録してある「進捗状態」情報（integer型）から、対応する「状態」名称を取得する
  def self.get_status_name(n)
      case n
      when 0 then
        return "未着手"

      when 1 then
        return "作業中"

      when 9 then
        return "完了"

      else
        return "「進捗状態」情報が不正です。"
      end

  end

end

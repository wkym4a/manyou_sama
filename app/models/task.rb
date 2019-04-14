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
        return I18n.t('priority.priority_S')
      end

    when 1 then
      if return_type==0
        return "A"
      else
        return I18n.t('priority.priority_A')
      end

    when 2 then
      if return_type==0
        return "B"
      else
        return I18n.t('priority.priority_B')
      end

    when 3 then
      if return_type==0
        return "C"
      else
        return I18n.t('priority.priority_C')
      end

    else
      return I18n.t("errors.messages.is_invalid_info", this: I18n.t('activerecord.attributes.task.priority'))
    end

  end

  #DBに登録してある「進捗状態」情報（integer型）から、対応する「状態」名称を取得する
  def self.get_status_name(n)
      case n
      when 0 then
        return I18n.t('status.status_0')

      when 1 then
        return I18n.t('status.status_1')

      when 9 then
        return I18n.t('status.status_9')

      else
        return I18n.t("errors.messages.is_invalid_info", this: I18n.t('activerecord.attributes.task.status'))
      end

  end

end

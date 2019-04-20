class Task < ApplicationRecord

    include MakeSql
  ########↓バリデーション情報↓########

  #ユーザーIDは入力必須
  #……にする予定だが、対応するユーザーテーブルがまだ作成されていないので一時的にバリデーションを無効化しておく。
  #validates :user_id, presence: true

  validates :user_id, presence: true
  validates :name, presence: true  , length: {maximum:20}
  validates :content, length: {maximum:120}

  ########↑バリデーション情報↑########

  def search_tasks(conditions)

    s = " select tasks.id"
    s += " ,tasks.user_id"
    s += " ,tasks.name"
    s += " ,tasks.content"
    s += " ,tasks.limit"
    s += " ,tasks.priority"
    s += " ,tasks.status"
    s += " ,tasks.created_at"
    s += " ,tasks.updated_at"
    s += " from tasks"
    s += " where 1 = 1"
    #仕事名（部分一致）
    s = sql_add_condition(s , col_name: :name , condition: conditions[:name] , search_type: 3)
    #内容詳細（部分一致）
    s = sql_add_condition(s , col_name: :content , condition: conditions[:content] , search_type: 3)
    #期限
    s = sql_add_condition_date_fromto(s , col_name: "tasks.limit" ,
       condition_from: conditions[:limit_from] , condition_to: conditions[:condition_to] ,
       null_only: conditions[:no_limit])
    #進捗
    status_condition = [[0,conditions[:status_0]],[1,conditions[:status_1]],[9,conditions[:status_9]]]
    s = sql_add_condition_check(s , col_name: :status , condition: status_condition)
    #重要度
    priority_condition = [[0,conditions[:priority_0]],[1,conditions[:priority_1]],
                        [2,conditions[:priority_2]],[3,conditions[:priority_3]]]
    s = sql_add_condition_check(s , col_name: :priority , condition: priority_condition)

    s += get_sort_info(conditions[:sort])
    
    Task.find_by_sql(s)

  end

  def get_sort_info(sort_type)

    case sort_type

    when "tasks_id_asc"
      return " order by tasks.id asc "
    when "tasks_id_desc"
      return " order by tasks.id desc "
    when "users_id_asc"
      return " order by tasks.users_id asc "
    when "users_id_desc"
      return " order by tasks.users_id desc "
    when "tasks_name_asc"
      return " order by tasks.name asc "
    when "tasks_name_desc"
      return " order by tasks.name desc "
    when "tasks_content_asc"
      return " order by tasks.content asc "
    when "tasks_content_desc"
      return " order by tasks.content desc "
    when "tasks_limit_asc"
      return " order by tasks.limit asc "
    when "tasks_limit_desc"
      return " order by tasks.limit desc "
    when "tasks_priority_asc"
      return " order by tasks.priority asc "
    when "tasks_priority_desc"
      return " order by tasks.priority desc "
    when "tasks_status_asc"
      return " order by tasks.status asc "
    when "tasks_status_desc"
      return " order by tasks.status desc "
    when "tasks_created_at_asc"
      return " order by tasks.created_at asc "
    when "tasks_created_at_desc"
      return " order by tasks.created_at desc "
    when "tasks_updated_at_asc"
      return " order by tasks.updated_at asc "
    when "tasks_updated_at_desc"
      return " order by tasks.updated_at desc "
    else
      return ""
    end

  end

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

class Task < ApplicationRecord

  include MakeSql
  ########↓バリデーション情報↓########

  #ユーザーIDは入力必須
  #……にする予定だが、対応するユーザーテーブルがまだ作成されていないので一時的にバリデーションを無効化しておく。
  #validates :user_id, presence: true

  validates :user_id, presence: true
  validates :name, presence: true  , length: {maximum:20}
  validates :content, length: {maximum:120}

  validate :tag_not_deplicate
  ########↑バリデーション情報↑########

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  belongs_to :user
  has_many :task_tags , dependent: :destroy
  # nestedfieldの使用にあたり、↓を追記
  accepts_nested_attributes_for :task_tags, allow_destroy: true

  has_many :pasted_tags , through: :task_tags , source: :tag
  ####↑↑↑↑アソシエーション情報↑↑↑↑############

  ########↓scope……使わないけど練習用に↓########
  scope :name_like, -> name {where(" name like ? ", "%#{name}%")}

  scope :status_is, -> status {where(" status = ? ", "#{status}" )}
  ########↑scope……使わないけど練習用に↑########

  def tag_not_deplicate

    #「今回登録しようとしているタグ」を集める枠を用意する
    tags_try_to_save=[]

    task_tags.each do |task_tag|
      #「_destroy」ではない→「今回登録しようとしているタグ」であるならば
      if task_tag._destroy == false
        #そのタグidを枠に格納
        tags_try_to_save.push(task_tag["tag_id"] )
      end
    end

    #「tags_try_to_save」をgroup_byし、「一つだけしかなかったものを排除
    # => タグが重複していなければ、「排除」後は空っぽになるはず
    # => 「排除」後も空でなければ、【重複によるエラー】とする。
    if tags_try_to_save.group_by{|i| i}.reject{|k,v| v.one?}.present?

      errors.add(" ",I18n.t('activerecord.attributes.tag.errors.duplicate'))
    end

  end

  def search_tasks(conditions)

    sql = " select max(tasks.id) as id "
    sql += " ,max(tasks.user_id) as user_id "
    sql += " ,max( concat(users.cd ,':', users.name)) as user_info"
    sql += " ,max(tasks.name) as name "
    sql += " ,max(tasks.content) as content "
    sql += " ,max(tasks.limit) as limit "
    sql += " ,max(tasks.priority) as priority "
    sql += " ,max(tasks.status) as status "
    sql += " ,max(tasks.created_at) as created_at "
    sql += " ,max(tasks.updated_at) as updated_at "
    sql += " ,count(task_tags.id) as tag_count "

    sql += " from tasks"
    sql += " inner join users"
    sql += " on tasks.user_id = users.id"
    sql += " left join task_tags"
    sql += " on tasks.id = task_tags.task_id"
    sql += " left join tags"
    sql += " on task_tags.tag_id = tags.id"
    sql += " where 1 = 1"
    # sql = " select tasks.id"
    # sql += " ,tasks.user_id"
    # sql += " , concat(users.cd ,':', users.name) as user_info"
    # sql += " ,tasks.name"
    # sql += " ,tasks.content"
    # sql += " ,tasks.limit"
    # sql += " ,tasks.priority"
    # sql += " ,tasks.status"
    # sql += " ,tasks.created_at"
    # sql += " ,tasks.updated_at"
    # sql += " from tasks"
    # sql += " inner join users"
    # sql += " on tasks.user_id = users.id"
    # sql += " where 1 = 1"

    sql_groupby = " group by tasks.id,tasks.user_id,concat(users.cd ,':', users.name),tasks.name"
    sql_groupby += ",tasks.content,tasks.limit,tasks.priority,tasks.status,tasks.created_at,tasks.updated_at "

    if not conditions.blank?
      #(タスクの)id（完全一致）
      sql = sql_add_condition(sql , col_name: "tasks.id" , condition: conditions[:id] , search_type: 0)
      #ユーザーコード（完全一致）
      sql = sql_add_condition(sql , col_name: "users.cd" , condition: conditions[:user_cd] , search_type: 0)
      #仕事名（部分一致）
      sql = sql_add_condition(sql , col_name: "tasks.name" , condition: conditions[:name] , search_type: 3)
      #内容詳細（部分一致）
      sql = sql_add_condition(sql , col_name: "tasks.content" , condition: conditions[:content] , search_type: 3)
      #期限
      sql = sql_add_condition_date_fromto(sql , col_name: "tasks.limit" ,
         condition_from: conditions[:limit_from] , condition_to: conditions[:limit_to] ,
         null_only: conditions[:no_limit])
      #進捗
      status_condition = [[0,conditions[:status_0]],[1,conditions[:status_1]],[9,conditions[:status_9]]]
      sql = sql_add_condition_check(sql , col_name: "tasks.status" , condition: status_condition)
      #重要度
      priority_condition = [[0,conditions[:priority_0]],[1,conditions[:priority_1]],
                          [2,conditions[:priority_2]],[3,conditions[:priority_3]]]
      sql = sql_add_condition_check(sql , col_name: "tasks.priority" , condition: priority_condition)
      #ラベル名（部分一致）
      sql = sql_add_condition(sql , col_name: "tags.name" , condition: conditions[:tag_name] , search_type: 3)
      sql += sql_groupby

      sql += get_sort_info(conditions[:sort])

    else
      sql += sql_groupby

    end

    Task.find_by_sql(sql)

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
    when "users_cd_asc"
      return " order by users.cd asc "
    when "users_cd_desc"
      return " order by users.cd desc "
    when "tag_count_asc"
      return " order by count(task_tags.id) asc "
    when "tag_count_desc"
      return " order by count(task_tags.id) desc "
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

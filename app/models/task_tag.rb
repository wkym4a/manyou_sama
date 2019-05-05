class TaskTag < ApplicationRecord

  ########↓バリデーション情報↓########
  # validates :task_id,  uniqueness: { scope: :tag_id}
  #↑だとうまく働いてくれないことがあるので、独自バリデーションをタスクモデル側で貼ることにする。
  ########↑バリデーション情報↑########

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  belongs_to :task
  belongs_to :tag
  ####↑↑↑↑アソシエーション情報↑↑↑↑############

end


FactoryBot.define do
  factory :task do
    user_id {1}
    name {:aaaa}
    #name "aaaa" ←これだとだめな模様
    content{"仕事内容しょうさい詳細"}
    limit {1.week.from_now}
    # content{:仕事内容しょうさい詳細}
    #limit ｛1.week.from_now｝
  end
end

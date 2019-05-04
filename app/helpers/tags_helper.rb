module TagsHelper

  def get_tags_as_selectbox_info
# [["a",1],["b",2],["c",3],["d",4]]
    tags = Tag.all.order(cd: "ASC")
    selectbox_info = []

    tags.each do |tag|
      # 表示形式は「コード：名称」、登録はidで行う。
      selectbox_info.push(["#{tag.cd}:#{tag.name}",tag.id])
    end
    return selectbox_info
  end

end

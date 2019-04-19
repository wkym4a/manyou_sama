$(document).ready(function(){
// function setup() {

    $('#datetimepicker4').datetimepicker({
        format: 'L'
    });

    //↓from〜toのtoで使用
    $('#datetimepicker4_2').datetimepicker({
        format: 'L'
    });

    //テーブル内に配置するソート（実質はorder_by条件を変えた再検索）用の動作（起動はjs) は、
    //非同期による読み込み時に再読込されるよう、「views/tasks/index_box.js.erb」でも記述する。
    $('.btn_sort').click(function() {

      var sort_info_box = document.getElementById("sort_type_hidden");
      sort_info_box.value = this.id;

      var btn_search = document.getElementById("btn_search_tasks");
      btn_search.click();
    });

});

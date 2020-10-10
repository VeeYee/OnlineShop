<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<body class="easyui-layout">
	<!-- 整个页面的总体框架 -->
	<div class="easyui-layout" data-options="fit:true">
	    <!-- 增删改查按钮显示部分 -->
	    <div id="wu-toolbar">
	        <div class="wu-toolbar-button">
	        	<%@ include file ="../common/menus.jsp"%>
	        </div>
	        <div class="wu-toolbar-search">
	            <label>日志内容：</label><input id="search-name" class="wu-text" style="width:100px">
	            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search" >搜索</a>
	        </div>
	    </div>
	    <!-- 列出所有记录的表格 -->
	    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
	</div>
	
	<!-- 添加新的日志信息的对话框 -->
	<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:480px; padding:10px;">
		<form id="add-form" method="post">
			<!-- table中每个输入框的name属性值要和数据库中保持一致，这样才能使用框架中的序列化方法，自动拼接成键值对方便插入数据库 -->
	        <table> 
	        	<tr>
	                <td align="right">日志内容:</td>
	                <td><textarea name="content" rows="6" class="wu-textarea" style="width:350px"></textarea></td>
	            </tr>
	        </table>
	    </form>
	</div>
	<%@ include file ="../common/footer.jsp"%>
	
	<!-- 以下是js部分 （以下所有的url都可将../../admin/log/去掉）-->
	<script type="text/javascript">
//---增
		//打开添加窗口的方法
		function openAdd(){
			$('#add-form').form('clear');  //每次打开前先清除上一次填写的数据
			$('#add-dialog').dialog({
				closed: false,
				modal:true,
		           title: "添加日志",
		           buttons: [{
		               text: '确定',
		               iconCls: 'icon-ok',
		               handler: add   //点击确定按钮，调用下面的add()方法
		           }, {
		               text: '取消',
		               iconCls: 'icon-cancel',
		               handler: function () {
		                   $('#add-dialog').dialog('close');                    
		               }
		           }]
	       });
		}
		
		//添加一条新记录的方法
		function add(){
			var data = $("#add-form").serialize();  
			$.ajax({
				url:'../../admin/log/add',   //请求的路径是 /BaseProjectSSM/admin/log/add
				dataType:'json',
				type:'post',
				data:data,  //传过去一个Log
				success:function(data){
					if(data.type == 'success'){
						$.messager.alert('信息提示','提交成功！','info');
						$('#add-dialog').dialog('close');
						$('#data-datagrid').datagrid('reload');  //添加后重新加载数据
					}else{
						$.messager.alert('信息提示', data.msg, 'warning');
					}
				}
			});
		}
		
//---删
		//删除记录
		function remove(){
			var item = $('#data-datagrid').datagrid('getSelections'); //获取选中的多条记录
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择要删除的数据！','info');
				return;
			}
			$.messager.confirm('信息提示','确定要删除该记录？', function(result){
				if(result){
					//批量删除，拼接id
					var ids = '';
					for(var i=0; i<item.length; i++){
						ids += item[i].id + ',';
					}
					$.ajax({
						url:'../../admin/log/delete',   //请求的路径是 /BaseProjectSSM/admin/menu/delete
						dataType:'json',
						type:'post',
						data:{ids:ids}, //将id传递过去
						success:function(data){
							if(data.type == 'success'){
								$.messager.alert('信息提示','删除成功！','info');
								$('#data-datagrid').datagrid('reload');  //删除后重新加载数据
							}else{
								$.messager.alert('信息提示', data.msg, 'warning');
							}
						}	
					});
				}	
			});
		}
		
//---查		
		//搜索按钮监听
		$("#search-btn").click(function(){
			$('#data-datagrid').datagrid('reload',{
				content:$("#search-name").val()
			});
		});
		
		//日志的时间转换
		function add0(m){return m<10?'0'+m:m }
		function format(shijianchuo){
		//shijianchuo是整数，否则要parseInt转换
			var time = new Date(shijianchuo);
			var y = time.getFullYear();
			var m = time.getMonth()+1;
			var d = time.getDate();
			var h = time.getHours();
			var mm = time.getMinutes();
			var s = time.getSeconds();
			return y+'-'+add0(m)+'-'+add0(d)+' '+add0(h)+':'+add0(mm)+':'+add0(s);
		}
		
		//进入界面时，加载所有的日志数据到表格中
		$('#data-datagrid').datagrid({
			url:'../../admin/log/list',
			rownumbers:true,  //是否显示行号
			singleSelect:false, //单选or多选
			pageSize:20,      //每页最多20条数据      
			pagination:true,  //页导航
			multiSort:true, 
			fitColumns:true,
			fit:true,
			//field的值和数据库中的名一样，自动填充数据
			columns:[[
				{ field:'chk',checkbox:true},
				{ field:'content',title:'日志内容',width:180,sortable:true},  //是否支持排序
				{ field:'createTime',title:'时间',width:100,sortable:true,formatter:function(value,row,index){
					return format(value);
				}},
			]]
		});
	</script>
</body>
</html>
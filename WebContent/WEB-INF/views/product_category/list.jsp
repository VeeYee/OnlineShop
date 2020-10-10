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
	            <label>分类名称：</label><input id="search-name" class="wu-text" style="width:100px">
	            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search" >搜索</a>
	        </div>
	    </div>
	    <!-- 列出所有商品分类的表格 -->
	    <table id="data-datagrid" class="easyui-treegrid" toolbar="#wu-toolbar"></table>
	</div>
	
	<!-- 添加商品分类对话框 -->
	<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:480px; padding:10px;">
		<form id="add-form" method="post">
	        <table>
	        	<tr>
	                <td width="60" align="right">父分类:</td>
	                <td>
	                	<select name="parentId" idField="id" treeField="name" class="easyui-combotree" url="tree_list" panelHeight="auto" style="width:358px">
		            	</select>
		            </td>
	            </tr>
	        	<tr>
	                <td width="60" align="right">分类名称:</td>
	                <td><input type="text" id="add-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写分类名称'" style="width:350px"/></td>
	            </tr> 
	        	<tr>
	                <td align="right">备注:</td>
	                <td><textarea name="remark" id="add-remark" rows="6" class="wu-textarea" style="width:350px"></textarea></td>
	            </tr>
	        </table>
	    </form>
	</div>
	
	<!-- 编辑商品分类对话框 -->
	<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:480px; padding:10px;">
		<form id="edit-form" method="post">
			<input type="hidden" name="id" id="edit-id">
	        <table>
	        	<tr>
	                <td width="60" align="right">父分类:</td>
	                <td>
	                	<select id="edit-parentId" name="parentId" idField="id" treeField="name" class="easyui-combotree" url="tree_list" panelHeight="auto" style="width:358px">
		            	</select>
		            </td>
	            </tr>
	        	<tr>
	                <td width="60" align="right">分类名称:</td>
	                <td><input id="edit-name" type="text" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写分类名称'" style="width:350px"/></td>
	            </tr> 
	        	<tr>
	                <td align="right">备注:</td>
	                <td><textarea id="edit-remark" name="remark" rows="6" class="wu-textarea" style="width:350px"></textarea></td>
	            </tr>
	        </table>
	    </form>
	</div>
	<%@ include file ="../common/footer.jsp"%>
	
	<!-- 以下是js部分 -->
	<script type="text/javascript">
//---增
		//打开添加窗口的方法
		function openAdd(){
			$('#add-dialog').dialog({
				closed: false,
				modal:true,
		           title: "添加商品分类",
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
		           }],
		           onBeforeOpen:function(){
		        	   $("#add-name").val("");
		        	   $("#add-remark").val("");
		           }
	       });
		}
		
		//添加一条新记录的方法
		function add(){
			var validate = $("#add-form").form("validate");
			if(!validate){
				$.messager.alert("消息提醒","请检查你输入的数据","warning");
				return;
			}
			var data = $("#add-form").serialize();  
			$.ajax({
				url:'add',   //也可写成../../admin/product_category/add
				dataType:'json',
				type:'post',
				data:data,  //传过去一个ProductCategory
				success:function(data){
					if(data.type == 'success'){
						$.messager.alert('信息提示','提交成功！','info');
						$('#add-dialog').dialog('close');
						$('#data-datagrid').treegrid('reload');  //添加后重新加载数据
					}else{
						$.messager.alert('信息提示', data.msg, 'warning');
					}
				}
			});
		}
		
//---删
		//删除记录
		function remove(){
			var item = $('#data-datagrid').datagrid('getSelected'); 
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择要删除的数据！','info');
				return;
			}
			$.messager.confirm('信息提示','确定要删除该记录？', function(result){
				if(result){
					$.ajax({
						url:'delete',   //可写成../../admin/product_categroy/delete
						dataType:'json',
						type:'post',
						data:{id:item.id}, //将id传递过去
						success:function(data){
							if(data.type == 'success'){
								$.messager.alert('信息提示','删除成功！','info');
								$('#data-datagrid').treegrid('reload');  
							}else{
								$.messager.alert('信息提示', data.msg, 'warning');
							}
						}	
					});
				}	
			});
		}
		
//---改
		//打开编辑窗口的方法
		function openEdit(){
			var item = $('#data-datagrid').treegrid('getSelected'); //获取选择的行
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择要修改的数据！','info');
				return;
			}
			$('#edit-dialog').dialog({
				closed: false,
				modal:true,
		           title: "编辑商品分类",
		           buttons: [{
		               text: '确定',
		               iconCls: 'icon-ok',
		               handler: edit   //点击确定按钮，调用下面的add()方法
		           }, {
		               text: '取消',
		               iconCls: 'icon-cancel',
		               handler: function () {
		                   $('#edit-dialog').dialog('close');                    
		               }
		           }],
		           onBeforeOpen:function(){
		        	   $("#edit-id").val(item.id);
		        	   $("#edit-parentId").combotree('setValue',item.parentId);
		        	   $("#edit-name").val(item.name);
		        	   $("#edit-remark").val(item.remark);
		           }
	       });
		}
		
		//编辑商品分类
		function edit(){
			var validate = $("#edit-form").form("validate");
			if(!validate){
				$.messager.alert("消息提醒","请检查你输入的数据","warning");
				return;
			}
			var data = $("#edit-form").serialize();  
			$.ajax({
				url:'edit',   //也可写成../../admin/product_category/edit
				dataType:'json',
				type:'post',
				data:data,  
				success:function(data){
					if(data.type == 'success'){
						$.messager.alert('信息提示','提交成功！','info');
						$('#edit-dialog').dialog('close');
						$('#data-datagrid').treegrid('reload');  //添加后重新加载数据
					}else{
						$.messager.alert('信息提示', data.msg, 'warning');
					}
				}
			});
		}		
//---查		
		//搜索按钮监听
		$("#search-btn").click(function(){
			$('#data-datagrid').treegrid('reload',{
				name:$("#search-name").val()
			});
		});
		
		//进入界面时，加载所有的日志数据到表格中
		$('#data-datagrid').treegrid({
			url:'list',
			rownumbers:true,  //是否显示行号
			singleSelect:true, //单选or多选
			pageSize:20,      //每页最多20条数据      
			pagination:true,  //页导航
			multiSort:true, 
			fitColumns:true,
			idField:'id',
			treeField:'name',
			fit:true,
			//field的值和数据库中的名一样，自动填充数据
			columns:[[
				{ field:'name',title:'商品分类名称',width:100,sortable:true},  //是否支持排序
				{ field:'remark',title:'商品分类备注',width:200}
			]]
		});
	</script>
</body>
</html>
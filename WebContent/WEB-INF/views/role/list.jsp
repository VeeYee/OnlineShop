<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<body class="easyui-layout">
	<!-- 整个页面的总体框架 -->
	<div class="easyui-layout" data-options="fit:true">
	    <!-- 增删改查功能部分 -->
	    <div id="wu-toolbar">
	        <div class="wu-toolbar-button">
	            <%@ include file ="../common/menus.jsp"%>
	        </div>
	        <div class="wu-toolbar-search">
	            <label>角色名称：</label><input id="search-name" class="wu-text" style="width:100px">
	            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search">搜索</a>
	        </div>
	    </div>
	    <!-- 列出所有记录的表格 -->
	    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
	</div>
	
	<!-- 添加新的菜单信息的对话框 -->
	<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:430px; padding:10px;">
		<form id="add-form" method="post">
			<!-- table中每个输入框的name属性值要和数据库中保持一致，这样才能使用框架中的序列化方法，自动拼接成键值对方便插入数据库 -->
	        <table> 
	            <tr>
	                <td width="60" align="right">角色名称:</td>
	                <td><input type="text" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写角色名称'"/></td>
	            </tr>
	            <tr>
	                <td align="right">角色备注:</td>
	                <td><textarea name="remark" rows="6" class="wu-textarea" style="width:260px"></textarea></td>
	            </tr>
	        </table>
	    </form>
	</div>
	
	<!-- 修改菜单信息的对话框 -->
	<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:430px; padding:10px;">
		<form id="edit-form" method="post">
			<!-- 设置隐藏域放置主键id的值，根据主键修改信息 -->
	        <input type="hidden" name="id" id="edit-id">
	        <table> 
	            <tr>
	                <td width="60" align="right">角色名称:</td>
	                <td><input type="text" id="edit-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写角色名称'"/></td>
	            </tr>
	            <tr>
	                <td align="right">角色备注:</td>
	                <td><textarea name="remark" id="edit-remark" rows="6" class="wu-textarea" style="width:260px"></textarea></td>
	            </tr>
	        </table>
	    </form>
	</div>
	
	<!-- 编辑角色权限弹框 -->
	<div id="select-authority-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:220px;height:450px; padding:10px;">
		<ul id="authority-tree" url="get_all_menu" checkbox="true"></ul>
	</div>
	
	<%@ include file ="../common/footer.jsp"%>
	
	<!-- 以下是js部分 （以下所有的url都可将../../admin/role/去掉） -->
	<script type="text/javascript">
//---增
		//打开添加窗口的方法
		function openAdd(){
			$('#add-form').form('clear');  //每次打开前先清除上一次填写的数据
			$('#add-dialog').dialog({
				closed: false,
				modal:true,
		           title: "添加信息",
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
			var validate = $("#add-form").form("validate");
			if(!validate){
				$.messager.alert("消息提醒","请检查你输入的数据","warning");
				return;
			}
			var data = $("#add-form").serialize();  
			$.ajax({
				url:'../../admin/role/add',   //请求的路径是 /BaseProjectSSM/admin/menu/add
				dataType:'json',
				type:'post',
				data:data,  //传过去一个Menu
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
			var item = $('#data-datagrid').datagrid('getSelected');
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择要删除的数据！','info');
				return;
			}
			$.messager.confirm('信息提示','确定要删除该记录？', function(result){
				if(result){
					$.ajax({
						url:'../../admin/role/delete',   //请求的路径是 /BaseProjectSSM/admin/menu/delete
						dataType:'json',
						type:'post',
						data:{id:item.id}, //将id传递过去
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
		
//---改		
		//打开修改窗口
		function openEdit(){
			var item = $('#data-datagrid').datagrid('getSelected'); //获取选择的行
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择要修改的数据！','info');
				return;
			}
			$('#edit-dialog').dialog({
				closed: false,  //定义初始化面板（panel）是关闭的。
				modal:true,
	            title: "修改信息",
	            buttons: [{
	                text: '确定',
	                iconCls: 'icon-ok',
	                handler: edit  //调用修改信息的edit()方法
	            }, {
	                text: '取消',
	                iconCls: 'icon-cancel',
	                handler: function () {
	                    $('#edit-dialog').dialog('close');                    
	                }
	            }],
	            onBeforeOpen:function(){  //打开窗口前触发
	            	//将点击的记录的值显示在表格中
	            	$("#edit-id").val(item.id);  //根据主键来修改信息
	            	$("#edit-name").val(item.name);
	            	$("#edit-remark").val(item.remark);
	            }
	        });
		}
		
		//修改角色信息的方法
		function edit(){
			var validate = $("#edit-form").form("validate");
			if(!validate){
				$.messager.alert("消息提醒","请检查你输入的数据","warning");
				return;
			}
			var data = $("#edit-form").serialize();  
			$.ajax({
				url:'../../admin/role/edit',   //请求的路径是 /BaseProjectSSM/admin/menu/edit
				dataType:'json',
				type:'post',
				data:data,  //传过去一个Menu
				success:function(data){
					if(data.type == 'success'){
						$.messager.alert('信息提示','修改成功！','info');
						$('#edit-dialog').dialog('close');
						$('#data-datagrid').datagrid('reload');  //修改后重新加载数据
					}else{
						$.messager.alert('信息提示', data.msg, 'warning');
					}
				}
			});
		}
		
//---查		
		//搜索按钮监听
		$("#search-btn").click(function(){
			$('#data-datagrid').datagrid('reload',{
				name:$("#search-name").val() //传参数name
			});
		});
		
		//进入界面时，加载所有的角色数据到表格中
		$('#data-datagrid').datagrid({
			url:'../../admin/role/list',
			rownumbers:true,  //是否显示行号
			singleSelect:true,  //单选or多选
			pageSize:20,      //每页最多20条数据      
			pagination:true,  //页导航
			multiSort:true, 
			fitColumns:true,
			fit:true,
			//field的值和数据库中的名一样，自动填充数据
			columns:[[
				{ field:'chk',checkbox:true},
				{ field:'name',title:'角色名称',width:100,sortable:true},  //是否支持排序
				{ field:'remark',title:'角色备注',width:180,sortable:true},
				{ field:'icon',title:'权限操作',width:100,formatter:function(value,row,index){
					//添加预览图标的效果
					var test = '<a class="authority-edit" onclick="selectAuthority('+row.id+')"></a>';
					return test;
				}},
			]],
			//数据加载成功后添加一个编辑权限的按钮
			onLoadSuccess:function(data){
				$('.authority-edit').linkbutton({text:'编辑权限',plain:true,iconCls:'icon-edit'});
			}
		});

//---编辑角色权限

		//某个角色已经拥有的权限
		var existAuthority = null;
		function isAdded(row,rows){
			for(var k=0; k<existAuthority.length; k++){
				if(existAuthority[k].menuId == row.id && haveParent(rows,row.parentId))
					return true;
			}
			return false;
		}
		
		//向上判断是否有父分类
		function haveParent(rows,parentId){
			for(var i=0; i<rows.length; i++){
				if (rows[i].id == parentId) {
					if(rows[i].parentId != 0) return true;
				}
			}
			return false;
		}
		
		//打开权限选择框
		function selectAuthority(roleId){
			$('#select-authority-dialog').dialog({
				closed: false,
				modal:true,
	            title: "选择权限信息",
	            buttons: [{
	                text: '确定',
	                iconCls: 'icon-ok',
	                handler:  function(){
	                	//获取选中状态的子节点
	                	var checkedNodes = $("#authority-tree").tree('getChecked');
	                	var ids = '';
	                	for(var i=0; i<checkedNodes.length; i++){
	                		ids += checkedNodes[i].id+",";
	                	}
	                	//获取半选状态（子节点部分选中）的父节点
	                	var checkedParentNodes = $("#authority-tree").tree('getChecked','indeterminate');
	                	for(var i=0; i<checkedParentNodes.length; i++){
	                		ids += checkedParentNodes[i].id+",";
	                	}
	                	if(ids!=''){
	                		$.ajax({
	                			url:'add_authority',
	                			type:'post',
	                			data:{ids:ids,roleId:roleId}, //传入所有选中的菜单id和角色id
	                			dataType:'json',
	                			//接收返回值
	                			success:function(data){
	                				if(data.type=='success'){
	                					$.messager.alert('信息提示',"权限编辑成功！",'info');
	                					$('#select-authority-dialog').dialog('close');
	                				}else{
	                					$.messager.alert('信息提示',data.msg,'warning');
	                				}
	                			}
	                		});
	                	}else{
	                		$.messager.alert('信息提示','请至少选择一条权限！','info');
	                	}
	                }
	            }, {
	                text: '取消',
	                iconCls: 'icon-cancel',
	                handler: function () {
	                    $('#select-authority-dialog').dialog('close');                    
	                }
	            }],
	            //在打开之前获取所有的菜单
	            onBeforeOpen:function(){
	            	//首先获取该角色已经拥有的权限
	            	$.ajax({
	            		url:'get_role_authority',
	            		type:'post',
	            		data:{roleId:roleId},
	            		dataType:'json',
	            		success:function(data){
	            			existAuthority = data;
	            			$("#authority-tree").tree({
	    	            		loadFilter: function(rows){
	    	            			//将数据加载到树上，使用官方api中的方法
	    	            			return convert(rows);
	    	            		}
	    	            	});
	            		}
	            	});
	            }
	        });
		}
		
		//判断是否有父类
		function exists(rows, parentId){
			for(var i=0; i<rows.length; i++){
				if (rows[i].id == parentId) return true;
			}
			return false;
		}
		//将数据加载到复选树上（转换原始数据至符合tree的要求）
		function convert(rows){ //rows中存放所有数据
			var nodes = []; //存放父节点的数组
			for(var i=0; i<rows.length; i++){
				var row = rows[i];
				//遍历所有结点，拿出父节点
				if (!exists(rows, row.parentId)){
					nodes.push({
						id:row.id,
						text:row.name
					});
				}
			}
			//将父节点全部复制到toDo数组中
			var toDo = [];
			for(var i=0; i<nodes.length; i++){
				toDo.push(nodes[i]);
			}
			//遍历父节点，找到所有父节点的子节点
			while(toDo.length){
				var node = toDo.shift();	// the parent node
				for(var i=0; i<rows.length; i++){
					var row = rows[i];
					if (row.parentId == node.id){
						var child = {id:row.id,text:row.name};
						if(isAdded(row,rows)){
							child.checked = true;
						}
						if (node.children){
							node.children.push(child);
						} else {
							node.children = [child];
						}
						//把刚才创建的孩子再添加到父分类的数组中
						toDo.push(child);
					}
				}
			}
			return nodes;
		}
	</script>
</body>
</html>
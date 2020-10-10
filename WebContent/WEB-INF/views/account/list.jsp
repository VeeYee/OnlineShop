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
	            <label>用户名：</label><input id="search-name" class="wu-text" style="width:100px">
	            <label>客户性别：</label>
	            <select id="search-sex" class="easyui-combobox" panelHeight="auto" style="width:80px">
	            	<option value="-1">全部</option>
	            	<option value="0">未知</option>
	            	<option value="1">男</option>
	            	<option value="2">女</option>
	            </select>
	            <label>客户状态：</label>
	            <select id="search-status" class="easyui-combobox" panelHeight="auto" style="width:100px">
	            	<option value="-1">全部</option>
	            	<option value="1">正常</option>
	            	<option value="2">冻结</option>
	            </select>
	            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search" >搜索</a>
	        </div>
	    </div>
	    <!-- 列出所有客户的表格 -->
	    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
	</div>
	
	<!-- 添加客户信息对话框 -->
	<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:420px; padding:10px;">
		<form id="add-form" method="post">
	        <table>
	        	<tr>
	                <td width="60" align="right">用户名:</td>
	                <td><input type="text" id="add-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写客户名'" /></td>
	            </tr>
	            <tr>
	                <td width="60" align="right">密码:</td>
	                <td><input type="password" id="add-password" name="password" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写密码'" /></td>
	            </tr> 
	            <tr>
	                <td width="60" align="right">邮箱:</td>
	                <td><input type="text" id="add-email" name="email" class="wu-text" /></td>
	            </tr> 
	             <tr>
	                <td width="60" align="right">真实姓名:</td>
	                <td><input type="text" id="add-trueName" name="trueName" class="wu-text" /></td>
	            </tr>
	            <tr>
	            	<td width="60" align="right">性别:</td>
	            	<td>
			            <select class="easyui-combobox" name="sex" panelHeight="auto" style="width:268px">
			            	<option value="0">未知</option>
			            	<option value="1">男</option>
			            	<option value="2">女</option>
			            </select> 
		            </td>
	            </tr>
	        	<tr>
	            	<td width="60" align="right">账号状态:</td>
	            	<td>
			            <select class="easyui-combobox" name="status" panelHeight="auto" style="width:268px">
			            	<option value="1">正常</option>
			            	<option value="2">冻结</option>
			            </select> 
		            </td>
	            </tr>
	        </table>
	    </form>
	</div>
	
	<!-- 编辑客户信息对话框 -->
	<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:420px; padding:10px;">
		<form id="edit-form" method="post">
			<input type="hidden" name="id" id="edit-id">
	        <table>
	        	<tr>
	                <td width="60" align="right">用户名:</td>
	                <td><input type="text" id="edit-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写客户名'" /></td>
	            </tr>
	            <tr>
	                <td width="60" align="right">密码:</td>
	                <td><input type="password" id="edit-password" name="password" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写密码'" /></td>
	            </tr> 
	            <tr>
	                <td width="60" align="right">邮箱:</td>
	                <td><input type="text" id="edit-email" name="email" class="wu-text" /></td>
	            </tr> 
	             <tr>
	                <td width="60" align="right">真实姓名:</td>
	                <td><input type="text" id="edit-trueName" name="trueName" class="wu-text" /></td>
	            </tr>
	            <tr>
	            	<td width="60" align="right">性别:</td>
	            	<td>
			            <select id="edit-sex" class="easyui-combobox" name="sex" panelHeight="auto" style="width:268px">
			            	<option value="0">未知</option>
			            	<option value="1">男</option>
			            	<option value="2">女</option>
			            </select> 
		            </td>
	            </tr>
	        	<tr>
	            	<td width="60" align="right">账号状态:</td>
	            	<td>
			            <select id="edit-status" class="easyui-combobox" panelHeight="auto" name="status" style="width:268px">
			            	<option value="1">正常</option>
			            	<option value="2">冻结</option>
			            </select> 
		            </td>
	            </tr>
	        </table>
	    </form>
	</div>
	<%@ include file ="../common/footer.jsp"%>
	
	<!-- 以下是js部分 -->
	<script type="text/javascript">
//---增
		function openAdd(){
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
		           }],
		           onBeforeOpen:function(){
					   $("#add-name").val("");
					   $("#add-password").val("");
					   $("#add-email").val("");
					   $("#add-trueName").val("");
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
				url:'add',   
				dataType:'json',
				type:'post',
				data:data, 
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
						url:'delete',  
						dataType:'json',
						type:'post',
						data:{id:item.id}, //将id传递过去
						success:function(data){
							if(data.type == 'success'){
								$.messager.alert('信息提示','删除成功！','info');
								$('#data-datagrid').datagrid('reload');  
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
			var item = $('#data-datagrid').datagrid('getSelected'); //获取选择的行
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择要修改的数据！','info');
				return;
			}
			$('#edit-dialog').dialog({
				closed: false,  
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
	            	$("#edit-password").val(item.password);
	            	$("#edit-email").val(item.email);
	            	$("#edit-trueName").val(item.trueName);
	            	$("#edit-sex").combobox('setValue',item.sex);
	            	$("#edit-status").combobox('setValue',item.status);
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
				url:'edit',   
				dataType:'json',
				type:'post',
				data:data,  
				success:function(data){
					if(data.type == 'success'){
						$.messager.alert('信息提示','提交成功！','info');
						$('#edit-dialog').dialog('close');
						$('#data-datagrid').datagrid('reload');  //添加后重新加载数据
					}else{
						$.messager.alert('信息提示', data.msg, 'warning');
					}
				}
			});
		}		
//---查		
		//搜索按钮监听
		$("#search-btn").click(function(){
			var option = {name:$("#search-name").val()};
			var sex = $("#search-sex").combobox('getValue');
			if(sex != -1){
				option.sex = sex;
			}
			var status = $("#search-status").combobox('getValue');
			if(status != -1){
				option.status = status;
			}
			$('#data-datagrid').datagrid('reload',option);
		});
		
		//时间转换
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
		
		//加载数据
		$('#data-datagrid').datagrid({
			url:'list',
			rownumbers:true,  //是否显示行号
			singleSelect:true, //单选or多选
			pageSize:20,      //每页最多20条数据      
			pagination:true,  //页导航
			multiSort:true, 
			fitColumns:true,
			nowrap: false,  //换行
			fit:true,
			//field的值和数据库中的名一样，自动填充数据
			columns:[[
				{ field:'chk',checkbox:true},
				{ field:'name',title:'用户名',width:100,sortable:true},  
				{ field:'password',title:'登录密码',width:100},
				{ field:'email',title:'邮箱',width:100},
				{ field:'trueName',title:'真实姓名',width:100},
				{ field:'sex',title:'性别',width:100,formatter:function(value,row,index){
					if(value == 0) return '未知';
					if(value == 1) return '男';
					if(value == 2) return '女';
					return value;
				}},
				{ field:'status',title:'状态',width:100,formatter:function(value,row,index){
					if(value == 1) return '正常';
					if(value == 2) return '冻结';
					return value;
				}},
				{ field:'createTime',title:'注册时间',width:200,formatter:function(value,row,index){
					return format(value);
				}}
			]]
		});
	</script>
</body>
</html>
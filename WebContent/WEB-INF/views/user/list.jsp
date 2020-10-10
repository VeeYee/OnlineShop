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
	            <label>所属角色：</label>
	            <select id="search-role" class="easyui-combobox" panelHeight="auto" style="width:120px">
	            	<option value="-1">全部</option>
	            	<c:forEach items="${roleList }" var="role">
	            		<option value="${role.id }">${role.name }</option>
	            	</c:forEach>
	            </select>
	            <label>性别：</label>
	            <select id="search-sex" class="easyui-combobox" panelHeight="auto" style="width:80px">
	            	<option value="-1">全部</option>
	            	<option value="0">未知</option>
	            	<option value="1">男</option>
	            	<option value="2">女</option>
	            </select>
	            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search" >搜索</a>
	        </div>
	    </div>
	    <!-- 列出所有记录的表格 -->
	    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
	</div>
	
	<!-- 添加新的用户信息的对话框 -->
	<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:480px; padding:10px;">
		<form id="add-form" method="post">
			<!-- table中每个输入框的name属性值要和数据库中保持一致，这样才能使用框架中的序列化方法，自动拼接成键值对方便插入数据库 -->
	        <table cellpadding="3px 15px 0px 0px"> 
	        	<tr>
	                <td width="60" align="right">头像预览:</td>
	                <td align="center">
	                	<img id="preview-photo" src="/OnlineShop/resources/admin/easyui/images/head1.jpg" width="100px"  />
	                	<a style="float:right;margin:40px 70px 0px 0px;" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-upload" onclick="uploadPhoto()" plain="true" style="margin-left:5px;">上传图片</a>
	                </td>
	            </tr>
	        	<tr>
	                <td width="60" align="right">头像:</td>
	                <td><input type="text" id="add-photo" name="photo" readonly="readonly" class="wu-text" value="/OnlineShop/resources/admin/easyui/images/head1.jpg" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td width="60" align="right">用户名:</td>
	                <td><input type="text" id="add-username" name="username" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写用户名'" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td width="60" align="right">密码:</td>
	                <td><input type="password" id="add-password" name="password" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写密码'" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td width="60" align="right">所属角色:</td>
	                <td> 
		                <select name="roleId" class="easyui-combobox easyui-validatebox" panelHeight="auto" style="width:358px" data-options="required:true, missingMessage:'请填写所属角色'" >
			            	<c:forEach items="${roleList }" var="role">
			            		<option value="${role.id }">${role.name }</option>
			            	</c:forEach>
		            	</select>
	            	</td>
	            </tr>
	            <tr>
	                <td width="60" align="right">性别:</td>
	                <td> 
		                <select name="sex" class="easyui-combobox" panelHeight="auto" style="width:358px" >
			            	<option value="0">未知</option>
			            	<option value="1">男</option>
			            	<option value="2">女</option>
		            	</select>
	            	</td>
	            </tr>
	            <tr>
	                <td width="60" align="right">年龄:</td>
	                <td><input type="text" id="add-age" name="age" class="wu-text easyui-numberbox" data-options="min:1,precision:0" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td align="right">地址:</td>
	                <td><input type="text" id="add-address" name="address" class="wu-text" style="width:350px;"/></td>
	            </tr>
	        </table>
	    </form>
	</div>
	<!-- 上传头像的文件选择器 -->
	<input type="file" id="photo-file" style="display:none;" onchange="upload()"/>
	<!-- 上传进度条 -->
	<div id="process-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-upload',title:'正在上传图片'" style="width:430px; padding:10px;">
		<div id="p" class="easyui-progressbar" style="width:400px;"></div>
	</div>
	
	<!-- 修改用户信息的对话框 -->
	<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:480px; padding:10px;">
		<form id="edit-form" method="post">
			<!-- 设置隐藏域放置主键id的值，根据主键修改信息 -->
	        <input type="hidden" name="id" id="edit-id">
	        <table cellpadding="3px 15px 0px 0px">
	        	 <tr>
	                <td width="60" align="right">头像预览:</td>
	                <td align="center">
	                	<img id="edit-preview-photo" src="/OnlineShop/resources/admin/easyui/images/head1.jpg" width="100px"  />
	                	<a style="float:right;margin:40px 70px 0px 0px;" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-upload" onclick="uploadPhoto()" plain="true" style="margin-left:5px;">上传图片</a>
	                </td>
	            </tr>
	            <tr>
	                <td width="60" align="right">头像:</td>
	                <td><input type="text" id="edit-photo" name="photo" readonly="readonly" class="wu-text" value="/OnlineShop/resources/admin/easyui/images/head1.jpg" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td width="60" align="right">用户名:</td>
	                <td><input type="text" id="edit-username" name="username" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写用户名'" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td width="60" align="right">所属角色:</td>
	                <td> 
		                <select id="edit-roleId" name="roleId" class="easyui-combobox easyui-validatebox" panelHeight="auto" style="width:358px" data-options="required:true, missingMessage:'请填写所属角色'" >
			            	<c:forEach items="${roleList }" var="role">
			            		<option value="${role.id }">${role.name }</option>
			            	</c:forEach>
		            	</select>
	            	</td>
	            </tr>
	            <tr>
	                <td width="60" align="right">性别:</td>
	                <td> 
		                <select id="edit-sex" name="sex" class="easyui-combobox" panelHeight="auto" style="width:358px" >
			            	<option value="0">未知</option>
			            	<option value="1">男</option>
			            	<option value="2">女</option>
		            	</select>
	            	</td>
	            </tr>
	            <tr>
	                <td width="60" align="right">年龄:</td>
	                <td><input type="text" id="edit-age" name="age" class="wu-text easyui-numberbox" data-options="min:1,precision:0" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td align="right">地址:</td>
	                <td><input type="text" id="edit-address" name="address" class="wu-text" style="width:350px;"/></td>
	            </tr>
	        </table>
	    </form>
	</div>
	<%@ include file ="../common/footer.jsp"%>
	
	<!-- 以下是js部分 （以下所有的url都可将../../admin/user/去掉） -->
	<script type="text/javascript">
//---增
		//打开添加窗口的方法
		function openAdd(){
			//$('#add-form').form('clear');  //每次打开前先清除上一次填写的数据
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
		        	   //打开添加用户前，先恢复成默认头像
		        	   $("#preview-photo").attr('src',"/OnlineShop/resources/admin/easyui/images/head1.jpg");
					   $("#add-photo").val("/OnlineShop/resources/admin/easyui/images/head1.jpg");
					   $("#add-username").val("");
					   $("#add-password").val("");
					   $("#add-age").val("");
					   $("#add-address").val("");
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
				url:'../../admin/user/add',   //请求的路径是 /OnlineShop/admin/user/add
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
		
		//打开文件选择器，选择头像
		function uploadPhoto(){
			$("#photo-file").click();
		}
		//进度条显示进度的方法
		function start(){
			var value = $('#p').progressbar('getValue');
			if (value < 100){
				value += Math.floor(Math.random() * 10);
				$('#p').progressbar('setValue', value);
			}else{
				$('#p').progressbar('setValue', 0);
			}
		}
		
		//上传头像
		function upload(){
			if($("#photo-file").val()=='') return;
			var formData = new FormData();
			formData.append('photo',document.getElementById('photo-file').files[0]);
			$("#process-dialog").dialog('open');
			//每隔200毫秒刷新进度条
			var interval = setInterval(start,200);
			$.ajax({
				url:'upload_photo',  //此处就相当于../../admin/user/upload
				type:'post',
				data:formData,
				contentType:false,
				processData:false,
				success:function(data){
					//关闭进度条
					clearInterval(interval);
					$("#process-dialog").dialog('close');
					if(data.type == 'success'){
						//更改图片路径为后台传过来的filePath
						$("#preview-photo").attr('src',data.filePath);
						$("#add-photo").val(data.filePath);
						//上传头像后需要把编辑框的图片也更改，这样在打开编辑框时就不是写死的默认的图片路径了
						$("#edit-preview-photo").attr('src',data.filePath);
						$("#edit-photo").val(data.filePath);
					}else{
						$.messager.alert('信息提示', data.msg, 'warning');
					}
				},
				error:function(data){
					$.messager.alert('信息提示', "上传失败！", 'warning');
					clearInterval(interval);
					$("#process-dialog").dialog('close');
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
						url:'../../admin/user/delete',   //请求的路径是 /OnlineShop/admin/menu/delete
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
		
//---改		
		//打开修改窗口
		function openEdit(){
			//获取所有选中的item
			var item = $('#data-datagrid').datagrid('getSelections'); //获取选择的行
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择要修改的数据！','info');
				return;
			}
			if(item.length > 1){
				$.messager.alert('信息提示','请选择一条数据进行修改！','info');
				return;
			}
			item = item[0];  //只能修改一条，取数组第一个
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
	            	$("#edit-preview-photo").attr('src',item.photo);
					$("#edit-photo").val(item.photo);
	            	$("#edit-username").val(item.username);
	            	$("#edit-roleId").combobox('setValue',item.roleId);
	            	$("#edit-sex").combobox('setValue',item.sex);
	            	$("#edit-age").val(item.age);
	            	$("#edit-address").val(item.address);
	            }
	        });
		}
		
		//修改用户信息的方法
		function edit(){
			var validate = $("#edit-form").form("validate");
			if(!validate){
				$.messager.alert("消息提醒","请检查你输入的数据","warning");
				return;
			}
			var data = $("#edit-form").serialize();  
			$.ajax({
				url:'../../admin/user/edit',   //请求的路径是 /OnlineShop/admin/user/edit
				dataType:'json',
				type:'post',
				data:data,  //传过去一个User
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
			var roleId = $("#search-role").combobox('getValue');
			var sex = $("#search-sex").combobox('getValue');
			var option = {username:$("#search-name").val()};
			//等于-1时 值是全部
			if(roleId != -1){
				option.roleId = roleId;
			}
			if(sex != -1){
				option.sex = sex;
			}
			$('#data-datagrid').datagrid('reload',option);
		});
		
		//进入界面时，加载所有的用户数据到表格中
		$('#data-datagrid').datagrid({
			url:'../../admin/user/list',
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
				{ field:'photo',title:'用户头像',width:100,align:'center',formatter:function(value,row,index){
					var img = '<img src="'+value+'" width="50px"/>';
					return img;
				}},
				{ field:'username',title:'用户名',width:100,sortable:true},  //是否支持排序
				{ field:'password',title:'密码',width:100},
				{ field:'roleId',title:'所属角色',width:100,formatter:function(value,row,index){
					//将roleId的数字 转换成具体的角色名
					var roleList = $("#search-role").combobox('getData');
					for(var i=0; i<roleList.length; i++){
						if(value == roleList[i].value)
							return roleList[i].text;
					} 
					return value;
				}},
				{ field:'sex',title:'性别',width:100,formatter:function(value,row,index){
					switch(value){
						case 0:{
							return '未知';
						}
						case 1:{
							return '男';
						}
						case 2:{
							return '女';
						}
					}
					return value;
				}},
				{ field:'age',title:'年龄',width:100},
				{ field:'address',title:'地址',width:200},
			]],
			//数据加载成功后添加一个编辑权限的按钮
			onLoadSuccess:function(data){
				$('.authority-edit').linkbutton({text:'编辑权限',plain:true,iconCls:'icon-edit'});
			}
		});
	</script>
</body>
</html>
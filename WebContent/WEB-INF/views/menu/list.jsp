<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<body>
	<!-- 整个页面的总体框架 -->
	<div class="easyui-layout" data-options="fit:true">
	    <!-- 增删改查功能部分 -->
	    <div id="wu-toolbar">
	        <div class="wu-toolbar-button">
	        	<%@ include file ="../common/menus.jsp"%>
	        </div>
	        <div class="wu-toolbar-search">
	            <label>菜单名称：</label><input id="search-name" class="wu-text" style="width:100px">
	            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search">搜索</a>
	        </div>
	    </div>
	    <!-- 列出所有记录的表格 -->
	    <table id="data-datagrid" class="easyui-treegrid" toolbar="#wu-toolbar"></table>
	</div>
	
	<!-- 添加新的菜单信息的对话框 -->
	<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
		<form id="add-form" method="post">
			<!-- table中每个输入框的name属性值要和数据库中保持一致，这样才能使用框架中的序列化方法，自动拼接成键值对方便插入数据库 -->
	        <table> 
	            <tr>
	                <td width="60" align="right">菜单名称:</td>
	                <td><input type="text" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写菜单名称'"/></td>
	            </tr>
	            <tr>
	                <td align="right">上级菜单:</td>
	                <td>
	                	<select name="parentId" class="easyui-combobox" panelHeight="auto" style="width:268px">
			                <option value="0">顶级分类</option>
			                <c:forEach items="${topList }" var="menu">
			                	<option value="${menu.id }">${menu.name }</option>
			                </c:forEach>
			            </select>
	                </td>
	            </tr>
	            <tr>
	                <td align="right">菜单URL:</td>
	                <td><input type="text" name="url" class="wu-text" /></td>
	            </tr>
	            <tr>
	                <td align="right">菜单图标:</td>
	                <td>
	                	<input type="text" id="add-icon" name="icon" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写菜单图标'"/>
	                	<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="selectIcon()" plain="true">选择</a>
	                </td>
	            </tr>
	        </table>
	    </form>
	</div>
	
	<!-- 添加按钮的弹框 -->
	<div id="add-menu-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
		<form id="add-menu-form" method="post">
			<!-- table中每个输入框的name属性值要和数据库中保持一致，这样才能使用框架中的序列化方法，自动拼接成键值对方便插入数据库 -->
	        <table> 
	            <tr>
	                <td width="60" align="right">按钮名称:</td>
	                <td><input type="text" class="wu-text easyui-validatebox" name="name" data-options="required:true, missingMessage:'请填写按钮名称'"/></td>
	            </tr>
	            <tr>
	                <td align="right">上级菜单:</td>
	                <td>
	                	<input type="hidden" name="parentId" id="add-menu-parent-id">
	                	<input type="text" readonly="readonly" id="parent-menu" class="wu-text easyui-validatebox" />
	                </td>
	            </tr>
	            <tr>
	                <td align="right">按钮事件:</td>
	                <td><input type="text" name="url" class="wu-text" /></td>
	            </tr>
	            <tr>
	                <td align="right">按钮图标:</td>
	                <td>
	                	<input type="text" id="add-menu-icon" name="icon" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写按钮图标'"/>
	                	<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="selectIcon()" plain="true">选择</a>
	                </td>
	            </tr>
	        </table>
	    </form>
	</div>
	
	<!-- 展示所有菜单图标的弹框 -->
	<div id="select-icon-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:820px;height:550px; padding:10px;">
		<table id="icons-table" cellspacing="8">
		</table>
	</div>
	<!-- 选中图标的css样式 -->
	<style>
		.selected{
			background: red;
		}
	</style>
	
	<!-- 修改菜单信息的对话框 -->
	<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
		<form id="edit-form" method="post">
			<!-- 设置隐藏域放置主键id的值，根据主键修改信息 -->
	        <input type="hidden" name="id" id="edit-id">
	        <table> 
	            <tr>
	                <td width="60" align="right">菜单名称:</td>
	                <td><input type="text" id="edit-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写菜单名称'"/></td>
	            </tr>
	            <tr>
	                <td align="right">上级菜单:</td>
	                <td>
	                	<select id="edit-parentId" name="parentId" class="easyui-combobox" panelHeight="auto" style="width:268px">
			                <option value="0">顶级分类</option>
			                <c:forEach items="${topList }" var="menu">
			                	<option value="${menu.id }">${menu.name }</option>
			                </c:forEach>
			            </select>
	                </td>
	            </tr>
	            <tr>
	                <td align="right">菜单URL:</td>
	                <td><input type="text" id="edit-url" name="url" class="wu-text" /></td>
	            </tr>
	            <tr>
	                <td align="right">菜单图标:</td>
	                <td>
	                	<input type="text" id="edit-icon" name="icon" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写菜单图标'"/>
	                	<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="selectIcon()" plain="true">选择</a>
	                </td>
	            </tr>
	        </table>
	    </form>
	</div>
	<%@ include file ="../common/footer.jsp"%>
	
	<!-- 以下是js部分 （以下所有的url都可将../../admin/menu/去掉）-->
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
			/** 
			 * 	将填好的表单数据序列化，会把表单输入框中name属性的值当做键，
			 *	把输入框中填写的内容当做值，自动拼接成键值对的形式
			 */
			var data = $("#add-form").serialize();  
			$.ajax({
				url:'../../admin/menu/add',   //请求的路径是 /BaseProjectSSM/admin/menu/add
				dataType:'json',
				type:'post',
				data:data,  //传过去一个Menu
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
		
		//点击选择菜单图标的方法
		function selectIcon(){
			$('#icons-table').empty();  //先清空表格
			$.ajax({
				url:'../../admin/menu/get_icons',  //获取所有图标的请求
				dataType:'json',
				type:'post',
				success:function(data){  //返回的数据
					if(data.type == 'success'){
						//将获取的所有图标在表格中显示出来
						var icons = data.content;
						var table = '';   //创建一个表格
						for(var i=0; i<icons.length; i++){
							var tbody = '<td class="icon-td"><a onclick="selected(this)" href="javascript:void(0)" class="'+icons[i]+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></td>';
							if(i == 0){
								table += '<tr>'+tbody;
								continue;
							}
							if((i+1)%24 === 0){
								table += tbody +'</tr><tr>';
								continue;
							}
							table += tbody;
						}
						table +='</tr>';
						$('#icons-table').append(table);
					}else{
						$.messager.alert('信息提示',data.msg,'warning');
					}
				}
			});
			//打开选择图标的对话框
			$('#select-icon-dialog').dialog({
				closed: false,
				modal:true,
	            title: "添加icon信息",
	            buttons: [{
	                text: '确定',
	                iconCls: 'icon-ok',
	                handler:  function(){
	                	var icon = $(".selected a").attr('class');
	                	//添加和修改选择图标时调用的是用一个方法
	                	$("#add-icon").val(icon);  //添加菜单时，在添加框中赋值
	                	$("#edit-icon").val(icon);  //修改菜单时,在修改框中赋值
	                	$("#add-menu-icon").val(icon);  
	                	$('#select-icon-dialog').dialog('close');   
	                }
	            }, {
	                text: '取消',
	                iconCls: 'icon-cancel',
	                handler: function () {
	                    $('#select-icon-dialog').dialog('close');                    
	                }
	            }]
	        });
		}
		
		//选中图标更改此图标背景颜色
		function selected(e){
			$(".icon-td").removeClass('selected');
			$(e).parent("td").addClass('selected'); //选中后更改背景颜色
		}
		
		//添加菜单弹框
		function openAddMenu(){
			$('#add-menu-form').form('clear');  //每次打开前先清除上一次填写的数据
			var item = $('#data-datagrid').treegrid('getSelected'); //获取选择的行
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择要添加的数据！','info');
				return;
			}
			if(item.parentId == 0){
				$.messager.alert('信息提示','请选择二级菜单！','info');
				return;
			}
			//只能选择二级菜单，不能在按钮上添加按钮
			var parent = $('#data-datagrid').treegrid('getParent',item.id);
			if(parent.parentId != 0){
				$.messager.alert('信息提示','请选择二级菜单！','info');
				return;
			}
			$('#add-menu-dialog').dialog({
				closed: false,
				modal:true,
		           title: "添加按钮信息",
		           buttons: [{
		               text: '确定',
		               iconCls: 'icon-ok',
		               handler: function(){
		                  var validate = $("#add-menu-form").form("validate");
			       		  if(!validate){
			       			$.messager.alert("消息提醒","请检查你输入的数据","warning");
			       			return;
			       		  }
			       		var data = $("#add-menu-form").serialize();  
						$.ajax({
							url:'add',   //请求的路径是 /BaseProjectSSM/admin/menu/add
							dataType:'json',
							type:'post',
							data:data,  //传过去一个Menu
							success:function(data){
								if(data.type == 'success'){
									$.messager.alert('信息提示','提交成功！','info');
									$('#add-menu-dialog').dialog('close');
									$('#data-datagrid').treegrid('reload');  //添加后重新加载数据
								}else{
									$.messager.alert('信息提示', data.msg, 'warning');
								}
							}
						});
		               }
		           }, {
		               text: '取消',
		               iconCls: 'icon-cancel',
		               handler: function () {
		                   $('#add-menu-dialog').dialog('close');                    
		               }
		           }],
		           onBeforeOpen:function(){
		        	   $("#parent-menu").val(item.name); //上级菜单赋值
		        	   $("#add-menu-parent-id").val(item.id);
		           }
	       });
		}
		
//---删
		//删除记录
		function remove(){
			var item = $('#data-datagrid').treegrid('getSelected');
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择要删除的数据！','info');
				return;
			}
			$.messager.confirm('信息提示','确定要删除该记录？', function(result){
				if(result){
					$.ajax({
						url:'../../admin/menu/delete',   //请求的路径是 /BaseProjectSSM/admin/menu/delete
						dataType:'json',
						type:'post',
						data:{id:item.id}, //将id传递过去
						success:function(data){
							if(data.type == 'success'){
								$.messager.alert('信息提示','删除成功！','info');
								$('#data-datagrid').treegrid('reload');  //删除后重新加载数据
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
			var item = $('#data-datagrid').treegrid('getSelected'); //获取选择的行
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
	            	$("#edit-parentId").combobox('setValue',item.parentId);  //设置顶级菜单的值
	            	$("#edit-parentId").combobox('readonly',false);
	            	//判断是否是按钮
	            	var parent = $('#data-datagrid').treegrid('getParent',item.id);  //获取此id的父节点
	            	if(parent != null){
	            		//并且此节点的父节点不是顶级菜单，即父节点是二级菜单，那么此节点才是按钮
	            		if(parent.parentId != 0){  
		            		$("#edit-parentId").combobox('setText',parent.name);
		            		$("#edit-parentId").combobox('readonly',true);
		            	}
	            	}
	            	$("#edit-url").val(item.url);
	            	$("#edit-icon").val(item.icon);
	            }
	        });
		}
		
		//修改菜单信息的方法
		function edit(){
			var validate = $("#edit-form").form("validate");
			if(!validate){
				$.messager.alert("消息提醒","请检查你输入的数据","warning");
				return;
			}
			var data = $("#edit-form").serialize();  
			$.ajax({
				url:'../../admin/menu/edit',   //请求的路径是 /BaseProjectSSM/admin/menu/edit
				dataType:'json',
				type:'post',
				data:data,  //传过去一个Menu
				success:function(data){
					if(data.type == 'success'){
						$.messager.alert('信息提示','修改成功！','info');
						$('#edit-dialog').dialog('close');
						$('#data-datagrid').treegrid('reload');  //修改后重新加载数据
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
				name:$("#search-name").val() //传参数name
			});
		});
		
		//进入界面时，加载所有的菜单数据到表格中
		$('#data-datagrid').treegrid({
			url:'../../admin/menu/list',
			rownumbers:true,  //是否显示行号
			singleSelect:true,  //单选or多选
			pageSize:20,      //每页最多20条数据      
			pagination:true,  //页导航
			multiSort:true, 
			fitColumns:true,
			idField:'id',
			treeField:'name',
			fit:true,
			//field的值和数据库中的名一样，自动填充数据
			columns:[[
				{ field:'name',title:'菜单名称',width:100,sortable:true},  //是否支持排序
				{ field:'url',title:'菜单URL',width:180,sortable:true},
				{ field:'icon',title:'图标icon',width:100,formatter:function(value,index,row){
					//添加预览图标的效果
					var test = '<a class="'+value+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>';
					return test + value;
				}},
			]]
		});
	</script>
</body>
</html>
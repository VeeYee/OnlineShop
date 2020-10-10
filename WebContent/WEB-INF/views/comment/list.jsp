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
	            <label>商品名：</label><input id="search-productName" class="wu-text" style="width:80px">
	            <label>用户名：</label><input id="search-username" class="wu-text" style="width:80px">
	            <label>评价类型：</label>
	            <select class="easyui-combobox" id="search-type" name="status" panelHeight="auto" style="width:90px">
	            	<option value="-1">全部</option>
	            	<option value="0">差评</option>
	            	<option value="1">好评</option>
	            	<option value="2">中评</option>
	            </select> 
	            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search" >搜索</a>
	        </div>
	    </div>
	    <!-- 列出所有评论 -->
	    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
	</div>
	
	<!-- 编辑评论 -->
	<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:420px; padding:10px;">
		<form id="edit-form" method="post">
			<input type="hidden" name="id" id="edit-id">
	        <table>
	            <tr>
	            	<td width="60" align="right">评价类型:</td>
	            	<td>
			            <select class="easyui-combobox" id="edit-type" name="type" panelHeight="auto" style="width:268px">
			            	<option value="0">差评</option>
			            	<option value="1">好评</option>
			            	<option value="2">中评</option>
			            </select> 
		            </td>
	            </tr> 
	        	<tr>
	                <td align="right">评论内容:</td>
	                <td><textarea id="edit-content" name="content" rows="6" class="wu-textarea" ></textarea></td>
	            </tr>
	        </table>
	    </form>
	</div>
	<%@ include file ="../common/footer.jsp"%>
	
	<!-- 以下是js部分 -->
	<script type="text/javascript">
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
		           title: "编辑评论",
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
		        	   $("#edit-type").combobox('setValue',item.type);
		        	   $("#edit-content").val(item.content);
		           }
	       });
		}
		
		//编辑评论
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
		
//---查		
		//搜索按钮监听
		$("#search-btn").click(function(){
			var option = {productName:$("#search-productName").val()};
			//客户名  （需要输入完整的才能查询出）
			var username = $("#search-username").val();
			if(username != null && username != ''){
				option.username = username;
			}
			var type = $("#search-type").combobox('getValue');
			if(type != -1){
				option.type = type;
			}
			$('#data-datagrid').datagrid('reload',option);
		});
		
		//时间转换
		function add0(m){return m<10?'0'+m:m }
		function format(shijianchuo){
			var time = new Date(shijianchuo);
			var y = time.getFullYear();
			var m = time.getMonth()+1;
			var d = time.getDate();
			var h = time.getHours();
			var mm = time.getMinutes();
			var s = time.getSeconds();
			return y+'-'+add0(m)+'-'+add0(d)+' '+add0(h)+':'+add0(mm)+':'+add0(s);
		}
		
		var accountList = ${accountList}
		
		//进入界面时，加载所有订单数据
		$('#data-datagrid').datagrid({
			url:'list',
			rownumbers:true,  //是否显示行号
			singleSelect:true, //单选or多选
			pageSize:20,      //每页最多20条数据      
			pagination:true,  //页导航
			multiSort:true, 
			fitColumns:true,
			fit:true,
			nowrap: false,  //换行
			//field的值和数据库中的名一样，自动填充数据
			columns:[[
				{ field:'chk',checkbox:true },
				{ field:'productId',title:'商品',width:150,formatter:function(value,row,index){
					return row.product.name;
				}}, 
				{ field:'userId',title:'用户',width:100,formatter:function(value,row,index){
					return row.account.name;
				}}, 
				{ field:'type',title:'订单状态',width:100,formatter:function(value,row,index){
					if(value == 0) return '差评';
					if(value == 1) return '好评';
					if(value == 2) return '中评';
					return value;
				}},
				{ field:'content',title:'评论内容',width:150},
				{ field:'createTime',title:'评论时间',width:150,formatter:function(value,row,index){
					return format(value);
				}}
			]]
		});
	</script>
</body>
</html>
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
	            <label>订单编号：</label><input id="search-sn" class="wu-text" style="width:80px">
	            <label>客户名：</label><input id="search-username" class="wu-text" style="width:80px">
	            <label>订单金额：</label><input id="search-moneyMin" class="wu-text" style="width:50px">
	            — <input id="search-moneyMax" class="wu-text" style="width:50px">
	            <label>订单状态：</label>
	            <select class="easyui-combobox" id="search-status" name="status" panelHeight="auto" style="width:90px">
	            	<option value="-1">全部</option>
	            	<option value="0">待发货</option>
	            	<option value="1">已发货</option>
	            	<option value="2">已完成</option>
	            </select> 
	            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search" >搜索</a>
	        </div>
	    </div>
	    <!-- 列出所有订单的表格 -->
	    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
	</div>
	
	<!-- 查看订单信息对话框 -->
	<div id="view-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-eye'" style="width:650px; padding:10px;">
        <table id="order_item_datagrid" class="easyui-datagrid" style="width:620px;height:400px">
        </table>
	</div>
	
	<!-- 编辑订单对话框 -->
	<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:420px; padding:10px;">
		<form id="edit-form" method="post">
			<input type="hidden" name="id" id="edit-id">
	        <table>
	        	<tr>
	                <td width="60" align="right">收货地址:</td>
	                <td><input id="edit-address" type="text" name="address" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写收货地址'" /></td>
	            </tr>
	        	<tr>
	                <td width="60" align="right">订单金额:</td>
	                <td><input id="edit-money" type="text" name="money" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写订单金额'" /></td>
	            </tr>
	            <tr>
	            	<td width="60" align="right">订单状态:</td>
	            	<td>
			            <select class="easyui-combobox" id="edit-status" name="status" panelHeight="auto" style="width:268px">
			            	<option value="0">待发货</option>
			            	<option value="1">已发货</option>
			            	<option value="2">已完成</option>
			            </select> 
		            </td>
	            </tr> 
	        	<tr>
	                <td align="right">备注:</td>
	                <td><textarea id="edit-remark" name="remark" rows="6" class="wu-textarea" ></textarea></td>
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
		           title: "编辑订单",
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
		        	   $("#edit-address").val(item.address);
		        	   $("#edit-money").val(item.money);
		        	   $("#edit-status").combobox('setValue',item.status);
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
		
//---查看订单		
		//打开编辑窗口的方法
		function openView(){
			var item = $('#data-datagrid').datagrid('getSelected'); //获取选择的行
			if(item == null || item.length == 0){
				$.messager.alert('信息提示','请选择需要查看的订单！','info');
				return;
			}
			$('#view-dialog').dialog({
				closed: false,
				modal:true,
		           title: "查看订单信息",
		           buttons: [{
		               text: '确定',
		               iconCls: 'icon-ok',
		               handler:function () {
		                   $('#view-dialog').dialog('close');                    
		               }
		           }],
		           onBeforeOpen:function(){
		        	   //加载订单中的商品
		        	   $('#order_item_datagrid').datagrid({
		        		  url:'get_item_list?orderId='+item.id,
		        		  nowrap: false,
		        		  columns:[[
		      				{ field:'productId',title:'ID',width:25},
		      				{ field:'imageUrl',title:'商品图片',width:150,align:'center',formatter:function(value,row,index){
		    					var img = '<img src="'+value+'" width="70px"/>';
		    					return img;
		    				}},
		      				{ field:'name',title:'商品名称',width:170}, 
		      				{ field:'num',title:'商品数量',width:90}, 
		      				{ field:'price',title:'商品单价',width:85}, 
		      				{ field:'money',title:'商品总价',width:85}
		      			]]
		        	   });
		           }
	       });
		}
		
//---查		
		//搜索按钮监听
		$("#search-btn").click(function(){
			var option = {sn:$("#search-sn").val()};
			//客户名  （需要输入完整的才能查询出）
			var username = $("#search-username").val();
			if(username != null && username != ''){
				option.username = username;
			}
			var moneyMin = $("#search-moneyMin").val();
			if(moneyMin != null){
				option.moneyMin = moneyMin;
			}
			var moneyMax = $("#search-moneyMax").val();
			if(moneyMax != null){
				option.moneyMax = moneyMax;
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
				{ field:'sn',title:'订单编号',width:150,sortable:true}, 
				{ field:'userId',title:'所属用户',width:100,formatter:function(value,row,index){
					for(var i=0; i<accountList.length; i++){
						if(value == accountList[i].id)
							return accountList[i].name;  //根据id返回客户的用户名
					}
					return value;
				}}, 
				{ field:'address',title:'收货地址',width:150}, 
				{ field:'money',title:'订单金额',width:100,sortable:true}, 
				{ field:'productNum',title:'订单商品数',width:100}, 
				{ field:'status',title:'订单状态',width:100,formatter:function(value,row,index){
					if(value == 0) return '待发货';
					if(value == 1) return '已发货';
					if(value == 2) return '已完成';
					return value;
				}},
				{ field:'remark',title:'订单备注',width:150},
				{ field:'createTime',title:'订单创建时间',width:150,formatter:function(value,row,index){
					return format(value);
				}}
			]]
		});
	</script>
</body>
</html>
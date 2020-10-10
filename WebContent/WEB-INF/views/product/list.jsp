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
	            <label>商品名称：</label><input id="search-name" class="wu-text" style="width:100px">
	            <label>所属分类：</label><select id="search-productCategoryId" idField="id" treeField="name" class="easyui-combotree" url="tree_list" panelHeight="auto" style="width:170px"></select>
	            <label>价格区间：</label><input id="search-priceMin" class="wu-text" style="width:50px">
	            — <input id="search-priceMax" class="wu-text" style="width:50px">
	            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search" >搜索</a>
	        </div>
	    </div>
	    <!-- 列出所有商品分类的表格 -->
	    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
	</div>
	
	<!-- 添加商品分类对话框 -->
	<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:480px; padding:10px;">
		<form id="add-form" method="post">
	        <table>
	        	<tr>
	                <td width="60" align="right">父分类:</td>
	                <td>
	                	<select name="parentId" idField="id" treeField="name" class="easyui-combotree" url="../product_category/tree_list" panelHeight="256px" style="width:358px">
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
	                	<select id="edit-parentId" name="parentId" idField="id" treeField="name" class="easyui-combotree" url="../product_category/tree_list" panelHeight="256px" style="width:358px">
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
			//进入商品添加界面
			window.location.href = 'add';
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
				url:'add',   //也可写成../../admin/product/add
				dataType:'json',
				type:'post',
				data:data,  //传过去一个Product
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
			window.location.href = 'edit?id='+item.id;
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
				url:'edit',   //也可写成../../admin/product/edit
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
			var productCategoryId = $("#search-productCategoryId").combotree('getValue');
			if(productCategoryId != null && productCategoryId != ''){
				option.productCategoryId = productCategoryId;
			}
			var priceMin = $("#search-priceMin").val();
			if(priceMin != null){
				option.priceMin = priceMin;
			}
			var priceMax = $("#search-priceMax").val();
			if(priceMax != null){
				option.priceMax = priceMax;
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
		
		//查到所有的分类
		var productCategoryList = ${productCategoryList}
		
		//进入界面时，加载所有的日志数据到表格中
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
				{ field:'chk',checkbox:true },
				{ field:'imageUrl',title:'商品主图',width:100,align:'center',formatter:function(value,row,index){
					var img = '<img src="'+value+'" width="60px"/>';
					return img;
				}},
				{ field:'name',title:'商品标题',width:130,sortable:true}, 
				{ field:'productCategoryId',title:'商品分类',width:100,formatter:function(value,row,index){
					for(var i=0; i<productCategoryList.length; i++){
						if(value == productCategoryList[i].id)
							return productCategoryList[i].name;  //根据id返回分类对应的分类名
					}
					return value;
				}},
				{ field:'price',title:'商品价格',width:100},
				{ field:'stock',title:'商品库存',width:100,sortable:true},
				{ field:'sellNum',title:'商品销量',width:100,sortable:true},
				{ field:'viewNum',title:'商品浏览量',width:100,sortable:true},
				{ field:'commentNum',title:'商品评论量',width:100},
				{ field:'content',title:'商品详情',width:150},
				{ field:'createTime',title:'商品添加时间',width:150,formatter:function(value,row,index){
					return format(value);
				}}
			]]
		});
	</script>
</body>
</html>
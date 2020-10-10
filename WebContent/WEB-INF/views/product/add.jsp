<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<body class="easyui-layout">
	<div class="easyui-panel" title="添加商品"  data-options="fit:true">
		<div style="padding:10px 20px 10px 70px">
			<form id="add-form" method="post">
		        <table cellpadding="8">
		        	<tr>
		                <td width="60" align="right">商品分类:</td>
		                <td>
		                	<select name="productCategoryId" idField="id" treeField="name" class="easyui-combotree easyui-validatebox" url="tree_list"  data-options="required:true, missingMessage:'请选择商品分类'" panelHeight="auto" style="width:358px">
			            	</select>
			            </td>
			            <td></td>
		            	<td></td>
		            </tr>
		        	<tr>
		                <td width="60" align="right">商品标题:</td>
		                <td><input type="text" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写商品标题'" style="width:350px"/></td>
		            	<td></td>
		            	<td></td>
		            </tr> 
		            <tr>
		                <td width="60" align="right">商品主图:</td>
		                <td cellpadding="5">
			                <input type="text" id="add-imageUrl" name="imageUrl" class="wu-text easyui-validatebox" readonly="readonly" data-options="required:true, missingMessage:'请填写商品主图'" style="width:350px"/>&nbsp;&nbsp;
			            	<a href="javascript:uploadPhoto()" id="upload-btn" class="easyui-linkbutton" iconCls="icon-upload" >上传图片</a>&nbsp;&nbsp;
			            	<a href="javascript:previewPhoto()" id="view-btn" class="easyui-linkbutton" iconCls="icon-eye" >预览图片</a>
		            	</td>
		            </tr>
		            <tr>
		                <td width="60" align="right">商品价格:</td>
		                <td><input type="text" name="price" class="wu-text easyui-numberbox easyui-validatebox" data-options="required:true,min:0,precision:2,missingMessage:'请填写商品价格'" style="width:350px"/></td>
		            </tr>
		            <tr>
		                <td width="60" align="right">商品库存:</td>
		                <td><input type="text" name="stock" class="wu-text easyui-numberbox easyui-validatebox" data-options="required:true,min:0,precision:0,missingMessage:'请填写商品库存'" style="width:350px"/></td>
		            </tr>
		        	<tr>
		                <td align="right">详情描述:</td>
		                <td><textarea name="content" id="add-content" rows="6" class=" " style="width:650px;height:210px;"></textarea></td>
		            </tr>
		            <tr>
		            	<td></td>
		                <td align="right"><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="submitForm()">提交</a></td>
			            <td><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-back" onclick="back()" >返回</a></td>
		            </tr>
		        </table>
		    </form>
	    </div>
	</div>
	
	<div id="preview-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-eye'" style="width:420px; padding:5px 5px;">
    	<img id="preview-photo" src="" width="395px" height="390px" />
	</div>
	
	<!-- 上传头像的文件选择器 -->
	<input type="file" id="photo-file" style="display:none;" onchange="upload()"/>
	<!-- 上传进度条 -->
	<div id="process-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-upload',title:'正在上传图片'" style="width:430px; padding:10px;">
		<div id="p" class="easyui-progressbar" style="width:400px;"></div>
	</div>
	
	<!-- ueditor 配置文件 -->
	<script type="text/javascript" src="../../resources/admin/ueditor/ueditor.config.js"></script>
	<script type="text/javascript" src="../../resources/admin/ueditor/ueditor.all.js"></script>
	
	<!-- 以下是js部分 -->
	<script type="text/javascript">
	var ue = UE.getEditor('add-content');  //商品详情处引入ueditor插件
	
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
		//打开文件选择器，选择头像
		function uploadPhoto(){
			$("#photo-file").click();
		}
		//上传商品主图
		function upload(){
			if($("#photo-file").val()=='') return;
			var formData = new FormData();
			formData.append('photo',document.getElementById('photo-file').files[0]);
			$("#process-dialog").dialog('open');
			//每隔200毫秒刷新进度条
			var interval = setInterval(start,200);
			$.ajax({
				url:'../user/upload_photo',  
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
						$("#add-imageUrl").val(data.filePath);
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
		
		//预览图片
		function previewPhoto(){
			$('#preview-dialog').dialog({
				closed: false,  
				modal:true,
	            title: "预览商品主图"
	        });
		}
		
		//返回到商品列表页面
		function back(){
			window.history.go(-1);
		}
		
		//提交数据
		function submitForm(){
			add();
		}
		//添加商品
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
	</script>
</body>
</html>
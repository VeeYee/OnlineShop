<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改密码</title>
<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/easyui/1.3.4/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/css/wu.css" />
<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/css/icon.css" />
<script type="text/javascript" src="../resources/admin/easyui/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="../resources/admin/easyui/easyui/1.3.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../resources/admin/easyui/easyui/1.3.4/locale/easyui-lang-zh_CN.js"></script>
</head>
<body class="easyui-layout">
	
	<!-- 修改密码窗口 -->
	<div id="edit-dialog" class="easyui-dialog" data-options="closed:false,iconCls:'icon-lock-edit',modal:true,title:'修改密码',buttons:[{
                text: '确定',
                iconCls: 'icon-ok',
                handler: edit  
            }]" style="width:500px; padding:10px;">
		<form id="edit-form" method="post">
	        <table> 
	        	<tr>
	                <td width="80" align="right">用户名:</td>
	                <td><input type="text" name="username" class="wu-text" readonly="readonly" value="${admin.username }" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td width="80" align="right">原密码:</td>
	                <td><input type="password" id="oldPassword" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写原密码'" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td width="80" align="right">新密码:</td>
	                <td><input type="password" id="newPassword" name="password" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请填写新密码'" style="width:350px;"/></td>
	            </tr>
	            <tr>
	                <td width="80" align="right">重复新密码:</td>
	                <td><input type="password" id="reNewPassword" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'请再次填写新密码'" style="width:350px;"/></td>
	            </tr>
	        </table>
	    </form>
	</div>
	
	<!-- 以下是js部分 -->
	<script type="text/javascript">
	//修改密码
	function edit(){
		var validate = $("#edit-form").form("validate");
		if(!validate){
			$.messager.alert("消息提醒","请检查你输入的数据","warning");
			return;
		}
		if($("#newPassword").val() != $("#reNewPassword").val()){
			$.messager.alert('信息提示', '两次密码输入不一致！', 'warning');
			return;
		}
		$.ajax({
			url:'edit_password',   //请求的路径是 /BaseProjectSSM/system/edit_password
			dataType:'json',
			type:'post',
			data:{newPassword:$("#newPassword").val(),oldPassword:$("#oldPassword").val()},
			success:function(data){
				if(data.type == 'success'){
					$.messager.alert('信息提示','密码修改成功！','info');
					$('#edit-dialog').dialog('close');
				}else{
					$.messager.alert('信息提示', data.msg, 'warning');
				}
			}
		});
	}
	</script>
</body>
</html>
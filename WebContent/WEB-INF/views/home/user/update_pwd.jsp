<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<!-- 我的个人中心主页 -->
<div class="shop_member_bd clearfix">
	<!-- 导入左侧菜单 -->
	<%@ include file ="../common/user_menu.jsp"%>
	
	<!-- 右边修改密码部分 -->
	<div class="shop_member_bd_right clearfix">
		<div class="shop_meber_bd_good_lists clearfix">
			<div class="title"><h3>修改密码</h3></div>
			<div class="clear"></div>
			<div class="shop_home_form">
				<form action="" name="" class="shop_form" method="post">
					<ul>
						<li class="bn"><label>原密码：</label><input id="old-pwd" type="password" class="truename form-text" /></li>
						<li class="bn"><label>新密码：</label><input id="new-pwd" type="password" class="truename form-text" /></li>
						<li class="bn"><label>确认新密码：</label><input id="new-pwd-re" type="password" class="truename form-text" /></li>
						<li class="bn"><label>&nbsp;</label><input type="button" onclick="updatePwd()" class="form-submit" value="保存" /></li>
					</ul>
				</form>
			</div>
		</div>
	</div>
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
	//修改密码
	function updatePwd(){
		var oldpassword = $("#old-pwd").val();
		var newpassword = $("#new-pwd").val();
		var newpasswordre = $("#new-pwd-re").val();
		if(oldpassword == ''){
			alert("请填写原密码！");
			return;
		}
		if(newpassword == ''){
			alert("请填写新密码！");
			return;
		}
		if(newpassword != newpasswordre){
			alert("两次密码不一致！");
			return;
		}
		$.ajax({
			url:'update_pwd',  //改密码
			type:'post',
			data:{oldpassword:oldpassword,newpassword:newpassword,newpasswordre:newpasswordre},
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){
					alert("密码修改成功，请重新登陆！");
					window.location.href = '../home/login';
				}else{
					alert(data.msg);
				}
			}
		});
	}
</script>
</body>
</html>
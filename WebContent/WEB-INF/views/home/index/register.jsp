<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title></title>
	<link rel="stylesheet" href="../resources/home/css/reset.css" />
	<link rel="stylesheet" href="../resources/home/css/login.css" />
    <script type="text/javascript" src="../resources/home/js/jquery.min.js"></script>
    <script type="text/javascript" src="../resources/home/js/jquery.js" ></script>
</head>
<body style="overflow:hidden">
<div class="page">
	<div class="loginwarrp">
		<div class="logo">用户注册</div>
        <div class="login_form">
			<form id="Login" name="Login" >
				<ul>
					<li class="login-item">
						<span>用户名：</span>
						<input type="text" id="username" name="name" class="login_input" >
	                    <span id="name-msg" class="error"></span>
					</li>
					<li class="login-item">
						<span>密　码：</span>
						<input type="password" id="password" name="password" class="login_input" >
	                    <span id="password-msg" class="error"></span>
					</li>
					<li class="login-item">
						<span>姓　名：</span>
						<input type="text" id="trueName" name="trueName" class="login_input" >
					</li>
					<li class="login-item">
						<span>性　别：</span>
						<select id="sex" name="sex" class="login_input" >
							<option value="0">未知</option>
							<option value="1">男</option>
							<option value="2">女</option>
						</select>
					</li>
					<li class="login-item">
						<span>邮　箱：</span>
						<input type="text" id="email" name="email" class="login_input" >
	                    <span id="email-msg" class="error"></span>
					</li>
					<li class="login-item">
						<span>验证码：</span>
						<input type="text" id="code" name="code" class="login_input" >
	                    <span id="code-msg" class="error"></span>
						<div style="width:100px;">
							<img id="register-code" src="../system/get_cpacha?vl=4&w=100&h=35&type=userRegisterCpacha" onclick="changeCode()"/> 
						</div>
					</li>
					<li class="login-sub">
						<input type="button" id="register-btn" value="注册" />
                     	<input type="button" id="login-btn" value="登录" />
					</li>  
				</ul>
			</form>
		</div>
	</div>
</div>
<script type="text/javascript">
	//背景动画
	window.onload = function() {
		var config = {
			vx : 4,
			vy : 4,
			height : 2,
			width : 2,
			count : 100,
			color : "121, 162, 185",
			stroke : "100, 200, 180",
			dist : 6000,
			e_dist : 20000,
			max_conn : 10
		}
		CanvasParticle(config);
	}
	
	//切换验证码
	function changeCode(){
		$("#register-code").attr('src','../system/get_cpacha?vl=4&w=100&h=35&type=userRegisterCpacha&t='+new Date().getTime());
	}
	
	//点击注册按钮
	$("#register-btn").click(function(){
		var name = $("input[name='name']").val();
		var password = $("input[name='password']").val();
		var trueName = $("input[name='trueName']").val();
		var sex = $("#sex").val();
		var email = $("input[name='email']").val();
		var code = $("input[name='code']").val();
		if(name == ''){
			$('#name-msg').html("用户名不能为空");
			return;
		}
		$('#name-msg').empty();
		if(password == ''){
			$('#password-msg').html("密码不能为空");
			return;
		}
		$('#password-msg').empty();
		if(email == ''){
			$('#email-msg').html("邮箱不能为空");
			return;
		}
		$('#email-msg').empty();
		if(code == ''){
			$('#code-msg').html("验证码不能为空");
			return;
		}
		$('#code-msg').empty();
		$.ajax({
			url:'register',  //进入注册提交处理控制器
			data:{name:name,password:password,trueName:trueName,sex:sex,email:email,code:code},
			type:'post',
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){ 
					//成功后跳转到登录页面
					window.location.href = 'login'; 
				}else{
					alert(data.msg);
					changeCode();
				}
			}
		});
	});
	
	//点击登录按钮跳转
	$("#login-btn").click(function(){
		window.location.href = 'login'; 
	});
</script>
	
<!-- 引入背景效果 -->
<script type="text/javascript" src="../resources/home/js/canvas-particle.js"></script>
</body>
</html>

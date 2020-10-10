<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<!-- 我的个人中心主页 -->
<div class="shop_member_bd clearfix">
	<!-- 导入左侧菜单 -->
	<%@ include file ="../common/user_menu.jsp"%>
	
	<!-- 个人基本信息 -->
	<div class="shop_member_bd_right clearfix">
		<div class="shop_meber_bd_good_lists clearfix">
			<div class="title"><h3>基本信息</h3></div>
			<div class="clear"></div>
			<div class="shop_home_form">
				<form action="" name="" class="shop_form" method="post">
					<ul>
						<li><label>用  户  名：</label>${user.name }</li>
						<li><label>电子邮件：</label><input type="text" id="email" class="truename form-text" value="${user.email }"/></li>
						<li><label>真实姓名：</label><input type="text" id="trueName" class="truename form-text" value="${user.trueName }"/></li>
						<li><label>性       别：</label>
							<input type="radio" class="mr5" name="sex" value="0" <c:if test="${user.sex == 0 }">checked</c:if> /> 保密
							<input type="radio" class="ml10 mr5" name="sex" value="1" <c:if test="${user.sex == 1 }">checked</c:if> />男
							<input type="radio" class="ml10 mr5" name="sex" value="2" <c:if test="${user.sex == 2 }">checked</c:if> />女
						</li>
						<li><label>账号状态：</label><input id="status" type="text" value="${user.status }" style="border: 0px;outline:none;font-size:16px;"/></li>
						<li><label>注册时间：</label><input id="time" type="text" value="${user.createTime }" style="border: 0px;outline:none;font-size:16px;"/></li>
						<li class="bn"><label>&nbsp;</label><input type="button" onclick="editInfo()" class="form-submit" value="保存" /></li>
					</ul>
				</form>
			</div>
		</div>
	</div>
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
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
	var time = $("#time").val();
	$("#time").val(format(time));  //转换时间的显示
	
	var status = $("#status").val();
	if(status == 1){
		$("#status").val("正常");
	}else if(status == 2){
		$("#status").val("冻结");
	}else{
		$("#status").val("其他");
	}

	//编辑并保存个人信息
	function editInfo(){
		var email = $("#email").val();
		var trueName = $("#trueName").val();
		var sex = $("input[type='radio']:checked").val();
		if(email == ''){
			alert("请填写邮箱！");
			return;
		}
		if(trueName == ''){
			alert("请填写真实姓名！");
			return;
		}
		if(sex == '' || sex == 'undefined' || sex == null){
			alert("请选择性别！");
			return;
		}
		$.ajax({
			url:'update_info',  //更新信息
			type:'post',
			data:{email:email,trueName:trueName,sex:sex},
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){
					alert("信息修改成功！");
				}else{
					alert(data.msg);
				}
			}
		});
	}
</script>
</body>
</html>
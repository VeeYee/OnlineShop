<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<!--评价类型的样式-->
<style>
	span.pingjia_type {
	    width: 24px;
	    height: 24px;
	    display: block;
	    margin: 0 auto;
	    background: url(../resources/home/images/credit_smile.png) no-repeat scroll 0 0 transparent;
	    float:left;
	}
	span.pingjia_type_2 {
    	background-position: 0 -30px;
	}
	span.pingjia_type_3 {
	    background-position: 0 -60px;
	}
</style>
<!-- 我的个人中心主页 -->
<div class="shop_member_bd clearfix">
	<!-- 导入左侧菜单 -->
	<%@ include file ="../common/user_menu.jsp"%>
	<!-- 商品评价 -->
	<div class="shop_member_bd_right clearfix">
		<div class="shop_meber_bd_good_lists clearfix">
			<div class="title"><h3>商品评价</h3></div>
			<div class="clear"></div>
			<div class="shop_home_form">
				<form action="" name="" class="shop_form" method="post">
					<ul>
						<li style="height:60px;"><label>商品图片：</label><img src="${product.imageUrl }" width=60px height=60px/></li>
						<li><label>商品名称：</label>${product.name }</li>
						<li><label>商品价格：</label>${product.price }元</li>
						<li><label>评价类型：</label>
							<span class="pingjia_type pingjia_type_1"></span>
							<input style="float:left;margin-top:5px;" type="radio" class="mr5" name="type" value="1" />
							<span style="float:left;margin-right:18px;">好评</span>
							<span class="pingjia_type pingjia_type_2"></span>
							<input style="float:left;margin-top:5px;" type="radio" class="mr5" name="type" value="2" />
							<span style="float:left;margin-right:18px;">中评</span>
							<span class="pingjia_type pingjia_type_3"></span>
							<input style="float:left;margin-top:5px;" type="radio" class="mr5" name="type" value="0" />差评
						</li>
						<li style="height:100px;"><label>评价内容：</label>
							<textarea id="content" style="width:400px;height:100px;"></textarea>
						</li>
						<li class="bn"><label>&nbsp;</label><input type="button" onclick="submitComment()" class="form-submit" value="提交评价" /></li>
					</ul>
				</form>
			</div>
		</div>
	</div>
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
	//提交评论
	function submitComment(){
		var content = $("#content").val();
		var type = $("input[type='radio']:checked").val();
		if(content == ''){
			alert("请填写评价内容！");
			return;
		}
		if(type == '' || type == 'undefined' || type == null){
			alert("请选择评价类型！");
			return;
		}
		$.ajax({
			url:'../comment/add',  //增加评价
			type:'post',
			data:{productId:'${product.id}',content:content,type:type},
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){
					alert("评价成功！");
					window.history.go(-1);  //返回上一级
				}else{
					alert(data.msg);
				}
			}
		});
	}
</script>
</body>
</html>
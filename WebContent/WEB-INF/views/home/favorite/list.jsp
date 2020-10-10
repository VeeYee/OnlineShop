<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<link rel="stylesheet" href="../resources/home/css/shop_list.css" type="text/css" />
<style>
.pagination{width:100%; margin:10px auto;}
.pagination ul{float:right}
.pagination ul li{float:left; margin:0 3px;}
.pagination ul li span{display: inline-block; padding:5px 5px; border:1px solid #CCCCCC; color:#999999;}
.pagination ul li span.currentpage{background-color:#6ea8f0; color:#FFF; font-weight: bold; border-color:#6ea8f0;}
</style>
<!-- 我的个人中心主页 -->
<div class="shop_member_bd clearfix">
	<!-- 导入左侧菜单 -->
	<%@ include file ="../common/user_menu.jsp"%>
	<!-- 我的收藏列表 -->
	<div class="shop_member_bd_right clearfix">
		<div class="shop_meber_bd_good_lists clearfix">
			<div class="title"><h3>收藏列表</h3></div>
			<!-- 收藏的商品列表 -->
			<div class="shop_bd_list_content clearfix">
				<ul>
					<c:forEach items="${favoriteList }" var="favorite">
					<li>
						<dl>
							<dt><a href="../product/detail?id=${favorite.productId }"><img src="${favorite.imageUrl }" /></a></dt>
							<dd class="title"><a href="../product/detail?id=${favorite.productId }">${favorite.name }</a></dd>
							<dd class="content">
								<span class="goods_jiage">￥<strong>${favorite.price}</strong></span>
								<span class="goods_chengjiao">
									<a href="javascript:void(0)" class="del-btn" data-id="${favorite.id }">删除</a>
								</span>
							</dd>
						</dl>
					</li>
					</c:forEach>
				</ul>
			</div>
			<div class="clear"></div>
			<div class="pagination"> 
				<ul>
					<li><span><a href="list?page=${page -1}" style="color:black;">上一页</a></span></li>
					<li><span class="currentpage">${page }</span></li>
					<li><span><a href="list?page=${page +1}" style="color:black;">下一页</a></span></li>
				</ul> 
			</div>
		</div>
	</div>
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
	//删除收藏的商品
	$(".del-btn").click(function(){
		var $this = $(this);
		if(confirm("是否确认删除？")){
			$.ajax({
				url:'delete',  
				type:'post',
				data:{favoriteId:$this.attr('data-id')},  //订单id
				dataType:'json',
				success:function(data){
					if(data.type == 'success'){
						alert("删除成功！");
						window.location.reload();  
					}else{
						alert(data.msg);
					}
				}
			});
		}
	});
</script>
</body>
</html>
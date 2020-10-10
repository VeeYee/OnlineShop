<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
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
	<!-- 我的订单列表 -->
	<div class="shop_member_bd_right clearfix">
		<div class="shop_meber_bd_good_lists clearfix">
		<div class="title"><h3>订单列表</h3></div>
		<table>
			<thead class="tab_title">
				<tr>
					<th style="width:482px;"><span>商品信息</span></th>
					<th style="width:118px;"><span>单价</span></th>
					<th style="width:94px;"><span>数量</span></th>
					<th style="width:119px;"><span>总价</span></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${orderList }" var="order">
				<tr>
					<td colspan="5">
					<table class="good">
						<thead>
							<tr><th colspan="6">
								<span><strong>订单号：</strong>${order.sn }</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<span><strong>订单总价：</strong>${order.money }</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<span><strong>下单时间：</strong>${order.orderTime }</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<span><strong>订单状态：</strong>
									<c:if test="${order.status == 0}">待发货</c:if>
									<c:if test="${order.status == 1}">已发货</c:if>
									<c:if test="${order.status == 2}">已完成</c:if>
								</span>
							</th></tr>
						</thead>
						<tbody>
							<c:forEach items="${order.orderItems }" var="orderItem">
							<tr>
								<td class="dingdan_pic"><a href="../product/detail?id=${orderItem.productId }"><img src="${orderItem.imageUrl }" /></a></td>
								<td class="dingdan_title"><span><a href="../product/detail?id=${orderItem.productId }">${orderItem.name }</a></span></td>
								<td class="dingdan_danjia">￥<strong>${orderItem.price }</strong></td>
								<td class="dingdan_shuliang">x ${orderItem.num }</td>
								<td class="dingdan_zongjia">￥<strong>${orderItem.money }</strong></td>
								<c:if test="${order.status == 2 }"><!-- 已完成的订单才可以评价 -->
									<td width=30px style="text-align:center;"><a href="comment?pid=${orderItem.productId }" style="color:#6ea8f0">评价</a></td>
								</c:if>
							</tr>
							</c:forEach>
							<!-- 显示收货信息，订单备注 -->
							<tr height=35px ><td colspan="6" class="dingdan_title">
								收货信息：${order.address }&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<c:if test="${ not empty order.remark }">订单备注：${order.remark }</c:if>
							</td></tr>
							<!-- 已发货状态显示确认收货按钮 -->
							<c:if test="${order.status == 1 }">
								<tr height=30px ><td colspan="6" class="dingdan_title">
									<a href="javascript:void(0)" data-id="${order.id }" class="finish-order-btn" style="float:right;">确认收货</a>
								</td></tr>
							</c:if>
						</tbody>
					</table>
					</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
		<!-- 分页导航 -->
		<div class="pagination"> 
			<ul>
				<li><span><a href="list?page=${page -1}" style="color:black;">上一页</a></span></li>
				<li><span class="currentpage">${page }</span></li>
				<li><span><a href="list?page=${page +1}" style="color:black;">下一页</a></span></li>
			</ul> 
		</div>
	</div>
</div>
<!-- 右边购物列表 End -->
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
	//点击确认收货按钮
	$(".finish-order-btn").click(function(){
		var $this = $(this);
		if(confirm("是否确认收货？")){
			$.ajax({
				url:'finish_order',  //订单完成
				type:'post',
				data:{id:$this.attr('data-id')},  //订单id
				dataType:'json',
				success:function(data){
					if(data.type == 'success'){
						alert("确认收货成功！");
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
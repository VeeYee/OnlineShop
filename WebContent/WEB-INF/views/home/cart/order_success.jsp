<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<link rel="stylesheet" href="../resources/home/css/shop_gouwuche.css" type="text/css" />
<style type="text/css">
		.shop_bd_error{width:1000px; height:50px; padding:100px 0; margin:10px auto 0; border:1px solid #ccc;}
		.shop_bd_error p{height:45px; line-height:45px; width:980px; text-align: center; font-size:14px; font-weight: bold; color:#55556F;}
		.shop_bd_error p span{display:inline-block;width:48px; height:48px; line-height:45px; overflow:hidden; text-indent: 99em; vertical-align:top; padding-right:10px; background:url('../resources/home/images/right.png') no-repeat left top;}
</style>
<!-- 订单提交成功 Body -->
<div class="shop_gwc_bd clearfix">
	<div class="shop_gwc_bd_contents clearfix">
		<!-- 购物流程导航 -->
		<div class="shop_gwc_bd_contents_lc clearfix">
			<ul>
				<li class="step_a">确认购物清单</li>
				<li class="step_b">确认收货人资料及送货方式</li>
				<li class="step_c hover_c">购买完成</li>
			</ul>
		</div>
	</div>
	
	<div class="shop_bd_error">
		<p><span></span>${msg}</p>
		<p>订单编号:${order.sn },订单总价:${order.money }</p>
	</div>
	<div class="clear"></div>
</div>
<div class="clear"></div>
<%@ include file ="../common/footer.jsp"%>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<link rel="stylesheet" href="../resources/home/css/shop_gouwuche.css" type="text/css" />
<!-- 购物车 Body -->
<div class="shop_gwc_bd clearfix">
	<!-- 购物车为空时显示此处 -->
	<c:if test="${empty cartList }">
		<div class="empty_cart mb10">
			<div class="message">
				<p>购物车内暂时没有商品，您可以<a href="/OnlineShop">去首页</a>挑选喜欢的商品</p>
			</div>
		</div>
	</c:if>
	
	<c:if test="${not empty cartList }">
	<!-- 购物车有商品时 -->
	<div class="shop_gwc_bd_contents clearfix">
		<!-- 购物流程导航 -->
		<div class="shop_gwc_bd_contents_lc clearfix">
			<ul>
				<li class="step_a hover_a">确认购物清单</li>
				<li class="step_b">确认收货人资料及送货方式</li>
				<li class="step_c">购买完成</li>
			</ul>
		</div>
		<!-- 购物车列表 -->
		<table>
			<thead>
				<tr>
					<th colspan="2"><span>商品</span></th>
					<th><span>单价(元)</span></th>
					<th><span>数量</span></th>
					<th><span>小计</span></th>
					<th><span>操作</span></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${cartList }" var="cart">
				<tr>
					<td class="gwc_list_pic">
						<a href="../product/detail?id=${cart.productId }"><img src="${cart.imageUrl }" style="width:120px;height:120px"/></a>
					</td>
					<td class="gwc_list_title">
						<a href="../product/detail?id=${cart.productId }">${cart.name } </a>
					</td>
					<td class="gwc_list_danjia">
						<span>￥<strong id="danjia_001">${cart.price }</strong></span>
					</td>
					<td class="gwc_list_shuliang">
						<span><!-- 商品数量 -->
							<a class="good_num_jian this_good_nums" cid="${cart.id}" price="${cart.price }" ty="-" valId="goods_001" href="javascript:void(0);">-</a>
							<input type="text" value="${cart.num }" readonly="readonly" id="goods_001" class="good_nums" style="text-align:center;width:28px;"/>
							<a class="good_num_jia this_good_nums"  cid="${cart.id}" price="${cart.price }" ty="+" valId="goods_001" href="javascript:void(0);">+</a>
						</span>
					</td>
					<td class="gwc_list_xiaoji">
						<span>￥<strong id="xiaoji_001" class="good_xiaojis">${cart.money }</strong></span>
					</td>
					<td class="gwc_list_caozuo">
						<a href="javascript:void(0);" class="product_favorite" pid="${cart.productId}">收藏</a><!-- 可获取要收藏商品的id -->
						<a href="javascript:void(0);" class="cart_delete_btn" cid="${cart.id}">删除</a><!-- 可获取要删除商品的id -->
					</td>
				</tr>
			</c:forEach>
			</tbody>
			<!-- 购物车结算处 -->
			<tfoot>
				<tr>
					<td colspan="6">
						<div class="gwc_foot_zongjia">商品总价(不含运费)<span>￥<strong id="good_zongjia">0.00</strong></span></div>
						<div class="clear"></div>
						<div class="gwc_foot_links">
							<a href="../home/index" class="go">继续购物</a>
							<a href="list_2" class="op">去结算</a> <!-- 跳到list_2.jsp  控制器cart/list_2 -->
						</div>
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
	</c:if>
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
	calTotalMoney();  //刚进入页面时就计算商品总价
	//减少商品数量
	$(".good_num_jian").click(function(){
		var num = parseInt($(this).next('input').val());
		num = num -1;
		if(num < 1) return;
		if(!updateNum($(this).attr('cid'),-1)) return;  //商品数量-1
		//计算商品小计   若数量没变化被return就不会进入下面的计算
		$(this).next('input').val(num);  //当前点击按钮最近的input框
		var money = parseFloat($(this).attr('price')*num);
		$(this).closest(".gwc_list_shuliang").next(".gwc_list_xiaoji").find(".good_xiaojis").text(money);
		calTotalMoney();  //计算购物车总价
	});
	//增加商品数量
	$(".good_num_jia").click(function(){
		var num = parseInt($(this).prev('input').val());
		num = num + 1;
		if(!updateNum($(this).attr('cid'),1)) return;  //商品数量+1
		$(this).prev('input').val(num);
		var money = parseFloat($(this).attr('price')*num);
		$(this).closest(".gwc_list_shuliang").next(".gwc_list_xiaoji").find(".good_xiaojis").text(money);
		calTotalMoney();  
	});
	
	//监听收藏按钮
	$(".product_favorite").click(function(){
		var pid = $(this).attr('pid');  //取到属性pid的值
		var $this = $(this);
		$.ajax({
			url:'../favorite/add',  //添加收藏
			type:'post',
			data:{productId:pid},
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){
					alert("收藏成功！");
				}else{
					alert(data.msg);
				}
			}
		});
	});
	
	//监听购物车删除按钮
	$(".cart_delete_btn").click(function(){
		var cid = $(this).attr('cid');  //取到属性cid的值
		var $this = $(this);
		if(confirm('确认删除该商品吗？')){
			$.ajax({
				url:'delete', 
				type:'post',
				data:{cartId:cid},
				dataType:'json',
				success:function(data){
					if(data.type == 'success'){
						//删除这个tr
						$this.closest('tr').hide('1000').remove();
						calTotalMoney();  //重新计算总价
					}else{
						alert(data.msg);
					}
				}
			});
		}
	});
	
	//计算购物车中的商品总价
	function calTotalMoney(){
		var totalMoney = 0;
		//遍历所有的小计
		$(".good_xiaojis").each(function(){
			var money = parseFloat($(this).text());
			totalMoney += money;
		});
		$("#good_zongjia").text(totalMoney);
	}
	
	//在数据库中更新购物车商品数量
	function updateNum(cartId, num){
		var ret = false;  //失败时不发送请求
		$.ajax({
			url:'update_num',
			type:'post',
			data:{cartId:cartId,num:num},
			dataType:'json',
			async: false,  //同步的
			success:function(data){
				if(data.type == 'success'){
					ret = true;
				}else{
					alert(data.msg);
				}
			}
		});
		return ret;
	}
</script>
</body>
</html>
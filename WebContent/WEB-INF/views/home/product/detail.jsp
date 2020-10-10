<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<link rel="stylesheet" href="../resources/home/css/shop_list.css" type="text/css" />
<link rel="stylesheet" href="../resources/home/css/shop_goods.css" type="text/css" />
<link rel="stylesheet" href="../resources/home/css/shop_goodPic.css" type="text/css" />
<script type="text/javascript" src="../resources/home/js/shop_goods.js" ></script>
<script type="text/javascript" src="../resources/home/js/shop_goodPic_base.js"></script>
<script type="text/javascript" src="../resources/home/js/lib.js"></script>
<script type="text/javascript" src="../resources/home/js/163css.js"></script>
<div class="shop_goods_bd clear">
	<!-- 商品详情展示 -->
	<div class="shop_goods_show">
		<div class="shop_goods_show_left">
			<div id="preview">
				<div class=jqzoom id="spec-n1" >
					<IMG height="350" src="${product.imageUrl }" jqimg="${product.imageUrl }" width="350">
				</div>
			</div>
		</div>
		<div class="shop_goods_show_right">
			<ul>
				<li>
					<strong style="font-size:14px; font-weight:bold;margin-left:35px;">${product.name }</strong>
				</li>
				<li>
					<label>价格：</label>
					<span><strong>${product.price }</strong>元</span>
				</li>
				<li>
					<label>运费：</label>
					<span>卖家承担运费</span>
				</li>
				<li>
					<label>累计售出：</label>
					<span>${product.sellNum }件</span>
				</li>
				<li>
					<label>评论：</label>
					<span>${product.commentNum }条评论</span>
				</li>
				<li>
					<label>浏览量：</label>
					<span>${product.viewNum }次</span>
				</li>
				<li class="goods_num">
					<label>购买数量：</label>
					<span>
						<a class="good_num_jian" id="good_num_jian" href="javascript:void(0);"></a>
						<input type="text" value="1" id="good_nums" class="good_nums" style="text-align:center;width:30px;"/>
						<a href="javascript:void(0);" id="good_num_jia" stock="${product.stock }" class="good_num_jia"></a>
						  当前库存${product.stock }件
					</span>
				</li>
				<li style="padding:20px 0;">
					<label>&nbsp;</label>
					<span><a href="javascript:void(0)" id="add-cart-btn" class="goods_sub goods_sub_gou" >加入购物车</a></span>
					<span><a href="javascript:void(0)" id="add-favorite-btn" pid="${product.id }" >收藏商品</a></span>
				</li>
			</ul>
		</div>
	</div>
	<!-- 商品详情展示End-->

	<!-- 热卖推荐商品 -->
	<div class="clear mt15"></div>
	<div class="shop_bd_list_left clearfix">
		<div class="shop_bd_list_bk clearfix">
			<div class="title">热卖推荐商品</div>
			<div class="contents clearfix">
				<ul class="clearfix">
				<c:forEach items="${sellProductList }" var="sellProduct">
					<li class="clearfix">
						<div class="goods_name"><a href="../product/detail?id=${sellProduct.id }">${sellProduct.name }</a></div>
						<div class="goods_pic"><span class="goods_price">¥ ${sellProduct.price }</span>
							<a href="../product/detail?id=${sellProduct.id }"><img src="${sellProduct.imageUrl }" /></a>
						</div>
						<div class="goods_xiaoliang">
							<span class="goods_xiaoliang_link"><a href="../product/detail?id=${sellProduct.id }">去看看</a></span>
							<span class="goods_xiaoliang_nums">已销售<strong>${sellProduct.sellNum }</strong>笔</span>
						</div>
					</li>
				</c:forEach>
				</ul>
			</div>
		</div>
		<div class="clear"></div>
	 </div>
	<!-- 热卖推荐商品 -->

	<!-- 商品详情描述 -->
	<script type="text/javascript" src="../resources/home/js/shop_goods_tab.js"></script>
	<div class="shop_goods_bd_xiangqing clearfix">
		<div class="shop_goods_bd_xiangqing_tab">
			<ul>
				<li id="xiangqing_tab_1" onmouseover="shop_goods_easytabs('1', '1');" onfocus="shop_goods_easytabs('1', '1');" onclick="return false;"><a href=""><span>商品详情</span></a></li>
				<li id="xiangqing_tab_2" onmouseover="shop_goods_easytabs('1', '2');" onfocus="shop_goods_easytabs('1', '2');" onclick="return false;"><a href=""><span>商品评论</span></a></li>
			</ul>
		</div>
		<div class="shop_goods_bd_xiangqing_content clearfix">
			<div id="xiangqing_content_1" class="xiangqing_contents clearfix">
				<p>${product.content }</p>
			</div>
			<div id="xiangqing_content_2" class="xiangqing_contents clearfix">
				<p>商品评论----22222</p>
			</div>
		</div>
	</div>
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
  //放大商品图
  $(function(){			
	   $(".jqzoom").jqueryzoom({
			xzoom:400,
			yzoom:400,
			offset:10,
			position:"right",
			preload:1,
			lens:1
		});
	})

    //添加到购物车按钮
	$("#add-cart-btn").click(function(){
		var num = $("#good_nums").val();
		if(num == '' || parseInt(num) < 1){
			alert('请选择正确的数量！');
			return;
		}
		//发送ajax请求，将商品添加到购物车
		$.ajax({
			url:'../cart/add',
			type:'post',
			data:{num:num,productId:'${product.id}'},
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){
					alert('添加成功！');
				}else{
					alert(data.msg);
				}
			}
		});
	});
	
    //添加到收藏按钮
	$("#add-favorite-btn").click(function(){
		var pid = $(this).attr('pid');  //取到属性pid的值
		var $this = $(this);
		$.ajax({
			url:'../favorite/add',
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
</script>
</body>
</html>
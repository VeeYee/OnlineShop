<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<link rel="stylesheet" href="../resources/home/css/shop_list.css" type="text/css" />
<script type="text/javascript" src="../resources/home/js/shop_list.js" ></script>
<script type="text/javascript" src="../resources/home/js/jquery.min.js"></script>
<script type="text/javascript" src="../resources/home/js/jquery.js" ></script>
<!-- 商品分类页主体 -->
<div class="shop_bd clearfix">
	<!-- 左侧热卖推荐商品列表 -->
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

	<!-- 商品列表 -->
	<div class="shop_bd_list_right clearfix">
		<!-- 按条件搜索 -->
		<div class="sort-bar">
			<div class="bar-l"> 
	            <!-- 不同的排序方式 -->
	            <ul class="array">
                	<li class="selected"><a title="默认排序"  class="nobg" href="../product/search?search_content=&page=${page}">默认</a></li>
              		<li><a title="按销量从高到低排序"  href="../product/search?search_content=${search_content }&orderBy=sellNum&priceMin=${priceMin}&priceMax=${priceMax}&page=${page}">销量</a></li>
              		<li><a title="按人气从高到低排序"  href="../product/search?search_content=${search_content }&orderBy=viewNum&priceMin=${priceMin}&priceMax=${priceMax}&page=${page}">人气</a></li>
             		<li><a title="按价格从高到低排序"  href="../product/search?search_content=${search_content }&orderBy=price&priceMin=${priceMin}&priceMax=${priceMax}&page=${page}">价格</a></li>
	            </ul>
	            <!-- 按价格区间搜索 -->
	            <div class="prices"> <em>¥</em>
	            	<input type="text" id="priceMin" value="${priceMin }" class="w30" style="width:50px;"> <em>--</em>
	              	<input type="text" id="priceMax" value="${priceMax }" class="w30" style="width:50px;">
	              	<input type="button" value="搜索" id="search_by_price" style="width:45px;"/>
	            </div>
	    	</div>
		</div>
		<div class="clear"></div>

		<!-- 显示属于本分类的所有商品 -->
		<div class="shop_bd_list_content clearfix">
			<ul>
			<c:forEach items="${productList }" var="product">
				<li>
					<dl>
						<dt><a href="../product/detail?id=${product.id }"><img src="${product.imageUrl }" /></a></dt>
						<dd class="title"><a href="../product/detail?id=${product.id }">${product.name }</a></dd>
						<dd class="content">
							<span class="goods_jiage">￥<strong>${product.price }</strong></span>
							<span class="goods_chengjiao">已售出${product.sellNum }件</span>
						</dd>
						<dd><span style="float: right;">浏览量${product.viewNum }</span></dd>
					</dl>
				</li>
			</c:forEach>
			</ul>
		</div>
		<div class="clear"></div>
		
		<!-- 分页导航 -->
		<div class="pagination"> 
			<ul>
				<li><span><a href="../product/search?search_content=${search_content }&orderBy=${orderBy }&priceMin=${priceMin}&priceMax=${priceMax}&page=${page -1}">上一页</a></span></li>
				<li><span class="currentpage">${page }</span></li>
				<li><span><a href="../product/search?search_content=${search_content }&orderBy=${orderBy }&priceMin=${priceMin}&priceMax=${priceMax}&page=${page +1}">下一页</a></span></li>
			</ul> 
		</div>
	</div>
</div>
<!-- 页脚 -->
<%@ include file ="../common/footer.jsp"%>
<script>
	//按价格区间搜索
	$("#search_by_price").click(function(){
		window.location.href = 'search?search_content=${search_content }&orderBy=${orderBy}&priceMin='+$("#priceMin").val()+'&priceMax='+$("#priceMax").val()+'&page=${page}'; 
	});
</script>
</body>
</html>
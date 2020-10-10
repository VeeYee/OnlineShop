<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<link rel="stylesheet" href="../resources/home/css/shop_gouwuche.css" type="text/css" />
<link rel="stylesheet" href="../resources/home/css/shop_list2.css" type="text/css" />
<!-- 购物车商品结算 Body -->
<div class="shop_gwc_bd clearfix">
	<div class="shop_gwc_bd_contents clearfix">
		<!-- 购物流程导航 -->
		<div class="shop_gwc_bd_contents_lc clearfix">
			<ul>
				<li class="step_a">确认购物清单</li>
				<li class="step_b hover_b">确认收货人资料及送货方式</li>
				<li class="step_c">购买完成</li>
			</ul>
		</div>
		<div class="clear"></div>
		
		<!-- 收货地址  -->
		<div class="shop_bd_shdz_title">
			<h3>收货人地址</h3>
			<p><a href="javasrcipt:void(0);" id="new_add_shdz_btn" style="text-decoration: none;">新增收货地址</a>
		</div>
		<div class="clear"></div>
		
		<div class="shop_bd_shdz clearfix">
			<div class="shop_bd_shdz_lists clearfix">
				<ul>
					<c:forEach items="${addressList }" var="address"><!-- CartController list_2 -->
						<li>
							<label>收货地址：<span><input type="radio" name="address" value="${address.id }"/></span></label>
							<em>${address.address }</em><em>${address.name }(收)</em><em>${address.phone }</em>
						</li>
					</c:forEach>
				</ul>
			</div>
			<!-- 新增收货地址 -->
			<div id="new_add_shdz_contents" style="display:none;" class="shop_bd_shdz_new clearfix">
				<div class="title">新增收货地址</div>
				<div class="shdz_new_form">
					<form>
						<ul>
							<li><label for=""><span>*</span>收货人姓名：</label><input type="text" id="name" class="name"/></li>
							<li><label for=""><span>*</span>详细地址：</label><input type="text" id="address" class="xiangxi"/></li>
							<li><label for=""><span>*</span>手机号：</label><input type="text" id="phone"  class="dianhua" /></li>
							<li><label for="">&nbsp;</label><a href="javascript:void(0)" class="add_address_btn" id="add_address_btn" style="text-decoration: none;">确认添加</a></li>
						</ul>
					</form>
				</div>
			</div>
		</div>
		<div class="clear"></div>
		
		<!-- 购物清单中的商品 -->
		<div class="shop_bd_shdz_title">
			<h3>确认购物清单</h3>
		</div>
		<div class="clear"></div>
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
						<a href="javascript:void(0);" class="cart_delete_btn" cid="${cart.id}">删除</a><!-- 可获取要删除商品的id -->
					</td>
				</tr>
			</c:forEach>
			</tbody>
			<!-- 提交订单 -->
			<tfoot>
				<tr>
					<td colspan="6" style="text-align:left;font-size:14px;">
						<textarea id="order-remark" style="width:1000px;height:75px;" placeholder="订单备注"></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="6">
						<div class="gwc_foot_zongjia">商品总价(不含运费)<span>￥<strong id="good_zongjia">0.00</strong></span></div>
						<div class="clear"></div>
						<div class="gwc_foot_links">
							<a href="list" class="go">返回</a> <!-- 返回到购物车页面 -->
							<a href="javascript:void(0)" id="submit-order-btn" class="op">提交订单</a>
						</div>
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
	//新增地址
	jQuery(function(){
		jQuery("#new_add_shdz_btn").toggle(function(){
			jQuery("#new_add_shdz_contents").show(500);
		},function(){
			jQuery("#new_add_shdz_contents").hide(500);
		});
	});

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
	
	//删除商品
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
	
	//计算商品总价
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
	
	//新增收货地址
	$("#add_address_btn").click(function(){
		var name = $("#name").val();
		var address = $("#address").val();
		var phone = $("#phone").val();
		if(name == '' || address == '' || phone == ''){
			alert('请填写完整的地址信息！');
			return;
		}
		$.ajax({
			url:'../address/add',  //地址添加
			type:'post',
			data:{name:name,address:address,phone:phone},
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){
					alert('添加成功！');
					window.location.reload();  //刷新本页面
				}else{
					alert(data.msg);
				}
			}
		});
	});
	
	//提交订单
	$("#submit-order-btn").click(function(){
		var addressId = $("input[type='radio']:checked").val();  //是否已选择收货地址
		if(addressId == '' || addressId == 'undefined' || addressId == null){
			alert('请选择收货地址！');
			return;
		}
		$.ajax({
			url:'../order/add',
			type:'post',
			data:{addressId:addressId,remark:$("#order-remark").val()},
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){
					alert('下单成功！');
					window.location.href = '../order/order_success?orderId='+data.oid;  //跳转到下单成功页面
				}else{
					alert(data.msg);
				}
			}
		});
	});
</script>
</body>
</html>
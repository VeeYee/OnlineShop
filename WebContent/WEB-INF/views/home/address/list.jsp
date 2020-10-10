<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="../common/header.jsp"%>
<link rel="stylesheet" href="../resources/home/css/shop_shdz_835.css" type="text/css" />
<!-- 我的个人中心主页 -->
<div class="shop_member_bd clearfix">
	<!-- 导入左侧菜单 -->
	<%@ include file ="../common/user_menu.jsp"%>
	<!-- 地址管理 -->
	<div class="shop_member_bd_right clearfix">
		<div class="shop_meber_bd_good_lists clearfix">
			<div class="title"><h3>管理收货地址<a style="float:right;" href="javasrcipt:void(0);" id="new_add_shdz_btn">新增收货地址</a></h3></div>
			<div class="clear"></div>
		<div class="shop_bd_shdz clearfix">
			<!-- 所有收货人地址 -->
			<div class="shop_bd_shdz_lists clearfix">
				<ul>
					<c:forEach items="${addressList }" var="address">
						<li><label><span>收货地址：</span></label>
						<em>${address.address }</em><em>${address.name }(收)</em><em>${address.phone }</em>
						<span class="admin_shdz_btn">
							<a href="javascript:void(0)" class="edit-btn" data-id="${address.id }" data-name="${address.name }" data-address="${address.address }" data-phone="${address.phone }">编辑</a>
							<a href="javascript:void(0)" class="del-btn" data-id="${address.id }">删除</a>
						</span></li>
					</c:forEach>
				</ul>
			</div>
			<!-- 新增收货地址 -->
			<div id="new_add_shdz_contents" style="display:none;" class="shop_bd_shdz_new clearfix">
				<div class="title" id="new-title">新增收货地址</div>
				<div class="shdz_new_form">
					<form>
						<ul>
							<li><label for=""><span>*</span>收货人姓名：</label><input type="text" id="name" class="name"/></li>
							<li><label for=""><span>*</span>详细地址：</label><input type="text" id="address" class="xiangxi"/></li>
							<li><label for=""><span>*</span>手机号：</label><input type="text" id="phone"  class="dianhua" /></li>
							<li><label for="">&nbsp;</label><a href="javascript:void(0)" class="add_address_btn" id="add_address_btn" style="text-decoration: none;">确认增加</a></li>
						</ul>
					</form>
				</div>
			</div>
			
			<!-- 编辑收货地址 -->
			<div id="new_edit_shdz_contents" style="display:none;" class="shop_bd_shdz_new clearfix">
				<div class="title" id="new-title">编辑收货地址</div>
				<div class="shdz_new_form">
					<form>
						<input type="hidden" id="edit-id"/>
						<ul>
							<li><label for=""><span>*</span>收货人姓名：</label><input type="text" id="edit-name" class="name"/></li>
							<li><label for=""><span>*</span>详细地址：</label><input type="text" id="edit-address" class="xiangxi"/></li>
							<li><label for=""><span>*</span>手机号：</label><input type="text" id="edit-phone"  class="dianhua" /></li>
							<li><label for="">&nbsp;</label><a href="javascript:void(0)" class="add_address_btn" id="edit_address_btn" style="text-decoration: none;">确认修改</a></li>
						</ul>
					</form>
				</div>
			</div>
			<!-- 新增收货地址 End -->
		</div>
		<div class="clear"></div>
		</div>
	</div>
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
	//出现新增地址的窗口
	jQuery(function(){
		jQuery("#new_add_shdz_btn").toggle(function(){
			jQuery("#new_add_shdz_contents").show(500);
		},function(){
			jQuery("#new_add_shdz_contents").hide(500);
		});
	});
	
	//点击编辑按钮，编辑收货地址
	$(".edit-btn").click(function(){
		var $this = $(this);
		if($("#new_edit_shdz_contents").css('display') == 'none'){
			//打开编辑地址前，在表单中填写数据
			$("#edit-name").val($this.attr('data-name'));
			$("#edit-address").val($this.attr('data-address'));
			$("#edit-phone").val($this.attr('data-phone'));
			$("#edit-id").val($this.attr('data-id'));
			jQuery("#new_edit_shdz_contents").show(500);
		}else{
			jQuery("#new_edit_shdz_contents").hide(500);
		}
	});
	
	//点击删除按钮 删除收货地址
	$(".del-btn").click(function(){  //必须使用class属性
		var $this = $(this);
		if(confirm('确认删除该地址吗？')){
			$.ajax({
				url:'../address/delete',
				type:'post',
				data:{id:$this.attr('data-id')},
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
	
	//编辑收货地址
	$("#edit_address_btn").click(function(){
		var name = $("#edit-name").val();
		var address = $("#edit-address").val();
		var phone = $("#edit-phone").val();
		var id = $("#edit-id").val();
		if(name == '' || address == '' || phone == ''){
			alert('请填写完整的地址信息！');
			return;
		}
		$.ajax({
			url:'../address/edit',  //编辑地址
			type:'post',
			data:{name:name,address:address,phone:phone,id:id},
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){
					alert('修改成功！');
					window.location.reload();  //刷新本页面
				}else{
					alert(data.msg);
				}
			}
		});
	});
</script>
</body>
</html>
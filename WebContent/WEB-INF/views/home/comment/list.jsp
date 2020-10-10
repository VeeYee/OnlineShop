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
	<!-- 我的评价列表 -->
	<div class="shop_member_bd_right clearfix">
		<div class="shop_meber_bd_good_lists clearfix">
			<div class="title"><h3>评价列表</h3></div>
			<table>
				<thead class="tab_title">
					<tr>
						<th style="width:75px;"><span>评价类型</span></th>
						<th style="width:350px;"><span>评价内容</span></th>
						<th style="width:150px;"><span>评价人</span></th>
						<th style="width:150px;"><span>宝贝信息</span></th>
						<th style="width:80px;"><span>操作</span></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${commentList }" var="comment">
					<tr>
						<td colspan="5">
						<table class="good" style="height:60px">
							<tbody>
								<tr>
									<td class="pingjia_pic">
										<c:if test="${comment.type == 1 }">
											<span class="pingjia_type pingjia_type_1"></span><!-- 好评 -->
										</c:if>
										<c:if test="${comment.type == 2 }">
											<span class="pingjia_type pingjia_type_2"></span><!-- 中评 -->
										</c:if>
										<c:if test="${comment.type == 0 }">
											<span class="pingjia_type pingjia_type_3"></span><!-- 差评 -->
										</c:if>
									</td>
									<td class="pingjia_title">
										<span>${comment.content }</span><br/>${comment.showTime}
									</td>
									<td class="pingjia_danjia"><strong>${comment.account.name }</strong></td>
									<td class="pingjia_shuliang">
										<a href="../product/detail?id=${comment.product.id }" style="color:black;">${comment.product.name }</a>
										<br/>￥ ${comment.product.price }</td>
									<td class="pingjia_caozuo">
										<a href="javascript:void(0)" data-id="${comment.id }" class="del-btn" style="color:#6ea8f0;">删除</a>
									</td>
								</tr>
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
</div>
<%@ include file ="../common/footer.jsp"%>
<script>
	//删除评论
	$(".del-btn").click(function(){
		var $this = $(this);
		if(confirm("是否确认删除？")){
			$.ajax({
				url:'../comment/delete',  
				type:'post',
				data:{commentId:$this.attr('data-id')},  //评论id
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
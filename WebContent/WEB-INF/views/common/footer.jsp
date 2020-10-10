<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 导入加载动画 -->
<div id="loading" style="position:absolute;z-index:1000;top:0px;left:0px;width:100%;height:100%;background:#FFFFFF;text-align:center;padding-top:12%">
	<img src="../../resources/admin/easyui/images/loading2.gif" width="300px">
	<h1><font color="#15428B">加载中...</font></h1>
</div>
<!-- 动画加载时间 -->
<script>
	var pc;
	$.parser.onComplete = function(){
		if(pc) clearTimeout(pc);
		pc = setTimeout(closes, 990);
	}
	
	function closes(){
		$('#loading').fadeOut('normal',function(){
			$(this).remove();
		});
	}
</script>

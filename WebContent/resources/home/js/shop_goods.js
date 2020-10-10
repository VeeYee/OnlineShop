
/**
 * 添加商品到购物车
 * 商品数量的加减方法
 * @returns
 */
 jQuery(function(){
 	jQuery("#good_num_jian").click(function(){
 		var num = jQuery("#good_nums").val();
 		num = parseInt(num);
 		num = num-1;
 		if(num<=1){
 			num = 1;  //商品数量不能小于1
 		}
 		jQuery("#good_nums").val(num);
 	});

 	jQuery("#good_num_jia").click(function(){
 		var num = jQuery("#good_nums").val();
 		num = parseInt(num);
 		num = num+1;
 		//商品数量不能超过库存量
 		if(num > parseInt($("#good_num_jia").attr('stock'))){
 			num = parseInt($("#good_num_jia").attr('stock'));
 		}
 		jQuery("#good_nums").val(num);
 	});
 });
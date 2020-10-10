package edu.hbuas.programmer.controller.home;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.common.Account;
import edu.hbuas.programmer.entity.common.Order;
import edu.hbuas.programmer.entity.common.OrderItem;
import edu.hbuas.programmer.entity.common.Product;
import edu.hbuas.programmer.entity.home.Address;
import edu.hbuas.programmer.entity.home.Cart;
import edu.hbuas.programmer.service.common.OrderService;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.service.common.ProductService;
import edu.hbuas.programmer.service.home.AddressService;
import edu.hbuas.programmer.service.home.CartService;
import edu.hbuas.programmer.util.DateUtil;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 前台订单控制器
 * @author Yee
 *
 */
@RequestMapping("/order")
@Controller
public class HomeOrderController {
	
	@Autowired
	private ProductCategoryService productCategoryService;
	@Autowired
	private ProductService productService;
	@Autowired
	private OrderService orderService;
	@Autowired
	private CartService cartService;
	@Autowired
	private AddressService addressService;
	
	/**
	 * 订单列表
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model,Integer page,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		Account onlineAccount = (Account) request.getSession().getAttribute("account");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		if(page == null || page.intValue() <= 0) {
			page = 1;
		}
		queryMap.put("offset", (page -1)*3);
		queryMap.put("pageSize", 3);
		queryMap.put("userId", onlineAccount.getId());
		queryMap.put("orderBy", "createTime");  //最新的订单在最上面
		queryMap.put("sort", "desc");
		List<Order> orderList = orderService.findList(queryMap);
		//查出订单子项
		for(Order order:orderList) {
			order.setOrderItems(orderService.findOrderItemList(order.getId()));
			order.setOrderTime(DateUtil.date2String(order.getCreateTime()));  //时间格式转换
		}
		model.addObject("orderList", orderList);  //查出所有的订单
		model.addObject("currentUser","current_");
		model.addObject("title", "我的订单");
		model.addObject("page", page); //分页
		model.setViewName("home/order/list");
		return model;
	}
	
	/**
	 * 确认收货处理
	 * @param id
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/finish_order",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> finishOrder(Long id,HttpServletRequest request) {
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(id == null) {
			ret.put("msg", "请选择要收货的订单！");
			return ret;
		}
		Order order = orderService.findById(id);
		if(order == null) {
			ret.put("msg", "订单不存在！");
			return ret;
		}
		//当前状态不是已发货时，不可确认收货
		if(order.getStatus() != Order.ORDER_STATUS_SENT) {
			ret.put("msg", "当前订单状态不可更改！");
			return ret;
		}
		order.setStatus(Order.ORDER_STATUS_FINISH);  //成功收货，更改订单状态为已完成
		if(orderService.edit(order) <= 0) {
			ret.put("msg", "订单收货成功！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
	
	/**
	 * 添加订单，用户下单
	 * @param addressId  地址id
	 * @param remark  订单备注
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(Long addressId,
			@RequestParam(name="remark",required = false)String remark,
			HttpServletRequest request) {
		Account onlineAccount = (Account) request.getSession().getAttribute("account");  //当前登录用户
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(addressId == null) {
			ret.put("msg", "请选择收货地址！");
			return ret;
		}
		Address address = addressService.findById(addressId);
		if(address == null) {
			ret.put("msg", "地址不存在！");
			return ret;
		}
		//根据用户id查询购物车
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("userId", onlineAccount.getId());
		List<Cart> cartList = cartService.findList(queryMap);
		if(cartList == null) {
			ret.put("msg", "该用户购物车中没有商品！");
			return ret;
		}
		Order order = new Order();
		double totalMoney = 0;  //订单总价
		int totalNum = 0;  //订单商品总数
		//遍历购物车中的商品，生成订单子项
		for(Cart cart : cartList) {
			OrderItem orderItem = new OrderItem();
			orderItem.setProductId(cart.getProductId());
			orderItem.setName(cart.getName());
			orderItem.setImageUrl(cart.getImageUrl());
			orderItem.setPrice(cart.getPrice());  //每项商品的单价
			orderItem.setNum(cart.getNum());  //每项商品的数量
			orderItem.setMoney(cart.getMoney()); //每项商品的总价
			totalMoney += cart.getMoney();  
			totalNum += cart.getNum();
			order.getOrderItems().add(orderItem); //将订单子项添加到订单中
		}
		//设置订单属性
		order.setSn("O"+System.currentTimeMillis());  //时间戳生成订单编号
		order.setUserId(onlineAccount.getId());
		order.setAddress(address.getAddress()+" "+address.getName()+"(收)"+address.getPhone());
		order.setMoney(totalMoney);  //计算订单的总价和数量
		order.setProductNum(totalNum);
		order.setStatus(Order.ORDER_STATUS_WAITING);  //待发货状态
		order.setRemark(remark);
		order.setCreateTime(new Date());
		//提交订单到数据库
		if(orderService.add(order) <= 0) {
			ret.put("msg", "订单提交失败！");
			return ret;
		}
		//下单成功，清空购物车商品及更新商品销量
		for(Cart cart:cartList) { 
			Product product = productService.findById(cart.getProductId());
			product.setStock(product.getStock() - cart.getNum());
			product.setSellNum(product.getSellNum() + cart.getNum());
			//更新购买的每个商品的信息    库存-1   销量+1
			productService.updateNum(product);
		}
		//清空购物车
		cartService.deleteByUid(onlineAccount.getId());
		ret.put("type", "success");
		ret.put("oid", order.getId());
		return ret;
	}
	
	/**
	 * 下单成功页面
	 * @param model
	 * @param orderId  订单id
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/order_success",method = RequestMethod.GET)
	public ModelAndView orderSuccess(ModelAndView model,Long orderId,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		model.addObject("currentCart","current_");
		model.addObject("msg", "下单成功！");
		model.addObject("title", "下单成功");
		model.addObject("order", orderService.findById(orderId));  
		model.setViewName("home/cart/order_success");
		return model;
	}
	
	@RequestMapping(value="/comment",method = RequestMethod.GET)
	public ModelAndView comment(ModelAndView model,Long pid,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		model.addObject("currentUser","current_");
		model.addObject("title", "商品评价");
		model.addObject("product", productService.findById(pid));  
		model.setViewName("home/order/comment");
		return model;
	}
}

package edu.hbuas.programmer.controller.home;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.common.Account;
import edu.hbuas.programmer.entity.common.Product;
import edu.hbuas.programmer.entity.home.Cart;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.service.common.ProductService;
import edu.hbuas.programmer.service.home.AddressService;
import edu.hbuas.programmer.service.home.CartService;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 购物车控制器
 * @author Yee
 *
 */
@RequestMapping("/cart")
@Controller
public class CartController {
	
	@Autowired
	private ProductCategoryService productCategoryService;
	@Autowired
	private ProductService productService;
	@Autowired
	private CartService cartService;
	@Autowired
	private AddressService addressService;
	
	/**
	 * 购物车列表页面
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView productCategoryList(ModelAndView model,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		//获取当前登录的用户
		Account onlineAccount = (Account) request.getSession().getAttribute("account");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("userId", onlineAccount.getId());
		model.addObject("title", "购物车");
		model.addObject("cartList", cartService.findList(queryMap));
		//当前选中的菜单是购物车
		model.addObject("currentCart","current_");
		model.setViewName("home/cart/list");
		return model;
	}
	
	/**
	 * 从购物车去结算页面
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/list_2",method = RequestMethod.GET)
	public ModelAndView list2(ModelAndView model,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		//获取当前登录的用户
		Account onlineAccount = (Account) request.getSession().getAttribute("account");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("userId", onlineAccount.getId());
		model.addObject("title", "订单提交");
		model.addObject("cartList", cartService.findList(queryMap));  //待购买商品集合
		model.addObject("addressList", addressService.findList(queryMap));  //地址集合
		//当前选中的菜单是购物车
		model.addObject("currentCart","current_");
		model.setViewName("home/cart/list_2");
		return model;
	}
	
	/**
	 * 添加商品到购物车
	 * @param cart
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(Cart cart,HttpServletRequest request) {
		Account onlineAccount = (Account) request.getSession().getAttribute("account");  //当前登录用户
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(cart == null) {
			ret.put("msg", "商品信息有误！");
			return ret;
		}
		if(cart.getProductId() == null) {
			ret.put("msg", "请选择要添加的商品！");
			return ret;
		}
		if(cart.getNum() == 0) {
			ret.put("msg", "请选择商品数量！");
			return ret;
		}
		Product product = productService.findById(cart.getProductId());
		if(product == null) {
			ret.put("msg", "商品不存在！");
			return ret;
		}
		if(product.getStock() <= 0) {
			ret.put("msg", "添加失败，商品库存不足！");
			return ret;
		}
		//根据商品id和用户id查询该商品是否已被添加过
		Map<String, Long> queryMap = new HashMap<String, Long>();
		queryMap.put("userId", onlineAccount.getId());
		queryMap.put("productId", cart.getProductId());
		Cart existCart = cartService.findByIds(queryMap);
		if(existCart != null) {
			//表示这个商品已被这个用户添加到购物车，只需更新商品数量即可
			existCart.setNum(existCart.getNum()+cart.getNum()); //原数量+新增数量（添加到购物车只能增加商品数量）
			existCart.setMoney(existCart.getNum() * existCart.getPrice());
			if(cartService.edit(existCart) <= 0) {
				ret.put("msg", "商品已被添加到购物车，但更新数量出错！");
				return ret;
			}
			ret.put("type", "success");
			return ret;
		}
		cart.setUserId(onlineAccount.getId());
		cart.setName(product.getName());
		cart.setImageUrl(product.getImageUrl());
		cart.setNum(cart.getNum());
		cart.setPrice(product.getPrice());
		cart.setMoney(product.getPrice() * cart.getNum());
		cart.setCreateTime(new Date());
		//该商品未添加过，直接添加到购物车
		if(cartService.add(cart) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "添加失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
	/**
	 * 在购物车中更新商品数量
	 * @param cartId  购物车id
	 * @param num  改变的商品数量
	 * @return
	 */
	@RequestMapping(value="/update_num",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(Long cartId,Integer num) {
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		Cart cart = cartService.findById(cartId);
		if(cart == null) {
			ret.put("msg", "商品信息有误！");
			return ret;
		}
		if(num == null) {
			ret.put("msg", "请选择商品数量！");
			return ret;
		}
		//找到该商品，获取商品库存
		Product product = productService.findById(cart.getProductId());
		if(product == null) {
			ret.put("msg", "商品不存在！");
			return ret;
		}
		if(cart.getNum() + num.intValue() > product.getStock()) {  //购物车中数量+新增数量>库存
			ret.put("msg", "商品库存不足！");
			return ret;
		}
		cart.setNum(cart.getNum() + num); //原数量+新增数量
		cart.setMoney(cart.getNum() * cart.getPrice());
		if(cartService.edit(cart) <= 0) {
			ret.put("msg", "操作失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
	/**
	 * 删除购物车中的商品
	 * @param cartId
	 * @return
	 */
	@RequestMapping(value="/delete",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delete(Long cartId) {
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(cartId == null) {
			ret.put("msg", "请选择要删除的商品！");
			return ret;
		}
		if(cartService.delete(cartId) <= 0) {
			ret.put("msg", "删除出错，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}

}

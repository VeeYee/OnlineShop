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
import edu.hbuas.programmer.entity.home.Favorite;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.service.common.ProductService;
import edu.hbuas.programmer.service.home.FavoriteService;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 收藏控制器
 * @author Yee
 *
 */
@RequestMapping("/favorite")
@Controller
public class FavoriteController {
	
	@Autowired
	private ProductCategoryService productCategoryService;
	@Autowired
	private ProductService productService;
	@Autowired
	private FavoriteService favoriteService;
	
	/**
	 * 收藏列表页面
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView productCategoryList(ModelAndView model,Integer page,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		Account onlineAccount = (Account) request.getSession().getAttribute("account");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		if(page == null || page.intValue() <= 0) {
			page = 1;
		}
		queryMap.put("offset", (page -1)*8);  //每页显示8个商品
		queryMap.put("pageSize", 8);
		queryMap.put("userId", onlineAccount.getId());
		queryMap.put("orderBy", "createTime");  //最新的订单在最上面
		queryMap.put("sort", "desc");
		model.addObject("favoriteList", favoriteService.findList(queryMap));  //所有收藏的商品
		model.addObject("currentUser", "current_");
		model.addObject("title", "我的收藏");
		model.addObject("page", page); //分页
		model.setViewName("home/favorite/list");
		return model;
	}
	
	/**
	 * 添加商品到收藏
	 * @param favorite
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(Favorite favorite,HttpServletRequest request) {
		Account onlineAccount = (Account) request.getSession().getAttribute("account");  //当前登录用户
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(favorite == null) {
			ret.put("msg", "商品信息有误！");
			return ret;
		}
		if(favorite.getProductId() == null) {
			ret.put("msg", "请选择要收藏的商品！");
			return ret;
		}
		Product product = productService.findById(favorite.getProductId());
		if(product == null) {
			ret.put("msg", "商品不存在！");
			return ret;
		}
		//根据商品id和用户id查询该商品是否已被添加过
		Map<String, Long> queryMap = new HashMap<String, Long>();
		queryMap.put("userId", onlineAccount.getId());
		queryMap.put("productId", favorite.getProductId());
		Favorite existFavorite = favoriteService.findByIds(queryMap);
		if(existFavorite != null) {
			ret.put("msg", "您已收藏过该商品！");
			return ret;
		}
		//该商品未添加过，直接添加到收藏
		favorite.setUserId(onlineAccount.getId());
		favorite.setName(product.getName());
		favorite.setImageUrl(product.getImageUrl());
		favorite.setPrice(product.getPrice());
		favorite.setCreateTime(new Date());
		if(favoriteService.add(favorite) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "收藏失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
	/**
	 * 删除收藏中的商品
	 * @param favoriteId
	 * @return
	 */
	@RequestMapping(value="/delete",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delete(Long favoriteId) {
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(favoriteId == null) {
			ret.put("msg", "请选择要删除的商品！");
			return ret;
		}
		if(favoriteService.delete(favoriteId) <= 0) {
			ret.put("msg", "删除出错，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
}

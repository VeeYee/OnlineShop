package edu.hbuas.programmer.controller.home;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.common.Product;
import edu.hbuas.programmer.entity.common.ProductCategory;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.service.common.ProductService;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 商品展示控制器
 * @author Yee
 *
 */
@RequestMapping("/product")
@Controller
public class HomeProductController {
	
	@Autowired
	private ProductCategoryService productCategoryService;
	@Autowired
	private ProductService productService;
	
	/**
	 * 根据分类列出该分类下的所有商品 ，还可按以下条件查询出该分类下满足条件的商品
	 * @param model
	 * @param cid  分类id
	 * @param orderBy   排序依据，可根据销量、浏览量、价格来排序
	 * @param priceMin  最低价格
	 * @param priceMax  最高价格
	 * @param page  当前页
	 * @return  返回分类详情页
	 */
	@RequestMapping(value="/product_category_list",method = RequestMethod.GET)
	public ModelAndView productCategoryList(ModelAndView model, 
			@RequestParam(name="cid",required = true)Long cid,
			@RequestParam(name="orderBy",required = false)String orderBy,
			@RequestParam(name="priceMin",required = false)Double priceMin,
			@RequestParam(name="priceMax",required = false)Double priceMax,
			@RequestParam(name="page",required = false)Integer page) {
		//不是首页加上id样式 （让左侧分类列表显示出来）
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		model.addObject("title","错误页面");
		model.addObject("currentHome","current_");
		if(cid == null) {  //未传cid时
			model.addObject("msg", "分类不存在");
			model.setViewName("home/common/error");
			return model;
		}
		//根据id查找该分类
		ProductCategory productCategory = productCategoryService.findById(cid);
		if(productCategory == null) {
			model.addObject("msg", "分类不存在");
			model.setViewName("home/common/error");
			return model;
		}
		model.addObject("title","分类-"+productCategory.getName());
		// queryListMap--查询条件  -- 销量、人气、价格、价格区间等
		Map<String, Object> queryListMap = new HashMap<String, Object>();
		queryListMap.put("tags", cid);
		if(!StringUtils.isEmpty(orderBy)) {
			queryListMap.put("orderBy", orderBy);  //排序依据
			queryListMap.put("sort","desc");  //降序排列
		}
		if(priceMin != null) {
			queryListMap.put("priceMin",priceMin);
		}
		if(priceMax != null) {
			queryListMap.put("priceMax",priceMax);
		}
		if(page == null || page.intValue() <= 0) {
			page = 1;  //默认第一页
		}
		queryListMap.put("offset", (page-1)*20);
		queryListMap.put("pageSize", 20);  //每页展示20个商品
		model.addObject("productList", productService.findList(queryListMap));  //根据queryListMap查询出的商品
		
		// queryMap--查询条件  -- 销量降序（左侧展示最近热卖）
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 10);
		queryMap.put("orderBy", "sellNum");  
		queryMap.put("sort", "desc");  
		model.addObject("sellProductList", productService.findList(queryMap)); //根据queryMap查询出的商品
		//链接里的参数  多条件查询需要
		model.addObject("cid", cid);
		model.addObject("orderBy", orderBy);
		model.addObject("priceMin", priceMin);
		model.addObject("priceMax", priceMax);
		model.addObject("page", page);
		model.setViewName("home/product/list");
		return model;
	}
	
	/**
	 * 关键字搜索商品列表页，搜索出来还可以多条件查询
	 * @param model
	 * @param search_content  搜索关键词
	 * @param orderBy  排序依据
	 * @param priceMin  最低价格
	 * @param priceMax  最高价格
	 * @param page   当前页
	 * @return
	 */
	@RequestMapping(value="/search")
	public ModelAndView search(ModelAndView model, 
			@RequestParam(name="search_content",required = true)String search_content,
			@RequestParam(name="orderBy",required = false)String orderBy,
			@RequestParam(name="priceMin",required = false)Double priceMin,
			@RequestParam(name="priceMax",required = false)Double priceMax,
			@RequestParam(name="page",required = false)Integer page) {
		//分类页的分类菜单
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		//不是首页加上Id样式 （让左侧分类列表显示出来）
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("title","搜索-" + search_content);
		model.addObject("currentHome","current_");
		
		//按照商品销量排序  --  最近热卖
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 10);
		queryMap.put("orderBy", "sellNum"); 
		queryMap.put("sort", "desc");  
		model.addObject("sellProductList", productService.findList(queryMap)); //最近热卖商品
		
		Map<String, Object> queryListMap = new HashMap<String, Object>();
		queryListMap.put("name", search_content);
		if(!StringUtils.isEmpty(orderBy)) {
			queryListMap.put("orderBy", orderBy);
			queryListMap.put("sort","desc");
		}
		if(priceMin != null) {
			queryListMap.put("priceMin",priceMin);
		}
		if(priceMax != null) {
			queryListMap.put("priceMax",priceMax);
		}
		if(page == null || page.intValue() <= 0) {
			page = 1;  //默认第一页
		}
		queryListMap.put("offset", (page-1)*20);
		queryListMap.put("pageSize", 20);
		model.addObject("productList", productService.findList(queryListMap));  //多条件查询结果
		
		//链接中需要的参数
		model.addObject("search_content", search_content);
		model.addObject("orderBy", orderBy);
		model.addObject("priceMin", priceMin);
		model.addObject("priceMax", priceMax);
		model.addObject("page", page);
		model.setViewName("home/product/search");
		return model;
	}
	
	/**
	 * 商品详情页面
	 * @param model
	 * @param id  商品id
	 * @return
	 */
	@RequestMapping(value="/detail")
	public ModelAndView detail(ModelAndView model, Long id) {
		//分类页的分类菜单
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		model.addObject("title","错误页面");
		model.addObject("currentHome","current_");
		if(id == null) {
			model.addObject("msg", "商品不存在");
			model.setViewName("home/common/error");
			return model;
		}
		Product product = productService.findById(id);
		if(product == null) {
			model.addObject("msg", "商品不存在");
			model.setViewName("home/common/error");
			return model;
		}
		//根据id查询到的商品
		model.addObject("product",product);
		model.addObject("title","商品详情页");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 10);
		queryMap.put("orderBy", "sellNum"); 
		queryMap.put("sort", "desc");  
		model.addObject("sellProductList", productService.findList(queryMap)); //最近热卖商品
		model.setViewName("home/product/detail");
		//打开商品详情页，浏览量 + 1
		product.setViewNum(product.getViewNum()+1);
		productService.updateNum(product);
		return model;
	}
	
}

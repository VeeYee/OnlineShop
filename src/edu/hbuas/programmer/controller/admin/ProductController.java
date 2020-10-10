package edu.hbuas.programmer.controller.admin;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.common.Product;
import edu.hbuas.programmer.entity.common.ProductCategory;
import edu.hbuas.programmer.page.admin.Page;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.service.common.ProductService;
import edu.hbuas.programmer.util.MenuUtil;
import net.sf.json.JSONArray;

/**
 * 商品管理控制器
 * @author Yee
 *
 */
@RequestMapping("/admin/product")
@Controller
public class ProductController {
	
	@Autowired
	private ProductCategoryService productCategoryService;
	@Autowired
	private ProductService productService;
	
	/**
	 * 商品列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model) {
		model.setViewName("product/list");
		//返回所有的商品分类
		model.addObject("productCategoryList",JSONArray.fromObject(productCategoryService.findList(new HashMap<String, Object>())));
		return model;
	}
	
	/**
	 * 获取商品列表数据
	 * @param name
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(Page page,
			@RequestParam(name="name",defaultValue = "",required = false)String name,
			@RequestParam(name="productCategoryId",required = false)Long productCategoryId,
			@RequestParam(name="priceMin",required = false)Double priceMin,
			@RequestParam(name="priceMax",required = false)Double priceMax) {
		//编辑查询条件
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("name", name);
		if(productCategoryId != null) {
			queryMap.put("tags", productCategoryId);
		}
		if(priceMin != null) {
			queryMap.put("priceMin", priceMin);
		}
		if(priceMax != null) {
			queryMap.put("priceMax", priceMax);
		}
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		//查询的结果集
		Map<String, Object> ret = new HashMap<String, Object>();
		//rows是每条Product数据
		ret.put("rows", productService.findList(queryMap));  
		ret.put("total", productService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 商品添加页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.GET)
	public ModelAndView add(ModelAndView model) {
		model.setViewName("product/add");
		return model;
	}
	
	/**
	 * 添加商品
	 * @param product
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(Product product) {
		Map<String, Object> ret = new HashMap<String, Object>();
		if(product == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的商品信息！");
			return ret;
		}
		if(StringUtils.isEmpty(product.getName())) {
			ret.put("type", "error");
			ret.put("msg", "请填写商品名称！");
			return ret;
		}
		if(product.getProductCategoryId() == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写所属分类！");
			return ret;
		}
		if(product.getPrice() == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写商品价格！");
			return ret;
		}
		if(StringUtils.isEmpty(product.getImageUrl())) {
			ret.put("type", "error");
			ret.put("msg", "请上传商品主图！");
			return ret;
		}
		//找到商品的父分类，设置商品标签
		ProductCategory productCategory = productCategoryService.findById(product.getProductCategoryId());
		//此产品的标签 = 父分类的标签 + 父分类本身的id （标签也就是父分类的id）
		product.setTags(productCategory.getTags()+","+productCategory.getId());  
		product.setCreateTime(new Date());
		if(productService.add(product) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "添加失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "商品添加成功！");
		return ret;
	}
	
	/**
	 * 返回三级树形菜单
	 * @return
	 */
	@RequestMapping(value="/tree_list",method=RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> treeList(){
		Map<String, Object> queryMap = new HashMap<String, Object>();
		return MenuUtil.getTreeCategory(productCategoryService.findList(queryMap));
	}
	
	
	/**
	 * 删除商品
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/delete",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delete(Long id) {
		Map<String, Object> ret = new HashMap<String, Object>();
		if(id == null) {
			ret.put("type", "error");
			ret.put("msg", "请选择要删除的商品！");
			return ret;
		}
		try {
			if(productService.delete(id) <= 0) {
				ret.put("type", "error");
				ret.put("msg", "删除失败，请联系管理员！");
				return ret;
			}
		} catch (Exception e) {
			ret.put("type", "error");
			ret.put("msg", "该商品下存在订单信息，不允许删除！");
			return ret;
		}
		
		ret.put("type", "success");
		ret.put("msg", "商品删除成功！");
		return ret;
	}
	
	/**
	 * 商品编辑页面
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/edit",method = RequestMethod.GET)
	public ModelAndView edit(ModelAndView model,Long id) {
		model.setViewName("product/edit");
		model.addObject("product",productService.findById(id));
		return model;
	}
	
	/**
	 * 编辑商品
	 * @param product
	 * @return
	 */
	@RequestMapping(value="/edit",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Product product){
		Map<String, String> ret = new HashMap<String, String>();
		if(product == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的商品信息！");
			return ret;
		}
		if(StringUtils.isEmpty(product.getName())) {
			ret.put("type", "error");
			ret.put("msg", "请填写商品名称！");
			return ret;
		}
		if(product.getProductCategoryId() == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写所属分类！");
			return ret;
		}
		if(product.getPrice() == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写商品价格！");
			return ret;
		}
		if(StringUtils.isEmpty(product.getImageUrl())) {
			ret.put("type", "error");
			ret.put("msg", "请上传商品主图！");
			return ret;
		}
		//找到商品的父分类，设置商品标签
		ProductCategory productCategory = productCategoryService.findById(product.getProductCategoryId());
		//此产品的标签 = 父分类的标签 + 父分类本身的id （标签也就是父分类的id）
		product.setTags(productCategory.getTags()+","+productCategory.getId());  
		product.setCreateTime(new Date());
		if(productService.edit(product) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "编辑失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "商品编辑成功！");
		return ret;
	}
	
}

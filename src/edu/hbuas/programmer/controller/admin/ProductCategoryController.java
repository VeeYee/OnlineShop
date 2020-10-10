package edu.hbuas.programmer.controller.admin;

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

import edu.hbuas.programmer.entity.common.ProductCategory;
import edu.hbuas.programmer.page.admin.Page;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 商品分类管理控制器
 * @author Yee
 *
 */
@RequestMapping("/admin/product_category")
@Controller
public class ProductCategoryController {
	
	@Autowired
	private ProductCategoryService productCategoryService;
	
	/**
	 * 商品分类列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model) {
		model.setViewName("product_category/list");
		return model;
	}
	
	/**
	 * 获取商品分类列表数据
	 * @param name
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(
			@RequestParam(name="name",defaultValue = "")String name,
			Page page) {
		//编辑查询条件
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("name", name);
		//queryMap.put("offset", page.getOffset());
		//queryMap.put("pageSize", page.getRows());
		//查询的结果集
		Map<String, Object> ret = new HashMap<String, Object>();
		//rows是每条ProductCategory数据
		ret.put("rows", productCategoryService.findList(queryMap));  
		ret.put("total", productCategoryService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 返回树形分类
	 * @return
	 */
	@RequestMapping(value="/tree_list",method=RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> treeList(){
		Map<String, Object> queryMap = new HashMap<String, Object>();
		return MenuUtil.getTreeCategory(productCategoryService.findList(queryMap));
	}
	
	
	/**
	 * 添加商品分类
	 * @param productCategory
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(ProductCategory productCategory) {
		Map<String, Object> ret = new HashMap<String, Object>();
		if(productCategory == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的分类信息！");
			return ret;
		}
		if(StringUtils.isEmpty(productCategory.getName())) {
			ret.put("type", "error");
			ret.put("msg", "请填写分类名称！");
			return ret;
		}
		if(productCategory.getParentId() != null) {
			ProductCategory productCategoryParent = productCategoryService.findById(productCategory.getParentId());
			//此分类的父级分类不为null -- 即不是顶级分类时
			if(productCategoryParent != null){
				String tags = "";
				//此分类的父级分类的标签不为null -- 即说明此分类的父级分类是二级分类
				if(productCategoryParent.getTags() != null){
					//此分类是三级分类，需要加上父级分类的标签（父级的父级）
					tags += productCategoryParent.getTags() + ",";
				}
				//再加上此分类的标签（此标签的父级id）
				productCategory.setTags(tags + productCategory.getParentId());
			}
		}
		if(productCategoryService.add(productCategory) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "添加失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "商品分类添加成功！");
		return ret;
	}
	
	/**
	 * 删除商品分类
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/delete",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delete(Long id) {
		Map<String, Object> ret = new HashMap<String, Object>();
		if(id == null) {
			ret.put("type", "error");
			ret.put("msg", "请选择要删除的分类！");
			return ret;
		}
		try {
			if(productCategoryService.delete(id) <= 0) {
				ret.put("type", "error");
				ret.put("msg", "删除失败，请联系管理员！");
				return ret;
			}
		} catch (Exception e) {
			//外键约束引起的异常，导致无法删除
			ret.put("type", "error");
			ret.put("msg", "该分类下存在商品信息，不允许删除！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "商品分类删除成功！");
		return ret;
	}
	
	/**
	 * 编辑商品分类
	 * @param productCategory
	 * @return
	 */
	@RequestMapping(value="/edit",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(ProductCategory productCategory){
		Map<String, String> ret = new HashMap<String, String>();
		if(productCategory == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的商品分类信息！");
			return ret;
		}
		if(productCategory.getParentId() == productCategory.getId()) {
			ret.put("type", "error");
			ret.put("msg", "请勿选择自己作为父分类！");
			return ret;
		}
		if(productCategoryService.edit(productCategory) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "商品分类修改失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "商品分类修改成功！");
		return ret;
	}
	
}

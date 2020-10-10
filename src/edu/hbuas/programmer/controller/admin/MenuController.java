package edu.hbuas.programmer.controller.admin;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.admin.Menu;
import edu.hbuas.programmer.page.admin.Page;
import edu.hbuas.programmer.service.admin.MenuService;

/**
 * 菜单管理控制器
 * @author Yee
 *
 */
@Controller
@RequestMapping("/admin/menu")
public class MenuController {
	
	@Autowired
	private MenuService menuService;
	
	/**
	 * 菜单管理列表页
	 * @param model
	 * @return 返回显示所有菜单数据的页面
	 */
	@RequestMapping(value="/list", method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model) {
		//找到所有上级菜单  此处使用setSession()也可以
		model.addObject("topList",menuService.findTopList());  
		model.setViewName("menu/list"); //找到list.jsp
		return model; //返回这个视图
	}
	
	/**
	 * 获取菜单列表的具体数据
	 * @param page 当前页，多页时默认返回第一页数据
	 * @param name 菜单名称，不是必须的参数，默认为 " " ；" "时将返回全部数据，否则查到菜单名中包含name的菜单记录
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.POST)
	@ResponseBody  //添加此注解就不会返回一个jsp页面，只返回json数据
	public Map<String, Object> getMenuList(Page page,
			@RequestParam(name="name",required = false,defaultValue = "") String name) {
		//查询参数的map集合
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		queryMap.put("name", name);
		//根据参数查询数据，返回所有数据或者返回模糊查询的结果
		List<Menu> findList = menuService.findList(queryMap);  
		//存放结果的集合
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("rows", findList);
		ret.put("total",menuService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 菜单添加
	 * @param menu
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody  //加上此注解就不会去寻找视图
	public Map<String, String> add(Menu menu){
		Map<String, String> ret = new HashMap<String, String>();
		if(menu == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的菜单信息");
			return ret;
		}
		if(StringUtils.isEmpty(menu.getName())) {
			ret.put("type", "error");
			ret.put("msg", "请填写菜单名称！");
			return ret;
		}
		if(StringUtils.isEmpty(menu.getIcon())) {
			ret.put("type", "error");
			ret.put("msg", "请填写菜单图标类！");
			return ret;
		}
		if(menu.getParentId() == null) {
			menu.setParentId(0l);
		}
		if(menuService.add(menu) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "添加失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "添加成功！");
		return ret;
	}
	
	/**
	 * 获取所有的菜单图标
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/get_icons",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getIconList(HttpServletRequest request){
		Map<String, Object> ret = new HashMap<String, Object>();
		String realPath = request.getServletContext().getRealPath("/");
		File file = new File(realPath+"\\resources\\admin\\easyui\\css\\icons");
		List<String> icons = new ArrayList<String>();
		if(!file.exists()) {
			ret.put("type","error");
			ret.put("msg","文件目录不存在！");
			return ret;
		}
		File[] listFiles = file.listFiles();
		for(File f:listFiles) {
			if(f!=null && f.getName().contains("png")) {
				icons.add("icon-"+f.getName().substring(0,f.getName().indexOf(".")).replace("_", "-"));
			}
		}
		ret.put("type", "success");
		ret.put("content", icons);  //将结果放在content变量中
		return ret;
	}
	
	/**
	 * 菜单修改
	 * @param menu
	 * @return
	 */
	@RequestMapping(value="/edit",method = RequestMethod.POST)
	@ResponseBody  //加上此注解就不会去寻找视图
	public Map<String, String> edit(Menu menu){
		Map<String, String> ret = new HashMap<String, String>();
		if(menu == null) {
			ret.put("type", "error");
			ret.put("msg", "请选择正确的菜单信息");
			return ret;
		}
		if(StringUtils.isEmpty(menu.getName())) {
			ret.put("type", "error");
			ret.put("msg", "请填写菜单名称！");
			return ret;
		}
		if(StringUtils.isEmpty(menu.getIcon())) {
			ret.put("type", "error");
			ret.put("msg", "请填写菜单图标类！");
			return ret;
		}
		if(menu.getParentId() == null) {
			menu.setParentId(0l);
		}
		if(menuService.edit(menu) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "修改失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "修改成功！");
		return ret;
	}
	
	/**
	 * 删除菜单信息
	 * @param id  菜单id，根据主键删除
	 * @return
	 */
	@RequestMapping(value="/delete",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> delete(
			@RequestParam(name="id",required = true) Long id){
		Map<String, String> ret = new HashMap<String, String>();
		if(id == null) {
			ret.put("type", "error");
			ret.put("msg", "请选择要删除的菜单信息！");
			return ret;
		}
		//判断该分类下是否有子分类，有则不能删除
		List<Menu> findChildrenList = menuService.findChildrenList(id);
		if(findChildrenList != null && findChildrenList.size()>0) {
			ret.put("type", "error");
			ret.put("msg", "该分类下存在子分类，不能删除！");
			return ret;
		}
		if(menuService.delete(id) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "删除失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "删除成功！");
		return ret;
	}
}

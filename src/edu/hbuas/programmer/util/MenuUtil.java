package edu.hbuas.programmer.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import edu.hbuas.programmer.entity.admin.Menu;
import edu.hbuas.programmer.entity.common.ProductCategory;

/**
 * 关于菜单操作的一些公用方法
 * @author Yee
 *
 */
public class MenuUtil {
	
	/**
	 * 获取所有的顶级菜单
	 * @param menuList 某角色已拥有权限的菜单列表（在这其中再找出顶级菜单）
	 * @return
	 */
	public static List<Menu> getAllTopMenu(List<Menu> menuList){
		List<Menu> ret = new ArrayList<Menu>();
		for(Menu menu:menuList) {
			//parentId=0就是顶级菜单
			if(menu.getParentId()==0) {
				ret.add(menu);
			}
		}
		return ret;
	}
	
	/**
	 * 获取所有的二级菜单
	 * @param menuList  某角色已拥有权限的菜单列表（在这其中再找出二级菜单）
	 * @return
	 */
	public static List<Menu> getAllSecondMenu(List<Menu> menuList){
		List<Menu> ret = new ArrayList<Menu>();
		List<Menu> allTopMenu = getAllTopMenu(menuList);
		for(Menu menu:menuList) {
			//如果此菜单的父级菜单在这些顶级菜单中，就说明此菜单是二级菜单
			for(Menu topMenu:allTopMenu) {
				if(menu.getParentId() == topMenu.getId()) {
					ret.add(menu);
					break;
				}
			}
		}
		return ret;
	}
	
	/**
	 * 获取某个二级菜单下的按钮
	 * @param menuList 某角色已拥有权限的菜单列表
	 * @param secondMenuId  二级菜单
	 * @return
	 */
	public static List<Menu> getAllThirdMenu(List<Menu> menuList,Long secondMenuId){
		List<Menu> ret = new ArrayList<Menu>();
		for(Menu menu:menuList) {
			//如果此菜单的父级菜单是二级菜单，则此菜单是按钮
			if(menu.getParentId() == secondMenuId) {
				ret.add(menu);
			}
		}
		return ret;
	}
	
	/**
	 * 获取所有的三级分类
	 * 生成按规定格式的三级树
	 * @param productCategorieList  所有的分类
	 * @return
	 */
	public static List<Map<String, Object>> getTreeCategory(List<ProductCategory> productCategorieList){
		List<Map<String, Object>> ret = new ArrayList<Map<String,Object>>();
		//添加顶级分类
		for(ProductCategory productCategory : productCategorieList){
			if(productCategory.getParentId() == null){
				Map<String, Object> top = new HashMap<String, Object>();
				top.put("id", productCategory.getId());
				top.put("text", productCategory.getName());
				top.put("children", new ArrayList<Map<String,Object>>());
				ret.add(top);
			}
		}
		//添加二级分类
		for(ProductCategory productCategory : productCategorieList){
			if(productCategory.getParentId() != null){
				for(Map<String, Object> map : ret){
					if(productCategory.getParentId().longValue() == Long.valueOf(map.get("id")+"")){
						List children = (List)map.get("children"); //顶级分类的孩子
						Map<String, Object> child = new HashMap<String, Object>();
						child.put("id", productCategory.getId());
						child.put("text", productCategory.getName());
						child.put("children", new ArrayList<Map<String,Object>>());
						//将二级分类添加到父分类的孩子上
						children.add(child);
					}
				}
			}
		}
		//添加三级分类
		for(ProductCategory productCategory : productCategorieList){
			if(productCategory.getParentId() != null){
				for(Map<String, Object> map : ret){
					//获取二级分类
					List<Map<String, Object>> children = (List<Map<String, Object>>)map.get("children");
					for(Map<String, Object> child : children) {
						if(productCategory.getParentId().longValue() == Long.valueOf(child.get("id")+"")){
							List grandsons = (List)child.get("children");  //二级分类的孩子
							Map<String, Object> grandson = new HashMap<String, Object>();
							grandson.put("id", productCategory.getId());
							grandson.put("text", productCategory.getName());
							//将三级分类添加到二级分类的孩子上
							grandsons.add(grandson);
						}
					}
				}
			}
		}
		return ret;
	}

}

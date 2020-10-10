package edu.hbuas.programmer.dao.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import edu.hbuas.programmer.entity.admin.Menu;

/**
 * 菜单管理dao
 * @author Yee
 *
 */
@Repository
public interface MenuDao {
	public int add(Menu menu);  //添加一条菜单记录
	public List<Menu> findList(Map<String, Object> queryMap);  //菜单信息模糊分页查询
	public List<Menu> findTopList();  //获取所有的上级菜单
	public int getTotal(Map<String, Object> queryMap); //获取总记录数
	public int edit(Menu menu);  //修改菜单信息
	public int delete(Long id);  //删除菜单
	public List<Menu> findChildrenList(Long parentId);  //获取所有的子集菜单
	public List<Menu> findListByIds(String ids);
}

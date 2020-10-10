package edu.hbuas.programmer.service.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import edu.hbuas.programmer.entity.admin.Menu;

/**
 * 菜单管理service
 * @author Yee
 *
 */
@Service
public interface MenuService {
	public int add(Menu menu);
	public List<Menu> findList(Map<String, Object> queryMap);  //查询出所有菜单数据（模糊查询也是此方法）
	public List<Menu> findTopList();  //查询顶级菜单
	public int getTotal(Map<String, Object> queryMap);  
	public int edit(Menu menu);
	public int delete(Long id);
	public List<Menu> findChildrenList(Long parentId);  //查询所有子菜单
	public List<Menu> findListByIds(String ids);  //通过id找到所有的菜单（根据权限获取菜单时用到）
}

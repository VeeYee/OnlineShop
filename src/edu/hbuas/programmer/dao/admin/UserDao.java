package edu.hbuas.programmer.dao.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import edu.hbuas.programmer.entity.admin.User;

/**
 * user用户dao
 * @author Yee
 *
 */
@Repository
public interface UserDao {
	public User findByUsername(String Username);
	public int add(User user);
	public int edit(User user);
	public int delete(String ids);
	public List<User> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int editPassword(User user);
}

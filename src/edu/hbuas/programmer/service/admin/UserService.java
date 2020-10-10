package edu.hbuas.programmer.service.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import edu.hbuas.programmer.entity.admin.User;

/**
 * user用户service
 * @author Yee
 *
 */
@Service
public interface UserService {
	public User findByUsername(String Username);
	public int add(User user);
	public int edit(User user);
	public int delete(String ids);
	public List<User> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int editPassword(User user);
}

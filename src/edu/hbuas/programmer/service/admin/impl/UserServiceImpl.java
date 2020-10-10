package edu.hbuas.programmer.service.admin.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.admin.UserDao;
import edu.hbuas.programmer.entity.admin.User;
import edu.hbuas.programmer.service.admin.UserService;

/**
 * UserService的实现类
 * @author Yee
 *
 */
@Service  //service实现类也需要注解
public class UserServiceImpl implements UserService{

	@Autowired   //可以自动从容器中拿出一个变量
	private UserDao userDao;
	
	/**
	 * 原理：真正使用的是service，然后容器会自动找到实现该service的类
	 * 然后调用dao层中对应的方法，dao会跑到mapper文件找到id与此方法名对应的操作
	 */
	@Override
	public User findByUsername(String Username) {
		return userDao.findByUsername(Username);
	}

	@Override
	public int add(User user) {
		return userDao.add(user);
	}

	@Override
	public int edit(User user) {
		return userDao.edit(user);
	}

	@Override
	public int delete(String ids) {
		return userDao.delete(ids);
	}

	@Override
	public List<User> findList(Map<String, Object> queryMap) {
		return userDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return userDao.getTotal(queryMap);
	}

	@Override
	public int editPassword(User user) {
		return userDao.editPassword(user);
	}
}

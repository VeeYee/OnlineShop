package edu.hbuas.programmer.entity.admin;

import org.springframework.stereotype.Component;

/**
 * 用户实体类
 * @author Yee
 *
 */

//实体类的注解
@Component
public class User {
	
	private Long id;  //用户id，自增
	private String username;  //用户名
	private String password;  //密码
	private Long roleId;  //所属角色id
	private String photo;  //头像
	private Long sex;  //性别  0-未知  1-男  2-女
	private Long age; //年龄
	private String address; //家庭住址
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public Long getRoleId() {
		return roleId;
	}
	public void setRoleId(Long roleId) {
		this.roleId = roleId;
	}
	public String getPhoto() {
		return photo;
	}
	public void setPhoto(String photo) {
		this.photo = photo;
	}
	public Long getSex() {
		return sex;
	}
	public void setSex(Long sex) {
		this.sex = sex;
	}
	public Long getAge() {
		return age;
	}
	public void setAge(Long age) {
		this.age = age;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	
}

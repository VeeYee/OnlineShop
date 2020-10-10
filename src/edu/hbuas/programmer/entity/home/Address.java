package edu.hbuas.programmer.entity.home;

import java.util.Date;

import org.springframework.stereotype.Component;

/**
 * 地址实体
 * @author Yee
 *
 */
@Component
public class Address {
	
	private Long id;  //Id
	
	private Long userId; //用户id
	
	private String name;  //用户名
	
	private String address;  //详细地址
	
	private String phone;  //手机号码
	
	private Date createTime;  //添加时间

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	
}

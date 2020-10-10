package edu.hbuas.programmer.entity.admin;

import java.io.Serializable;

import org.springframework.stereotype.Component;

/**
 * 菜单实体类
 * @author Yee
 *
 */
//实体类的注解
@Component
public class Menu implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private Long id;
	private Long parentId;  //父类Id
	//父类id，用来匹配easyui的父类id  easyui框架默认的父分类
	private Long _parentId;  
	private String name;  //菜单名称
	private String url;  //点击后的url
	private String icon; //菜单icon图标
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getParentId() {
		return parentId;
	}
	public void setParentId(Long parentId) {
		this.parentId = parentId;
	}
	public Long get_parentId() {
		_parentId = parentId;
		return _parentId;
	}
	public void set_parentId(Long _parentId) {
		this._parentId = _parentId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
	
	
}

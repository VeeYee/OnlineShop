package edu.hbuas.programmer.entity.home;

import java.util.Date;

import org.springframework.stereotype.Component;

/**
 * 购物车实体
 * @author Yee
 *
 */
@Component
public class Cart {
	
	private Long id;  //Id
	
	private Long productId;  //商品id
	
	private Long userId; //用户id
	
	private String name;  //商品名称
	
	private String imageUrl;  //商品主图
	
	private Double price;  //商品单价
	
	private int num;  //商品数量
	
	private Double money;  //商品总价
	
	private Date createTime;  //商品添加时间

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getProductId() {
		return productId;
	}

	public void setProductId(Long productId) {
		this.productId = productId;
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

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public Double getMoney() {
		return money;
	}

	public void setMoney(Double money) {
		this.money = money;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
}

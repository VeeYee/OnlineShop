package edu.hbuas.programmer.entity.common;

import java.util.Date;

import org.springframework.stereotype.Component;

/**
 * 评论实体
 * @author Yee
 *
 */
@Component
public class Comment {
	
	private Long id;  //评论Id
	
	private Long productId;  //所属商品id
	
	private Product product;  //根据id查询商品
	
	private Long userId;  //所属用户id
	
	private Account account;  //根据id查询用户
	
	private int type = 0;  //评价类型   0-差评 1-好评 2-中评
	
	private String content;  //评论内容
	
	private String showTime;  //在页面上展示的时间
	
	private Date createTime;  //评论时间

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

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getShowTime() {
		return showTime;
	}

	public void setShowTime(String showTime) {
		this.showTime = showTime;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}
	
}

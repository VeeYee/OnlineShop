package edu.hbuas.programmer.service.home;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import edu.hbuas.programmer.entity.home.Cart;

/**
 * 购物车接口
 * @author Yee
 *
 */
@Service
public interface CartService {
	
	/**
	 * 添加商品到购物车
	 * @param cart
	 * @return
	 */
	public int add(Cart cart);
	
	/**
	 * 编辑商品
	 * @param cart
	 * @return
	 */
	public int edit(Cart cart);

	/**
	 * 删除商品
	 * @param id
	 * @return
	 */
	public int delete(Long id);
	
	/**
	 * 根据用户id删除商品，清空购物车
	 * @param userId
	 * @return
	 */
	public int deleteByUid(Long userId);
	
	/**
	 * 多条件查询商品
	 * @param queryMap
	 * @return
	 */
	public List<Cart> findList(Map<String, Object> queryMap);

	/**
	 * 获取符合条件的总记录数
	 * @param queryMap
	 * @return
	 */
	public int getTotal(Map<String, Object> queryMap);
	
	/**
	 * 根据id查询购物车中的商品
	 * @param id
	 * @return
	 */
	public Cart findById(Long id);
	
	/**
	 * 根据userId和productId查询该用户是否已添加过该商品
	 * @param queryMap
	 * @return
	 */
	public Cart findByIds(Map<String, Long> queryMap);
}

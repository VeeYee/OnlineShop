package edu.hbuas.programmer.service.home.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.home.CartDao;
import edu.hbuas.programmer.entity.home.Cart;
import edu.hbuas.programmer.service.home.CartService;

/**
 * 购物车接口实现类
 * @author Yee
 *
 */
@Service
public class CartServiceImpl implements CartService {

	@Autowired
	private CartDao cartDao;
	
	@Override
	public int add(Cart cart) {
		return cartDao.add(cart);
	}

	@Override
	public int edit(Cart cart) {
		return cartDao.edit(cart);
	}

	@Override
	public int delete(Long id) {
		return cartDao.delete(id);
	}

	@Override
	public List<Cart> findList(Map<String, Object> queryMap) {
		return cartDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return cartDao.getTotal(queryMap);
	}

	@Override
	public Cart findById(Long id) {
		return cartDao.findById(id);
	}

	@Override
	public Cart findByIds(Map<String, Long> queryMap) {
		return cartDao.findByIds(queryMap);
	}

	@Override
	public int deleteByUid(Long userId) {
		return cartDao.deleteByUid(userId);
	}

}

package edu.hbuas.programmer.service.home.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.home.FavoriteDao;
import edu.hbuas.programmer.entity.home.Favorite;
import edu.hbuas.programmer.service.home.FavoriteService;

/**
 * 购物车接口实现类
 * @author Yee
 *
 */
@Service
public class FavoriteServiceImpl implements FavoriteService {

	@Autowired
	private FavoriteDao favoriteDao;
	
	@Override
	public int add(Favorite favorite) {
		return favoriteDao.add(favorite);
	}

	@Override
	public int delete(Long id) {
		return favoriteDao.delete(id);
	}

	@Override
	public List<Favorite> findList(Map<String, Object> queryMap) {
		return favoriteDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return favoriteDao.getTotal(queryMap);
	}

	@Override
	public Favorite findById(Long id) {
		return favoriteDao.findById(id);
	}

	@Override
	public Favorite findByIds(Map<String, Long> queryMap) {
		return favoriteDao.findByIds(queryMap);
	}

}

package edu.hbuas.programmer.service.home;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import edu.hbuas.programmer.entity.home.Favorite;

/**
 * 收藏接口
 * @author Yee
 *
 */
@Service
public interface FavoriteService {
	
	/**
	 * 添加商品到收藏
	 * @param favorite
	 * @return
	 */
	public int add(Favorite favorite);
	
	/**
	 * 删除商品
	 * @param id
	 * @return
	 */
	public int delete(Long id);
	
	/**
	 * 多条件查询商品
	 * @param queryMap
	 * @return
	 */
	public List<Favorite> findList(Map<String, Object> queryMap);

	/**
	 * 获取符合条件的总记录数
	 * @param queryMap
	 * @return
	 */
	public int getTotal(Map<String, Object> queryMap);
	
	/**
	 * 根据id查询收藏中的商品
	 * @param id
	 * @return
	 */
	public Favorite findById(Long id);
	
	/**
	 * 根据userId和productId查询该用户是否已添加过该商品
	 * @param queryMap
	 * @return
	 */
	public Favorite findByIds(Map<String, Long> queryMap);
}

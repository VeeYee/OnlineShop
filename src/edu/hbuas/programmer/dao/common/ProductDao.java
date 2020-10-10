package edu.hbuas.programmer.dao.common;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import edu.hbuas.programmer.entity.common.Product;

/**
 * 商品dao
 * @author Yee
 *
 */
@Repository
public interface ProductDao {
	
	/**
	 * 添加商品
	 * @param product
	 * @return
	 */
	public int add(Product product);
	
	/**
	 * 编辑商品
	 * @param product
	 * @return
	 */
	public int edit(Product product);

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
	public List<Product> findList(Map<String, Object> queryMap);

	/**
	 * 获取符合条件的总记录数
	 * @param queryMap
	 * @return
	 */
	public int getTotal(Map<String, Object> queryMap);
	
	/**
	 * 根据id查询商品
	 * @param id
	 * @return
	 */
	public Product findById(Long id);
	
	/**
	 * 更新统计信息
	 * @param product
	 * @return
	 */
	public int updateNum(Product product);

}

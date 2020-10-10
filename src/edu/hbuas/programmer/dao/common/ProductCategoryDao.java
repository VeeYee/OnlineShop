package edu.hbuas.programmer.dao.common;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import edu.hbuas.programmer.entity.common.ProductCategory;

/**
 * 商品分类dao 
 * @author Yee
 *
 */
@Repository
public interface ProductCategoryDao {
	/**
	 * 添加商品分类
	 * @param productCategory
	 * @return
	 */
	public int add(ProductCategory productCategory);
	
	/**
	 * 编辑商品分类
	 * @param productCategory
	 * @return
	 */
	public int edit(ProductCategory productCategory);

	/**
	 * 删除商品分类
	 * @param id
	 * @return
	 */
	public int delete(Long id);
	
	/**
	 *多条件查询商品分类
	 * @param queryMap
	 * @return
	 */
	public List<ProductCategory> findList(Map<String, Object> queryMap);

	/**
	 * 获取符合条件的总记录数
	 * @param queryMap
	 * @return
	 */
	public int getTotal(Map<String, Object> queryMap);
	
	/**
	 * 根据id查询商品分类
	 * @param id
	 * @return
	 */
	public ProductCategory findById(Long id);
}

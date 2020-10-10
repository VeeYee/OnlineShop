package edu.hbuas.programmer.service.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.common.ProductCategoryDao;
import edu.hbuas.programmer.entity.common.ProductCategory;
import edu.hbuas.programmer.service.common.ProductCategoryService;

/**
 * 商品分类接口实现类
 * @author Yee
 *
 */
@Service
public class ProductCategoryServiceImpl implements ProductCategoryService {

	@Autowired
	private ProductCategoryDao productCategoryDao;
	
	@Override
	public int add(ProductCategory productCategory) {
		return productCategoryDao.add(productCategory);
	}

	@Override
	public int edit(ProductCategory productCategory) {
		return productCategoryDao.edit(productCategory);
	}

	@Override
	public int delete(Long id) {
		return productCategoryDao.delete(id);
	}

	@Override
	public List<ProductCategory> findList(Map<String, Object> queryMap) {
		return productCategoryDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return productCategoryDao.getTotal(queryMap);
	}

	@Override
	public ProductCategory findById(Long id) {
		return productCategoryDao.findById(id);
	}

	

}

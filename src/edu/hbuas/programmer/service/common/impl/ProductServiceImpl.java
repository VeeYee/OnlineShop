package edu.hbuas.programmer.service.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.common.ProductDao;
import edu.hbuas.programmer.entity.common.Product;
import edu.hbuas.programmer.service.common.ProductService;

/**
 * 商品接口实现类
 * @author Yee
 *
 */
@Service
public class ProductServiceImpl implements ProductService {

	@Autowired
	private ProductDao productDao;
	
	@Override
	public int add(Product product) {
		return productDao.add(product);
	}

	@Override
	public int edit(Product product) {
		return productDao.edit(product);
	}

	@Override
	public int delete(Long id) {
		return productDao.delete(id);
	}

	@Override
	public List<Product> findList(Map<String, Object> queryMap) {
		return productDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return productDao.getTotal(queryMap);
	}

	@Override
	public Product findById(Long id) {
		return productDao.findById(id);
	}

	@Override
	public int updateNum(Product product) {
		return productDao.updateNum(product);
	}

}

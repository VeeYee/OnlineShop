package edu.hbuas.programmer.dao.home;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import edu.hbuas.programmer.entity.home.Address;

/**
 * 收货地址dao
 * @author Yee
 *
 */
@Repository
public interface AddressDao {
	
	/**
	 * 添加商品到收货地址
	 * @param address
	 * @return
	 */
	public int add(Address address);
	
	/**
	 * 编辑商品
	 * @param address
	 * @return
	 */
	public int edit(Address address);

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
	public List<Address> findList(Map<String, Object> queryMap);

	/**
	 * 获取符合条件的总记录数
	 * @param queryMap
	 * @return
	 */
	public int getTotal(Map<String, Object> queryMap);
	
	/**
	 * 根据id查询收货地址中的商品
	 * @param id
	 * @return
	 */
	public Address findById(Long id);
}

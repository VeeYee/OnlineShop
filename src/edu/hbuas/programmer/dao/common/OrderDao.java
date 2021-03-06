package edu.hbuas.programmer.dao.common;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import edu.hbuas.programmer.entity.common.Order;
import edu.hbuas.programmer.entity.common.OrderItem;

/**
 * 订单dao
 * @author Yee
 *
 */
@Repository
public interface OrderDao {
	
	/**
	 * 添加订单
	 * @param Order
	 * @return
	 */
	public int add(Order Order);
	
	/**
	 * 添加订单子项
	 * @param orderItem
	 * @return
	 */
	public int addItem(OrderItem orderItem);
	
	/**
	 * 编辑订单
	 * @param Order
	 * @return
	 */
	public int edit(Order Order);

	/**
	 * 删除订单
	 * @param id
	 * @return
	 */
	public int delete(Long id);
	
	/**
	 * 多条件查询订单
	 * @param queryMap
	 * @return
	 */
	public List<Order> findList(Map<String, Object> queryMap);

	/**
	 * 获取符合条件的总记录数
	 * @param queryMap
	 * @return
	 */
	public int getTotal(Map<String, Object> queryMap);
	
	/**
	 * 根据id查询订单
	 * @param id
	 * @return
	 */
	public Order findById(Long id);
	
	/**
	 * 根据订单编号查询订单子项
	 * @param orderId
	 * @return
	 */
	public List<OrderItem> findOrderItemList(Long orderId);

}

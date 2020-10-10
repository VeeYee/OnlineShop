package edu.hbuas.programmer.service.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.common.OrderDao;
import edu.hbuas.programmer.entity.common.Order;
import edu.hbuas.programmer.entity.common.OrderItem;
import edu.hbuas.programmer.service.common.OrderService;

/**
 * 订单接口实现类
 * @author Yee
 *
 */
@Service
public class OrderServiceImpl implements OrderService {

	@Autowired
	private OrderDao orderDao;
	
	@Override
	public int add(Order order) {
		if(orderDao.add(order) <= 0) return 0;
		for(OrderItem orderItem:order.getOrderItems()) {
			orderItem.setOrderId(order.getId());  //设置订单子项的id
			orderDao.addItem(orderItem);  //向order_item表中插入
		}
		return 1;
	}

	@Override
	public int edit(Order order) {
		return orderDao.edit(order);
	}

	@Override
	public int delete(Long id) {
		return orderDao.delete(id);
	}

	@Override
	public List<Order> findList(Map<String, Object> queryMap) {
		return orderDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return orderDao.getTotal(queryMap);
	}

	@Override
	public Order findById(Long id) {
		return orderDao.findById(id);
	}

	@Override
	public List<OrderItem> findOrderItemList(Long orderId) {
		return orderDao.findOrderItemList(orderId);
	}

}

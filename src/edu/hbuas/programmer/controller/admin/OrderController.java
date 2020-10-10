package edu.hbuas.programmer.controller.admin;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.common.Account;
import edu.hbuas.programmer.entity.common.Order;
import edu.hbuas.programmer.page.admin.Page;
import edu.hbuas.programmer.service.common.AccountService;
import edu.hbuas.programmer.service.common.OrderService;
import net.sf.json.JSONArray;

/**
 * 订单管理控制器
 * @author Yee
 *
 */
@RequestMapping("/admin/order")
@Controller
public class OrderController {
	
	@Autowired
	private OrderService orderService;
	@Autowired
	private AccountService accoutService;
	
	/**
	 * 订单列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model) {
		model.addObject("accountList", JSONArray.fromObject(accoutService.findList(new HashMap<String, Object>())));
		model.setViewName("order/list");
		return model;
	}
	
	/**
	 * 获取订单列表数据
	 * @param name
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(Page page,
			@RequestParam(name="sn",defaultValue = "",required = false)String sn,
			@RequestParam(name="username",required = false)String username,
			@RequestParam(name="moneyMin",required = false)Double moneyMin,
			@RequestParam(name="moneyMax",required = false)Double moneyMax,
			@RequestParam(name="status",required = false)Integer status) {
		//编辑查询条件
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("sn", sn);
		//根据客户名找到客户id
		if(!StringUtils.isEmpty(username)) {
			Account account = accoutService.findByName(username);
			if(account != null) {
				queryMap.put("userId", account.getId());
			}else {
				//如果账户为null，就把userId设为0，避免查询出来  查询时输入完整的客户名才能搜索出来
				queryMap.put("userId", 0);  
			}
		}
		if(moneyMin != null) {
			queryMap.put("moneyMin", moneyMin);
		}
		if(moneyMax != null) {
			queryMap.put("moneyMax", moneyMax);
		}
		if(status != null) {
			queryMap.put("status", status);
		}
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		//查询的结果集
		Map<String, Object> ret = new HashMap<String, Object>();
		//rows是每条order数据
		ret.put("rows", orderService.findList(queryMap));  
		ret.put("total", orderService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 编辑订单
	 * @param order
	 * @return
	 */
	@RequestMapping(value="/edit",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Order order){
		Map<String, String> ret = new HashMap<String, String>();
		if(order == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的订单信息！");
			return ret;
		}
		if(StringUtils.isEmpty(order.getAddress())) {
			ret.put("type", "error");
			ret.put("msg", "请填写订单收货地址！");
			return ret;
		}
		if(order.getMoney() == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写订单总价！");
			return ret;
		}
		if(orderService.edit(order) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "编辑失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "订单编辑成功！");
		return ret;
	}
	
	/**
	 * 根据订单id查询出所有的订单子项
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value="/get_item_list",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> itemList(Long orderId) {
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("rows", orderService.findOrderItemList(orderId));  
		return ret;
	}
	
}

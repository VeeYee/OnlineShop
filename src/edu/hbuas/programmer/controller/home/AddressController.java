package edu.hbuas.programmer.controller.home;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.common.Account;
import edu.hbuas.programmer.entity.home.Address;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.service.home.AddressService;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 收货地址控制器
 * @author Yee
 *
 */
@RequestMapping("/address")
@Controller
public class AddressController {
	
	@Autowired
	private AddressService addressService;
	@Autowired
	private ProductCategoryService productCategoryService;
	
	/**
	 * 收货地址页面
	 * @param model
	 * @param request
	 * @return  返回页面，即所有的收货地址数据
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		//获取当前登录的用户
		Account onlineAccount = (Account) request.getSession().getAttribute("account");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("userId", onlineAccount.getId());
		model.addObject("addressList", addressService.findList(queryMap));
		model.addObject("title", "收货地址");
		model.addObject("currentUser","current_");
		model.setViewName("home/address/list");
		return model;
	}
	
	/**
	 * 添加新的收货地址
	 * @param address  地址实体
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(Address address,HttpServletRequest request) {
		Account onlineAccount = (Account) request.getSession().getAttribute("account");  //当前登录用户
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(address == null) {
			ret.put("msg", "请填写正确的收货信息！");
			return ret;
		}
		if(StringUtils.isEmpty(address.getName())) {
			ret.put("msg", "请填写收货人！");
			return ret;
		}
		if(StringUtils.isEmpty(address.getAddress())) {
			ret.put("msg", "请填写收货地址！");
			return ret;
		}
		if(StringUtils.isEmpty(address.getPhone())) {
			ret.put("msg", "请填写手机号！");
			return ret;
		}
		address.setUserId(onlineAccount.getId());
		address.setCreateTime(new Date());
		if(addressService.add(address) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "添加失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
	/**
	 * 编辑收货地址
	 * @param address
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/edit",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> edit(Address address,HttpServletRequest request) {
		Account onlineAccount = (Account) request.getSession().getAttribute("account");  //当前登录用户
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(address == null) {
			ret.put("msg", "请填写正确的收货信息！");
			return ret;
		}
		//先判断改地址是否存在，如果不存在将不能编辑
		Address existAddress = addressService.findById(address.getId());
		if(existAddress == null) {
			ret.put("msg", "不存在该地址！");
			return ret;
		}
		if(StringUtils.isEmpty(address.getName())) {
			ret.put("msg", "请填写收货人！");
			return ret;
		}
		if(StringUtils.isEmpty(address.getAddress())) {
			ret.put("msg", "请填写收货地址！");
			return ret;
		}
		if(StringUtils.isEmpty(address.getPhone())) {
			ret.put("msg", "请填写手机号！");
			return ret;
		}
		address.setUserId(onlineAccount.getId());
		if(addressService.edit(address) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "修改失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
	/**
	 * 删除地址
	 * @param id  地址id
	 * @return
	 */
	@RequestMapping(value="/delete",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delete(Long id) {
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(id == null) {
			ret.put("msg", "请选择要删除的地址！");
			return ret;
		}
		if(addressService.delete(id) <= 0) {
			ret.put("msg", "删除出错，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
}

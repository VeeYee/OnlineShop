package edu.hbuas.programmer.controller.home;

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
import edu.hbuas.programmer.service.common.AccountService;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 用户中心控制器
 * @author Yee
 *
 */
@RequestMapping("/user")
@Controller
public class HomeUserController {
	
	@Autowired
	private ProductCategoryService productCategoryService;
	@Autowired
	private AccountService accountService;
	
	/**
	 * 个人基本信息页面
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/info",method = RequestMethod.GET)
	public ModelAndView info(ModelAndView model,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		Account onlineAccount = (Account) request.getSession().getAttribute("account");
		model.addObject("title", "个人主页");
		model.addObject("user", onlineAccount);
		model.addObject("currentUser","current_");
		model.setViewName("home/user/info");  //个人主页
		return model;
	}
	
	/**
	 * 修改个人基本信息
	 * @param account
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/update_info",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(Account account,HttpServletRequest request) {
		Account onlineAccount = (Account) request.getSession().getAttribute("account");  //当前登录用户
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(account == null) {
			ret.put("msg", "请填写正确的信息！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getEmail())) {
			ret.put("msg", "邮箱地址不能为空！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getTrueName())) {
			ret.put("msg", "真实姓名不能为空！");
			return ret;
		}
		onlineAccount.setEmail(account.getEmail());
		onlineAccount.setTrueName(account.getTrueName());
		onlineAccount.setSex(account.getSex());
		if(accountService.edit(onlineAccount) <= 0) {
			ret.put("msg", "修改失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
	/**
	 * 修改个人密码的页面
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/update_pwd",method = RequestMethod.GET)
	public ModelAndView updatePwd(ModelAndView model,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		model.addObject("title", "修改密码");
		model.addObject("currentUser","current_");
		model.setViewName("home/user/update_pwd");  //修改密码页面
		return model;
	}
	
	/**
	 * 修改密码提交
	 * @param oldpassword  旧密码
	 * @param newpassword  新密码
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/update_pwd",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updatePassword(String oldpassword,String newpassword,
			HttpServletRequest request) {
		Account onlineAccount = (Account) request.getSession().getAttribute("account");  //当前登录用户
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(StringUtils.isEmpty(oldpassword)) {
			ret.put("msg", "旧密码不能为空！");
			return ret;
		}
		if(StringUtils.isEmpty(newpassword)) {
			ret.put("msg", "新密码不能为空！");
			return ret;
		}
		if(!onlineAccount.getPassword().equals(oldpassword)) {
			ret.put("msg", "旧密码错误！");
			return ret;
		}
		onlineAccount.setPassword(newpassword);
		if(accountService.edit(onlineAccount) <= 0) {
			ret.put("msg", "修改失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
}

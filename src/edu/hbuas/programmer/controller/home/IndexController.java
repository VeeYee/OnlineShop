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
import edu.hbuas.programmer.service.common.AccountService;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.service.common.ProductService;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 前台首页控制器
 * @author Yee
 *
 */
@RequestMapping("/home")
@Controller
public class IndexController {
	
	@Autowired
	private AccountService accountService;
	@Autowired
	private ProductCategoryService productCategoryService;
	@Autowired
	private ProductService productService;
	
	/**
	 * 前台首页页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/index",method = RequestMethod.GET)
	public ModelAndView index(ModelAndView model) {
		//所有的商品分类
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 5);
		//按照商品添加时间排列 -- 最近上架
		queryMap.put("orderBy", "createTime");
		queryMap.put("sort", "desc");  //降序排列  （后添加的排在前面）
		model.addObject("lastProductList", productService.findList(queryMap));
		//按照商品销量排序  --  最近热卖
		queryMap.put("orderBy", "sellNum");  //默认是升序排列
		model.addObject("sellProductList", productService.findList(queryMap));
		//首页加上class样式，去掉id样式（显示左侧分类列表）
		model.addObject("allCategoryClass","shop_hd_menu_hover");  
		model.addObject("title","商城首页");
		model.addObject("currentHome","current_");
		model.setViewName("home/index/index");
		return model;
	}
	
	/**
	 * 商城注册页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/register",method = RequestMethod.GET)
	public ModelAndView register(ModelAndView model) {
		model.setViewName("home/index/register");
		return model;
	}
	
	/**
	 * 用户注册处理
	 * @param account
	 * @param code
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/register",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> register(Account account, String code,HttpServletRequest request) {
		Map<String, String> ret = new HashMap<String, String>();
		ret.put("type", "error");
		if(account == null) {
			ret.put("msg", "请填写正确的用户信息！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getName())) {
			ret.put("msg", "请填写用户名！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getPassword())) {
			ret.put("msg", "请填写密码！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getEmail())) {
			ret.put("msg", "请填写邮箱！");
			return ret;
		}
		if(StringUtils.isEmpty(code)) {
			ret.put("msg", "请填写验证码！");
			return ret;
		}
		Object codeObject = request.getSession().getAttribute("userRegisterCpacha");
		if(codeObject == null) {
			ret.put("msg", "验证码已过期，请刷新页面后重试！");
			return ret;
		}
		if(!code.equalsIgnoreCase((String)codeObject)){
			ret.put("msg", "验证码错误！");
			return ret;
		}
		Account findResult = accountService.findByName(account.getName());
		if(findResult != null) {
			ret.put("msg", "注册失败，该用户名已存在！");
			return ret;
		}
		account.setCreateTime(new Date());
		account.setStatus(1);  //注册时账号是可用状态
		if(accountService.add(account) <= 0) {
			ret.put("msg", "注册失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
	/**
	 * 商城登录页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/login",method = RequestMethod.GET)
	public ModelAndView login(ModelAndView model) {
		model.setViewName("home/index/login");
		return model;
	}
	
	/**
	 * 用户登录处理
	 * @param account
	 * @param code
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/login",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> login(Account account, String code,HttpServletRequest request) {
		Map<String, String> ret = new HashMap<String, String>();
		ret.put("type", "error");
		if(account == null) {
			ret.put("msg", "请填写正确的用户信息！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getName())) {
			ret.put("msg", "请填写用户名！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getPassword())) {
			ret.put("msg", "请填写密码！");
			return ret;
		}
		if(StringUtils.isEmpty(code)) {
			ret.put("msg", "请填写验证码！");
			return ret;
		}
		Object codeObject = request.getSession().getAttribute("userLoginCpacha");
		if(codeObject == null) {
			ret.put("msg", "验证码已过期，请刷新页面后重试！");
			return ret;
		}
		if(!code.equalsIgnoreCase((String)codeObject)){
			ret.put("msg", "验证码错误！");
			return ret;
		}
		Account findResult = accountService.findByName(account.getName());
		if(findResult == null) {
			ret.put("msg", "该用户名不存在！");
			return ret;
		}
		if(!account.getPassword().equals(findResult.getPassword())) {
			ret.put("msg", "登陆失败，密码错误！");
			return ret;
		}
		//1--正常  2--冻结
		if(findResult.getStatus() == 2) {
			ret.put("msg", "该用户已被冻结，请联系管理员！");
			return ret;
		}
		request.getSession().setAttribute("userLoginCpacha", null);
		request.getSession().setAttribute("account", findResult);  //当前登录的用户
		ret.put("type", "success");
		return ret;
	}
	
}

package edu.hbuas.programmer.controller.admin;

import java.util.Date;
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
import edu.hbuas.programmer.page.admin.Page;
import edu.hbuas.programmer.service.common.AccountService;

/**
 * 客户管理控制器
 * @author Yee
 *
 */
@RequestMapping("/admin/account")
@Controller
public class AccountController {
	
	@Autowired
	private AccountService accountService;
	
	/**
	 * 客户列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model) {
		model.setViewName("account/list");
		return model;
	}
	
	/**
	 * 获取客户列表数据
	 * @param page
	 * @param name
	 * @param sex
	 * @param status
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(Page page,
			@RequestParam(name="name",defaultValue = "",required = false)String name,
			@RequestParam(name="sex",required = false)Long sex,
			@RequestParam(name="status",required = false)Double status){
		//编辑查询条件
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("name", name);
		if(sex != null) {
			queryMap.put("sex", sex);
		}
		if(status != null) {
			queryMap.put("status", status);
		}
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		//查询的结果集
		Map<String, Object> ret = new HashMap<String, Object>();
		//rows是每条account数据
		ret.put("rows", accountService.findList(queryMap));  
		ret.put("total", accountService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 检查用户名是否存在
	 * 若用户名不存在但id还存在时就说明也存在该用户（可能已更改了用户名）
	 * @param name
	 * @param id
	 * @return
	 */
	private boolean isExist(String name,Long id) {
		Account account = accountService.findByName(name);
		if(account == null) return false;
		if(account.getId().longValue() == id.longValue()) return false;
		return true;
	}
	
	/**
	 * 添加客户
	 * @param account
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(Account account) {
		Map<String, Object> ret = new HashMap<String, Object>();
		if(account == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的客户信息！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getName())) {
			ret.put("type", "error");
			ret.put("msg", "请填写客户名称！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getPassword())) {
			ret.put("type", "error");
			ret.put("msg", "请填写登录密码！");
			return ret;
		}
		if(isExist(account.getName(), 0l)) { //添加时id=0
			ret.put("type", "error");
			ret.put("msg", "该用户名已存在！");
			return ret;
		}
		account.setCreateTime(new Date());
		if(accountService.add(account) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "添加失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "客户添加成功！");
		return ret;
	}
	
	
	
	/**
	 * 删除客户
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/delete",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delete(Long id) {
		Map<String, Object> ret = new HashMap<String, Object>();
		if(id == null) {
			ret.put("type", "error");
			ret.put("msg", "请选择要删除的客户！");
			return ret;
		}
		try {
			if(accountService.delete(id) <= 0) {
				ret.put("type", "error");
				ret.put("msg", "删除失败，请联系管理员！");
				return ret;
			}
		} catch (Exception e) {
			ret.put("type", "error");
			ret.put("msg", "该客户下存在订单信息，不允许删除！");
			return ret;
		}
		
		ret.put("type", "success");
		ret.put("msg", "客户删除成功！");
		return ret;
	}
	
	/**
	 * 编辑客户
	 * @param account
	 * @return
	 */
	@RequestMapping(value="/edit",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Account account){
		Map<String, String> ret = new HashMap<String, String>();
		if(account == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的客户信息！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getName())) {
			ret.put("type", "error");
			ret.put("msg", "请填写客户名称！");
			return ret;
		}
		if(StringUtils.isEmpty(account.getPassword())) {
			ret.put("type", "error");
			ret.put("msg", "请填写登录密码！");
			return ret;
		}
		if(isExist(account.getName(), account.getId())) { //编辑时是自己的id
			ret.put("type", "error");
			ret.put("msg", "该用户名已存在！");
			return ret;
		}
		if(accountService.edit(account) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "编辑失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "客户编辑成功！");
		return ret;
	}
	
}

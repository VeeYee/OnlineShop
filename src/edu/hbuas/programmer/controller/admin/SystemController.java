package edu.hbuas.programmer.controller.admin;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.admin.Authority;
import edu.hbuas.programmer.entity.admin.Menu;
import edu.hbuas.programmer.entity.admin.Role;
import edu.hbuas.programmer.entity.admin.User;
import edu.hbuas.programmer.service.admin.AuthorityService;
import edu.hbuas.programmer.service.admin.LogService;
import edu.hbuas.programmer.service.admin.MenuService;
import edu.hbuas.programmer.service.admin.RoleService;
import edu.hbuas.programmer.service.admin.UserService;
import edu.hbuas.programmer.util.CpachaUtil;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 系统操作类控制器
 * @author Yee
 *
 */
@Controller
@RequestMapping("/system")   //请求的url
//每个控制器都有一个@RequestMapping，每个方法也都有一个@RequestMapping，拼接起来就是请求的url
public class SystemController {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private RoleService roleService;
	
	@Autowired
	private AuthorityService authorityService;
	
	@Autowired
	private MenuService menuService;
	
	@Autowired
	private LogService logService;
	
	
	/**
	 * 生成验证码的方法
	 * @param vcodeLen  验证码位数
	 * @param width 图片宽度
	 * @param height  图片高度
	 * @param cpachaType：用来区别验证码的类型，传入字符串
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/get_cpacha",method=RequestMethod.GET)
	public void generateCpacha(
			//添加参数
			@RequestParam(name="vl",required = false, defaultValue = "4") Integer vcodeLen,
			@RequestParam(name="w",defaultValue = "100") Integer width,
			@RequestParam(name="h",defaultValue = "30") Integer height,
			@RequestParam(name="type",required = true,defaultValue = "loginCpacha") String cpachaType,
			HttpServletRequest request,
			HttpServletResponse response) {
		//设置验证码的长度、图片高度、宽度
		CpachaUtil cpachaUtil = new CpachaUtil(vcodeLen, width, height);
		String generatorVCode = cpachaUtil.generatorVCode();
		request.getSession().setAttribute(cpachaType, generatorVCode);
		//生成验证码的图片
		BufferedImage generatorRotateVCodeImage = cpachaUtil.generatorRotateVCodeImage(generatorVCode, true);
		try {
			//生成的验证码图片以流的形式写到response的输出流中去
			ImageIO.write(generatorRotateVCodeImage, "gif", response.getOutputStream());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 登录页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public ModelAndView login(ModelAndView model) {
		model.setViewName("system/login");
		return model;
	}
	
	/**
	 * 登录提交处理控制器
	 * @param user  用户实体
	 * @param cpacha  四位验证码
	 * @return
	 */
	@RequestMapping(value="/login",method = RequestMethod.POST)
	@ResponseBody   //返回时只返回json字符串，不去找jsp页面
	public Map<String, String> loginAct(User user,String cpacha,HttpServletRequest request){
		Map<String, String> ret = new HashMap<String, String>();
		//若用户绕过了前端表单的验证，后端还会再校验一遍
		//用户对象为null时
		if(user == null) {
			ret.put("type", "error");
			ret.put("msg","请填写用户信息！");
			return ret;
		}
		//验证码为空
		if(StringUtils.isEmpty(cpacha)) {
			ret.put("type","error");
			ret.put("msg","请填写验证码！");
			return ret;
		}
		//用户名为空时
		if(StringUtils.isEmpty(user.getUsername())) {
			ret.put("type","error");
			ret.put("msg","请填写用户名！");
			return ret;
		}
		//密码为空时
		if(StringUtils.isEmpty(user.getPassword())) {
			ret.put("type","error");
			ret.put("msg","请填写密码！");
			return ret;
		}
		Object loginCpacha = request.getSession().getAttribute("loginCpacha");
		if(loginCpacha == null) {
			ret.put("type", "error");
			ret.put("msg", "会话超时，请刷新页面！");
			return ret;
		}
		//再依次判断验证码、用户名、密码的正确性  
		if(!cpacha.toUpperCase().equals(loginCpacha.toString().toUpperCase())) { //转为大写再比较，验证码忽略大小写
			ret.put("type", "error");
			ret.put("msg", "验证码错误！");
			logService.add("登录时，用户名为[ "+user.getUsername()+" ]的用户验证码输入错误！"); 
			return ret;
		}
		//使用的是service中的方法
		User findByUsername = userService.findByUsername(user.getUsername());
		if(findByUsername == null) {
			ret.put("type", "error");
			ret.put("msg", "该用户名不存在！");
			logService.add("登录时，用户名为[ "+user.getUsername()+" ]的用户不存在！"); 
			return ret;
		}
		if(!user.getPassword().equals(findByUsername.getPassword())) {
			ret.put("type", "error");
			ret.put("msg", "密码错误！");
			logService.add("登录时，用户名为[ "+user.getUsername()+" ]的用户密码输入错误！"); 
			return ret;
		}
		//根据登录的用户获取其角色信息
		Role role = roleService.find(findByUsername.getRoleId());
		//根据角色获取权限列表（有哪些菜单可以管理）
		List<Authority> authorityList = authorityService.findListByRoleId(role.getId());
		String menuIds = "";  //获取可管理的菜单
		for(Authority authority:authorityList) {
			menuIds += authority.getMenuId()+",";
		}
		if(!StringUtils.isEmpty(menuIds)) {
			//去掉最后一个逗号
			menuIds = menuIds.substring(0,menuIds.length()-1);
		}
		//将登陆上来的用户、角色信息、菜单信息放在session中
		request.getSession().setAttribute("admin", findByUsername);
		request.getSession().setAttribute("role", role);
		request.getSession().setAttribute("userMenus", menuService.findListByIds(menuIds));
		ret.put("type", "success");
		ret.put("msg", "登陆成功！");
		logService.add("登录时，用户名为[ "+user.getUsername()+" ]，角色为{ "+role.getName()+" }的用户登陆成功！"); 
		return ret;
	}
	
	/**
	 * 系统登陆后的主页
	 * 此方法的请求路径 http://localhost:8080/BaseProjectSSM/system/index
	 * @param model
	 * @param request
	 * @return 返回index.jsp界面
	 */
	@RequestMapping(value="/index",method=RequestMethod.GET)
	public ModelAndView index(ModelAndView model,HttpServletRequest request) {
		//返回所有的顶级菜单和二级菜单  取得放置在session中该用户已拥有权限的userMenus
		List<Menu> userMenus = (List<Menu>)request.getSession().getAttribute("userMenus");
		model.addObject("topMenuList",MenuUtil.getAllTopMenu(userMenus));
		model.addObject("secondMenuList",MenuUtil.getAllSecondMenu(userMenus));
		// 视图的路径：  /WEB-INF/views/ + system/index + .jsp  并不是请求的url路径
		model.setViewName("system/index");
		return model;
	}
	
	/**
	 * 系统登陆后的欢迎页
	 * @param model
	 * @return  返回system下的welcome.jsp页面
	 */
	@RequestMapping(value="/welcome",method=RequestMethod.GET)
	public ModelAndView welcome(ModelAndView model) {
		model.setViewName("system/welcome");
		return model;
	}
	
	/**
	 * 后台退出注销功能
	 * @param request 取得session中的admin，置为null，即下线状态
	 * @return
	 */
	@RequestMapping(value="/logout",method = RequestMethod.GET)
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute("admin", null);
		session.setAttribute("role", null);
		request.getSession().setAttribute("username", null);
		return "redirect:login";  //重定向到登录页面
	}
	
	/**
	 * 修改密码页面
	 * @param model 
	 * @return  返回修改密码的界面
	 */
	@RequestMapping(value="/edit_password",method=RequestMethod.GET)
	public ModelAndView editPassword(ModelAndView model) {
		model.setViewName("system/edit_password");
		return model;
	}
	
	/**
	 * 修改密码的方法
	 * @param newPassword 新密码
	 * @param oldPassword 旧密码
	 * @param request 取得session中的admin，即当前登录的用户
	 * @return
	 */
	@RequestMapping(value="/edit_password",method = RequestMethod.POST)
	@ResponseBody   
	public Map<String, String> editPasswordAct(String newPassword,String oldPassword,HttpServletRequest request){
		Map<String, String> ret = new HashMap<String, String>();
		if(StringUtils.isEmpty(newPassword)) {
			ret.put("type","error");
			ret.put("msg","请填写新密码！");
			return ret;
		}
		//获取当前登录的用户
		User user = (User)request.getSession().getAttribute("admin");
		if(!user.getPassword().equals(oldPassword)) {
			ret.put("type","error");
			ret.put("msg","原密码错误！");
			return ret;
		}
		 //修改成功，设置为新密码，再进入数据库修改
		user.setPassword(newPassword); 
		if(userService.editPassword(user) <= 0) {
			ret.put("type","error");
			ret.put("msg","密码修改失败，请联系管理员！");
			logService.add("修改密码时，用户名为[ "+user.getUsername()+" ]的用户密码修改失败！"); 
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "密码修改成功！");
		logService.add("修改密码时，用户名为[ "+user.getUsername()+" ]的用户密码修改成功！"); 
		return ret;
	}
}


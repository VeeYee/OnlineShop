package edu.hbuas.programmer.interceptor.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.admin.Menu;
import edu.hbuas.programmer.util.MenuUtil;
import net.sf.json.JSONObject;

/**
 * 后台登录拦截器
 * @author Yee
 *
 */
public class LoginInterceptor implements HandlerInterceptor {

	/**
	 * 在请求之后拦截
	 */
	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {
		// TODO Auto-generated method stub

	}

	/**
	 * 在请求时拦截
	 */
	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3)
			throws Exception {
		// TODO Auto-generated method stub

	}

	/**
	 * 在请求之后拦截
	 * 在springmvc.xml中配置了拦截器，并指定了拦截哪些请求
	 * 拦截下来的请求需要进入以下方法，判断用户是否已经登录，若未登录将会重定向到system/login.jsp页面
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object arg2) throws Exception {
		String requestURI = request.getRequestURI();  //requestURI = /OnlineShop/xx
		Object admin = request.getSession().getAttribute("admin");
		if(admin == null) {
			//表示未登陆或者登陆失败  （退出系统时会将admin置为null）
			System.out.println("链接"+requestURI+"进入拦截器！");
			String header = request.getHeader("X-Requested-With");  //取X-Requested-With的值
			//判断是否是ajax请求，ajax请求X-Requested-With的值是XMLHttpRequest
			if("XMLHttpRequest".equals(header)) {
				//表示是ajax请求
				Map<String, String> ret = new HashMap<String, String>();
				ret.put("type","error");
				ret.put("msg","登录会话超时或还未登录，请重新登录！");
				response.getWriter().write(JSONObject.fromObject(ret).toString());
				return false;
			}
			//若是普通链接 用户未登录时重定向到登录页面   路径：BaseProjectSSM/system/login
			response.sendRedirect(request.getServletContext().getContextPath()+"/system/login");  
			return false;
		}
		//获取二级菜单的id
		String mid = request.getParameter("_mid");
		if(!StringUtils.isEmpty(mid)) {
			List<Menu> allThirdMenu = MenuUtil.getAllThirdMenu((List<Menu>)request.getSession().getAttribute("userMenus"), Long.valueOf(mid));
			//返回所有的按钮菜单
			request.setAttribute("thirdMenuList", allThirdMenu);
		}
		return true;
	}

}

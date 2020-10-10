package edu.hbuas.programmer.controller.admin;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.admin.User;
import edu.hbuas.programmer.page.admin.Page;
import edu.hbuas.programmer.service.admin.RoleService;
import edu.hbuas.programmer.service.admin.UserService;

/**
 * 用户管理器
 * @author Yee
 *
 */
@RequestMapping("/admin/user")   //这是ajax请求的路径，与视图路径不是同一个东西
@Controller
public class UserController {
	
	@Autowired
	private UserService userService;
	@Autowired
	private RoleService roleService;
	
	/**
	 * 返回用户列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		Map<String, Object> queryMap = new HashMap<String, Object>();
		model.addObject("roleList", roleService.findList(queryMap));
		//视图的路径： /WEB-INF/views/ + user/list + .jsp  （根据springmvc.xml配置文件来的）
		model.setViewName("user/list");
		return model;
	}
	
	/**
	 * 获取用户列表数据
	 * @param page
	 * @param username
	 * @param roleId
	 * @param sex
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getList(Page page,
			@RequestParam(name="username",required = false,defaultValue = "")String username,
			@RequestParam(name="roleId",required = false)Long roleId,
			@RequestParam(name="sex",required = false)Integer sex){
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("username", username);
		queryMap.put("roleId", roleId);
		queryMap.put("sex", sex);
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		//结果集
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("rows", userService.findList(queryMap)); //查出的每条数据
		ret.put("total", userService.getTotal(queryMap));  //总记录数
		return ret;
	}
	
	/**
	 * 添加用户
	 * @param user
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	//批量修改变量快捷键  alt+shift+r
	public Map<String, String> add(User user){
		Map<String, String> ret = new HashMap<String, String>();
		if(user == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的用户信息！");
			return ret;
		}
		//用户名、密码、所属角色是必填项
		if(StringUtils.isEmpty(user.getUsername())) {
			ret.put("type", "error");
			ret.put("msg", "请填写用户名！");
			return ret;
		}
		if(StringUtils.isEmpty(user.getPassword())) {
			ret.put("type", "error");
			ret.put("msg", "请填写密码！");
			return ret;
		}
		if(user.getRoleId() == null) {
			ret.put("type", "error");
			ret.put("msg", "请选择所属角色！");
			return ret;
		}
		if(isExist(user.getUsername(), 0l)) {
			ret.put("type", "error");
			ret.put("msg", "该用户已存在，请重新输入！");
			return ret;
		}
		if(user.getSex() == null) {
			user.setSex(0l);
		}
		if(userService.add(user) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "用户添加失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "用户添加成功！");
		return ret;
	}
	
	//判断用户名是否存在
	private boolean isExist(String username,Long id) {
		User user = userService.findByUsername(username);
		if(user == null)
			return false;
		if(user.getId().longValue() == id.longValue())
			return false;
		return true;
	}
	
	/**
	 * 上传图片当做头像
	 * @param photo
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/upload_photo",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> uploadPhoto(MultipartFile photo,HttpServletRequest request){
		Map<String, String> ret = new HashMap<String, String>();
		if(photo == null) {
			ret.put("type", "error");
			ret.put("msg", "请选择要上传的文件！");
			return ret;
		}
		//限制上传的文件大小
		if(photo.getSize() > 1024*1024*1024) {
			ret.put("type", "error");
			ret.put("msg", "文件大小不能超过10M！");
			return ret;
		}
		//截取文件后缀  asddf.dfd.jpg -->  jpg
		String suffix = photo.getOriginalFilename().substring(photo.getOriginalFilename().lastIndexOf(".")+1, photo.getOriginalFilename().length());
		//判断后缀是否是jpg,jpeg,gif,png这些图片类型
		if(!"jpg,jpeg,gif,png".toUpperCase().contains(suffix.toUpperCase())) {
			ret.put("type", "error");
			ret.put("msg", "请选择jpg,jpeg,gif,png格式的文件！");
			return ret;
		}
		//图片路径 request.getServletContext().getRealPath("/") = D:\Zeclipse\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\BaseProjectSSM\
		//上传的图片会保存到tomcat中，在项目目录下看不到
		String savePath = request.getServletContext().getRealPath("/") + "/resources/upload/";
		File savePathFile = new File(savePath);
		if(!savePathFile.exists()) {
			//若目录不存在则创建
			savePathFile.mkdir();
		}
		//以时间戳来命名图片文件
		String fileName = new Date().getTime()+"."+suffix;
		try {
			//将文件保存至指定目录
			photo.transferTo(new File(savePath + fileName));
		} catch (Exception e) {
			ret.put("type", "error");
			ret.put("msg", "保存文件异常！");
			e.printStackTrace();
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "头像上传成功！");
		//显示此图片的路径 request.getServletContext().getContextPath() = /BaseProjectSSM
		ret.put("filePath", request.getServletContext().getContextPath()+"/resources/upload/"+fileName);
		return ret;
	}
	
	/**
	 * 编辑用户信息
	 * @param user
	 * @return
	 */
	@RequestMapping(value="/edit",method = RequestMethod.POST)
	@ResponseBody
	//批量修改变量快捷键  alt+shift+r
	public Map<String, String> edit(User user){
		Map<String, String> ret = new HashMap<String, String>();
		if(user == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的用户信息！");
			return ret;
		}
		//用户名、密码、所属角色是必填项
		if(StringUtils.isEmpty(user.getUsername())) {
			ret.put("type", "error");
			ret.put("msg", "请填写用户名！");
			return ret;
		}
		if(user.getRoleId() == null) {
			ret.put("type", "error");
			ret.put("msg", "请选择所属角色！");
			return ret;
		}
		if(isExist(user.getUsername(), user.getId())) {
			ret.put("type", "error");
			ret.put("msg", "该用户已存在，请重新输入！");
			return ret;
		}
		if(user.getSex() == null) {
			user.setSex(0l);
		}
		if(userService.edit(user) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "用户编辑失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "用户编辑成功！");
		return ret;
	}
	
	/**
	 * 批量删除用户
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/delete",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> delete(String ids){
		Map<String, String> ret = new HashMap<String, String>();
		if(StringUtils.isEmpty(ids)) {
			ret.put("type", "error");
			ret.put("msg", "请选择要删除的数据！");
			return ret;
		}
		if(ids.contains(",")) {
			//去掉最后一个逗号,  拼接成以逗号分隔的ids,以便批量删除
			ids = ids.substring(0, ids.length()-1);
		}
		if(userService.delete(ids) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "用户删除失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "用户删除成功！");
		return ret;
	}
	
}

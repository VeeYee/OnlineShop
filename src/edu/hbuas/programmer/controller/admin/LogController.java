package edu.hbuas.programmer.controller.admin;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.hbuas.programmer.entity.admin.Log;
import edu.hbuas.programmer.page.admin.Page;
import edu.hbuas.programmer.service.admin.LogService;

/**
 * 日志管理器
 * @author Yee
 *
 */
@RequestMapping("/admin/log")
@Controller
public class LogController {
	
	@Autowired
	private LogService logService;
	
	/**
	 * 返回日志列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		model.setViewName("log/list");
		return model;
	}
	
	/**
	 * 获取日志列表数据
	 * @param page
	 * @param content  日志内容
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getList(Page page,
			@RequestParam(name="content",required = false,defaultValue = "")String content){
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("content", content);
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		//结果集
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("rows", logService.findList(queryMap)); //查出的每条数据
		ret.put("total", logService.getTotal(queryMap)); //总记录数
		return ret;
	}
	
	/**
	 * 添加日志
	 * @param log
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	//批量修改变量快捷键  alt+shift+r
	public Map<String, String> add(Log log){
		Map<String, String> ret = new HashMap<String, String>();
		if(log == null) {
			ret.put("type", "error");
			ret.put("msg", "请填写正确的日志信息！");
			return ret;
		}
		if(StringUtils.isEmpty(log.getContent())) {
			ret.put("type", "error");
			ret.put("msg", "请填写日志内容！");
			return ret;
		}
		log.setCreateTime(new Date());  //添加日志创建的时间
		if(logService.add(log) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "日志添加失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "日志添加成功！");
		return ret;
	}
	
	/**
	 * 批量删除日志
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
		if(logService.delete(ids) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "日志删除失败，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "日志删除成功！");
		return ret;
	}
	
}

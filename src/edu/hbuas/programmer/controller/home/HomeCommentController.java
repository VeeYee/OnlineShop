package edu.hbuas.programmer.controller.home;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
import edu.hbuas.programmer.entity.common.Comment;
import edu.hbuas.programmer.entity.common.Product;
import edu.hbuas.programmer.service.common.CommentService;
import edu.hbuas.programmer.service.common.ProductCategoryService;
import edu.hbuas.programmer.service.common.ProductService;
import edu.hbuas.programmer.util.DateUtil;
import edu.hbuas.programmer.util.MenuUtil;

/**
 * 评价控制器
 * @author Yee
 *
 */
@RequestMapping("/comment")
@Controller
public class HomeCommentController {
	
	@Autowired
	private ProductCategoryService productCategoryService;
	@Autowired
	private ProductService productService;
	@Autowired
	private CommentService commentService;
	
	/**
	 * 评价列表页面
	 * @param model
	 * @param page
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model,Integer page,HttpServletRequest request) {
		model.addObject("allCategoryId","shop_hd_menu_all_category");  
		model.addObject("productCategoryList",MenuUtil.getTreeCategory(productCategoryService.findList(new HashMap<String, Object>())));
		Account onlineAccount = (Account) request.getSession().getAttribute("account");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		if(page == null || page.intValue() <= 0) {
			page = 1;
		}
		queryMap.put("offset", (page -1)*5);
		queryMap.put("pageSize", 5);
		queryMap.put("userId", onlineAccount.getId());  //根据用户id搜索出该用户的所有评价
		List<Comment> commentList = commentService.findList(queryMap);
		//设置时间的显示格式
		for (Comment comment : commentList) {
			comment.setShowTime(DateUtil.date2String(comment.getCreateTime()));
		}
		model.addObject("commentList", commentList);  //查出所有的评价
		model.addObject("currentUser","current_");
		model.addObject("title", "评价列表");
		model.addObject("page", page); //分页
		model.setViewName("home/comment/list");
		return model;
	}
	
	/**
	 * 添加评论处理
	 * @param comment
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(Comment comment,HttpServletRequest request) {
		Account onlineAccount = (Account) request.getSession().getAttribute("account");  //当前登录用户
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(comment == null) {
			ret.put("msg", "请填写正确的评价信息！");
			return ret;
		}
		if(StringUtils.isEmpty(comment.getContent())) {
			ret.put("msg", "请填写评价内容！");
			return ret;
		}
		comment.setCreateTime(new Date());
		comment.setUserId(onlineAccount.getId());
		if(commentService.add(comment) <= 0) {
			ret.put("type", "error");
			ret.put("msg", "评论失败，请联系管理员！");
			return ret;
		}
		Product product = productService.findById(comment.getProductId());
		product.setCommentNum(product.getCommentNum() + 1);
		productService.updateNum(product);
		ret.put("type", "success");
		return ret;
	}
	
	/**
	 * 删除评论
	 * @param commmentId
	 * @return
	 */
	@RequestMapping(value="/delete",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delete(Long commentId) {
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("type", "error");
		if(commentId == null) {
			ret.put("msg", "请选择要删除的评论！");
			return ret;
		}
		if(commentService.delete(commentId) <= 0) {
			ret.put("msg", "删除出错，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		return ret;
	}
	
	
}

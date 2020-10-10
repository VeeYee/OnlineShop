package edu.hbuas.programmer.service.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.common.CommentDao;
import edu.hbuas.programmer.entity.common.Comment;
import edu.hbuas.programmer.service.common.CommentService;

/**
 * 评论接口实现类
 * @author Yee
 *
 */
@Service
public class CommentServiceImpl implements CommentService {

	@Autowired
	private CommentDao commentDao;
	
	@Override
	public int add(Comment comment) {
		return commentDao.add(comment);
	}

	@Override
	public int edit(Comment comment) {
		return commentDao.edit(comment);
	}

	@Override
	public int delete(Long id) {
		return commentDao.delete(id);
	}

	@Override
	public List<Comment> findList(Map<String, Object> queryMap) {
		return commentDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return commentDao.getTotal(queryMap);
	}

	@Override
	public Comment findById(Long id) {
		return commentDao.findById(id);
	}

}

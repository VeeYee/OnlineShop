package edu.hbuas.programmer.dao.common;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import edu.hbuas.programmer.entity.common.Comment;

/**
 * 评论dao
 * @author Yee
 *
 */
@Repository
public interface CommentDao {
	
	/**
	 * 添加评论
	 * @param comment
	 * @return
	 */
	public int add(Comment comment);
	
	/**
	 * 编辑评论
	 * @param comment
	 * @return
	 */
	public int edit(Comment comment);

	/**
	 * 删除评论
	 * @param id
	 * @return
	 */
	public int delete(Long id);
	
	/**
	 * 多条件查询评论
	 * @param queryMap
	 * @return
	 */
	public List<Comment> findList(Map<String, Object> queryMap);

	/**
	 * 获取符合条件的总记录数
	 * @param queryMap
	 * @return
	 */
	public int getTotal(Map<String, Object> queryMap);
	
	/**
	 * 根据id查询评论
	 * @param id
	 * @return
	 */
	public Comment findById(Long id);

}

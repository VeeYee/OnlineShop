package edu.hbuas.programmer.dao.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import edu.hbuas.programmer.entity.admin.Log;

/**
 * 系统日志dao
 * @author Yee
 *
 */
@Repository
public interface LogDao {
	
	public int add(Log log);
	public int delete(String ids);
	public List<Log> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
}

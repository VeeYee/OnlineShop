package edu.hbuas.programmer.service.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import edu.hbuas.programmer.entity.admin.Log;


/**
 * 日志接口
 * @author Yee
 *
 */
@Service
public interface LogService {
	public int add(Log log);
	public int add(String content);
	public int delete(String ids);
	public List<Log> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
}

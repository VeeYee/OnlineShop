package edu.hbuas.programmer.service.admin.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.admin.LogDao;
import edu.hbuas.programmer.entity.admin.Log;
import edu.hbuas.programmer.service.admin.LogService;

/**
 * 日志接口的实现类
 * @author Yee
 *
 */
@Service
public class LogServiceImpl implements LogService {

	@Autowired
	private LogDao logDao;
	
	@Override
	public int add(Log log) {
		return logDao.add(log);
	}

	@Override
	public List<Log> findList(Map<String, Object> queryMap) {
		return logDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return logDao.getTotal(queryMap);
	}

	@Override
	public int delete(String ids) {
		return logDao.delete(ids);
	}

	/**
	 * 添加一条日志的方法
	 */
	@Override
	public int add(String content) {
		Log log = new Log();
		log.setContent(content);
		log.setCreateTime(new Date());
		return logDao.add(log);
	}

}

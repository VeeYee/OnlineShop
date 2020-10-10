package edu.hbuas.programmer.service.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.common.AccountDao;
import edu.hbuas.programmer.entity.common.Account;
import edu.hbuas.programmer.service.common.AccountService;

/**
 * 商品接口实现类
 * @author Yee
 *
 */
@Service
public class AccountServiceImpl implements AccountService {

	@Autowired
	private AccountDao accountDao;

	@Override
	public int add(Account Account) {
		return accountDao.add(Account);
	}

	@Override
	public int edit(Account Account) {
		return accountDao.edit(Account);
	}

	@Override
	public int delete(Long id) {
		return accountDao.delete(id);
	}

	@Override
	public List<Account> findList(Map<String, Object> queryMap) {
		return accountDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return accountDao.getTotal(queryMap);
	}

	@Override
	public Account findById(Long id) {
		return accountDao.findById(id);
	}

	@Override
	public Account findByName(String name) {
		return accountDao.findByName(name);
	}

}

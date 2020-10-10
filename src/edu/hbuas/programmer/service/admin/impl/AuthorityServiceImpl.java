package edu.hbuas.programmer.service.admin.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.admin.AuthorityDao;
import edu.hbuas.programmer.entity.admin.Authority;
import edu.hbuas.programmer.service.admin.AuthorityService;

/**
 * 权限sevice的实现类
 * @author Yee
 *
 */
@Service
public class AuthorityServiceImpl implements AuthorityService {

	@Autowired
	AuthorityDao authorityDao;
	
	@Override
	public int add(Authority authority) {
		return authorityDao.add(authority);
	}

	@Override
	public int deleteByRoleId(Long roleId) {
		return authorityDao.deleteByRoleId(roleId);
	}

	@Override
	public List<Authority> findListByRoleId(Long roleId) {
		return authorityDao.findListByRoleId(roleId);
	}

}

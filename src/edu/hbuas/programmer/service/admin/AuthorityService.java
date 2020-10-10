package edu.hbuas.programmer.service.admin;

import java.util.List;

import org.springframework.stereotype.Service;

import edu.hbuas.programmer.entity.admin.Authority;

/**
 * 权限service接口
 * @author Yee
 *
 */
@Service
public interface AuthorityService {
	public int add(Authority authority);
	public int deleteByRoleId(Long roleId);
	public List<Authority> findListByRoleId(Long roleId);
}

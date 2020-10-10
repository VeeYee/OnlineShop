package edu.hbuas.programmer.dao.admin;

import java.util.List;

import org.springframework.stereotype.Repository;

import edu.hbuas.programmer.entity.admin.Authority;

/**
 * 权限实现类dao
 * @author Yee
 *
 */
@Repository
public interface AuthorityDao {
	public int add(Authority authority);
	public int deleteByRoleId(Long roleId);
	public List<Authority> findListByRoleId(Long roleId);
}

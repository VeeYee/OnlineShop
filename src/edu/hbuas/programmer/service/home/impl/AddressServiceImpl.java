package edu.hbuas.programmer.service.home.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.hbuas.programmer.dao.home.AddressDao;
import edu.hbuas.programmer.entity.home.Address;
import edu.hbuas.programmer.service.home.AddressService;

/**
 * 购物车接口实现类
 * @author Yee
 *
 */
@Service
public class AddressServiceImpl implements AddressService {

	@Autowired
	private AddressDao addressDao;

	@Override
	public int add(Address address) {
		return addressDao.add(address);
	}

	@Override
	public int edit(Address address) {
		return addressDao.edit(address);
	}

	@Override
	public int delete(Long id) {
		return addressDao.delete(id);
	}

	@Override
	public List<Address> findList(Map<String, Object> queryMap) {
		return addressDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return addressDao.getTotal(queryMap);
	}

	@Override
	public Address findById(Long id) {
		return addressDao.findById(id);
	}
}

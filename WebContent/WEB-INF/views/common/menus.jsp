<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<!-- 这里加载了二级菜单下拥有权限的菜单按钮 --> 
<c:forEach items="${thirdMenuList }" var="thirdMenu">
   	<a href="#" class="easyui-linkbutton" iconCls="${thirdMenu.icon }" onclick="${thirdMenu.url }" plain="true">${thirdMenu.name }</a>
</c:forEach>
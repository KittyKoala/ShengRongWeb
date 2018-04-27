package com.shengrong.manager.actions;

import java.security.MessageDigest;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;
import org.hibernate.Transaction;

import sun.misc.BASE64Encoder;

import com.shengrong.hibernate.Master;
import com.shengrong.hibernate.MasterDAO;
import com.shengrong.hibernate.Role;
import com.shengrong.hibernate.RoleDAO;

public class Login extends ActionBase {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7722879410740390753L;
	
	private String mastername;

	private String password;
	
	private String roleid;
	
	public String getRoleid(){
		return this.roleid;
	}
	
	public void setRoleid(String roleid){
		this.roleid = roleid;
	}
	
	public String getMastername(){
		return this.mastername;
	}
	
	public void setMastername(String mastername){
		this.mastername = mastername;
	}
	
	public String getPassword(){
		return this.password;
	}
	
	public void setPassword(String password){
		this.password = password;
	}
	
	/**
	 *	进行系统初始化，如果没有超级管理员则要进行超级管理员注册，如果有则进行系统页面
	 * @return String 返回“success”则直接进入系统；返回“input”进入超管注册页面；返回“error”进入错误页面
	 * 					
	 */
	@Override
	public String execute(){
		RoleDAO roleDao = new RoleDAO();
		Role master = roleDao.findById("master");
		if(master == null){
			this.setMessage("数据库中没有master角色，请联系系统管理员进行维修！");			
			return ERROR;
		}
		
		MasterDAO managerDao = new MasterDAO();
		@SuppressWarnings("unchecked")
		List<Master> managers = managerDao.findAll();
		if(managers.size() == 0){
			return INPUT;
		}else if(managers.size() == 1){
			return SUCCESS;
		}else {
			this.setMessage("超级管理员不唯一，请联系系统管理员进行维修！");
			return ERROR;
		}
	}
	
	/**
	 * 超级管理员注册
	 * @return String error时返回重新输入；success时进入登录页面
	 */
	public String register(){
		
		if(this.mastername == null || this.password == null){
			this.setMessage("账号和密码不可以为空！");
			this.setHref("enter.action");
			return ERROR;
		}
		
		try {
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			byte str[] = md5.digest(this.password.getBytes("utf-8"));
			str[Role.MASTER % 15] ^= Role.MASTER % 127 ; //利用角色对密码进行再加密
			BASE64Encoder encoder = new BASE64Encoder();
			
			//获取加密后的密码
			String encodePassword = encoder.encode(str);
			
			RoleDAO roleDao = new RoleDAO();
			Role role = roleDao.findById("master");
			
			MasterDAO masterDao = new MasterDAO();
			Master master = new Master(this.mastername, role, encodePassword);
			Transaction tx = masterDao.getSession().beginTransaction();
			masterDao.save(master);
			tx.commit();
			masterDao.getSession().close();
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		this.setMessage("您已成功注册超级管理员！");
		this.setHref("enter.action");
		return SUCCESS;
	}
	
	/**
	 * 管理员登录，超级管理员登录比普通管理员多一个管理员管理模块
	 * @return success时进入系统(roleid用户判断是哪种登录方式)；error时进入错误页面
	 */
	public String login(){
		
		if(this.mastername == null || this.password == null || this.roleid == null){
			this.setMessage("账号、密码、登录身份不可以为空！");
			this.setHref("enter.action");
			return ERROR;
		}
		
		//获取session对象，当session为空时不要创建新的session
		HttpSession session = ServletActionContext.getRequest().getSession(false);
		if(session == null){
			this.setMessage("会话过期，请重新登陆！");
			this.setHref("enter.action");
			return ERROR;
		}
		
		//如果session中存在name，则说明已登录
		if(session.getAttribute("managername") != null){
			return SUCCESS;			
		}
		
		//如果session中没有managername字段，则需要验证登录信息
		String encodePassword = null;
		try{
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			byte str[] = md5.digest(this.password.getBytes("utf-8"));
			str[Role.MASTER % 15] ^= Role.MASTER % 127 ; //利用角色对密码进行再加密
			BASE64Encoder encoder = new BASE64Encoder();
			//获取加密后的密码
			encodePassword = encoder.encode(str);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		RoleDAO roleDao = new RoleDAO();
		Role role = roleDao.findById(this.roleid);
		
		//超级管理员身份登录
		if(this.roleid.equals("master")){
			Master master = new Master(this.mastername, role, encodePassword);
			MasterDAO masterDao = new MasterDAO();
			@SuppressWarnings("unchecked")
			List<Master> masters = masterDao.findByExample(master);
			if(masters.size() == 0){
				this.setMessage("账号或密码错误！");
				this.setHref("enter.action");
				return ERROR;
			}else{
				//登录成功
				return SUCCESS;
			}
			
		}else if(this.roleid.equals("admin")){
			//普通管理员身份登录
			
		}else{
			this.setMessage("系统角色中仅有master和admin，但登录时出现了其余角色，请联系系统管理员！");
			this.setHref("enter.action");
			return ERROR;
		}
		
		
		return SUCCESS;
	}
}

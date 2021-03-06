<%@ page language="java" import="java.util.*, com.shengrong.hibernate.*, java.text.SimpleDateFormat, java.io.*" pageEncoding="utf-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
String path = request.getContextPath();
response.setCharacterEncoding("utf-8");
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
List<Member> memberList = (List<Member>)request.getAttribute("memberList");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="zh-CN">
  <head>
    <base href="<%=basePath%>">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>河南晟荣建筑工业科技有限公司-企业门户网站后台管理系统</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="description" content="河南晟荣建筑工业科技有限公司-企业门户网站后台管理系统">
	
	<link href="<%=basePath%>Plugins/bootstrap/bootstrap.css" rel="stylesheet"/>
	<link href="<%=basePath%>Plugins/FontAwesome/font-awesome.css" rel="stylesheet"/>
	<link href="<%=basePath%>styles.css" rel="stylesheet"/>
	<link href="<%=basePath%>Plugins/validform/css/validform.css" rel="stylesheet"/>
	<!-- Google Fonts-->
    <link href='<%=basePath%>fonts.css' rel='stylesheet' type='text/css' />
    <link href="<%=basePath%>Plugins/datetimepicker/bootstrap-datetimepicker.min.css" rel="stylesheet" />
    <link href="<%=basePath%>Plugins/cropper/cropper.css" rel="stylesheet"/>
    <style>
    	.cropppic {
		    position:relative; /* or fixed or absolute */
		    border:1px solid #ccc;
		}
		.friend-grid {
			text-align:center;
		}
		.friend-grid h4 {
		    font-size: 1.5em;
		    padding: .8em 0 .5em 0;
			font-family: 'Righteous', cursive;
		    color: #000;
		}
		.friend-grid img:hover {
		    border-radius: 60%;
		    border: 6px solid#2DA9E1;
			 transform: scale(1.05);
		    -webkit-transform: scale(1.05);
		    -moz-transform: scale(1.05);
		    -o-transform: scale(1.05);
		    -ms-transform: scale(1.05);
		}
		.friend-grid img {
			width:200px;
			height:200px;
		    border-radius: 60%;
		    border: 6px solid#fff;
			transition: 0.5s all;
		    -webkit-transition: 0.5s all;
		    -moz-transition: 0.5s all;
		    -o-transition: 0.5s all;
		    -ms-transition: 0.5s all;
		}
		.friend-grid p {
			margin-top:0px;
			padding-top:0px;
		    font-size: 1em;
			line-height:1.8em;
		    color: #777;
		}
    </style>
  </head>
  
<body>
	<div id="wrapper">
		
		<!-- 添加navbar，动态链接方式，需要jsp重新编译 -->
		<jsp:include page="../navbar.jsp" flush="true"/>
				
		<div id="page-wrapper">
			<div class="header"> 
				<h1 class="page-header">
					关于团队<small>About Member</small>
				</h1>
				<ol class="breadcrumb">
				  <li><a href="#">河南晟荣</a></li>
				  <li class="active">关于我们</li>
				</ol> 
			</div>
			<div id="page-inner">
				<!-- form -->
				<div class="row">
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading">
								增加新的成员
							</div>
							<div class="panel-body">
								<div class="row">
									<div class="col-lg-12">
										<form method="post" role="form" action="<%=basePath %>aboutus/saveAboutmember.action">
											<div class="form-group">
												<label>新成员的昵称</label>
												<input datatype="*1-16" errormsg="昵称不能为空，且不要超过16个字！" class="form-control" name="encpMember.membername"/>
												<p class="help-block">请输入新成员的昵称，也可以使用真实姓名，不要超过16个字</p>
											</div>
											<div class="form-group">
												<label>新成员的职务</label>											
												<input datatype="*1-16" errormsg="职务不能为空，且不要超过32个字！" class="form-control" name="encpMember.post"/>
									            <p class="help-block">请输入新成员的职务，如技术总监、产品经理等，不要超过16个字</p>
											</div>
											<div id="form_group_img" class="form-group">
												<label>上传新成员的头像</label>											
												<img id="img_teamprocess" class="cropppic" src="<%=basePath %>Images/login-bg.jpg" />
												<input type="file" class="sr-only" id="input_file" name="image" accept="image/*">
												<input name="encpMember.encpImage" type="text" class="sr-only" id="input_imagedata"/>
												<p class="help-block">发一张代表公司里程碑事件的图片，图片大小不要超过16M，<a onclick="loadImage()">点击此处添加图片</a></p>
											</div>
											<button onclick="preSubmit();" type="submit" class="btn btn-default">确认增加</button>
	                                        <button onclick="resetImage();" type="reset" class="btn btn-default">内容重置</button>
										</form>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading">
								现有成员
							</div>
							<div class="panel-body">
								<%
									for(int i=0; i<memberList.size(); i++){
										InputStream is = memberList.get(i).getImage().getBinaryStream();
										byte[] b = new byte[is.available()];
										is.read(b, 0, b.length);
										String imageString = new String(b); 
									%>
										<div class="col-md-4 friend-grid">
											<img src="<%=imageString %>">
											<h4>
												<%=memberList.get(i).getMembername() %>
											</h4>
											<p>
												<%=memberList.get(i).getPost() %>
												<a type="button" class="btn btn-danger btn-sm" onclick="deleteMember(<%=memberList.get(i).getMemberid() %>)" >
                                            		<span class="fa fa-minus"></span>&nbsp;删除
                                            	</a>
											</p>
										</div>
									<%
									} 
								%>
								
							</div>
						</div>
					</div>
				</div>
				
				<footer>
					<p>Copyright &copy; 2018.河南晟荣建筑工业科技有限公司版权所有.</p>
				</footer>
			</div>
		</div>
	</div>
	
	<!-- 模态对话框 -->
	<div class="modal fade" id="operatorInfo_dlg" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
	    	<div class="modal-content">
	            <div class="modal-header">
	            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title" id="operatorInfo_title"></h4>
	            </div>
	            <div class="modal-body" id="operatorInfo_content">
	                
	            </div>
	            <div class="modal-footer">
	                <button onclick="window.location.href='<%=basePath%>aboutus/aboutmember.action';" type="button" class="btn btn-default" data-dismiss="modal">确定</button>
	            </div>
	        </div>
	    </div>
	</div>
	
	<script src="<%=basePath%>Plugins/jquery/jquery-1.10.2.js"></script>
	<script src="<%=basePath%>Plugins/jquery/jquery.metisMenu.js"></script>
	<script src="<%=basePath%>Plugins/bootstrap/bootstrap.min.js"></script>
	<script src="<%=basePath%>scripts.js"></script>
	<script src="<%=basePath%>Plugins/validform/js/Validform_v5.3.2_ncr_min.js"></script>
	<script src="<%=basePath%>Plugins/datetimepicker/moment-with-locales.min.js"></script>
	<script src="<%=basePath%>Plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
	<script src="<%=basePath%>Plugins/cropper/cropper.js"></script>
	<script type="text/javascript">
		var cropper = null;
		$(function(){
			$(window).resize(function(){
				updateCroppicSize();	
			});
			//初始化表单验证信息
			var form = $("form").Validform({
				tiptype:3,
				label:".label",
				showAllError:true
			});
			
			updateCroppicSize();
			initFileInput();
			initCropper();
		});
		
		/**
		*	给所有的Input[type=file]添加监听事件
		**/
		function initFileInput(){
			var fileInput = $("input[type=file]");
			$(fileInput).bind('input propertychange', function(){
				cropper.replace(window.URL.createObjectURL(this.files[0]));
			});
		}
		
		function updateCroppicSize(){
			var croppics = $(".cropppic");
			for(var i = 0; i<croppics.length;i++){
				var div_colo_6s = $("#form_group_img");
				var width = $(div_colo_6s[0]).width()*0.25;
				var height = width;
				$(croppics[i]).css("width", width + "px");
				$(croppics[i]).css("height", height + "px");
			};
		}
		
		function loadImage(){
			$("#input_file").click();
			return false;
		}
		
		function initCropper(){
			var $image = $("#img_teamprocess");
			var options = {
				dragMode: 'move',
		        aspectRatio: 1 / 1,
		        autoCropArea: 0.65,
		        restore: false,
		        guides: false,
		        center: false,
		        highlight: false,
		        cropBoxMovable: false,
		        cropBoxResizable: false,
		        toggleDragModeOnDblclick: false,
			};
			cropper = new Cropper($image[0], options);
		}
		
		function preSubmit(){
			var dataURL = cropper.getCroppedCanvas().toDataURL('image/jpeg');
			$("#input_imagedata").val(dataURL);
		}
		
		function deleteMember(memberid){
			$.ajax({  
				type:"POST",
        		url:"<%=basePath%>aboutus/deleteAboutMember.action",
        		dataType:"json",
        		data:{
       				"memberid":memberid
        		},
        		success:function(data){
        			var result = JSON.parse(data);
        			if(result.code == "200"){
        				$("#operatorInfo_title").html("提示信息");
						$("#operatorInfo_content").html(result.msg);
        			}else{
        				$("#operatorInfo_title").html("错误信息");
						$("#operatorInfo_content").html(result.msg);
        			}
        			$("#operatorInfo_dlg").modal();
        		},
        		error:function(XMLHttpRequest, textStatus, errorThrown){
        			$("#operatorInfo_title").html("错误信息");
					$("#operatorInfo_content").html(textStatus);
					$("#operatorInfo_dlg").modal();
        		}
        	});
		}
	</script>
</body>
</html>

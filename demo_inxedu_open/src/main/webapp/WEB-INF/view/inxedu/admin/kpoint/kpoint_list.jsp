<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>课程节点</title>
<link type="text/css" rel="stylesheet" href="${ctx}/static/common/ztree/css/zTreeStyle.css" />
<script type="text/javascript" src="${ctx}/static/common/ztree/jquery.ztree.core-3.5.min.js"></script>
<script type="text/javascript" src="${ctx}/static/common/ztree/jquery.ztree.excheck-3.5.min.js"></script>
<script type="text/javascript" src="${ctx}/static/common/ztree/jquery.ztree.exedit-3.5.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/kindeditor/themes/default/default.css" />
	<script type="text/javascript" src="${ctx}/kindeditor/kindeditor-all.js"></script>
<script type="text/javascript" src="${ctx}/static/admin/kpoint/kpoint.js"></script>
<script type="text/javascript" src="${ctx}/static/admin/teacher/select_teacher_list.js"></script>

<script type="text/javascript" src="${ctx}/static/common/uploadify/ccswfobject.js"></script>

	<script type="text/javascript" src="${ctximg}/static/common/uploadify/swfobject.js"></script>
	<script type="text/javascript" src="${ctximg}/static/common/uploadify/jquery.uploadify.v2.1.4.min.js"></script>
	<script type="text/javascript" src="${ctximg}/static/admin/js/es6-promise.min.js"></script>
	<script type="text/javascript" src="${ctximg}/static/admin/js/aliyun-oss-sdk-5.3.1.min.js"></script>
	<script type="text/javascript" src="${ctximg}/static/admin/js/aliyun-upload-sdk-1.5.0.min.js"></script>
<style type="text/css">
#swfDiv embed {
	position: absolute;
	z-index: 1;
}
#swfDiv{*position:absolute; z-index:2;}
</style>
<script type="text/javascript">
		var ztree='${kpointList}';
		$(function(){
			showKpointZtree(ztree);
			//文本编辑框
			initKindEditor_addblog('content', 580, 350,'courseContxt','true');
		});

        //上传控件加载
        function uploadPicLoad(fileupload,showId,fileQueue){
            //$("#fileuploadUploader").remove();

            $("#fileupload").uploadify({
                'uploader' : '/static/common/uploadify/uploadify.swf', //上传控件的主体文件，flash控件  默认值='uploadify.swf'
                'script'  :'<%=uploadServerUrl%>/video/uploadvideo',
                'scriptData':{"fileType":"mp4","param":"video"},
                'queueID' : fileQueue, //文件队列ID
                'fileDataName' : 'uploadfile', //您的文件在上传服务器脚本阵列的名称
                'auto' : true, //选定文件后是否自动上传
                'multi' :false, //是否允许同时上传多文件
                'hideButton' : false,//上传按钮的隐藏
                'buttonText' : 'Browse',//默认按钮的名字
                'buttonImg' : '/static/common/uploadify/liulan.png',//使用图片按钮，设定图片的路径即可
                'width' : 105,
                'simUploadLimit' : 3,//多文件上传时，同时上传文件数目限制
                'sizeLimit' : 5120000000,//控制上传文件的大小
                'queueSizeLimit' : 3,//限制在一次队列中的次数（可选定几个文件）
                'fileDesc' : '支持格式:mp4.',//出现在上传对话框中的文件类型描述
                'fileExt' : '*.MP4;*.mp4;',//支持的格式，启用本项时需同时声明fileDesc
                'folder' : '/upload',//您想将文件保存到的路径
                'cancelImg' : '/static/common/uploadify/cancel.png',
                onSelect : function(event, queueID,fileObj) {
                    fileuploadIndex = 1;
                    $("#"+fileQueue).html("");
                    if (fileObj.size > 5120000000) {
                        alert('文件太大最大限制5120000kb');
                        return false;
                    }
                },
                onComplete : function(event,queueID, fileObj, response,data) {
                    var obj = eval('(' + response + ')');
                    $("#"+showId).val(obj.url);
                    $("#"+showId).show();
                },
                onError : function(event, queueID, fileObj,errorObj) {
                    $("#"+fileQueue).html("<br/><font color='red'>"+ fileObj.name + "上传失败</font>");
                }
            });
        }
        function setBlogrollImageName(uploadInfo){

        }
  /*      function setBlogrollImageName(uploadInfo) {
            var uploader = new AliyunUpload.Vod({
                //阿里账号ID，必须有值 ，值的来源https://help.aliyun.com/knowledge_detail/37196.html
                userId:"1753139843658599",
                //分片大小默认1M，不能小于100K
                partSize: 1048576,
                //并行上传分片个数，默认5
                parallel: 5,
                //网络原因失败时，重新上传次数，默认为3
                retryCount: 3,
                //网络原因失败时，重新上传间隔时间，默认为2秒
                retryDuration: 2,
                //是否上报上传日志到点播，默认为true
                enableUploadProgress: true,
                // 开始上传
                'onUploadstarted': function (uploadInfo) {
                    log("onUploadStarted:" + uploadInfo.file.name + ", endpoint:" + uploadInfo.endpoint + ", bucket:" + uploadInfo.bucket + ", object:" + uploadInfo.object);
                    //上传方式1, 需要根据uploadInfo.videoId是否有值，调用点播的不同接口获取uploadauth和uploadAddress，如果videoId有值，调用刷新视频上传凭证接口，否则调用创建视频上传凭证接口
                    if (uploadInfo.videoId) {
                        // 如果 uploadInfo.videoId 存在, 调用 刷新视频上传凭证接口(https://help.aliyun.com/document_detail/55408.html)
                    }
                    else{
                        // 如果 uploadInfo.videoId 不存在,调用 获取视频上传地址和凭证接口(https://help.aliyun.com/document_detail/55407.html)
                    }
                    //从点播服务获取的uploadAuth、uploadAddress和videoId,设置到SDK里
                    uploader.setUploadAuthAndAddress(uploadInfo, uploadAuth, uploadAddress,videoId);
                },
                // 文件上传成功
                'onUploadSucceed': function (uploadInfo) {
                    log("onUploadSucceed: " + uploadInfo.file.name + ", endpoint:" + uploadInfo.endpoint + ", bucket:" + uploadInfo.bucket + ", object:" + uploadInfo.object);
                },
                // 文件上传失败
                'onUploadFailed': function (uploadInfo, code, message) {
                    log("onUploadFailed: file:" + uploadInfo.file.name + ",code:" + code + ", message:" + message);
                },
                // 文件上传进度，单位：字节
                'onUploadProgress': function (uploadInfo, totalSize, loadedPercent) {
                    log("onUploadProgress:file:" + uploadInfo.file.name + ", fileSize:" + totalSize + ", percent:" + Math.ceil(loadedPercent * 100) + "%");
                },
                // 上传凭证超时
                'onUploadTokenExpired': function (uploadInfo) {
                    console.log("onUploadTokenExpired");
                    //实现时，根据uploadInfo.videoId调用刷新视频上传凭证接口重新获取UploadAuth
                    //https://help.aliyun.com/document_detail/55408.html
                    //从点播服务刷新的uploadAuth,设置到SDK里
                    uploader.resumeUploadWithAuth(uploadAuth);
                },
                //全部文件上传结束
                'onUploadEnd':function(uploadInfo){
                    console.log("onUploadEnd: uploaded all the files");
                }
            });

        }*/

        /**
         * 音频上传控件加载
         * @param controlId
         * @param ids
         * @param errId
         */
        function uploadAudios(controlId,ids,errId){
            $("#"+controlId).uploadify({
                'uploader' : baselocation+'/static/common/uploadify/uploadify.swf', //上传控件的主体文件，flash控件  默认值='uploadify.swf'
                'script'  :'<%=uploadServerUrl%>/video/uploadaudio',
                'scriptData':{"fileType":"mp3","param":"audio"},
                'queueID' : errId, //文件队列ID
                'fileDataName' : 'uploadfile', //您的文件在上传服务器脚本阵列的名称
                'auto' : true, //选定文件后是否自动上传
                'multi' :false, //是否允许同时上传多文件
                'hideButton' : false,//上传按钮的隐藏
                'buttonText' : 'Browse',//默认按钮的名字
                'buttonImg' : '/static/common/uploadify/liulan.png',//使用图片按钮，设定图片的路径即可
                'width' : 105,
                'simUploadLimit' : 3,//多文件上传时，同时上传文件数目限制
                'sizeLimit' : 51200000,//控制上传文件的大小
                'queueSizeLimit' : 3,//限制在一次队列中的次数（可选定几个文件）
                'fileDesc' : '支持格式:mp3',//出现在上传对话框中的文件类型描述
                'fileExt' : '*.mp3',//支持的格式，启用本项时需同时声明fileDesc
                'folder' : '/upload',//您想将文件保存到的路径
                'cancelImg' : '/static/common/uploadify/cancel.png',
                onSelect : function(event, queueID,fileObj) {
                    fileuploadIndex = 1;
                    $("#"+errId).html("");
                    if (fileObj.size > 51200000) {
                        alert("文件太大最大限制51200kb");
                        return false;
                    }
                },
                onComplete : function(event,queueID, fileObj, response,data) {
                    alert("上传成功");
                    var obj = eval('(' + response + ')');
                    $("#"+ids).val(obj.url);
                    $("#"+ids).show();
                },
                onError : function(event, queueID, fileObj,errorObj) {
                    $("#"+errId).html("<br/><font color='red'>"+ fileObj.name + "上传失败</font>");
                }
            });
        }
        //兼容IE11
        if (!FileReader.prototype.readAsBinaryString) {
            FileReader.prototype.readAsBinaryString = function (fileData) {
                var binary = "";
                var pt = this;
                var reader = new FileReader();
                reader.onload = function (e) {
                    var bytes = new Uint8Array(reader.result);
                    var length = bytes.byteLength;
                    for (var i = 0; i < length; i++) {
                        binary += String.fromCharCode(bytes[i]);
                    }
                    //pt.result  - readonly so assign binary
                    pt.content = binary;
                    pt.onload()
                }
                reader.readAsArrayBuffer(fileData);
            }
        }
        $(document).ready(function () {
            /**
             * 创建一个上传对象
             * 使用 UploadAuth 上传方式
             */
            function createUploader () {
                var uploader = new AliyunUpload.Vod({
                    timeout: 60000,
                    partSize: 1048576,
                    parallel:  5,
                    retryCount:  3,
                    retryDuration:  2,
                    region: "cn-shanghai",
                    userId: "1800191873308375",
                    // 添加文件成功
                    addFileSuccess: function (uploadInfo) {
                        console.log('addFileSuccess')
                        $('#authUpload').attr('disabled', false)
                        $('#resumeUpload').attr('disabled', false)
                        $('#status').text('添加文件成功, 等待上传...')
                        console.log("addFileSuccess: " + uploadInfo.file.name)
                    },
                    // 开始上传
                    onUploadstarted: function (uploadInfo) {
                        // 如果是 UploadAuth 上传方式, 需要调用 uploader.setUploadAuthAndAddress 方法
                        // 如果是 UploadAuth 上传方式, 需要根据 uploadInfo.videoId是否有值，调用点播的不同接口获取uploadauth和uploadAddress
                        // 如果 uploadInfo.videoId 有值，调用刷新视频上传凭证接口，否则调用创建视频上传凭证接口
                        // 注意: 这里是测试 demo 所以直接调用了获取 UploadAuth 的测试接口, 用户在使用时需要判断 uploadInfo.videoId 存在与否从而调用 openApi
                        // 如果 uploadInfo.videoId 存在, 调用 刷新视频上传凭证接口(https://help.aliyun.com/document_detail/55408.html)
                        // 如果 uploadInfo.videoId 不存在,调用 获取视频上传地址和凭证接口(https://help.aliyun.com/document_detail/55407.html)
                        if (!uploadInfo.videoId) {
                            var createUrl ="${ctximg}/video/getVideoId?title="+ uploadInfo.file.name+"&fileName="+uploadInfo.file.name;
                            $.get(createUrl, function (data) {
                                console.log(data)
                                var uploadAuth = data.uploadAuth
                                var uploadAddress = data.uploadAddress
                                var videoId = data.videoId
                                uploader.setUploadAuthAndAddress(uploadInfo, uploadAuth, uploadAddress,videoId)
                                $('#videourl').val(uploadInfo.videoId);
                            }, 'json')
                            $('#status').text('文件开始上传...')
                            console.log("onUploadStarted:" + uploadInfo.file.name + ", endpoint:" + uploadInfo.endpoint + ", bucket:" + uploadInfo.bucket + ", object:" + uploadInfo.object)
                        } else {
                            // 如果videoId有值，根据videoId刷新上传凭证
                            // https://help.aliyun.com/document_detail/55408.html?spm=a2c4g.11186623.6.630.BoYYcY
                            var refreshUrl = "${ctximg}/video/refreshVideoId?videoId="+ uploadInfo.videoId;//'https://demo-vod.cn-shanghai.aliyuncs.com/voddemo/RefreshUploadVideo?BusinessType=vodai&TerminalType=pc&DeviceModel=iPhone9,2&UUID=59ECA-4193-4695-94DD-7E1247288&AppVersion=1.0.0&Title=haha1&FileName=xxx.mp4&VideoId=' + uploadInfo.videoId
                            $.get(refreshUrl, function (data) {
                                var uploadAuth = data.uploadAuth
                                var uploadAddress = data.uploadAddress
                                var videoId = data.videoId
                                uploader.setUploadAuthAndAddress(uploadInfo, uploadAuth, uploadAddress,videoId)
                                $('#videourl').val(uploadInfo.videoId);
                            }, 'json')
                        }
                    },
                    // 文件上传成功
                    onUploadSucceed: function (uploadInfo) {
                        console.log("*******onUploadSucceed: " + uploadInfo.file.name + ", endpoint:" + uploadInfo.endpoint + ", bucket:" + uploadInfo.bucket + ", object:" + uploadInfo.object)
                        $('#status').text('文件上传成功!')
                    },
                    // 文件上传失败
                    onUploadFailed: function (uploadInfo, code, message) {
                        console.log("onUploadFailed: file:" + uploadInfo.file.name + ",code:" + code + ", message:" + message)
                        $('#status').text('文件上传失败!')
                    },
                    // 取消文件上传
                    onUploadCanceled: function (uploadInfo, code, message) {
                        console.log("Canceled file: " + uploadInfo.file.name + ", code: " + code + ", message:" + message)
                        $('#status').text('文件上传已暂停!')
                    },
                    // 文件上传进度，单位：字节, 可以在这个函数中拿到上传进度并显示在页面上
                    onUploadProgress: function (uploadInfo, totalSize, progress) {
                        console.log("onUploadProgress:file:" + uploadInfo.file.name + ", fileSize:" + totalSize + ", percent:" + Math.ceil(progress * 100) + "%")
                        var progressPercent = Math.ceil(progress * 100)
                        $('#auth-progress').text(progressPercent)
                        $('#status').text('文件上传中...')
                    },
                    // 上传凭证超时
                    onUploadTokenExpired: function (uploadInfo) {
                        // 上传大文件超时, 如果是上传方式一即根据 UploadAuth 上传时
                        // 需要根据 uploadInfo.videoId 调用刷新视频上传凭证接口(https://help.aliyun.com/document_detail/55408.html)重新获取 UploadAuth
                        // 然后调用 resumeUploadWithAuth 方法, 这里是测试接口, 所以我直接获取了 UploadAuth
                        $('#status').text('文件上传超时!')
                        <%--var refreshUrl = "${ctximg}/video/refreshVideoId?videoId="+ uploadInfo.videoId;--%>
                        let refreshUrl = "${ctximg}/video/refreshVideoId?videoId="+ uploadInfo.videoId;//refreshUrl = 'https://demo-vod.cn-shanghai.aliyuncs.com/voddemo/RefreshUploadVideo?BusinessType=vodai&TerminalType=pc&DeviceModel=iPhone9,2&UUID=59ECA-4193-4695-94DD-7E1247288&AppVersion=1.0.0&Title=haha1&FileName=xxx.mp4&VideoId=' + uploadInfo.videoId
                        $.get(refreshUrl, function (data) {
                            var uploadAuth = data.UploadAuth
                            uploader.resumeUploadWithAuth(uploadAuth)
                            console.log('upload expired and resume upload with uploadauth ' + uploadAuth)
                        }, 'json')
                    },
                    // 全部文件上传结束
                    onUploadEnd: function (uploadInfo) {
                        $('#status').text('文件上传完毕!')
                        // console.log("文件上传完毕"+uploadInfo.videoId)
                        // $('#videourl').val(uploadInfo.videoId);
                    }
                })
                return uploader
            }

            var uploader = null

            $('#fileUpload').on('change', function (e) {
                var file = e.target.files[0]
                if (!file) {
                    alert("请先选择需要上传的文件!")
                    return
                }
                var Title = file.name
                var userData = '{"Vod":{}}'
                if (uploader) {
                    uploader.stopUpload()
                    $('#auth-progress').text('0')
                    $('#status').text("")
                }
                uploader = createUploader()
                // 首先调用 uploader.addFile(event.target.files[i], null, null, null, userData)
                console.log(uploader)
                uploader.addFile(file, null, null, null, userData)
                $('#authUpload').attr('disabled', false)
                $('#pauseUpload').attr('disabled', true)
                $('#resumeUpload').attr('disabled', true)
            })

            // 第一种方式 UploadAuth 上传
            $('#authUpload').on('click', function () {
                // 然后调用 startUpload 方法, 开始上传
                if (uploader !== null) {
                    uploader.startUpload()
                    $('#authUpload').attr('disabled', true)
                    $('#pauseUpload').attr('disabled', false)
                }
            })

            // 暂停上传
            $('#pauseUpload').on('click', function () {
                if (uploader !== null) {
                    uploader.stopUpload()
                    $('#resumeUpload').attr('disabled', false)
                    $('#pauseUpload').attr('disabled', true)
                }
            })


            $('#resumeUpload').on('click', function () {
                if (uploader !== null) {
                    uploader.startUpload()
                    $('#resumeUpload').attr('disabled', true)
                    $('#pauseUpload').attr('disabled', false)
                }
            })

        })
</script>
</head>
<body>
<div class="mt20">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" class="commonTab01">
		<thead>
		<tr>
			<th colspan="2" align="left">
				<span>${courseSellType}节点管理</span>
				<font color="red">*视频节点只支持二级</font>
			</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td width="20%">
				<fieldset style="height: 662px;">
					<legend>
						<span>${courseSellType}节点管理</span>
						&gt;
						<span>节点列表</span>
					</legend>
					<div class="mt20">
						<div class="commonWrap">
							<div id="kpointList" class="ztree"></div>
							<a title="创建视频节点" onclick="addaKpoint(${courseId});" class="button tooltip" href="javascript:void(0)">
								<span></span>
								创建视频节点
							</a>
							<a title="取消选中" onclick="ztreeCancelSelectedNode();" class="button tooltip" href="javascript:void(0)">
								<span></span>
								取消选中
							</a>
						</div>
					</div>
				</fieldset>

			</td>
			<td width="80%"  >
				<fieldset id="updateWin" style="display: none; height: 662px;">
					<legend>
						&gt;
						<span>编辑节点</span>
					</legend>
					<div class="mt20">
						<div class="commonWrap">
							<form id="updateForm">
								<input type="hidden" name="courseKpoint.kpointId" />
								<input type="hidden" id="courseId" />
								<input type="hidden" name="courseKpoint.atlas" value="" id="atlas" />
								<input type="hidden" name="courseKpoint.atlasThumbnail" value="" id="atlasThumbnail" />
								<table style="line-height: 35px;" width="100%" cellspacing="0" cellpadding="0" border="0" class="commonTab01">
									<tr>
										<td>节点名称:</td>
										<td style="text-align: left;">
											<input name="courseKpoint.name" type="text" />
										</td>
									</tr>
									<tr>
										<td>节点类型:</td>
										<td style="text-align: left;">
											<select id="courseKpointKpointType" name="courseKpoint.kpointType" onchange="kpointTypeChange()">
												<option value="0">目录</option>
												<option value="1">章节</option>
											</select>
										</td>
									</tr>
									<tr style="display:none" class="tr_all">
										<td>课件类型:</td>
										<td style="text-align: left;">
											<select id="fileType" name="courseKpoint.fileType" onchange="chooseFileType()">
												<option value="VIDEO">视频</option>
												<%--<option value="AUDIO">音频</option>--%>
												<%--<option value="TXT">文本</option>--%>
											</select>
										</td>
									</tr>
									<tr style="display:none" class="tr_all videoType">
										<td>视频类型:</td>
										<td style="text-align: left;">
											<select id="courseKpointVideoType" name="courseKpoint.videoType" >
												<%--<option value="">--请选择--</option>--%>
												<%--<option value="CC">CC视频</option>--%>
												<option value="uploadVideo">上传本地视频</option>
												<%--<option value="IFRAME">其他</option>--%>
											</select>
										</td>
									</tr>
									<tr class=" tr_fileType_control uploadVideo" style="display: none;">
										<td>上传进度:</td>
										<td class=" tr_fileType_control uploadVideo" style="text-align: left;">

											<font color="red vam ml10">请上传mp4文件</font>
											<div id="fileQueue" class="mt10">
												<input type="file" id="fileUpload" ><%--value="mp4" name="blogrollimage"  onchange="setBlogrollImageName(this)">--%>
											</div>
                                            <label class="status">上传状态: <span id="status"></span></label>
                                            <div class="upload-type">
                                                <button id="authUpload" disabled="true">开始上传</button>
                                                <button id="pauseUpload" disabled="true">暂停</button>
                                                <button id="resumeUpload" disabled="true">恢复上传</button>
                                                <span class="progress">上传进度: <i id="auth-progress">0</i> %</span>
                                                <span></span>
                                            </div>
										</td>
									</tr>
									<%--音频  开始--%>
									<tr class="tr_all tr_fileType_control uploadaudio" style="display: none;">
										<td>上传进度:</td>
										<td style="text-align: left;">
											<input type="file" id="controlId" class="vam"/>
											<font color="red vam ml10">请上传mp3文件（<a target="_blank" href="http://www.ckplayer.com/manual/12/66.htm">边下边播文档</a>）</font>
											<div id="errId" class="mt10">
											</div>
										</td>
									</tr>
									<%--音频  结束--%>
									<tr style="display:none" class="tr_all videoType">
										<td id="videoUrlTitle">视频地址:</td>
										<td style="text-align: left;">
											<input type="text" name="courseKpoint.videoUrl" id="videourl" value="" style="width: 360px;"/>
									</tr>


									<tr class="tr_all txtContent" style="display: none;">
										<td>文本内容:</td>
										<td><textarea id="content" name="courseKpoint.content" rows="" cols=""></textarea></td>
									</tr>

									<tr>
										<td>排序:</td>
										<td>
											<input type="text" value="0" name="courseKpoint.sort" />
										</td>
									</tr>
									<tr class="tr_all videoType">
										<td>播放次数:</td>
										<td>
											<input type="text" value="0" name="courseKpoint.playCount" disabled="disabled" readonly=""readonly/>
										</td>
									</tr>
									<tr class="tr_all videoType" id="timeLongTr">
										<td>播放时间:</td>
										<td>
											<input type="text" value="00:00" name="courseKpoint.playTime" />
										</td>
									</tr>
									<tr class="tr_all videoType">
										<td>是否免费:</td>
										<td style="text-align: left;" id="isfree">
											<input type="radio" name="courseKpoint.free" value="2" />
											否
                                            <input type="radio" name="courseKpoint.free" value="1" />
                                            是
											<font color="red vam ml10">文档、文本格式、图片集、音频等格式暂不支持试听</font>
										</td>
									</tr>
									<tr class="tr_all videoType" id="teacherTr">
										<td>讲师:</td>
										<td style="text-align: left;">
											<input type="hidden" name="courseKpoint.teacherId" value="0" />
											<p id="teacher" style="margin: 0 0 0em;"></p>
											<a href="javascript:void(0)" onclick="selectTeacher('radio')">选择老师</a>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<button class="ui-state-default ui-corner-all" style="float: left;" onclick="updateKpoint()" type="button">确定</button>
											<button class="ui-state-default ui-corner-all closeBut" style="float: left;" type="button">取消</button>
										</td>
									</tr>
								</table>
							</form>
						</div>
					</div>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">

			</td>
		</tr>
		</tbody>
	</table>
</div>
	<!-- 修改视频节点信息窗口，结束 -->
</body>
</html>
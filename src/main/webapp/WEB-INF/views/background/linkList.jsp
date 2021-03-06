<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>友链列表</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8" />
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/background/css/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/background/css/xadmin.css">
    <script type="text/javascript" src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/background/lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/background/js/xadmin.js"></script>
    <!-- 让IE8/9支持媒体查询，从而兼容栅格 -->
    <!--[if lt IE 9]>
    <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body class="layui-anim layui-anim-up">
<div class="x-body">
    <div class="layui-row">
        <div class="layui-col-md12 x-so">
            <input type="text" name="title" id="title" placeholder="请输入链接名称" autocomplete="off" class="layui-input">
            <button class="layui-btn" lay-filter="reload" id="reload"><i class="layui-icon">&#xe615;</i></button>
        </div>
    </div>
    <xblock>
        <button class="layui-btn" onclick="x_admin_show('添加友链','${pageContext.request.contextPath}/admin/link_add_edit.html',600,400)"><i class="layui-icon"></i>添加</button>
        <span class="x-right" style="line-height:40px">共有数据：<span id="count"></span> 条</span>
    </xblock>
    <script type="text/html" id="bartool">
        <a title="编辑" lay-event="edit" href="javascript:;">
            <i class="layui-icon">&#xe642;</i>
        </a>
        <a title="删除" lay-event="del" href="javascript:;">
            <i class="layui-icon">&#xe640;</i>
        </a>
    </script>
    <script type="text/html" id="linkStatus">
        <input type="checkbox" name="linkStatus" value="{{d.id}}"
               lay-skin="switch" lay-text="YES|NO" lay-filter="linkStatus" {{ d.linkStatus == true ? 'checked' : '' }} />
    </script>
    <script type="text/html" id="showIndex">
        <input type="checkbox" name="showIndex" value="{{d.id}}"
               lay-skin="switch" lay-text="YES|NO" lay-filter="showIndex" {{ d.showIndex == true ? 'checked' : '' }} />
    </script>
    <table class="layui-hide" id="I_am_a_table" lay-filter="I_am_a_table"></table>
</div>
<script>
    layui.use(['table','util'], function(){
        var table = layui.table
            ,form = layui.form
            ,util = layui.util;

        table.render({
            elem: '#I_am_a_table'
            ,id: 'I_am_a_table'
            ,url:'${pageContext.request.contextPath}/admin/link/getLinks'
            ,method: 'post'
            ,cellMinWidth: 80
            ,cols: [[
                {field:'id', title:'ID'}
                ,{field:'linkName', title:'链接名称',width:200}
                ,{field:'linkUrl', title:'链接地址',width:200}
                ,{field:'linkOwnerNickname', title:'所有者',width:200}
                ,{field:'linkOwnerContact', title:'联系方式',width:200}
                ,{field:'linkDescription', title:'描述',width:200}
                ,{field:'linkCreateTime', title:'创建时间',width:180,templet:function(d){return util.toDateString(d.createTime, "yyyy-MM-dd HH:mm:ss");}}
                ,{field:'linkStatus', title:'状态',width:200,templet: '#linkStatus', unresize: true}
                ,{field:'showIndex', title:'首页显示',width:200,templet: '#showIndex', unresize: true}
                ,{field:'right', title: '操作', toolbar:"#bartool",align:"center"}
            ]]
            ,where: {
                'title': null
            }
            ,page: true
            ,request: {
                limitName: 'size' //每页数据量的参数名，默认：limit
            }
            ,response: {
                countName: 'total' //规定数据总数的字段名称，默认：count
                ,dataName: 'rows' //规定数据列表的字段名称，默认：data
            }
            ,done: function(res, curr, total) {
                $("#count").html(total);
            }
        });

        //监听开关操作
        form.on('switch(linkStatus)', function(obj){
            var linkId = this.value;
            var val = obj.elem.checked;
            var name = this.name;
            $.ajax({
                type: 'POST'
                ,url:"${pageContext.request.contextPath}/admin/link/editSwitch"
                ,data:{linkId:linkId,val:val,name:name}
                ,success:function (res) {
                    if(res.code == 200){
                        layer.tips('温馨提示：状态修改成功!', obj.othis);
                    }else {
                        layer.tips('温馨提示：状态修改失败!', obj.othis);
                    }
                }
            });
        });

        form.on('switch(showIndex)', function(obj){
            var linkId = this.value;
            var val = obj.elem.checked;
            var name = this.name;
            $.ajax({
                type: 'POST'
                ,url:"${pageContext.request.contextPath}/admin/link/editSwitch"
                ,data:{linkId:linkId,val:val,name:name}
                ,success:function (res) {
                    if(res.code == 200){
                        layer.tips('温馨提示：状态修改成功!', obj.othis);
                    }else {
                        layer.tips('温馨提示：状态修改失败!', obj.othis);
                    }
                }
            });
        });

        // 执行搜索，表格重载
        $('#reload').on('click', function () {
            // 搜索条件
            var title = $('#title').val();
            table.reload('I_am_a_table', {
                method: 'post'
                , where: {
                    'title': title
                }
                , page: {
                    curr: 1
                }
            });
        });
        //监听工具条
        table.on('tool(I_am_a_table)', function(obj){
            var data = obj.data;
            if(obj.event === 'del'){
                layer.confirm('要删除吗'+data.id, function(res){
                    $.ajax({
                        url: "${pageContext.request.contextPath}/admin/link/delLinkById",
                        type: "POST",
                        data:{"linkId":data.id},
                        dataType: "json",
                        success: function(res){

                            if(res.code == 200){
                                layer.alert('会员删除成功', {
                                    title: "消息提醒",
                                    btn: ['确定']
                                },function (index, item) {
                                    window.location.reload();
                                });
                            }else{
                                layer.msg("删除失败", {icon: 5});
                            }
                        }

                    });
                });
            }else if(obj.event === 'edit'){
                x_admin_show('编辑','${pageContext.request.contextPath}/admin/link/getLinkInfo?linkId='+data.id,600,400);
            }
        });
    });
</script>

</html>
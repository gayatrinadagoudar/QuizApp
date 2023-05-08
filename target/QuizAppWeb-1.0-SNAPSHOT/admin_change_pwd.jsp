<% if ((session.getAttribute("user_id") == null) && (session.getAttribute("role") != "A")) {
        response.sendRedirect("login.jsp");
    } else {%>
<!DOCTYPE html>

<html lang="en">
    <%@include file="head.jsp" %>
    <body>
        <%@include file="admin_top_nav.jsp" %>
        <div class="container-fluid mainContainer">
            <div class='alert alert-danger'><strong>Welcome Admin</strong> </div>
            <div class="row col-12 m-0">
        <div class="col-md-3 p-sm-1">
                    <%@include file="admin_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">
                    <h3 class="text-primary"><i class="fa fa-key"></i> Change Password </h3><hr>    
                    <div class="row" style="padding: 2%">
                        <% if (session.getAttribute("admin_pwd_msg") != null) {%>

                        <div class='alert alert-danger'><button type="button" class="pull-right" data-dismiss="alert"><i class="fa fa-close"></i></button><strong><%=session.getAttribute("admin_pwd_msg")%></strong> </div>
                                <% session.setAttribute("admin_pwd_msg", null);
                                        }%>
                        <div class="panel panel-primary">
                           
                            <div class="panel-body">
                                <form method="post" action="admin_change_pwd_act.jsp" autocomplete="off" role="form" >
                                    <div class="form-group">
                                        <label class="control-label text-primary" for="cpwd" >Current Password</label>
                                        <input type="password"  required name="cpwd" id="cpwd" class="form-control" placeholder="Current Password">
                                        <span class="text-primary" id="cpwd_msg"></span>
                                    </div>

                                    <div class="form-group">
                                        <label class="control-label text-primary" for="npwd" >New Password</label>
                                        <input type="password"  required name="npwd" id="npwd" class="form-control" placeholder="New Password">
                                        <span class="text-primary" id="npwd_msg"></span>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label text-primary" for="cnpwd" >Confirm New Password</label>
                                        <input type="password"  required name="cnpwd" id="cnpwd" class="form-control" placeholder="Confirm New Password">
                                        <span class="text-primary" id="cnpwd_msg"></span>
                                    </div>
                                    
                                    <div class="form-group text-center w-50">
                                        <input class="btn btn-success" type="submit" name="submit" value="Save">
                                    </div>
                                </form>
                            </div>

                        </div>                       
                    </div>
                </div>
            </div>

                        <!-- Footer -->
            <%@include file="footer.jsp" %>
        </div>


    </body>

</html>

<%}%>

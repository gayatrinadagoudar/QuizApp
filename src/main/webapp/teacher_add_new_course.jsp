<% if ((session.getAttribute("user_id") == null) && (session.getAttribute("role") != "T")) {
        response.sendRedirect("login.jsp");
    } else {%>
<!DOCTYPE html>

<html lang="en">
    <%@include file="head.jsp" %>
    <body>

        <%@include file="teacher_top_nav.jsp" %>
        <div class="container-fluid mainContainer">
            <div class='alert alert-danger'><strong>Welcome <%=session.getAttribute("teacher_name")%></strong> </div>
            <div class="row col-12 m-0">
        <div class="col-md-3 p-sm-1">
                    <%@include file="teacher_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">
                    <h3 class="text-primary"><i class="fa fa-plus-circle"></i> Add New Course </h3><hr>    
                    <div class="row col-md-12">
                        <div class="col-md-2"></div>
                        <div class="col-md-8">

                            <% if (session.getAttribute("teacher_ac_msg") != null) {%>

                            <div class='alert alert-danger'><button type="button" class="pull-right" data-dismiss="alert"><i class="fa fa-close"></i></button><strong><%=session.getAttribute("teacher_ac_msg")%></strong> </div>
                                    <% session.setAttribute("teacher_ac_msg", null);
                                }%>
                            <form role="form" action="teacher_add_new_course_act.jsp" method="post">
                                <div class="form-group">
                                    <label for="course_name" class="text-primary">Course Name</label>
                                    <input class="form-control" name="course_name" id="course_name" type="text" required>
                                </div>
                                <div class="form-group">
                                    <label for="passkey" class="text-primary">Enrollment Key</label>
                                    <input class="form-control" id="passkey" name="passkey" type="password" value="" required>
                                </div>


                                <input class="btn btn-primary pull-right" name="submit" type="submit" value="Add Course">
                            </form>
                        </div>
                        <div class="col-md-2"></div>
                    </div>

                </div>
            </div>

                        <!-- Footer -->
            <%@include file="footer.jsp" %>
        </div>

    </body>

</html>

<%}%>
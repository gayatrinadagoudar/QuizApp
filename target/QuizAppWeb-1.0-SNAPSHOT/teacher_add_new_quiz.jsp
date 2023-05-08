<% if ((session.getAttribute("user_id") == null) && (session.getAttribute("role") != "T")) {
        response.sendRedirect("login.jsp");
    } else {%>
<!DOCTYPE html>

<html lang="en">
    <%@include file="head.jsp" %>

    <body>
        <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*,java.util.*"%> 
        <%@include file="teacher_top_nav.jsp" %>
        <div class="container-fluid mainContainer">
            <div class='alert alert-danger'><strong>Welcome <%=session.getAttribute("teacher_name")%></strong> </div>
            <div class="row col-12 m-0">
        <div class="col-md-3 p-sm-1">
                    <%@include file="teacher_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">
                    <h3 class="text-primary"><i class="fa fa-plus-circle"></i> Add New Quiz </h3><hr> 
                    <div class="row col-md-12">
                        <div class="col-md-8 ">

                            <% if (session.getAttribute("teacher_aq_msg") != null) {%>
                            <div class='alert alert-danger'><button type="button" class="pull-right" data-dismiss="alert"><i class="fa fa-close"></i></button><strong><%=session.getAttribute("teacher_aq_msg")%></strong> </div>
                                    <% session.setAttribute("teacher_aq_msg", null);
                                        }%>
                            <form role="form" action="teacher_add_new_quiz_act.jsp" method="post">
                                <div class="form-group">
                                    <label for="quiz_name" class="text-primary">Quiz Name</label>
                                    <input class="form-control" name="quiz_name" id="quiz_name" type="text" required>
                                </div>
                                <div class="form-group">
                                    <label class="control-label text-primary"  for="course">Course</label>
                                    <select id="course" name="course" required class="form-control">
                                        <option value="" selected disabled>Select Course</option>

                                        <%
                                            try {
                                                Class.forName("com.mysql.jdbc.Driver");
                                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                                                int tid = Integer.parseInt(session.getAttribute("teacher_id").toString());
                                                Statement stmt = con.createStatement();
                                                String sql = "select * from course where teacher_id=" + tid;
                                                ResultSet rs = stmt.executeQuery(sql);
                                                while (rs.next()) {%>
                                        <option value="<%=rs.getInt("course_id")%>"><%=rs.getString("course_name")%></option>
                                        <% }
                                                // close the connection
                                                con.close();
                                            } catch (Exception e) {
                                                out.println(e);
                                            }
                                        %>
                                    </select>
                                    <span class="text-primary" id="course_msg"></span>
                                </div>
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <label for="stime" class="text-primary">Quiz Start Date Time</label>
                                        <input class="form-control" id="stime" name="stime" type="datetime-local" value="" required>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="etime" class="text-primary">Quiz End Date Time</label>
                                        <input class="form-control" id="etime" name="etime" type="datetime-local" value="" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <button type="button" class="form-control btn btn-primary" data-toggle="modal" data-target="#modalTable">Select Image Key</button>
                                </div>
                                <!--Start Modal -->
                                <div class="modal fade" id="modalTable">
                                    <div class="modal-dialog" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Select Image Key</h5>
                                            </div>
                                            <div class="modal-body">
                                                <table id="tab">
                                                    <thead>
                                                        <tr>
                                                            <th>&nbsp;</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            Blob b;
                                                            byte[] imgData = null;

                                                            String imgDataBase64 = "";
                                                            try {
                                                                Class.forName("com.mysql.jdbc.Driver");
                                                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                                                                Statement stmt = con.createStatement();
                                                                String sql = "select * from images order by image_id";
                                                                ResultSet rs = stmt.executeQuery(sql);
                                                                while (rs.next()) {
                                                                    b = rs.getBlob("image");
                                                                    imgData = b.getBytes(1, (int) b.length());
                                                                    imgDataBase64 = new String(Base64.getEncoder().encode(imgData));
                                                        %>


                                                        <tr class="col-sm-4">
                                                            <td>
                                                                <label class="form-check-label">
                                                                    <input type="radio" class="form-check-input" required name="optionsRadios" id="optionsRadios<%=rs.getInt("image_id")%>" value="<%=rs.getInt("image_id")%>">
                                                                    &nbsp;<%=rs.getInt("image_id")%>
                                                                    <img class="col-12" style="height: 100px;width: 100px" src="data:image/jpg;base64,<%=imgDataBase64%>" alt="<%=rs.getInt("image_id")%>">
                                                                </label>
                                                            </td>

                                                        </tr>
                                                        <%  }
                                                                con.close();
                                                            } catch (Exception e) {
                                                                out.println(e);
                                                            }
                                                        %>
                                                    </tbody>   
                                                </table>
                                                <script type="text/javascript">
                                                    $('#tab').DataTable({
                                                        "iDisplayLength": 9,
                                                        "bFilter": false,
                                                        "bLengthChange": false,
                                                        "ordering": false
                                                    });
                                                </script>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-primary" data-dismiss="modal"> OK </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--End Modal -->
                                <input class="btn btn-primary pull-right" name="submit" type="submit" value="Add Quiz">
                            </form>
                        </div>                                        
                        <div class="col-md-4">
                            <% if (session.getAttribute("teacher_up_msg") != null) {%>
                            <div class='alert alert-danger'><button type="button" class="pull-right" data-dismiss="alert"><i class="fa fa-close"></i></button><strong><%=session.getAttribute("teacher_up_msg")%></strong> </div>
                                    <% session.setAttribute("teacher_up_msg", null);
                                        }%>
                            <form role="form" action="uploadImage" method="post" enctype="multipart/form-data">
                                <legend class="text-center">Upload Image</legend>
                                <div class="form-group">
                                    <label for="upfile" class="text-primary">Browse File</label>

                                    <input class="form-control" accept="image/x-png,image/jpeg" name="upfile" id="upfile" type="file" required>
                                </div>
                                <div class="form-group">
                                    <input value="Upload" class="form-control btn btn-primary" type="submit" required>
                                </div>
                            </form>
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
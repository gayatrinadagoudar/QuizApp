<% if ((session.getAttribute("user_id") == null) && (session.getAttribute("role") != "S")) {
        response.sendRedirect("login.jsp");
    } else {
        int qid=Integer.parseInt(request.getParameter("qid").toString());
        String qname=request.getParameter("qname").toString();
        java.util.ArrayList<Integer> quizzes = (java.util.ArrayList<Integer>)(session.getAttribute("student_quizzes"));
        if(quizzes.contains(qid))
        {
            response.sendRedirect("student_quiz_dashboard.jsp?qid="+qid+"&qname="+qname);
        }        
%>
<html lang="en">
    <%@include file="head.jsp" %>
    <body>
        <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*,java.util.*"%> 

        <%@include file="student_top_nav.jsp" %>
        <div class="container-fluid mainContainer">
            <div class='alert alert-danger'><strong>Welcome <%=session.getAttribute("student_name")%></strong> </div>
            <div class="row col-12 m-0">
        <div class="col-md-3 p-sm-1">
                    <%@include file="student_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">
                    <h3 class="text-primary"><i class="fa fa-unlock-alt"></i> Self Enrollment (Quiz)</h3><hr>    
                    <div class="row col-md-12">
                        <div class="col-md-2"></div>
                        <div class="col-md-8">

                            <% if (session.getAttribute("student_eq_msg") != null) {%>

                            <div class='alert alert-danger'><button type="button" class="pull-right" data-dismiss="alert"><i class="fa fa-close"></i></button><strong><%=session.getAttribute("student_eq_msg")%></strong> </div>
                                    <% session.setAttribute("student_eq_msg", null);
                                }%>
                            <form role="form" action="student_enroll_quiz_act.jsp" method="post">
                                <input name="quiz_id" id="quiz_id" type="text" value="<%=request.getParameter("qid")%>" hidden="true">
                                
                                <div class="form-group">
                                    <label for="course_name" class="text-primary">Quiz Name</label>
                                    <input class="form-control" name="quiz_name" id="quiz_name" type="text" value="<%=request.getParameter("qname")%>" readonly>
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


                                <input class="btn btn-primary pull-right" name="submit" type="submit" value="Enrol me">
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
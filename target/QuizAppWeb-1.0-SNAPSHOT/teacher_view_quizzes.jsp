<% if ((session.getAttribute("user_id") == null) && (session.getAttribute("role") != "T")) {
        response.sendRedirect("login.jsp");
    } else {%>
<html lang="en">
    <%@include file="head.jsp" %>
    <body>
        <%@include file="teacher_top_nav.jsp" %>
        <div class="container-fluid mainContainer">
            <div class='alert alert-danger'><strong>Welcome <%=session.getAttribute("teacher_name")%></strong></div>
            <div class="row col-12 m-0">
                <div class="col-md-3 p-sm-1">
                    <%@include file="teacher_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">
                    <div class="row">
                        <div class="col-md-10">
                            <%
                                String cname = request.getParameter("cname");
                                if (cname == null || cname.trim().length() == 0) {%>
                            <h1>All Quizzes</h1>
                            <%} else {%>
                            <h1><a class="h2" href="teacher_view_courses.jsp"><i class="glyphicon glyphicon-chevron-left fa-sm"></i></a>&nbsp;Course: <%=cname%> Quizzes</h1>
                            <%}%>

                        </div>
                        <div class="col-md-2" >
                            <a class="btn btn-primary float-right" href="teacher_add_new_quiz.jsp">Add New Quiz</a>
                        </div>
                    </div>
                    <hr>
                    <div>

                        <table id='tab' class="display table text-center table-hover">
                            <thead>
                                <tr class="table-light">
                                    <th scope="col"> Quizzes </th>                                 
                                </tr>
                            </thead>
                            <tbody>
                                <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%> 
                                <%
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                                        int tid = Integer.parseInt(session.getAttribute("teacher_id").toString());
                                        Statement stmt = con.createStatement();
                                        String sql = "";
                                        int cid = 0;
                                        String tmp = request.getParameter("cid");
                                        if (tmp == null || tmp.trim().length() == 0) {
                                            sql = "select * from quiz where teacher_id=" + tid;
                                        } else {
                                            cid = Integer.parseInt(request.getParameter("cid"));
                                            sql = "select * from quiz where teacher_id=" + tid + " and course_id=" + cid;
                                        }
                                        ResultSet rs = stmt.executeQuery(sql);

                                        while (rs.next()) {%>
                                <tr class="table-light">
                                    <td>
                                        <a href="teacher_view_questions.jsp?qid=<%=rs.getInt("quiz_id")%>&qname=<%=rs.getString("quiz_name")%>" class="list-group-item list-group-item-action flex-column align-items-start">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h5 class="mb-1 text-left h4"><%=rs.getString("quiz_name")%><span class="pull-right h5"><%=rs.getString("quiz_marks")%>&nbsp;Marks</span></h5>

                                            </div>
                                        </a>
                                    </td>
                                </tr>
                                <% }
                                        // close the connection
                                        con.close();
                                    } catch (Exception e) {
                                        out.println(e);
                                    }
                                %>
                            </tbody>
                        </table>

                        <script type="text/javascript">
                            $('#tab').DataTable({
                                "iDisplayLength": 5,
                            });

                        </script>
                    </div>
                </div>
            </div>
            <!-- Footer -->
            <%@include file="footer.jsp" %>
        </div>


    </body>

</html>

<%}%>
<% if ((session.getAttribute("user_id") == null) && (session.getAttribute("role") != "S")) {
        response.sendRedirect("login.jsp");
    } else {%>
<html lang="en">
    <%@include file="head.jsp" %>
    <body>
        <%@include file="student_top_nav.jsp" %>
        <div class="container-fluid mainContainer">
            <div class='alert alert-danger'><strong>Welcome <%=session.getAttribute("student_name")%></strong></div>
            <div class="row col-12 m-0">
        <div class="col-md-3 p-sm-1">
                    <%@include file="student_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">

                    <h3 class="text-primary"><i class="fa fa-book-open"></i> My Enrolled Quizzes </h3><hr>
                    <div class="row"> 
                        <table id='tab' class="display table text-center table-hover">
                            <thead>
                                <tr class="table-light">
                                    <th scope="col">Enrolled Quizzes </th>                                 
                                </tr>
                            </thead>
                            <tbody>
                                <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%> 
                                <%
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                                        java.util.ArrayList<Integer> quizzes = (java.util.ArrayList<Integer>) (session.getAttribute("student_quizzes"));
                                        if (!quizzes.isEmpty()){
                                            String query = "select * from quiz where quiz_id in";
                                            String param = "(";
                                            for (int i = 0; i < quizzes.size(); i++) {
                                                param += "?,";
                                            }
                                            param = param.substring(0, param.length() - 1);
                                            param += ")";
                                            query += param;
                                            PreparedStatement pstmt = con.prepareStatement(query);
                                            for (int i = 0; i < quizzes.size(); i++) {
                                                pstmt.setInt(i + 1, quizzes.get(i));
                                            }
                                            ResultSet rs = pstmt.executeQuery();
                                            while (rs.next()) {

                                %>
                                <tr class="table-light">
                                    <td>
                                        <a href="student_quiz_dashboard.jsp?qid=<%=rs.getInt("quiz_id")%>&qname=<%=rs.getString("quiz_name")%>" class="list-group-item list-group-item-action flex-column align-items-start">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h5 class="mb-1 text-left h4"><%=rs.getString("quiz_name")%><span class="pull-right h5"><%=rs.getString("quiz_marks")%>&nbsp;Marks</span></h5>
                                            </div>
                                        </a>
                                    </td>
                                </tr>
                                <% }
                                        }

                                        // close the connection
                                        con.close();
                                    } catch (Exception e) {
                                        out.println(e);
                                    }
                                %>
                            </tbody>
                        </table>

                        <script type="text/javascript">
                            $('#tab').DataTable();
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
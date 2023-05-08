<%@page import="java.util.Base64"%>
<% if ((session.getAttribute("user_id") == null) && (session.getAttribute("role") != "T")) {
        response.sendRedirect("login.jsp");
    } else {%>
<html lang="en">
    <%@include file="head.jsp" %>
    <body>
        <%@include file="teacher_top_nav.jsp" %>
        <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%> 
        <div class="container-fluid mainContainer">
            <div class='alert alert-danger'><strong>Welcome <%=session.getAttribute("teacher_name")%></strong></div>
            <div class="row col-12 m-0">
        <div class="col-md-3 p-sm-1">
                    <%@include file="teacher_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">
                    <%
                        int qid = Integer.parseInt(request.getParameter("qid").toString());
                        String qname = request.getParameter("qname");
                        String quizStartDateTime=null, quizEndDateTime=null, quizCourseName=null;
                        int quizImageKeyId=0, quizCourseId=0;
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                            Statement stmt1 = conn.createStatement();
                            String sql1 = "select * from quiz join course on quiz.course_id=course.course_id where quiz.quiz_id=" + qid;
                            ResultSet rs1 = stmt1.executeQuery(sql1);
                            if (rs1.next()) {
                                quizStartDateTime=rs1.getString("quiz_start_time");
                                quizEndDateTime=rs1.getString("quiz_end_time");
                                quizImageKeyId=rs1.getInt("image_id");
                                quizCourseId=rs1.getInt("course_id");
                                quizCourseName=rs1.getString("course_name");
                    %>
                    <h3 class="text-primary"><a class="h2" href="teacher_view_questions.jsp?qid=<%=qid%>&qname=<%=qname%>"><i class="glyphicon glyphicon-chevron-left fa-sm"></i></a>&nbsp;<i class="fa fa-info-circle"></i> Quiz Results </h3><hr>    

                    <h3>Quiz Name: <%=request.getParameter("qname")%></h3>                         
                    <h4>Quiz Start Time: <%= rs1.getString("quiz_start_time")%></h4>
                    <h4>Quiz End Time: <%= rs1.getString("quiz_end_time")%></h4>
                    <div class="row">
                        <div class="form-group col-md-12">
                            <h4 class="pull-right">Total Marks: <%= rs1.getInt("quiz_marks")%></h4>
                        </div>
                    </div>
                    <% }
                            conn.close();
                        } catch (Exception e) {
                            out.println(e);
                        }
                    %>
                    <table id='tab' class="display table text-center table-hover">
                            <thead>
                                <tr class="table-default">
                                    <th scope="col"> Sr.No </th>
                                    <th scope="col">Student ID</th>
                                    <th scope="col">Student Name</th>
                                    <th scope="col">Obtained marks</th>
                                    <th scope="col">View Answersheet</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");

                                        Statement stmt = con.createStatement();
                                        String sql = "select r.student_id , s.student_name , r.score  from (select  q.student_id , sum(q.question_score) as score from questions_result q where q.student_id in ( select e.student_id from enrollment_quiz e where e.quiz_id = "+qid+" ) and q.quiz_id = "+qid+" group by q.student_id ) r join Student s where s.student_id = r.student_id";
                                        ResultSet rs = stmt.executeQuery(sql);
                                        int i = 1;
                                        while (rs.next()) {%>
                                <tr class="table-default t1">
                                    <td scope="row"> <%=i++%></td>
                                    <td><%=rs.getInt("student_id")%></td>
                                    <td><%=rs.getString("student_name")%></td>
                                    <td><%=rs.getInt("score")%></td>
                                    <td><a href="teacher_view_answersheet.jsp?qid=<%=qid%>&sid=<%=rs.getInt("student_id")%>" class="btn btn-primary"> View </a></td>
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
                            dom: 'Bfrtip',
                            buttons: [{
                                extend: 'pdf',
                                text: '<i class="fa fa-file-pdf-o"></i> PDF',
                                className: 'btn btn-default',
                                title: 'Quiz Results',
                                exportOptions: {
                                    columns: 'th:not(:last-child)'
                                },
                                customize: function(doc) {
    doc.content[1].table.widths =Array(doc.content[1].table.body[0].length + 1).join('*').split('');
    doc.defaultStyle.alignment = 'center';
    doc.styles.tableHeader.alignment = 'center';
}
            
                            }]
                        });
                    </script>
                </div>

            </div>

                        <!-- Footer -->
            <%@include file="footer.jsp" %>
        </div>


    </body>

</html>

<%}%>
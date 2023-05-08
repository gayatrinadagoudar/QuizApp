<% if((session.getAttribute("user_id") == null) && (session.getAttribute("role") != "T"))
{
   response.sendRedirect("login.jsp");
}
else
{%>
<!DOCTYPE html>

<html lang="en">
    <%@include file="head.jsp" %>
    <body>
        <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%> 
        <%
            String n_courses="",n_students="", n_quizzes="";
            int tid = Integer.parseInt(session.getAttribute("teacher_id").toString());

            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                Statement stmt = con.createStatement();
                String sql1 = "select count(quiz_id) from quiz where teacher_id="+tid;
                String sql2 = "select count(distinct(e.student_id)) from enrollment_course e where e.course_id in ( select c.course_id from course c where teacher_id =" + tid + ")";
                String sql3 = "select count(course_id) from course where teacher_id="+tid;

                ResultSet rs1 = stmt.executeQuery(sql1);
                if(rs1.next())
                {
                    n_quizzes=rs1.getString(1);
                }
                rs1.close();
                ResultSet rs2 = stmt.executeQuery(sql2);
                if(rs2.next())
                {
                    n_students=rs2.getString(1);
                }
                rs2.close();
                ResultSet rs3 = stmt.executeQuery(sql3);
                if(rs3.next())
                {
                    n_courses=rs3.getString(1);
                }
                rs3.close();
                       con.close();
            } catch (Exception e) {
                out.println(e.getMessage());
            }
        %>
        <%@include file="teacher_top_nav.jsp" %>
        <div class="container-fluid mainContainer">
             <div class='alert alert-danger'><strong>Welcome <%=session.getAttribute("teacher_name")%></strong> </div>
           <div class="row col-12 m-0">
        <div class="col-md-3 p-sm-1">
                    <%@include file="teacher_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h4><i class="fa fa-fw fa-users"></i> Total Enrolled Students</h4>
                                </div>
                                <div class="panel-body text-center text-primary">
                                    <h1><%=n_students%></h1>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h4><i class="fa fa-fw fa-book"></i> Total Courses</h4>
                                </div>
                               <div class="panel-body text-center text-primary">
                                    <h1><%=n_courses%></h1>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h4><i class="fa fa-fw fa-bars"></i> Total Quizzes</h4>
                                </div>
                                <div class="panel-body text-center text-primary">
                                    <h1><%=n_quizzes%></h1>
                                </div>
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
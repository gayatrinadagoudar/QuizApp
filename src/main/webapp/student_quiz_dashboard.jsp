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
                    <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%> 
                    <%
                        int sid = Integer.parseInt(session.getAttribute("student_id").toString());
                        int qid = Integer.parseInt(request.getParameter("qid").toString());
                        String qname = request.getParameter("qname");
                        String quizStartDateTime=null, quizEndDateTime=null, quizCourseName=null;
                        int quizImageKeyId=0, quizCourseId=0, quizTotalMarks=0, quizObtainedMarks=0;
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
                                quizTotalMarks=rs1.getInt("quiz_marks");
                            }
                            rs1.close();
                            sql1 = "select sum(question_score) as obtainedScore from questions_result where student_id = "+ sid +" and quiz_id =" + qid;
                            ResultSet rs2 = stmt1.executeQuery(sql1);
                            if (rs2.next()) {
                                quizObtainedMarks=rs2.getInt("obtainedScore");
                            }
                            rs2.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println(e);
                        }
                    %>
                    <h3>Quiz Name: <%=request.getParameter("qname")%></h3>                         
                    <h4>Quiz Start Time: <%=quizStartDateTime%></h4>
                    <h4>Quiz End Time: <%=quizEndDateTime%></h4>
                    <div class="row">
                        <div class="form-group col-md-12">
                            <h4 class="pull-right">Obtained Marks: <%=quizObtainedMarks%> / <%=quizTotalMarks%></h4>
                        </div>
                    </div>
                    <hr>
                    <h2> Exam Instructions </h2>
                    <% 
                        Connection con;
                        Statement stmt;
                        ResultSet rs;
                        int attemptedQuestionsCount=0;
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                            stmt = con.createStatement();
                            String sql = "select count(question_score) from questions_result where student_id ="+ sid +" and quiz_id = "+ qid;
                            rs= stmt.executeQuery(sql);
                            if (rs.next()) {
                                attemptedQuestionsCount=rs.getInt(1);
                            }
                            rs.close(); 
                        }
                        catch (Exception e) { out.println(e.getMessage().toString());}
                    %>
                    <div id="ResDiv" class="mb-3" >
                    <% if (attemptedQuestionsCount>0) { %>
                        <a href="student_review_answersheet.jsp?qid=<%=qid%>&qname=<%=qname%>" class="btn btn-primary"> Review Answersheet </a>
                    <% } else { %>
                        <h3>The Quiz is Yet to start. </h3> 
                        <p> or </p>
                        <h3>You have missed this Quiz. </h3>  
                    <% } %>
                    </div>         

                    <div id="showstarter" class="mb-3">
                        <p class="text-primary"> The quiz will start at sharp <%=quizStartDateTime%> and will end at sharp <%=quizEndDateTime%> </p>
                        
                        <a href="student_quiz_panel.jsp?qid=<%=qid%>&qname=<%=qname%>" class="btn btn-primary"> Start Attempt </a>
                            
                    </div>      
                </div>
            </div>

                        <!-- Footer -->
            <%@include file="footer.jsp" %>
        </div>
        <script type='text/javascript' >

        $(document).ready(function() {
            var st_dt = Date.parse( '<%=quizStartDateTime%>') ;
            var ed_dt = Date.parse( '<%=quizEndDateTime%>') ;
            var now =  Date.now() ;
            if (  (st_dt < now) && ( now <  (st_dt + 900000))  ){
                $('#ResDiv').hide();
            }
            else{
                $('#showstarter').hide();
            }        
        });
        </script>
    </body>

</html>

<%}%>
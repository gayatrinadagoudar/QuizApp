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
                    <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*" %>
                    <% int sid=Integer.parseInt(request.getParameter("sid").toString());
                        int qid=Integer.parseInt(request.getParameter("qid").toString());
                        String quizStartDateTime=null, quizEndDateTime=null, quizCourseName=null, quizName=null, studentName=null; 
                        int quizImageKeyId=0, quizCourseId=0, quizTotalMarks=0, quizObtainedMarks=0;
                        try {
                            Class.forName("com.mysql.jdbc.Driver"); 
                            Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root" , "" ); 
                            Statement stmt1=conn.createStatement(); 
                            String sql1="select * from quiz join course on quiz.course_id=course.course_id where quiz.quiz_id=" + qid;
                            ResultSet rs1=stmt1.executeQuery(sql1); 
                            if (rs1.next()) {
                                quizName=rs1.getString("quiz_name"); 
                                quizStartDateTime=rs1.getString("quiz_start_time"); 
                                quizEndDateTime=rs1.getString("quiz_end_time");
                                quizImageKeyId=rs1.getInt("image_id"); 
                                quizCourseId=rs1.getInt("course_id");
                                quizCourseName=rs1.getString("course_name"); 
                                quizTotalMarks=rs1.getInt("quiz_marks"); 
                            }
                            rs1.close();
                            String sql2 = "select sum(question_score) as score from questions_result where student_id ="+ sid +" and quiz_id = "+ qid;
                            ResultSet rs2= stmt1.executeQuery(sql2);
                            if (rs2.next()) {
                                quizObtainedMarks=rs2.getInt("score");
                            }
                            rs2.close(); 
                            String sql3 = "select student_name from student where student_id ="+ sid;
                            ResultSet rs3= stmt1.executeQuery(sql3);
                            if (rs3.next()) {
                                studentName=rs3.getString("student_name"); 
                            }
                            rs3.close();
                            conn.close(); 
                        } catch (Exception e) { 
                            out.println(e); 
                        } %>
                        <h3 class="text-primary"><a class="h2" href="teacher_view_results.jsp?qid=<%=qid%>&qname=<%=quizName%>"><i class="glyphicon glyphicon-chevron-left fa-sm"></i></a>&nbsp;<i class="glyphicon glyphicon-list-alt"></i> View Student Answersheet </h3><hr>    
                        <div class="p-sm-5">
                            <h2> Quiz Name :  <%=quizName%> </h2>
                            <div class="row">
                            <div class="col-sm-6">
                                <h5> Quiz Started : <%=quizStartDateTime%>  ( Date Time ) </h5>
                                <h5> Quiz Ended : <%=quizEndDateTime%>  ( Date Time )</h5>
                            </div>
                            <div class="col-sm-6">
                                <div class="pull-right">
                                <h4 class=""> Student ID : <%=sid%> </h4>
                                <h4> Student Name : <%=studentName%> </h4>
                                <h4> Quiz Score : <%=quizObtainedMarks%> / <%=quizTotalMarks%>  </h4>
                                </div>
                            </div>
                            </div>
                            <hr>
                            <div id="wrap">
                                <%
                                    int i=0;
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                                        Statement stmt = con.createStatement();
                                        String sql = "select * from question where quiz_id=" + qid;
                                        ResultSet rs = stmt.executeQuery(sql);

                                        while (rs.next()) {%>
                                        <div id="quest<%=i+1%>">
                                            <div class="panel panel-default mb-3">
                                                <div class="panel-body">
                                                    <%
                                                    int student_question_score=0, student_answer=0;
                                                    Statement stmt3 = con.createStatement();
                                                    String sql3 = "select qr.question_score, sa.answer from questions_result qr, student_answer sa where qr.student_answer_id=sa.student_answer_id and qr.question_id =" + rs.getInt("question_id");
                                                    ResultSet rs3= stmt3.executeQuery(sql3);
                                                    if (rs3.next()) {
                                                        student_question_score=rs3.getInt("question_score");
                                                        student_answer=rs3.getInt("answer");
                                                    }
                                                    rs3.close();
                                                    %>
                                                    <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-success"> Marks : <%=rs.getInt("question_marks")%></button>
                                                        </div>
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-light"> Obtained Marks : <%=student_question_score%></button>
                                                        </div>
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-danger">Neg Marks : <%=rs.getInt("question_neg_marks")%></button>
                                                        </div>
                                                    </div>

                                                    <hr>
                                                        <h4 class="card-title"> Q.<%=i+1%>. <%=rs.getString("question_text")%> </h4>
                                                        <%
                                                        Statement stmt1 = con.createStatement();
                                                        String sql1 = "select * from option where question_id=" + rs.getInt("question_id");
                                                        ResultSet rs1 = stmt1.executeQuery(sql1);

                                                        while (rs1.next()) {%>

                                                        <div class="form-check d-flex">
                                                            <label class="form-check-label">
                                                                <input type="radio" disabled class="form-check-input" name="answer<%=rs.getInt("question_id")%>"
                                                                    id="radioOptions[]" value="<%=rs1.getInt("option_id")%>">
                                                                <%=rs1.getString("option")%>
                                                            </label>
                                                        </div>

                                                        <%  } %>
                                                        <script>$('input:radio[name="answer<%=rs.getInt("question_id")%>"][value="<%=student_answer%>"]').attr('checked',true);
                                                        $('input:radio[name="answer<%=rs.getInt("question_id")%>"][value="<%=student_answer%>"]').attr('disabled',false);</script>
                                                    <hr>
                                                    <%
                                                    String correct_answer=null;
                                                    Statement stmt2 = con.createStatement();
                                                    String sql2 = "select answer from answer where question_id =" + rs.getInt("question_id");
                                                    ResultSet rs2= stmt2.executeQuery(sql2);
                                                    if (rs2.next()) {
                                                        correct_answer=rs2.getString("answer");
                                                    }
                                                    rs2.close();
                                                    %>
                                                    <h5 class="form-label"> Correct Answer: <b><%=correct_answer%></b></h5>
                                                </div>

                                            </div>
                                        </div>
                                        <%  
                                            i++; }
                                        con.close();
                                        } catch (Exception e) {
                                            out.println(e);
                                        }
                                    %>                                
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
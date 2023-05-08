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
                    <h3 class="text-primary"><a class="h2" href="teacher_view_quizzes.jsp?cid=<%=quizCourseId%>&cname=<%=quizCourseName%>"><i class="glyphicon glyphicon-chevron-left fa-sm"></i></a>&nbsp;<i class="fa fa-info-circle"></i> Quiz Details </h3><hr>    

                    <h3>Quiz Name: <%=request.getParameter("qname")%></h3>                         
                    <h4>Quiz Start Time: <%= rs1.getString("quiz_start_time")%></h4>
                    <h4>Quiz End Time: <%= rs1.getString("quiz_end_time")%></h4>
                    <div class="row">

                        <div class="form-group col-md-6">
                            <button type="button" class="btn btn-info" data-toggle="modal" data-target="#modalEditQuiz">Edit Quiz Details</button>

                            <button type="button" id="addQuestionBtn" class="btn btn-info" data-toggle="modal" data-target="#modalAddQuestion">Add New Question</button>
                            <a class="btn btn-warning float-right" id="viewResultsBtn" href="teacher_view_results.jsp?qid=<%=qid%>&qname=<%=qname%>">View Results</a>
                        </div>
                        <div class="form-group col-md-6">
                            <h4 class="pull-right">Total Marks: <%= rs1.getInt("quiz_marks")%></h4>
                        </div>
                    </div>
                    <% }
                            conn.close();
                        } catch (Exception e) {
                            out.println(e);
                        }
                    %>
                    <% if (session.getAttribute("teacher_vq_msg") != null) {%>
                    <div class='alert alert-danger'><button type="button" class="pull-right" data-dismiss="alert"><i class="fa fa-close"></i></button><strong><%=session.getAttribute("teacher_vq_msg")%></strong> </div>
                    <% session.setAttribute("teacher_vq_msg", null);}%>
                    <div class="modal" id="modalEditQuiz">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Edit Quiz Details</h5>
                                </div>
                                <div class="modal-body">  
                                    <form role="form" action="teacher_edit_quiz_act.jsp" method="post">
                                        <input type="text" hidden name="quiz_id" value="<%=qid%>">
                                        <div class="form-group">
                                            <label for="quiz_name" class="text-primary">Quiz Name</label>
                                            <input class="form-control" name="quiz_name" id="quiz_name" type="text" value="<%=request.getParameter("qname")%>" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label text-primary" for="course">Course</label>
                                            <select id="course" name="course" required class="form-control">
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
                                                <input class="form-control" id="stime" name="stime" type="datetime-local" value="<%=quizStartDateTime%>" required>
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label for="etime" class="text-primary">Quiz End Date Time</label>
                                                <input class="form-control" id="etime" name="etime" type="datetime-local" value="<%=quizEndDateTime%>" required>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <button type="button" class="form-control btn btn-primary" data-toggle="modal" data-target="#modalTable">Change Image Key</button>
                                        </div>
                                        <!--Start Modal -->
                                        <div class="modal fade" id="modalTable">
                                            <div class="modal-dialog" role="document">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Select Image Key</h5>
                                                    </div>
                                                    <div class="modal-body">
                                                        <table id="tab1">
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
                                                            $('#tab1').DataTable({
                                                                "iDisplayLength": 9,
                                                                "bFilter": false,
                                                                "bLengthChange": false,
                                                                "ordering": false
                                                            });
                                                        </script>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-primary" onclick="$('#modalTable').modal('hide');$('#modalEditQuiz').modal('show');"> OK </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!--End Modal -->
                                        <script type="text/javascript">
                                            $('#course').val(<%=quizCourseId%>).attr('selected', 'selected');
                                            $('#optionsRadios<%=quizImageKeyId%>').attr('checked', 'checked');
                                        </script>
                                </div>
                                <div class="modal-footer">
                                    <input class="btn btn-primary pull-right" name="submit" type="submit" value="Update Quiz">
                                </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="modal" id="modalAddQuestion">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form role="form" action="teacher_add_question_act.jsp" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Add New Question</h5>
                                        <%-- <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true"></span>
                                        </button> --%>
                                    </div>
                                    <div class="modal-body">  
                                        <input type="text" hidden name="quiz_id" value="<%=qid%>">
                                        <input type="text" hidden name="course_id" value="<%=quizCourseId%>">
                                        <input type="text" hidden name="quiz_name" value="<%=qname%>">
                                        <div class="form-group">
                                            <label for="question_text" class="text-primary">Enter Question</label>
                                            <textarea rows="4" class="form-control" name="question_text" id="question_text" type="text" required></textarea>
                                            <small class="form-text text-muted">Enter the question text only for now, you can add options at edit question.</small>
                                        </div>
                                        <div class="row">
                                            <div class="form-group col-md-6">
                                                <label for="marks" class="text-primary">Marks</label>
                                                <input class="form-control" id="marks" name="marks" type="number" value="1" min="1" onKeyDown="return false" required>
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label for="neg_marks" class="text-primary">Negative Marks</label>
                                                <input class="form-control" id="neg_marks" name="neg_marks" type="number" value="0" max="0" onKeyDown="return false" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <input class="btn btn-primary pull-right" name="submit" type="submit" value="Add Question">
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <table id='tab' class="display table text-center table-hover">
                        <thead>
                            <tr class="table-light">
                                <th scope="col"> Questions </th>                                 
                            </tr>
                        </thead>
                        <tbody>
                                <%
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                                        Statement stmt = con.createStatement();
                                        String sql = "select * from question where quiz_id=" + qid;
                                        ResultSet rs = stmt.executeQuery(sql);

                                        while (rs.next()) {%>
                                <tr class="table-light">
                                    <td>
                                        <div style="padding-bottom: 20px;" class="list-group-item list-group-item-action flex-column align-items-start">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h5 class="mb-1 text-left h4"><%=rs.getString("question_text")%><div class="pull-right"><small class="text-muted">Marks:&nbsp;<%=rs.getInt("question_marks")%></small></div></h5>
                                            </div>
                                            <div class="d-flex w-100 justify-content-between">
                                                <div class="mb-1 text-left">
                                                    <small class="text-muted">Negative Marks:&nbsp;<%=rs.getInt("question_neg_marks")%></small>
                                                    <a class="btn btn-primary btn-sm pull-right editQuestionBtn" href="teacher_edit_question.jsp?id=<%=rs.getInt("question_id")%>&cid=<%=quizCourseId%>&qid=<%=qid%>&qname=<%=qname%>">Edit Question</a>
                                                </div>
                                            </div>
                                        </div>
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
                            "iDisplayLength": 10,
                            "bFilter": false,
                            "bLengthChange": false,
                            "ordering": false
                        });
                    </script>
                    <script type='text/javascript' >

                    $(document).ready(function() {
                        var st_dt = Date.parse( '<%=quizStartDateTime%>') ;
                        var ed_dt = Date.parse( '<%=quizEndDateTime%>') ;
                        var now =  Date.now() ;
                        if (  (now > st_dt)  ){
                            $('#addQuestionBtn').attr('disabled', 'disabled');
                            $('.editQuestionBtn').addClass('disabled');
                        }
                        else {
                            $('#addQuestionBtn').removeAttr('disabled');
                            $('.editQuestionBtn').removeClass('disabled');
                        }
                        if ( (now < ed_dt) ){
                            $('#viewResultsBtn').addClass('disabled');
                        }
                        else {
                            $('#viewResultsBtn').removeClass('disabled');
                        }

                        $('a').click(function() {
                            if ($(this).hasClass('disabled')) {
                                return false;
                            }
                        });
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
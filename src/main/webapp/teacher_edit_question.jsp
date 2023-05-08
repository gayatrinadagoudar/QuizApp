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
                    <h3 class="text-primary"><i class="fa fa-edit"></i> Edit Question </h3><hr> 
                    <div class="row col-md-12">
                            <% 
                            int queid = Integer.parseInt(request.getParameter("id").toString());
                            int qid = Integer.parseInt(request.getParameter("qid").toString());
                            int cid = Integer.parseInt(request.getParameter("cid").toString());
                            String qname = request.getParameter("qname");
                            if (session.getAttribute("teacher_eq_msg") != null) {%>
                            <div class='alert alert-danger'><button type="button" class="pull-right" data-dismiss="alert"><i class="fa fa-close"></i></button><strong><%=session.getAttribute("teacher_eq_msg")%></strong> </div>
                                    <% session.setAttribute("teacher_eq_msg", null);
                                        }%>
                            <form class="col-xs-push-2 col-xs-8" role="form" action="teacher_edit_question_act.jsp?id=<%=queid%>&cid=<%=cid%>&qid=<%=qid%>&qname=<%=qname%>" method="post">
                                    <%
                                                String questionText=null, answer=null;
                                                int marks=0, negMarks=0;
                                                java.util.ArrayList<String> options = new ArrayList<>();
                                            try {
                                                Class.forName("com.mysql.jdbc.Driver");
                                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                                                Statement stmt = con.createStatement();
                                                String sql = "select * from question where question_id=" + queid;
                                                ResultSet rs = stmt.executeQuery(sql);
                                                while (rs.next()) {
                                                    questionText=rs.getString("question_text");
                                                    marks=rs.getInt("question_marks");
                                                    negMarks=rs.getInt("question_neg_marks");
                                                }
                                                rs.close();
                                                sql = "select * from option where question_id=" + queid;
                                                ResultSet rs1 = stmt.executeQuery(sql);
                                                while (rs1.next()) {
                                                    options.add(rs1.getString("option"));
                                                }
                                                rs1.close();
                                                sql = "select * from answer where question_id=" + queid;
                                                ResultSet rs2 = stmt.executeQuery(sql);
                                                while (rs2.next()) {
                                                    answer=rs2.getString("answer");
                                                }
                                                rs2.close();
                                                con.close();
                                            } catch (Exception e) {
                                                out.println(e);
                                            }
                                        %>
                                        <div class="form-group">
                                            <label for="question_text" class="text-primary">Question</label>
                                            <textarea rows="4" readonly class="form-control" name="question_text" id="question_text" type="text" required><%=questionText%></textarea>
                                        </div>
                                        <div class="row">
                                            <div class="form-group col-md-6">
                                                <label for="marks" class="text-primary">Marks</label>
                                                <input class="form-control" readonly id="marks" name="marks" type="number" value="<%=marks%>" min="1" onKeyDown="return false" required>
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label for="neg_marks" class="text-primary">Negative Marks</label>
                                                <input class="form-control" readonly id="neg_marks" name="neg_marks" type="number" value="<%=negMarks%>" max="0" onKeyDown="return false" required>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="optionText" class="text-primary">Add Options</label>
                                            <div id="optionsSection">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="text" class="form-control optionText" id="optionText" name="optionText[]" rows="1" placeholder="Enter Option"> 
                                                        <span class="input-group-btn">
                                                            <button class="btn btn-primary w-100" id="addOption"><i class="fa fa-plus"></i></button>
                                                        </span>
                                                    </div>
                                                </div>            
                                        
                                                <fieldset class="form-group">
                                                    <label class="form-label">Select Answer</label>
                                                    <ul class="list-group" id="answer">
                                                    <% for (String option : options) {%>
                                                    <div class="list-group-item form-check d-flex">
                                                        <label class="form-check-label" style="width: 90%">
                                                            <%if(option.equals(answer)){%>
                                                            <input type="radio" required class="form-check-input" name="radioOptions" id="radioOptions" value="<%=option%>" checked>
                                                            <%}else{%>
                                                            <input type="radio" required class="form-check-input" name="radioOptions" id="radioOptions" value="<%=option%>">
                                                            <%}%>
                                                            <%=option%>
                                                        </label>
                                                        <input type="hidden" name="options" id="options" value="<%=option%>" >
                                                    <a href="#" class="delete btn btn-primary btn-sm pull-right"> <i class="glyphicon glyphicon-trash"></i> </a>  
                                                    </div>
                                                    <%}%>                                                    
                                                    </ul>
                                                </fieldset>
                                            </div>
                                        </div>
                                <div class="row">
                                    <div class="col-md-2">
                                        <a class="btn btn-warning" onclick="deleteQuest('<%=queid%>', '<%=qid%>', '<%=marks%>', '<%=qname%>')" type="button"> Delete </a>
                                    </div>
                                    <div class="col-md-3"></div>
                                    <div class="col-md-2 text-center">
                                        <input class="btn btn-primary" type="submit" value="Update" >
                                    </div>
                                    <div class="col-md-3"></div>
                                    <div class="col-md-2">
                                        <a class="btn btn-danger pull-right" href="teacher_view_questions.jsp?qid=<%=qid%>&qname=<%=qname%>" type="button"> Cancel </a>
                                    </div>
                                </div>
                            </form>
                    </div>

                </div>
            </div>

                        <!-- Footer -->
            <%@include file="footer.jsp" %>
        </div>
<script type='text/javascript' >
   
    $(document).ready(function() {

    var max_fields = 10;
    var wrapper = $("#optionsSection");
    var ans =  $("#answer");
    var x = 1;
    
    $("#addOption").click(function(e) {
        e.preventDefault(); 
        if(x < max_fields){
            opt_text =  $.trim( $(".optionText").val() ) ; 
            if( opt_text  != '' ){                
                $(".optionText").val('') ;
                    $(ans).append(`<div class="list-group-item form-check d-flex">
                            <label class="form-check-label" style="width: 90%">
                            <input type="radio" required class="form-check-input" name="radioOptions" id="radioOptions" value="`+ opt_text +`">
                            `+ opt_text +` 
                            </label>
                            <input type="hidden" name="options" id="options" value="`+opt_text+`" >

                            <a href="#" class="delete btn btn-primary btn-sm pull-right"> <i class="glyphicon glyphicon-trash"></i> </a>  
                        </div>`);
                        x++;                      
            }else {
                alert('Enter Some text before clicking button.')
            }   
        }else{
            alert('You Reached the limit of Adding Options')
        }
    });

    $(wrapper).on("click", ".delete", function(e) {
        e.preventDefault();
        prev_ip = $(this).prevAll('p').html();
        console.log( 'remove' , prev_ip ) 
        $(this).parent('div').remove();
        x--;
    });
});

</script> 

<script type='text/javascript'>

    function deleteQuest( queid, qid, marks, qname ){        
        alert(queid, qid, marks);
        var r = confirm("Are You sure, you want to Delete this Question, \nEvery data related to this Question will be deleted. \n Options \n Results");
        if (r == true) {
            url = 'teacher_delete_question.jsp?queid='+ queid + '&qid='+ qid + '&marks='+marks+ '&qname='+qname ;   
            window.location = url ;
        }   
    }

   
</script>

    </body>

</html>

<%}%>
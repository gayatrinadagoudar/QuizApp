<!DOCTYPE html>

<html lang="en">
    <%@include file="head.jsp" %>
    <body>
        <%@include file="student_top_nav.jsp" %>
        <div class="container-fluid mainContainer">
             <div class='alert alert-danger'><strong>Welcome <%=session.getAttribute("student_name")%></strong> </div>
             <div class="row col-12 m-0">
        <div class="col-md-3 p-sm-1">
                    <%@include file="student_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">
                    <%  java.util.ArrayList<Integer> courses = (java.util.ArrayList<Integer>)(session.getAttribute("student_courses"));
                        java.util.ArrayList<Integer> quizzes = (java.util.ArrayList<Integer>)(session.getAttribute("student_quizzes")); %>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h4><i class="fa fa-fw fa-book"></i> Total Enrolled Courses</h4>
                                </div>
                                <div class="panel-body text-center text-primary">
                                    <h1><%=courses.size()%></h1>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h4><i class="fa fa-fw fa-bars"></i> Total Enrolled Quizzes</h4>
                                </div>
                               <div class="panel-body text-center text-primary">
                                    <h1><%=quizzes.size()%></h1>
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


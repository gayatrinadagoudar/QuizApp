<% if ((session.getAttribute("user_id")==null) && (session.getAttribute("role") !="S" )) {
    response.sendRedirect("login.jsp"); } else {%>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <title>Quiz App | Quiz Panel</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/x-icon" href="images/logo.png">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.15.1/moment.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script
            src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js"
            integrity="sha512-GDey37RZAxFkpFeJorEUwNoIbkTwsyC736KNSYucu1WJWFK9qTdzYub8ATxktr6Dwke7nbFaioypzbDOQykoRg=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

        <link rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css"
            integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">

        <script type="text/javascript">
            $(window).on('load', function () {
                $('#myModal').modal({ backdrop: 'static', keyboard: false });
                $('#myModal').modal('show');
                $('#wrap').hide();
            });
        </script>

        <style>
            #content:fullscreen {
                overflow: scroll !important;
            }

            #content:-ms-fullscreen {
                overflow: scroll !important;
            }

            #content:-webkit-full-screen {
                overflow: scroll !important;
            }

            #content:-moz-full-screen {
                overflow: scroll !important;
            }
        </style>

    </head>

    <body>
        <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*" %>
            <% int sid=Integer.parseInt(session.getAttribute("student_id").toString()); 
                int qid=Integer.parseInt(request.getParameter("qid").toString()); 
                String qname=request.getParameter("qname"); 
                String quizStartDateTime=null, quizEndDateTime=null, quizCourseName=null; 
                int quizImageKeyId=0, quizCourseId=0, quizTotalMarks=0, quizObtainedMarks=0;
                try {
                    Class.forName("com.mysql.jdbc.Driver"); 
                    Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root" , "" ); 
                    Statement stmt1=conn.createStatement(); 
                    String sql1="select * from quiz join course on quiz.course_id=course.course_id where quiz.quiz_id=" + qid;
                    ResultSet rs1=stmt1.executeQuery(sql1); 
                    if (rs1.next()) {
                        quizStartDateTime=rs1.getString("quiz_start_time"); 
                        quizEndDateTime=rs1.getString("quiz_end_time");
                        quizImageKeyId=rs1.getInt("image_id"); 
                        quizCourseId=rs1.getInt("course_id");
                        quizCourseName=rs1.getString("course_name"); 
                        quizTotalMarks=rs1.getInt("quiz_marks"); 
                    }
                    rs1.close();
                    conn.close(); 
                } catch (Exception e) { 
                    out.println(e); 
                } %>
                <script>

                    function Redirect() {
                        window.location = 'student_quiz_dashboard.jsp?qid=<%=qid%>&qname=<%=qname%>';
                    }

                    function finish(flag) {
                        url = 'student_quiz_dashboard.jsp?qid=<%=qid%>&qname=<%=qname%>'

                        if (flag == 'finish') {
                          var r = confirm("Are You sure, you want to submit Quiz.");
                          if (r == true) {
                            window.location = url ;
                          }  
                        }  
                        else{
                            window.location = url ;
                        }    
                    }

                </script>

                <div class="modal" id="myModal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Quiz Instructions</h5>
                            </div>
                            <div class="modal-body">
                                <p>1. Read Questions Carefully.</p>
                                <p>2. ESC key will terminate your quiz.</p>
                                <button class="btn btn-success" onclick="openFullscreen()"> Start Now</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="content" class="col-12">
                    <div class="row">
                        <div class="bg-light p-5 col-md-12">

                            <div class="row p-3">
                                <div class="col-sm-8">
                                    <h1> <%=qname%> </h1>
                                    <h4> Quiz Total Marks : <%=quizTotalMarks%> </h4>
                                </div>
                                <div class="col-sm-4 text-center bg-warning">
                                    <p>TIMER</p>
                                    <div id="clockdiv" class="row text-white">
                                        <div class="col-2 offset-2  bg-info border border-light">
                                            <span class="days " id="day"></span>
                                            <span class="">Days</span>
                                        </div>
                                        <div class="col-2  bg-info border border-light ">
                                            <span class="hours " id="hour"></span>
                                            <div class="">Hrs</div>
                                        </div>
                                        <div class="col-2  bg-info border border-light">
                                            <span class="minutes " id="minute"></span>
                                            <div class="">Mins</div>
                                        </div>
                                        <div class="col-2  bg-info border border-light">
                                            <span class="seconds " id="second"></span>
                                            <div class="">Secs</div>
                                        </div>
                                    </div>
                                    <p id="demo"></p>
                                </div>
                            </div>

                            <div id="altmsg" class="alert alert-dismissible alert-light text-center"> </div>
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
                                            <div class="card border-primary mb-3" style="max-width: 100rem;">
                                                <div class="card-header">
                                                    <div class="d-flex w-100 justify-content-between">
                                                        <h6 class="text-success"> Marks : <%=rs.getInt("question_marks")%> </h6>
                                                        <h6 class="text-danger"> Neg Marks : <%=rs.getInt("question_neg_marks")%> </h6>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    <form id="form<%=i+1%>" method="post" enctype="multipart/form-data">

                                                        <h4 class="card-title"> Q.<%=i+1%>. <%=rs.getString("question_text")%> </h4>
                                                        <%
                                                        Statement stmt1 = con.createStatement();
                                                        String sql1 = "select * from option where question_id=" + rs.getInt("question_id");
                                                        ResultSet rs1 = stmt1.executeQuery(sql1);

                                                        while (rs1.next()) {%>

                                                        <div class="form-check d-flex">
                                                            <label class="form-check-label mt-3">
                                                                <input type="radio" class="form-check-input" name="answer"
                                                                    id="radioOptions[]" value="<%=rs1.getInt("option_id")%>">

                                                                <%=rs1.getString("option")%>
                                                            </label>
                                                        </div>

                                                        <%  } %>
                                                </div>

                                                <div class="d-flex w-100 justify-content-between mt-5 p-1">
                                                    <a onclick="ShowDiv('<%=i%>')" class="btn btn-info"> Previous </a>
                                                    <input type="submit" onclick="SaveAns('<%=i+1%>', '<%=quizCourseId%>', '<%=qid%>', '<%=rs.getInt("question_id")%>', '<%=rs.getInt("question_marks")%>', '<%=rs.getInt("question_neg_marks")%>' )"
                                                        class="btn btn-success save" value="Save">
                                                    <a onclick="ShowDiv('<%=i+2%>')" class="btn btn-info"> Next </a>
                                                </div>
                                                </form>
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
                            <div>
                                <button id="finish" class="btn btn-danger btn-lg float-right" onclick="finish('finish')"> Finish </button>
                            </div>
                        </div>
                    </div>
                    <div class="text-center text-white p-2" style="margin-bottom:0 ; background-color:#2c3e50 ; font-weight:bolder">
                        <p class='text-center'>Copyright &copy; QuizApp</p>
                    </div>
                </div>

                <script>
                    var deadline = Date.parse('<%=quizEndDateTime%>');
                    var x = setInterval(function () {

                        var now = new Date().getTime();
                        var T = deadline - now;
                        var days = Math.floor(T / (1000 * 60 * 60 * 24));
                        var hours = Math.floor((T % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                        var minutes = Math.floor((T % (1000 * 60 * 60)) / (1000 * 60));
                        var seconds = Math.floor((T % (1000 * 60)) / 1000);
                        document.getElementById("day").innerHTML = days;
                        document.getElementById("hour").innerHTML = hours;
                        document.getElementById("minute").innerHTML = minutes;
                        document.getElementById("second").innerHTML = seconds;
                        if (T < 0) {
                            clearInterval(x);
                            document.getElementById("demo").innerHTML = "TIME UP";
                            document.getElementById("day").innerHTML = '0';
                            document.getElementById("hour").innerHTML = '0';
                            document.getElementById("minute").innerHTML = '0';
                            document.getElementById("second").innerHTML = '0';
                            finish('TimeUp');
                        }

                    }, 1000);
                </script>

                <script>
                    var elem = document.getElementById("content");

                    /*Note that we must include prefixes for different browsers, as they don't support the requestFullscreen method yet */
                    function openFullscreen() {
                        if (elem.requestFullscreen) {
                            elem.requestFullscreen();
                        } else if (elem.webkitRequestFullscreen) { /* Safari */
                            elem.webkitRequestFullscreen();
                        } else if (elem.msRequestFullscreen) { /* IE11 */
                            elem.msRequestFullscreen();
                        }
                        console.log('openfull');
                        $('#wrap').show();
                        $('#quest1').siblings().hide();

                    }

                    if (document.addEventListener) {
                        document.addEventListener('fullscreenchange', exitHandler, false);
                        document.addEventListener('mozfullscreenchange', exitHandler, false);
                        document.addEventListener('MSFullscreenChange', exitHandler, false);
                        document.addEventListener('webkitfullscreenchange', exitHandler, false);
                    }

                    function exitHandler() {
                        if (!document.webkitIsFullScreen && !document.mozFullScreen && !document.msFullscreenElement) {
                            setTimeout('Redirect()', 1000);
                        }
                    }

                </script>

                <script type='text/javascript'>

                    function tempAlert(msg, duration, status) {

                        var el = document.getElementById('altmsg');

                        if (status) {
                            el.classList.add('text-success')
                            el.classList.add('border-success')
                        }
                        else {
                            el.classList.add('text-danger')
                            el.classList.add('border-danger')
                        }
                        el.innerHTML = msg;
                        setTimeout(function () {
                            if (status) {
                                el.classList.remove('text-success')
                                el.classList.remove('border-success')
                            }
                            else {
                                el.classList.remove('text-danger')
                                el.classList.remove('border-danger')
                            }
                            el.innerHTML = '';
                        }, duration);

                    }

                    function ShowDiv(qno) {
                        qno = '#quest' + qno;
                        console.log(qno);
                        $(qno).show();
                        $(qno).siblings().hide();
                        return false;
                    }

                    function SaveAns(qno, course_id, quiz_id, question_id, marks, negMarks) {
                        qno = '#form' + qno;
                        let formData = $(qno).serializeArray();
                        if (formData.toString().length) {
                            $.ajax({
                                type: 'POST',
                                url: 'student_answer_question.jsp?qid=' + quiz_id,
                                data: "cid=" + course_id +"&queid=" + question_id + "&answer=" + formData[0]['value']+ "&marks=" + marks+ "&negMarks=" + negMarks,
                                dataType: "json",
                                cache: false,
                                processData: false,
                                success: function (result) {
                                    if (result.status) {
                                        tempAlert('Answer Succefully Saved', 2000, true);
                                    }
                                    else {
                                        tempAlert('Something went wrong!!!', 2000, false);
                                    }
                                },
                                error: function (result) {
                                    console.log("error")
                                }
                            });
                        } else {
                            tempAlert('Answer Not Selected', 2000, false);
                        }
                    }
                    $(".save").click(function (e) {
                        e.preventDefault();
                        console.log('save')
                    });

                </script>
    </body>

    </html>
    <%}%>
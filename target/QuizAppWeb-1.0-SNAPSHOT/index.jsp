<!DOCTYPE html>

<html lang="en">
    <%@include file="head.jsp" %>
    <body>

        <%@include file="top_nav.jsp" %>

        <!-- Header Carousel -->
        <header id="myCarousel" class="carousel slide">
            <!-- Indicators -->
            <ol class="carousel-indicators">
                <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                <li data-target="#myCarousel" data-slide-to="1"></li>
            </ol>

            <!-- Wrapper for slides -->
            <div class="carousel-inner">
                <div class="item active">
                    <div class="fill" style="background-image:url('images/banner2.png');"></div>
                    <div class="carousel-caption">

                    </div>
                </div>
                <div class="item">
                    <div class="fill" style="background-image:url('images/banner1.png');"></div>
                    <div class="carousel-caption">

                    </div>
                </div>
                
            </div>

            <!-- Controls -->
            <a class="left carousel-control" href="#myCarousel" data-slide="prev">
                <span class="icon-prev"></span>
            </a>
            <a class="right carousel-control" href="#myCarousel" data-slide="next">
                <span class="icon-next"></span>
            </a>
        </header>

        <!-- Page Content -->
        <div class="container">

            <!-- Marketing Icons Section -->
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header text-primary">
                        Quiz App - For Regular Class Tests
                    </h1>
                    <p>Generic Quiz Web App for Assessment of Students performance. </p> 
        <p> Teachers will be creating courses and add Quizzes to those courses and similarly, questions to each
            quiz. Students will be enrolling to the courses using the enrollment key given by the
            respective course creator. Similarly to attempt the individual quiz student had to select
            the same enrollment image selected by the teacher at the time of creating the quiz. Quiz
            will contain MCQ type questions and System will evaluate the marks to the students.</p>
        
                </div>
                <div class="col-md-6">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h4><i class="fa fa-fw fa-user"></i> User Registration</h4>
                        </div>
                        <div class="panel-body">
                            <a href="register.jsp" class="btn btn-primary">View More</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h4><i class="fa fa-fw fa-user"></i> Who we are</h4>
                        </div>
                        <div class="panel-body">
                            <a href="about.jsp" class="btn btn-primary">View More</a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.row -->

            <!-- Features Section -->
            <div class="row">
                <div class="col-lg-12">
                    <h2 class="page-header  text-primary">Some Major In-corporations :</h2>
                </div>
                <div class="col-md-6">

                    <ul>
                        <li> Images will be used for quiz enrollment keys. </li>
                        
                    </ul>
                </div>
                <div class="col-md-6">
                    <img class="img-responsive" src="images/contact.jpg" alt="">
                </div>
            </div>
            <!-- /.row -->

            <hr>

            <!-- Call to Action Section -->
            <div class="well">
                <div class="row">
                    <div class="col-md-8">
                        <p>We expect your loyal feedback to improve our standard.For more details and any subject related queries..</p>
                    </div>
                    <div class="col-md-4">
                        <a class="btn btn-primary btn-block" href="contact.jsp"><i class="fa fa-phone"></i> Call to Action</a>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="myModal">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <img src='' width="100%" height="100%" id='ModalImg'>
                    </div>
                </div>
            </div>

            <hr>

            <!-- Footer -->
            <%@include file="footer.jsp" %>

        </div>
        <!-- /.container -->

        <!-- jQuery -->
        <script src="js/jquery.js"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="js/bootstrap.min.js"></script>

        <!-- Script to Activate the Carousel -->
        <script>
            $('.carousel').carousel({
                interval: 5000 //changes the speed
            })

            $(".img-portfolio").click(function () {
                var a = $(this).attr("src");
                $("#ModalImg").attr("src", a);
                $('#myModal').modal();
            })
        </script>

    </body>

</html>

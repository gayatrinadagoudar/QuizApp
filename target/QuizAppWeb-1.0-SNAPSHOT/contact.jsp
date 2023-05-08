    <!DOCTYPE html>

    <html lang="en">
        <%@include file="head.jsp" %>
        <body>

            <%@include file="top_nav.jsp" %>
            <!-- Page Content -->
            <div class="container" style="margin-top:70px;">

                <div class="row">
                    <div class="col-md-8">


                        <h3 class='text-primary'>Send us a Message</h3>
                        <form method="post" action="" role="form" >
                            <div class="control-group form-group">
                                <div class="controls">
                                    <label>Full Name:</label>
                                    <input type="text" class="form-control" name="name" required>
                                    <p class="help-block"></p>
                                </div>
                            </div>
                            <div class="control-group form-group">
                                <div class="controls">
                                    <label>Phone Number:</label>
                                    <input type="tel" class="form-control" name="phone" required>
                                </div>
                            </div>
                            <div class="control-group form-group">
                                <div class="controls">
                                    <label>Email Address:</label>
                                    <input type="email" class="form-control" name="email"  >
                                </div>
                            </div>
                            <div class="control-group form-group">
                                <div class="controls">
                                    <label>Message:</label>
                                    <textarea rows="5" cols="100" class="form-control" name="message" required maxlength="999" style="resize:none"></textarea>
                                </div>
                            </div>
                            <div id="success"></div>
                            <!-- For success/fail messages -->
                            <button type="submit" class="btn btn-primary" name="submit"><i class='fa fa-send'></i> Send Message</button>
                        </form>

                    </div>

                    <div class="col-md-4">
                        <h3 class='text-primary' style="margin-bottom: 20px">Contact Details</h3>

                        <p style="margin-bottom: 20px" ><i class="fa fa-phone"></i> 
                            02322229187</p>
                        <p style="margin-bottom: 20px"><i class="fa fa-envelope-o"></i> 
                            <a href="#" >quizapp@gmail.com</a>
                        </p>
                        <p style="margin-bottom: 20px"><i class="fa fa-clock-o"></i> 
                            24*7</p>
                        <p style="margin-bottom: 20px"><i class="fa fa-globe"></i> 
                            <a href="index.jsp">www.quizapp.org</a></p>
                        <ul style="margin-bottom: 20px" class="list-unstyled list-inline list-social-icons">
                            <li>
                                <a href="#"><i class="fa fa-facebook-square"></i></a>
                            </li>
                            <li>
                                <a href="#"><i class="fa fa-linkedin-square"></i></a>
                            </li>
                            <li>
                                <a href="#"><i class="fa fa-twitter-square"></i></a>
                            </li>
                            <li>
                                <a href="#"><i class="fa fa-google-plus-square"></i></a>
                            </li>
                        </ul>
                    </div>
                </div>


                <hr>
                <%@include file="footer.jsp" %>

            </div>
            <!-- /.container -->

            <!-- jQuery -->
            <script src="js/jquery.js"></script>

            <!-- Bootstrap Core JavaScript -->
            <script src="js/bootstrap.min.js"></script>



        </body>

    </html>

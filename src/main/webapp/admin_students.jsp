<!DOCTYPE html>

<html lang="en">
    <%@include file="head.jsp" %>
    <body>
        <%@include file="admin_top_nav.jsp" %>
        <div class="container-fluid mainContainer">
            <div class='alert alert-danger'><strong>Welcome Admin</strong> </div>
            <div class="row col-12 m-0">
        <div class="col-md-3 p-sm-1">
                    <%@include file="admin_side_nav.jsp" %>
                </div>
                <div class="col-md-9 contentContainer">
                    <h3 class="text-primary"><i class="fa fa-users"></i> All Students </h3><hr>    
                    <div class="row">
                       
                        <table id='tab' class="display table text-center table-hover">
                            <thead>
                                <tr class="table-default">
                                    <th scope="col"> Sr.No.</th>
                                    <th scope="col">Student ID</th>
                                    <th scope="col">Student Name</th>
                                    <th scope="col">Email ID</th>
                                    <th scope="col">Mobile No.</th>
                                    <th scope="col">Password</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%> 
                                <%
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");

                                        Statement stmt = con.createStatement();
                                        String sql = "select * from student join user on student.user_id=user.user_id";
                                        ResultSet rs = stmt.executeQuery(sql);
                                        int i=1;
                                        while (rs.next()) {%>
                                <tr class="table-default">
                                    <td scope="row"> <%=i++%></td>
                                    <td><%=rs.getInt("student_id")%></td>
                                    <td><%=rs.getString("student_name")%></td>
                                    <td><%=rs.getString("user_email")%></td>
                                    <td><%=rs.getString("phone_no")%></td>
                                    <td><%=rs.getString("password")%></td>
                                    
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
                            $('#tab').DataTable();
                            
                        </script>
                    </div>
                </div>
            </div>

                        <!-- Footer -->
            <%@include file="footer.jsp" %>
        </div>


    </body>

</html>


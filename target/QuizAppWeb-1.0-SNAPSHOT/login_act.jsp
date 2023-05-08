<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%> 
<%
    // take password for validation
    String username = request.getParameter("email");
    String password = request.getParameter("pass");

    try {
        // register the driver
        Class.forName("com.mysql.jdbc.Driver");

        // establish the connection with the database
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");

        // create a SQL statement
        Statement stmt = con.createStatement();
        String sql = "select * from user where user_email='" + username + "' and password = '" + password + "'";

        // execute the statement
        ResultSet rs = stmt.executeQuery(sql);

        // if admin password is in DB, redirect to dashboard
        if (rs.next()) {
            int active = rs.getInt("active");
            int user_id = rs.getInt("user_id");
            String role = rs.getString("role");
            session.setAttribute("user_id", user_id);
            session.setAttribute("role", role);
            if (active == 1) {
                if (role.equals("T")) {

                    String sql1 = "select * from teacher where user_id=" + user_id;

                    ResultSet rs1 = stmt.executeQuery(sql1);
                    if (rs1.next()) {
                        session.setAttribute("teacher_id", rs1.getInt("teacher_id"));
                        session.setAttribute("teacher_name", rs1.getString("teacher_name"));
                        response.sendRedirect("teacher_home.jsp");
                    } else {
                        session.setAttribute("login_msg", "Something went wrong");
                        response.sendRedirect("login.jsp");
                    }

                } else if (role.equals("S")) {
                    String sql2 = "select * from student where user_id=" + user_id;

                    ResultSet rs2 = stmt.executeQuery(sql2);
                    
                    if (rs2.next()) {
                        int sid=rs2.getInt("student_id");
                        session.setAttribute("student_id", rs2.getInt("student_id"));
                        session.setAttribute("student_name", rs2.getString("student_name"));
                        rs2.close();
                        java.util.ArrayList<Integer> student_courses = new java.util.ArrayList<>();
                        String sql3 = "select course_id from enrollment_course where student_id=" + sid;
                        ResultSet rs3 = stmt.executeQuery(sql3);
                        while (rs3.next()) {
                            student_courses.add(rs3.getInt("course_id"));
                        }
                        session.setAttribute("student_courses", student_courses);
                        rs3.close();
                        java.util.ArrayList<Integer> student_quizzes = new java.util.ArrayList<>();
                        String sql4 = "select quiz_id from enrollment_quiz where student_id=" + sid;
                        ResultSet rs4 = stmt.executeQuery(sql4);
                        while (rs4.next()) {
                            student_quizzes.add(rs4.getInt("quiz_id"));
                        }
                        session.setAttribute("student_quizzes", student_quizzes);
                        rs4.close();
                        response.sendRedirect("student_home.jsp");
                    } else {
                        session.setAttribute("login_msg", "Something went wrong");
                        response.sendRedirect("login.jsp");
                    }
                    rs2.close();
                } else {
                    response.sendRedirect("admin_home.jsp");
                }

            } else {
                session.setAttribute("login_msg", "Your account is not active ,contact admin");
                response.sendRedirect("login.jsp");
            }

        } // if password is wrong, display error message
        else {
            session.setAttribute("login_msg", "Invalid Username or Password");
            response.sendRedirect("login.jsp");
        }

        // close the connection
        con.close();
    } catch (Exception e) {
        out.println(e);
    }
%>
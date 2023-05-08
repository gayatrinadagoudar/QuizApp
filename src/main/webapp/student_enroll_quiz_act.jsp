<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%> 
<%
    // take password for validation
    int qid = Integer.parseInt(request.getParameter("quiz_id").toString());
    int sid = Integer.parseInt(session.getAttribute("student_id").toString());
    String qname = request.getParameter("quiz_name");
    String img_id = request.getParameter("optionsRadios");

    try {
        // register the driver
        Class.forName("com.mysql.jdbc.Driver");

        // establish the connection with the database
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");

        // create a SQL statement
        Statement stmt = con.createStatement();
        String sql = "select * from quiz where quiz_id='" + qid + "' and image_id = '" + img_id + "'";

        // execute the statement
        ResultSet rs = stmt.executeQuery(sql);
        PreparedStatement pst;
        if (rs.next()) {
            pst = con.prepareStatement("insert into enrollment_quiz(quiz_id,student_id) values(?,?)");
            pst.setInt(1, qid);
            pst.setInt(2, sid);
            int i = pst.executeUpdate();

            if (i > 0) {
                java.util.ArrayList<Integer> quizzes = (java.util.ArrayList<Integer>) (session.getAttribute("student_quizzes"));
                quizzes.add(qid);
                session.setAttribute("student_quizzes", quizzes);
                response.sendRedirect("student_quiz_dashboard.jsp?qid=" + qid + "&qname=" + qname);
            }

            rs.close();;
            con.close();
        } // if password is wrong, display error message
        else {
            session.setAttribute("student_eq_msg", "Incorrect Enrollment Key");
            response.sendRedirect("student_enroll_quiz.jsp?qid=" + qid + "&qname=" + qname);
        }

        con.close();
    } catch (Exception e) {
        session.setAttribute("student_eq_msg", e.getMessage().toString());
        response.sendRedirect("student_enroll_quiz.jsp?qid=" + qid + "&qname=" + qname);
    }
%>
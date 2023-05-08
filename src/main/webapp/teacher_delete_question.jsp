<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 

<%
    int queid = Integer.parseInt(request.getParameter("queid").toString());
    String qname = request.getParameter("qname");
    int qid = Integer.parseInt(request.getParameter("qid").toString());
    int marks = Integer.parseInt(request.getParameter("marks").toString());    

    Connection con;
    PreparedStatement pst, pst1;
    ResultSet rs;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
        pst = con.prepareStatement("delete from quiz_app.question where question_id=?");
        pst.setInt(1, queid);      

        int i = pst.executeUpdate();
        if (i > 0) {
            pst1 = con.prepareStatement("update quiz_app.quiz set quiz_marks=quiz_marks-? where quiz_id=?");
            pst1.setInt(1, marks);
            pst1.setInt(2, qid);
            int j = pst1.executeUpdate();
            if (j > 0) {
                session.setAttribute("teacher_vq_msg", "Question deleted successfully!");
                response.sendRedirect("teacher_view_questions.jsp?qid="+qid+"&qname="+qname);
            }
        }
    }
    catch (Exception e) {
        session.setAttribute("teacher_vq_msg", e.getMessage().toString());
        response.sendRedirect("teacher_view_questions.jsp?qid="+qid+"&qname="+qname);
    }
%>

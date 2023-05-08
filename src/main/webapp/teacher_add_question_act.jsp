<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 

<%
    int cid = Integer.parseInt(request.getParameter("course_id").toString());
    String qname = request.getParameter("quiz_name");
    int qid = Integer.parseInt(request.getParameter("quiz_id").toString());
    String qtext = request.getParameter("question_text");
    int marks = Integer.parseInt(request.getParameter("marks").toString());    
    int neg_marks = Integer.parseInt(request.getParameter("neg_marks").toString());

    Connection con;
    PreparedStatement pst, pst1;
    ResultSet rs;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
        pst = con.prepareStatement("insert into quiz_app.question(course_id,quiz_id,question_text,question_marks,question_neg_marks) values(?,?,?,?,?)");
        pst.setInt(1, cid);        
        pst.setInt(2, qid);
        pst.setString(3, qtext);
        pst.setInt(4, marks);        
        pst.setInt(5, neg_marks);

        int i = pst.executeUpdate();
        if (i > 0) {
            pst1 = con.prepareStatement("update quiz_app.quiz set quiz_marks=quiz_marks+? where quiz_id=?");
            pst1.setInt(1, marks);
            pst1.setInt(2, qid);
            int j = pst1.executeUpdate();
            if (j > 0) {
                session.setAttribute("teacher_vq_msg", "Question \""+ qtext +"\" added successfully!");
                response.sendRedirect("teacher_view_questions.jsp?qid="+qid+"&qname="+qname);
            }
        }
    }
    catch (Exception e) {
        session.setAttribute("teacher_vq_msg", e.getMessage().toString());
        response.sendRedirect("teacher_view_questions.jsp?qid="+qid+"&qname="+qname);
    }
%>

<%@page import="java.util.Locale"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 

<%

    int tid = Integer.parseInt(session.getAttribute("teacher_id").toString());
    String qname = request.getParameter("quiz_name");
    int qid = Integer.parseInt(request.getParameter("quiz_id").toString());
    int cid = Integer.parseInt(request.getParameter("course").toString());
    int img_id = Integer.parseInt(request.getParameter("optionsRadios").toString());
    String stime = request.getParameter("stime");
    String etime = request.getParameter("etime");
    Connection con;
    PreparedStatement pst;
    ResultSet rs;

    LocalDateTime st_d = LocalDateTime.parse(stime);
    LocalDateTime en_d = LocalDateTime.parse(etime);
    LocalDateTime now = LocalDateTime.now();

    if (st_d.isAfter(now)) {
        if (en_d.isAfter(st_d)) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                Statement stmt = con.createStatement();

                pst = con.prepareStatement("update quiz_app.quiz set teacher_id=?,course_id=?,quiz_name=?,image_id=?,quiz_start_time=?,quiz_end_time=? where quiz_id=?");
                pst.setInt(1, tid);
                pst.setInt(2, cid);
                pst.setString(3, qname);
                pst.setInt(4, img_id);
                pst.setString(5, stime);
                pst.setString(6, etime);
                pst.setInt(7, qid);
                int i = pst.executeUpdate();

                if (i > 0) {
                    session.setAttribute("teacher_vq_msg", "Quiz details updated succesfully!");
                    response.sendRedirect("teacher_view_questions.jsp?qid="+qid+"&qname="+qname);
                }

            } catch (Exception e) {
                session.setAttribute("teacher_vq_msg", e.getMessage().toString());
                response.sendRedirect("teacher_view_questions.jsp?qid="+qid+"&qname="+qname);
            }
        } else {
            session.setAttribute("teacher_vq_msg", "Invalid Timings!!!");
            response.sendRedirect("teacher_view_questions.jsp?qid="+qid+"&qname="+qname);
        }
    } else {
        session.setAttribute("teacher_vq_msg", "Invalid Timings!!!");
        response.sendRedirect("teacher_view_questions.jsp?qid="+qid+"&qname="+qname);
    }

%>

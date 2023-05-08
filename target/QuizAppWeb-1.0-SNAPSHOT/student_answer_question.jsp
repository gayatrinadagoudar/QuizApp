<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.Date" %> 
<%@page import="com.google.gson.JsonObject" %>
<%@page import="com.google.gson.Gson" %>


<%
    JsonObject obj=new JsonObject();

    int sid = Integer.parseInt(session.getAttribute("student_id").toString());
    int qid = Integer.parseInt(request.getParameter("qid").toString());
    int cid = Integer.parseInt(request.getParameter("cid").toString());
    int queid = Integer.parseInt(request.getParameter("queid").toString());
    int answer = Integer.parseInt(request.getParameter("answer").toString());
    int marks = Integer.parseInt(request.getParameter("marks").toString());
    int negMarks = Integer.parseInt(request.getParameter("negMarks").toString());
    boolean flag = false;
    int student_answer_id=0, correct_answer_id=0, score=0;
    Connection con;
    Statement stmt;
    PreparedStatement pst1, pst2, pst3, pst4;
    ResultSet rs1, rs2, rs3;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
        stmt = con.createStatement();
        String sql = "select * from questions_result where student_id ="+ sid +" and  quiz_id ="+ qid +" and question_id =" + queid;
        rs1= stmt.executeQuery(sql);
        if (rs1.next()) {
            flag=true;
            student_answer_id=rs1.getInt("student_answer_id");
        }
        rs1.close();

        sql = "select option_id from answer where question_id =" + queid;
        rs2= stmt.executeQuery(sql);
        if (rs2.next()) {
            correct_answer_id=rs2.getInt("option_id");
        }
        rs2.close();

        if( answer == correct_answer_id) {
            score=marks;
        } else {
            score=negMarks;
        }

        if( flag) {
            pst1 = con.prepareStatement("UPDATE questions_result SET question_score = ? , ans_datetime = ?  WHERE student_answer_id = ?");
            pst1.setInt(1, score);
            pst1.setString(2, (new Date()).toString());
            pst1.setInt(3, student_answer_id);
            pst1.executeUpdate();

            pst2 = con.prepareStatement("UPDATE student_answer SET answer = ? WHERE student_answer_id = ?");
            pst2.setInt(1, answer);
            pst2.setInt(2, student_answer_id);
            pst2.executeUpdate();
        } else {
            pst3 = con.prepareStatement("INSERT INTO questions_result (student_id, course_id, quiz_id , question_id , question_score , ans_datetime) VALUES (?, ?, ?, ?, ? ,?)");
            pst3.setInt(1, sid);
            pst3.setInt(2, cid);
            pst3.setInt(3, qid);
            pst3.setInt(4, queid);
            pst3.setInt(5, score);
            pst3.setString(6, (new Date()).toString());
            pst3.executeUpdate();

            sql = "select student_answer_id from questions_result where student_id ="+ sid +" and  quiz_id ="+ qid +" and question_id =" + queid;
            int stud_ans_id=0;
            rs3= stmt.executeQuery(sql);
            if (rs3.next()) {
                stud_ans_id=rs3.getInt("student_answer_id");
            }
            rs3.close();

            pst4 = con.prepareStatement("insert into student_answer(student_answer_id, answer) values (?, ?)");
            pst4.setInt(1, stud_ans_id);
            pst4.setInt(2, answer);
            pst4.executeUpdate();
        }       
        obj.addProperty("status",(Boolean) true);
        out.println(new Gson().toJson(obj));                   
    }
    catch (Exception e) {
        obj.addProperty("status",(Boolean) false);
        out.println(new Gson().toJson(obj));
    }
%>

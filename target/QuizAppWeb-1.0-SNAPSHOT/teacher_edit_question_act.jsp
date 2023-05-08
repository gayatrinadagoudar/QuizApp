<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 

<%
    int queid = Integer.parseInt(request.getParameter("id").toString());
    int cid = Integer.parseInt(request.getParameter("cid").toString());
    String qname = request.getParameter("qname");
    int qid = Integer.parseInt(request.getParameter("qid").toString());
    String qtext = request.getParameter("question_text");
    int marks = Integer.parseInt(request.getParameter("marks").toString());    
    int neg_marks = Integer.parseInt(request.getParameter("neg_marks").toString());
    java.util.ArrayList<String> prev_options = new java.util.ArrayList<String>();
    String sql="", prev_answer="";
    int prev_ans_option_id=0;
    String options[] = request.getParameterValues("options");
    String answers[] = request.getParameterValues("radioOptions");
    Connection con;
    Statement stmt;
    PreparedStatement pst1, pst2, pst3, pst4;
    ResultSet rs1, rs2, rs3, rs4;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
        stmt = con.createStatement();
        sql = "SELECT OPTION from OPTION WHERE QUESTION_ID =" + queid;
        rs1= stmt.executeQuery(sql);
        while (rs1.next()) {
            prev_options.add(rs1.getString("option"));
        }
        rs1.close();
        sql = "SELECT ANSWER , OPTION_ID from ANSWER WHERE QUESTION_ID =" + queid;
        rs2= stmt.executeQuery(sql);
        if (rs2.next()) {
            prev_answer=rs2.getString("answer");
            prev_ans_option_id=rs2.getInt("option_id");
        }
        rs2.close();
        if( options.length >= 2 ) {
            for (String option : options) { 
                if(prev_options.indexOf(option)<0){
                        pst1 = con.prepareStatement("insert into option(question_id,option) values(?,?)");
                        pst1.setInt(1, queid);
                        pst1.setString(2, option);
                        pst1.executeUpdate();
                    }
            }
            for (String option : prev_options) { 
                int flag=1;
                for (String opt : options) { 
                    if(opt.equals(option)){
                        flag=0;
                    }
                }
                if(flag==1) {
                    pst2 = con.prepareStatement("DELETE FROM OPTION where OPTION = ? And QUESTION_ID = ?");
                    pst2.setString(1, option);
                    pst2.setInt(2, queid);
                    pst2.executeUpdate();
                }
            }

            for (String answer : answers) { 
                if(!prev_answer.equals(answer)){
                    int option_id = 0;
                    sql = "SELECT OPTION_ID from option WHERE QUESTION_ID =" + queid + " and option='"+answer+"'";
                    rs3= stmt.executeQuery(sql);
                    if (rs3.next()) {
                        option_id=rs3.getInt("option_id");
                    }
                    rs3.close();
                    pst3 = con.prepareStatement("insert into answer(question_id,option_id, answer) values(?,?,?)");
                    pst3.setInt(1, queid);
                    pst3.setInt(2, option_id);
                    pst3.setString(3, answer);
                    pst3.executeUpdate();

                }
            }
            for (String answer : answers) { 
                if(!answer.equals(prev_answer)){
                    int option_id = 0;
                    sql = "SELECT OPTION_ID from option WHERE QUESTION_ID =" + queid + " and option='"+prev_answer+"'";
                    rs4= stmt.executeQuery(sql);
                    if (rs4.next()) {
                        option_id=rs4.getInt("option_id");
                    }
                    rs4.close();
                    pst4 = con.prepareStatement("DELETE FROM ANSWER where QUESTION_ID = ? AND OPTION_ID = ?");
                    pst4.setInt(1, queid);
                    pst4.setInt(2, option_id);
                    pst4.executeUpdate();
                }
            }
            session.setAttribute("teacher_vq_msg", "Question Updated Successfully");
            response.sendRedirect("teacher_view_questions.jsp?qid="+qid+"&qname=" + qname);
        } else {
            session.setAttribute("teacher_eq_msg", "MCQ type question must have at least 2 options.");
            response.sendRedirect("teacher_edit_question.jsp?id="+queid+"&cid="+cid+"&qname="+qname+"&qid="+qid+"&qname=" + qname);
        }                   
    }
    catch (Exception e) {
        session.setAttribute("teacher_eq_msg", e.getMessage().toString());
    }
%>

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "uploadImage", urlPatterns = { "/uploadImage" })
@MultipartConfig
public class uploadImage extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Part pic = request.getPart("upfile");
        int imageSize = (int) pic.getSize();

        Connection con;
        PreparedStatement pst;

        if (imageSize < 2024000) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quiz_app", "root", "");
                pst = con.prepareStatement("insert into quiz_app.images(image) values(?)");

                pst.setBinaryStream(1, pic.getInputStream(), (int) pic.getSize());
                int i = pst.executeUpdate();
                if (i > 0) {
                    session.setAttribute("teacher_up_msg", "Image added!");
                    response.sendRedirect("teacher_add_new_quiz.jsp");
                }

            } catch (Exception e) {
                session.setAttribute("teacher_up_msg", e.getMessage().toString());
                response.sendRedirect("teacher_add_new_quiz.jsp");

            }
        } else {
            session.setAttribute("teacher_up_msg", "File is more than 2 MB that is=" + imageSize);
            response.sendRedirect("teacher_add_new_quiz.jsp");

        }

    }

}

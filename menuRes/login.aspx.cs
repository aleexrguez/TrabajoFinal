using System;
using System.Web.UI;
using MySql.Data.MySqlClient;

namespace menuRes
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Iniciar(object sender, EventArgs e)
        {
            string connectionString = "Database=menucomida;Data Source=localhost;User=root;Port=3306";
            using (MySqlConnection conexion = new MySqlConnection(connectionString))
            {
                MySqlCommand comando1 = new MySqlCommand("SELECT * FROM admin WHERE usuario = @usuario AND contrasenia = @contrasenia", conexion);
                comando1.Parameters.AddWithValue("@usuario", txtUsername.Text);
                comando1.Parameters.AddWithValue("@contrasenia", txtPassword.Text);

                try
                {
                    conexion.Open();
                    MySqlDataReader reader = comando1.ExecuteReader();

                    if (reader.HasRows)
                    {
                        Response.Redirect("admin.aspx");
                    }
                    else
                    {
                        lblErrorMessage.Text = "Credenciales inválidas";
                    }
                }
                catch (Exception ex)
                {
                    lblErrorMessage.Text = "Error al conectar con la base de datos: " + ex.Message;
                }
                finally
                {
                    conexion.Close();
                }
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace menuRes
{
    public partial class Agradecimiento : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id_pedido"] != null)
                {
                    int idPedido = Convert.ToInt32(Request.QueryString["id_pedido"]);
                    pedidoIdLiteral.Text = idPedido.ToString();
                }
            }
        }
    }
}
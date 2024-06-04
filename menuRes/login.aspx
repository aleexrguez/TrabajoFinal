<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="menuRes.login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>SR Company Admin</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="Estilos/estiloLogin.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet">

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="updatePanel" runat="server">
                    
            <ContentTemplate>
            <div class="divTitulo">
                <h2 class="titulo">Admin SR Company</h2>
            </div>
                <div class="container col-md-12">
                    <div class="row justify-content-center">
                        <div>
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title">Inicia sesión</h5>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <asp:Label runat="server" AssociatedControlID="txtUsername" CssClass="form-label">Usuario:</asp:Label>
                                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Ingresa tu usuario" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Iniciar" ControlToValidate="txtUsername" CssClass="text-danger"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label runat="server" AssociatedControlID="txtPassword">Contraseña:</asp:Label>
                                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Ingresa tu contraseña" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Iniciar" ControlToValidate="txtPassword" CssClass="text-danger"></asp:RequiredFieldValidator>
                                    </div>
                                    <asp:Label runat="server" ID="lblErrorMessage" CssClass="text-danger"></asp:Label>
                                        <asp:Button runat="server" ID="btnIniciarSesion" Text="Iniciar sesión" ValidationGroup="Iniciar" CssClass="btn btn-inicio" OnClick="Iniciar" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>


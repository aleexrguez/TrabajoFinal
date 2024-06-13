<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Agradecimiento.aspx.cs" Inherits="menuRes.Agradecimiento" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet">
    <title>¡GRACIAS!</title>
    <link rel="stylesheet" href="Estilos/estiloAgradecimiento.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.5/lottie.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            setTimeout(function () {
                document.getElementById('redi').style.display = 'block';

                setTimeout(function () {
                    window.location.href = 'index.aspx';
                }, 3000);
            }, 3000);
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="animation" id="lottie-animation"></div>
        <div class="content">
            <div class="animation-container">
                <div id="check-animation"></div>
            </div>
           <div class="texto">
                <h1>¡Pedido realizado con éxito!</h1>
                <p>En breves tendrá su comida</p>
                <p>Num.Pedido:# <asp:Literal ID="pedidoIdLiteral" runat="server"></asp:Literal></p>
            </div>

        
        </div>
        <div id="divRe">
            <p id="redi">Redirigiendo a la página principal...</p>
        </div>
    </form>
    <script>
        var confetiAnimation = lottie.loadAnimation({
            container: document.getElementById('lottie-animation'),
            renderer: 'svg',
            loop: false,
            autoplay: true,
            path: 'Imagenes/animaciones/Confeti.json'
        });
        var checkAnimation = lottie.loadAnimation({
            container: document.getElementById('check-animation'),
            renderer: 'svg',
            loop: false,
            autoplay: true,
            path: 'Imagenes/animaciones/check.json'
        });
    </script>
</body>
</html>

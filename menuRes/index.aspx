<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="menuRes.index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Inicio</title>
    <link rel="shortcut icon" href="Fotos/Index/logoSolo.png" />
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-*******" crossorigin="anonymous" />
    <link rel="stylesheet" href="Estilos/estiloIndex.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <!------------------------------------------------------------------------------- ANIMACION DE CARGA -------------------------------------------------------------------------->

        <div id="background"></div>
            <div id="content">
                <h1>SR Company</h1>
                <div class="loading-bar"></div>
            </div>
        <!------------------------------------------------------------------------------- NAVBAR -------------------------------------------------------------------------->

            <div class="navbar">
                <div class="navbar-left">
                    <span class="fas fa-bars" style="font-size: 24px; margin-right: 10px; cursor: pointer;" onclick="toggleMenu()" title="Abrir menú"></span>
                    <a href="#" style="margin-right: 20px;">SR COMPANY</a>
                </div>
            </div>
            <div id="menu" class="menu" runat="server">
                <span class="fas fa-times" onclick="toggleMenu()" style="position: absolute; top: 10px; right: 10px; font-size: 24px; cursor: pointer;"></span>
                <div class="modal-header">SR Company</div>
            </div>
            <div id="overlay" class="overlay" onclick="toggleMenu()"></div>
        <!------------------------------------------------------------------------------- CARROUSEL -------------------------------------------------------------------------->
            <div class="carousel-container">
                <div class="carousel-track">
                    <asp:Literal ID="litCarousel" runat="server"></asp:Literal>
                </div>
        </div>
    </form>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelector('.carousel-container').style.display = 'none';

            setTimeout(function () {
                document.getElementById('background').style.opacity = '0';
            }, 3000);

            setTimeout(function () {
                document.getElementById('content').style.display = 'none';
            }, 3000);

            setTimeout(function () {
                document.querySelector('.carousel-container').style.display = 'flex';
                startCarousel();
            }, 3000);

            function startCarousel() {
                const track = document.querySelector('.carousel-track');
                const items = Array.from(document.querySelectorAll('.carousel-item'));
                const itemCount = items.length;

                const firstClone = items[0].cloneNode(true);
                const lastClone = items[itemCount - 1].cloneNode(true);

                track.appendChild(firstClone);
                track.insertBefore(lastClone, items[0]);

                const newItems = document.querySelectorAll('.carousel-item');
                const totalItems = newItems.length;
                let currentIndex = 1;

                function moveToItem(index) {
                    track.style.transition = 'transform 1s ease';
                    track.style.transform = `translateX(-${100 * index}%)`;
                }

                function moveToNextItem() {
                    currentIndex++;
                    track.style.transition = 'transform 1s ease';
                    track.style.transform = `translateX(-${100 * currentIndex}%)`;

                    if (currentIndex === totalItems - 1) {
                        setTimeout(() => {
                            track.style.transition = 'none';
                            track.style.transform = `translateX(-${100}%)`;
                            currentIndex = 1;
                        }, 1000); 
                    }
                }

                track.style.transform = `translateX(-${100}%)`;
                const autoSlide = setInterval(moveToNextItem, 3000);
            }
        });
        function toggleMenu() {
            const menu = document.getElementById('menu');
            const overlay = document.getElementById('overlay');
            if (menu.classList.contains('open')) {
                menu.classList.remove('open');
                overlay.style.display = 'none';
            } else {
                menu.classList.add('open');
                overlay.style.display = 'block';
            }
        }
    </script>
</body>
</html>

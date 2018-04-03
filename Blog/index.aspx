﻿<%@ Page Language="C#" enableSessionState="true" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Blog.index" %>
<% 
    %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>PCinfo - Strona Główna</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.6.2/css/bulma.min.css">
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>
    <script>
        $(document).ready(function () {
            $("li").click(function () {
                $("li").removeClass("is-active");
                $(this).addClass("is-active");
            });
            $(".artIMG").click(function () {
                $(".artIMG").addClass("is-128x128");
                $(this).removeClass("is-128x128");
            });
            $.ajax({
            type: "POST",
            url: "index.aspx/SprawdzenieSesji",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess
            });
            function OnSuccess(response) {
                for (i = 0; i < 3; i++)
                        $("#pan" + i).empty();
                if (response.d[0] != null) {
                    var zalogowany = response.d[0];
                    $('#pan0').append("<p class='is-small'>Zalogowałeś się jako <strong>" + zalogowany + "</strong></p>");
                    $('#pan1').append("<div class='button is-info is-small' onclick='wylogowanie()'>Wyloguj</div>");
                }
                else {
                    $('#pan0').append("<input class='input is-small is-rounded' id='log' type='text' placeholder='Nazwa użytkownika...' />");
                    $('#pan1').append("<input class='input is-small is-rounded' id='pass' type='password' placeholder='Hasło...' />");
                    $('#pan2').append("<div class='button is-info is-small' onclick='logowanie()'>Zaloguj</div>");
                }
                switch (response.d[1]) {
                    case "admin":
                        break;
                    case "user":
                        break;
                }
                switch (response.d[2]) {
                    case 'o-mnie':
                        $("li").removeClass("is-active");
                        $('#menu1').addClass("is-active");
                        oMnie();
                        break;
                    case 'newsy':
                        $("li").removeClass("is-active");
                        $('#menu2').addClass("is-active");
                        $(".delete").hide();
                        Newsy();
                        if (response.d[1] == "admin") {
                            $('#contentStrony').append("<div class='button is-info' onclick='nowyNews()'>Nowy artykuł...</div>");
                            $(".delete").show();
                        }
                        break;
                    case 'cpu-rank':
                        //RankingCPU();
                        break;
                    case 'gpu-rank':
                        //RankingGPU();
                        break;
                    case 'reg':
                        if (response.d[0] != null) {
                            $("li").removeClass("is-active");
                            $('#menu2').addClass("is-active");
                            $("#menu3").hide();
                            $(".delete").hide();
                            Newsy();
                            if (response.d[1] == "admin") {
                                $('#contentStrony').append("<div class='button is-info' onclick='nowyNews()'>Nowy artykuł...</div>");
                                $(".delete").show();
                            }
                            break;
                        }
                        else {
                            $("li").removeClass("is-active");
                            $('#menu3').show();
                            $('#menu3').addClass("is-active");
                            Rejestracja();
                            break;
                        }
                }
            }
        });
        function ajaxNumerStrony(i) {
            $.ajax({
            type: "POST",
            url: "index.aspx/SprawdzenieAktywnejStrony",
            data: '{"numer_strony":"' + i + '"}', 
            contentType: "application/json; charset=utf-8",
            dataType: "json"
            });
        }
        function oMnie() {
            ajaxNumerStrony(1);
            $("#contentStrony").text("");
            $('#contentStrony')
                .append("<section class ='section'><h3 class='has-text-centered'>Bartłomiej Stasiak</h3>" +
                "<p class='has-text-centered'><img src='http://oi65.tinypic.com/zmjos2.jpg' /></p>" +
                "<p>Witam na mojej stronie. Jestem studentem VI semestru na WSTI i pochodzę z Katowic. " +
                "Zamieszczam tu nowinki ze świata podzespołów komputerowych.</p></section>");
        }
        function Newsy() {
            ajaxNumerStrony(2);
            $('#contentStrony').empty();
        }
        function Rejestracja() {
            ajaxNumerStrony(5);
            $('#contentStrony').empty();
            $('#contentStrony').append($("<div class='kontener'>"));
            var dane = ["Nazwa użytkownika: ", "Hasło: ", "Powtórz hasło: ", "Miasto: ", "E-mail: "];
            for (i = 0; i < dane.length; i++)
            {
                var typ = "'text'";
                if (dane[i].includes("hasło") || dane[i].includes("Hasło"))
                    typ = "'password'";
                $('.kontener').append($("<div class = 'columns'>")
                    .append($("<div class='column is-one-quarter'>")
                        .append("<label class='label has-text-right'>" + dane[i] + "</label>"))
                    .append($("<div class='column is-one-quarter'>")
                        .append("<input class='input' id='" + i + "' type=" + typ + "/>"))
                    .append($("<div class='column is-one-quarter'>"))
                    .append($("<div class='column is-one-quarter'>"))
                );
            }
            $('.kontener').append($("<div class = 'columns'>")
                .append($("<div class='column is-one-quarter'>"))
                .append($("<div class='column is-one-quarter'>")
                    .append("<button class='button is-info is-fullwidth' id='przyciskrejestracji' onclick='sprawdzRejestracje()'>Zarejestruj</button>"))
                .append($("<div class='column is-one-quarter'>"))
                .append($("<div class='column is-one-quarter'>"))
            );
            $('.kontener').wrap($("<section class='section'>"));
        }
        function sprawdzRejestracje() {
            var znacznik = 0;
            var input_nazwa = $('#0').val();
            var input_haslo = $('#1').val();
            var input_miasto = $('#3').val();
            var input_email = $('#4').val();
            var walidacja_hasla = $('#2').val();
            for (i = 0; i < 3; i++) {
                var x = $("#" + i).val();
                if (x.length == 0) {
                    $("#" + i).addClass("is-danger");
                    znacznik = 1;
                }
                else $("#" + i).removeClass("is-danger");
                if (i == 2 && znacznik == 1)
                        return;
            }

            if (input_haslo != walidacja_hasla) {
                $('#1').addClass("is-danger");
                $('#2').addClass("is-danger");
                return;
            }
        $.ajax({
            type: "POST",
            url: "index.aspx/RejestracjaUzytkownika",
            data: '{"nick":"' + input_nazwa + '","password":"' + input_haslo + '","city":"' + input_miasto + '","email":"' + input_email + '"}', 
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess
            });
            function OnSuccess(response) {
                var odpowiedz = response.d;
                if (odpowiedz === "zly-nick") {
                    $('#0').addClass("is-danger");
                    alert("Wprowadzona nazwa użytkownika jest już zarezerwowana!. Wybierz inną.");
                }
                if (response.d === "zly-email") {
                    $('#4').addClass("is-danger");
                    alert("Wprowadzony adres mailowy jest już zarezerwowany!");
                }
                if (response.d === "prawidlowe-dane") {
                    for (i = 0; i < 5; i++)
                        $("#" + i).addClass("is-success");
                    $('#przyciskrejestracji').prop('disabled', true);
                }

        }
        }
        function logowanie() {
            var input_nazwa = $('#log').val();
            var input_haslo = $('#pass').val();
            $.ajax({
                type: "POST",
                url: "index.aspx/LogowanieUzytkownika",
                data: "{nick:'" + input_nazwa + "', password:'" + input_haslo + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess
            });
            function OnSuccess(response) {
                if (response.d == true) location.reload();
                else alert("Nieprawidłowy login lub hasło.");
            }
        }
        function wylogowanie() {
            $.ajax({
                type: "POST",
                url: "index.aspx/UsuwanieSesji",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess
            });
            function OnSuccess() {
                location.reload();
            }
        }
        function nowyNews() {
            $("#contentStrony").empty();
            $('#contentStrony').append($("<div class='container' id='main'>")
                .append($("<div class='field'>")
                    .append("<label class='label'>Tytuł</label>")
                    .append($("<div class='control'>")
                        .append($("<input class='input' type='text' id='naglowek'>"))
                    )
            )
                .append($("<div class='field'>")
                .append("<label class='label'>Podtytuł</label>")
                .append($("<div class='control'>")
                    .append($("<input class='input' type='text' id='sub-naglowek'>"))
                )
            )
            );
            $('#main').append($("<div class='field has-addons'>")
                .append($("<div class='control'>")
                    .append($("<input class='input' type='text' placeholder='Link do obrazka...' id='link'>"))
            )
                .append($("<div class='control'>")
                    .append("<a class='button is-info' onclick='dodajLink()'>Załącz</a>"))
                .append($("<ul id='lista_linkow'>"))
            );
            $('#main').append($("<div class='field'>")
                .append("<label class='label'>Treść</label>")
                .append($("<p class='control'>")
                    .append($("<textarea class='textarea' id='cont'>"))
                )
            )
                .append($("<div class='field'>")
                    .append($("<p class='control'>")
                        .append("<button class='button is-info' onclick='zatwierdzenie()'>Zatwierdź</button>"))
            );
            $('#main').wrap($("<section class='section'>"));

        }
        function dodajLink() {
            var input_link = $('#link').val();
            $("#lista_linkow").append("<li class='element'>" + input_link + "</li>");
        }
        function zatwierdzenie() {
            var input_tytul = $('#naglowek').val();
            var input_subtytul = $('#sub-naglowek').val();
            var input_links = [];
            $('.element').each(function () {
                input_links.push(this.innerHTML);
            });
            input_links = JSON.stringify(input_links);
            var input_artcl = $('#cont').val();
            $.ajax({
                type: "POST",
                url: "index.aspx/artykul",
                data: '{"Tytul":"' + input_tytul + '", "Podtytul":"' + input_subtytul + '", "Links_arr":' + input_links + ', "Tresc":"' + input_artcl + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess
            });
            function OnSuccess(response) {
                alert(response.d);
            }
        }

    </script>
</head>
<body>
    <section class="hero is-primary">
        <div class="hero-body">
    <div class="container">
      <h1 class="title has-text-centered">
        PCinfo
      </h1>
    </div>
    </div>
    </section>


    <section class="section">
        <div class="columns is-multiline is-mobile">
              <div class="column is-one-fifth" id ="pan0"><input class="input is-small is-rounded" id="log" type="text" placeholder="Nazwa użytkownika..." /></div>
              <div class="column is-one-fifth" id="pan1"><input class="input is-small is-rounded" id="pass" type="password" placeholder="Hasło..." /></div>
              <div class="column is-one-fifth" id ="pan2"><div class="button is-info is-small" onclick="logowanie()">Zaloguj</div></div>
              <div class="column is-two-fifths"></div>
        </div>

        <div class="tabs">
  <ul>
    <li onclick="oMnie()" id="menu1"><a>O mnie</a></li>
    <li onclick="Newsy()" id="menu2"><a>Newsy</a></li>
    <li onclick="rankingCPU()"><a>Ranking CPU</a></li>
    <li onclick="rankingGPU()"><a>Ranking GPU</a></li>
    <li onclick="Rejestracja()" id="menu3"><a>Rejestracja</a></li>
  </ul>
</div>
            <section class="content" id="contentStrony">
                <div class='button is-info' onclick='nowyNews()'>Nowy artykuł...</div>
                <section class="section">
    <div class="container">
      <h2 class="title"><a class="delete"></a> News #1</h2>
      <h5 class="subtitle">
        Przykładowy news na tej stronie.
      </h5>
        <nav class="level">
            <div class="level-left">
            <div class="level-item">
                <figure class ="image is-128x128 artIMG">
                <img src="http://www.dailymobile.net/wp-content/uploads/wallpapers/android-640x480-wallpapers/android-640x480-wallpaper-4589.jpg" />
                </figure>
            </div>
            <div class="level-item">
                <figure class ="image is-128x128 artIMG">
                <img src="http://www.dailymobile.net/wp-content/uploads/wallpapers/android-640x480-wallpapers/android-640x480-wallpaper-4589.jpg" />
                </figure>
            </div>
            </div>
        </nav>
        <p>xxxxxxxxxxxxxxxxx</p>
        <article class="media">
             <div class="media-content">
    <div class="field">
      <p class="control">
        <textarea class="textarea"></textarea>
      </p>
    </div>
    <div class="field">
      <p class="control">
        <button class="button is-info">Napisz komentarz</button>
      </p>
    </div>
  </div>
        </article>
        <article class="media">
             <div class="media-content">
    <div class="content">
      <p>
        <strong>user</strong> <small>09.09.2009</small>
        <br>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ornare magna eros, eu pellentesque tortor vestibulum ut. Maecenas non massa sem. Etiam finibus odio quis feugiat facilisis.
      </p>
    </div>
</div>
            <div class="media-right">
    <button class="delete"></button>
  </div>

        </article>
    </div>
  </section>
</section>
         </section>

    <footer class="footer">
        <div class="container">
            <div class="content">
                <div class="columns">
                    <div class="column has-text-centered">
                        <a href="https://bulma.io">
                        <img src="https://bulma.io/images/made-with-bulma.png" alt="Made with Bulma" width="128" height="24">
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </footer>


</body>
</html>

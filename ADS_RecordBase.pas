{ MADE BY GRACJAN MIKA }
{ COPYRIGHT (C) BY GRACJAN MIKA }
program ADS_RecordBase;

uses Crt,SysUtils;

  type
    tosoba = record
      czyAktywne:Boolean;
      imie:string[30];
      nazwisko:string[50];
      wiek:byte;
      pesel:string[11];
      email:string[40];
    end;
    osoba = Array of tosoba;

  function weryfikujMail(mail:String):Boolean;
  var
    czyPoprawny:Boolean;
  begin
    czyPoprawny := false;
    if((pos('@',mail) > 0) and (pos('.',mail) > 0) and (Length(mail) > 5)) then czyPoprawny := true;
    weryfikujMail := czyPoprawny;
  end;

  procedure dodajOs(var osoby:osoba;var liczbaOsob:Integer);
  var
    a:string;
    b:byte;
    czyJuzJest:Boolean;
    i,miejsce:integer;
  begin
    ClrScr;
    miejsce:=-1;
    if(length(osoby) > 0) then
    begin
      for i:=0 to (length(osoby)-1) do
      begin
        if(not osoby[i].czyAktywne) then
        begin
          miejsce:=i;
          break;
        end;
      end;
    end;

    if(miejsce = -1) then
    begin
      miejsce:=length(osoby);
      SetLength(osoby,(length(osoby)+1));
    end;

    writeln('+----------------------------------------------------+');
    writeln('|                  Dodaj nowa osobe                  |');
    writeln('+----------------------------------------------------+');
    osoby[miejsce].czyAktywne:=false;
    repeat
      writeln('+ Podaj imie');
      readln(a);
    until (length(a) > 2);
    a[1]:=UpCase(a[1]);
    osoby[miejsce].imie:=a;

    repeat
      writeln('+ Podaj nawisko');
      readln(a);
    until (length(a) > 2);
    a[1]:=UpCase(a[1]);
    osoby[miejsce].nazwisko:=a;

    repeat
      writeln('+ Podaj wiek');
      readln(b);
    until (b < 140);
    osoby[miejsce].wiek:=b;

    repeat
      czyJuzJest:=false;
      repeat
        writeln('+ Podaj PESEL (11 znakow)');
        readln(a);
        if (length(a) = 11) then for i:=1 to 11 do
        begin
          if((ord(a[i]) < 48) or (ord(a[i]) > 57)) then a:='000000000000';
        end;
      until (length(a) = 11);

      for i:=0 to (length(osoby)-1) do
      begin
        if(osoby[i].czyAktywne) then
        begin
          if(osoby[i].pesel = a) then
          begin
            writeln('+ Osoba o takim numerze PESEL juz istnieje!');
            czyJuzJest:=true;
            break;
          end;
        end;
      end;
    until (not czyJuzJest);
    osoby[miejsce].pesel:=a;

    repeat
      writeln('+ Podaj e-mail');
      readln(a);
    until (weryfikujMail(a));
    osoby[miejsce].email:=a;
    osoby[miejsce].czyAktywne := true;
    liczbaOsob:=liczbaOsob+1;
    ClrScr;
    writeln('+----------------------------------------------------+');
    writeln('|                 Dodano nowa osobe                  |');
    writeln('+----------------------------------------------------+');
    write('| IMIE: ',osoby[miejsce].imie:44);
    writeln(' |');
    write('| NAZWISKO: ',osoby[miejsce].nazwisko:40);
    writeln(' |');
    write('| WIEK: ',osoby[miejsce].wiek:44);
    writeln(' |');
    write('| PESEL: ',osoby[miejsce].pesel:43);
    writeln(' |');
    write('| E-MAIL: ',osoby[miejsce].email:42);
    writeln(' |');
    writeln('+----------------------------------------------------+');
    writeln();
    writeln('Aby wrocic do MENU, wcisnij ENTER');
    readln();
  end;

  procedure usunOsobe(var osoby:osoba;var liczbaOsob:Integer);
  var
    d:char;
    a:String;
    i:Integer;
    czyZnaleziono:Boolean;
  begin
    if(length(osoby) < 1) then exit;
    ClrScr;
    writeln('+----------------------------------------------------+');
    writeln('|                     Usun osobe                     |');
    writeln('+----------------------------------------------------+');
    repeat
      d := 'n';
      czyZnaleziono := false;
      repeat
        writeln('+ Podaj numer PESEL');
        readln(a);
      until (Length(a) = 11);

      for i:=0 to (Length(osoby)-1) do
      begin
        if(osoby[i].czyAktywne) then
        begin
          if(a = osoby[i].pesel) then
          begin
            czyZnaleziono := true;
            break;
          end;
        end;
      end;

      if(not czyZnaleziono) then
      begin
        writeln('+ Nie znaleziono osoby o takim numerze PESEL');
        writeln('+ Czy powtorzyc czynnosc usuwania?');
        writeln('+ Jesli tak wpisz: T, jesli nie, wcisnij ENTER, aby wrocic do MENU');
        readln(d);
      end;
    until (not (LowerCase(d) = 't'));
    if(czyZnaleziono) then
    begin
      ClrScr;
      writeln('+----------------------------------------------------+');
      writeln('|                     Usun osobe                     |');
      writeln('+----------------------------------------------------+');
      write('| IMIE: ',osoby[i].imie:44);
      writeln(' |');
      write('| NAZWISKO: ',osoby[i].nazwisko:40);
      writeln(' |');
      write('| WIEK: ',osoby[i].wiek:44);
      writeln(' |');
      write('| PESEL: ',osoby[i].pesel:43);
      writeln(' |');
      write('| E-MAIL: ',osoby[i].email:42);
      writeln(' |');
      writeln('+----------------------------------------------------+');
      repeat
        writeln('+ Czy na pewno chcesz usunac te osobe? T/N');
        readln(d);
      until ((LowerCase(d) = 't') or (LowerCase(d) = 'n'));
      if(LowerCase(d) = 't') then
      begin
        osoby[i].czyAktywne:=false;
        liczbaOsob:=liczbaOsob-1;
        writeln('+ USUNIETO!');
      end else writeln('+ ANULOWANO!');
      writeln();
      writeln('Aby wrocic do MENU, wcisnij ENTER');
      readln();
    end;
  end;

  procedure wyszukajOs(var osoby:osoba);
  var
    d:Char;
    a:String;
    i:Integer;
    znaleziono:Boolean;
  begin
    if(length(osoby) < 1) then exit;
    repeat
      ClrScr;
      writeln('+----------------------------------------------------+');
      writeln('|          Wyszukaj uzytkownika po nr PESEL          |');
      writeln('+----------------------------------------------------+');
      d:='n';
      znaleziono:=false;
      repeat
        writeln('+ Podaj numer PESEL');
        readln(a);
      until (Length(a) = 11);

      for i:=0 to (Length(osoby)-1) do
      begin
        if(osoby[i].pesel = a) then
        begin
          znaleziono:=true;
          break;
        end;
      end;

      if(znaleziono) then
      begin
        ClrScr;
        writeln('+----------------------------------------------------+');
        writeln('|          Wyszukaj uzytkownika po nr PESEL          |');
        writeln('+----------------------------------------------------+');
        write('| IMIE: ',osoby[i].imie:44);
        writeln(' |');
        write('| NAZWISKO: ',osoby[i].nazwisko:40);
        writeln(' |');
        write('| WIEK: ',osoby[i].wiek:44);
        writeln(' |');
        write('| PESEL: ',osoby[i].pesel:43);
        writeln(' |');
        write('| E-MAIL: ',osoby[i].email:42);
        writeln(' |');
        writeln('+----------------------------------------------------+');
      end else
      begin
        writeln('+ Nie ma takiego uzytkownika!');
      end;
      writeln();
      writeln('Aby powtorzyc wyszukiwanie wpisz: T');
      writeln('Aby wrocic do MENU wcisnij ENTER');
      readln(d);
    until (not (LowerCase(d) = 't'));
  end;

  procedure wyswietlPoNazwisku(var osoby:osoba);
  var
    i,j:Integer;
    temp:tosoba;
    zmieniono:Boolean;
  begin
    if(length(osoby) < 1) then exit;
    if(length(osoby) > 1) then
    begin
      i:=(Length(osoby)-1);
      repeat
        zmieniono:=false;
        for j:=1 to i do
        begin
          if(osoby[j-1].nazwisko > osoby[j].nazwisko) then
          begin
            temp:=osoby[j];
            osoby[j]:=osoby[j-1];
            osoby[j-1]:=temp;
            zmieniono:=true;
          end;
        end;
        i:=i-1;
      until ((i = 0) or (not zmieniono));
    end;

    i:=0;
    repeat
      ClrScr;
      writeln('+----------------------------------------------------+');
      writeln('|            Wyswietl rosnaco po nazwisku            |');
      writeln('+----------------------------------------------------+');
      for j:=i to (i+2) do
      begin
        if(j < Length(osoby)) then
        begin
          write('| IMIE: ',osoby[j].imie:44);
          writeln(' |');
          write('| NAZWISKO: ',osoby[j].nazwisko:40);
          writeln(' |');
          write('| WIEK: ',osoby[j].wiek:44);
          writeln(' |');
          write('| PESEL: ',osoby[j].pesel:43);
          writeln(' |');
          write('| E-MAIL: ',osoby[j].email:42);
          writeln(' |');
          writeln('+----------------------------------------------------+');
        end;
      end;
      i:=i+3;
      if(i < Length(osoby)) then
      begin
        writeln();
        write('Aby wyswietlic kolejna strone, wcisnij ENTER');
        readln();
      end;
    until (i >= Length(osoby));

    writeln();
    writeln('Aby wrocic do MENU, wcisnij ENTER');
    readln();
  end;

  function liczbaPelnoletnichOs(var osoby:osoba):Integer;
  var
    i,ilosc:Integer;
  begin
    ilosc:=0;
    for i:=0 to (Length(osoby)-1) do
    begin
      if(osoby[i].wiek >= 18) then ilosc:=ilosc + 1;
    end;
    liczbaPelnoletnichOs:=ilosc;
  end;

  procedure pelnoletnieOs(var osoby:osoba);
  begin
    if(length(osoby) < 1) then exit;
    ClrScr;
    writeln('+----------------------------------------------------+');
    writeln('|         Wyswietl liczbe osob pelnoletnich          |');
    writeln('+----------------------------------------------------+');
    write('| Liczba osob pelnoletnich: ',liczbaPelnoletnichOs(osoby):24);
    writeln(' |');
    writeln('+----------------------------------------------------+');
    writeln();
    writeln('Aby wrocic do MENU, wcisnij ENTER');
    readln();
  end;

  var
    d:byte;
    osoby:osoba;
    liczbaOs:Integer;

begin
  repeat
    ClrScr;
    if(Length(osoby) = 0) then liczbaOs:=0;
    writeln('+----------------------------------------------------+');
    writeln('|                        MENU                        |');
    writeln('+----------------------------------------------------+');
    write('| Liczba osob w bazie: ',liczbaOs:29);
    writeln(' |');
    writeln('+----------------------------------------------------+');
    writeln('| [1] Dodaj nowa osobe                               |');
    writeln('| [2] Usun osobe                                     |');
    writeln('| [3] Wyszukaj uzytkownika po nr PESEL               |');
    writeln('| [4] Wyswietl rosnaco po nazwisku                   |');
    writeln('| [5] Wyswietl liczbe osob pelnoletnich              |');
    writeln('|                                                    |');
    writeln('| [0] Aby wyjsc                                      |');
    writeln('+----------------------------------------------------+');
    writeln();
    readln(d);
    case d of
      1:dodajOs(osoby,liczbaOs);
      2:usunOsobe(osoby,liczbaOs);
      3:wyszukajOs(osoby);
      4:wyswietlPoNazwisku(osoby);
      5:pelnoletnieOs(osoby);
    end;
  until (d = 0);
end.


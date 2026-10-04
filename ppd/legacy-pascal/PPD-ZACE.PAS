PROGRAM Pre_Processador_Dlearn_01_12_2001;

Uses Graph, Crt, Geral { Unit Geral (GERAL.PAS) feita dia 20/11/2001 };

VAR
 IECHO, IEXEC, IACODE, IREADR, IWRITR, IPRTIN, IRANK, NUMSEQ, NDOUT ,NSD,
 NUMNP ,NDOF ,NLVECT, NLTFTN, NPTSLF, NUMEG, NUMGP, NGP, NGP2, N2, NINC1,
 NINC2, NINC3, INC1, INC2, INC3, NINC12, NINC22, NINC32, INC12, INC22,
 INC32, NINC13, NINC23, NINC33, INC13, INC23, INC33, M, MGEN, N3, N4, NE,
 NG, N5, N6, NTYPE, NUMEL, NUMAT, NSURF, NSOUT, IOPT, ISTPRT, LFSURF, LFBODY,
 NICODE, IBBAR, IMASS, IMEXP, IELNO, ISIDE, NINT, NEN, IHERM: Integer;

 N1, NSTEP, NDPRT, NSPRT, NHPLT, NITER, IDHIST1, IDHIST2, IDHIST3 , ID, IEN,
 NEL, INCEL, ISHIST, AUXI: Array[1..70] of Integer;

 ALPHA, BETA, GAMMA, DT, X1, X2, X3, Temp1, Temp2, Temp3, F, F2, F3, FK, E,
 POIS, RHO, RDAMPM, RDAMPK, TH, GRAV, PRESS, SHEAR, AREA: Array[1..70] of REAL;

 i, j, k, a, b, num, aux, aux2, aux3, aux4, aux5, aux6, aux7, aux8, aux9,
 controle, linhamod, colmod, ctrlinha, ctrnumeg, volta, var1: Integer;

 tipoele: real;

 Auxiliar:    String[05];
 Auxiliar2:   String[10];
 Nome:        String[12];
 Title,Titulo:String[80];
 Straux:      String;

 Linha: Array [1..150] of String[80];
 Cmenu: Array [1..050] of String[25];

 Arq:Text;
 Cte,sn:Char;
 Npos, NPos_ant, Ni:Integer;


{****************************Rotina de Gravação do 0}
PROCEDURE Grava0(l,p:Integer);
 Begin
   insert('0',linha[l],p);
 End;

{****************************Rotina de Gravação do 1}
PROCEDURE Grava1(l,p:Integer);
 Begin
    Insert('1',linha[l],p);
 End;

{****************************Rotina de Gravação do 2}
PROCEDURE Grava2(l,p:Integer);
 Begin
    Insert('2',linha[l],p);
 End;


{****************************Rotina de Gravação de um número qualquer 1}
PROCEDURE Gravareal(l,p:Integer);
 Begin
    Insert(auxiliar,linha[l],p);
 End;

{****************************Rotina de Gravação de um número qualquer 2}
PROCEDURE Gravareal2(l,p:Integer);
 Begin
    Insert(Auxiliar2,linha[l],p);
 End;


{****************************Rotina de definição de zeros }
PROCEDURE Defzeros(def:Real);

Var
  def2:real;

label fim;

 Begin
       def2:=int(def);
       if (def2=def) and (def<>0) then
         begin
           str(def:1:1,Auxiliar2);
           goto fim;
         end;
       if (def<=-100000) then
           str(def:1:1,Auxiliar2);
       if (def<=-10000) and (def>-100000) then
           str(def:2:2,Auxiliar2);
       if (def<=-1000) and (def>-10000) then
           str(def:3:3,Auxiliar2);
       if (def<=-100) and (def>-1000) then
           str(def:4:4,Auxiliar2);
       if (def<=-10) and (def>-100) then
           str(def:4:4,Auxiliar2);
       if (def<0) and (def>-10) then
           str(def:6:6,Auxiliar2);
       if (def=0) then
           str(def:2:2,Auxiliar2);
       if (def<10) and (def>0) then
           str(def:7:7,Auxiliar2);
       if (def<100) and (def>=10) then
           str(def:6:6,Auxiliar2);
       if (def<1000) and (def>=100) then
           str(def:4:4,Auxiliar2);
       if (def>=1000) and (def>10000) then
           str(def:3:3,Auxiliar2);
       if (def>=10000) and (def>100000) then
            str(def:2:2,Auxiliar2);
       if (def>=1000000) then
            str(def:1:1,Auxiliar2);
       FIM:
 End;







{****************************Rotina Linha 5.2 e 5.3 NUMGP diferente de zero}
PROCEDURE Linha52;
{** Geração de coordenadas nodais LINHA 5.2 **}
label inicio,meio;

 Begin
   aux5:=numgp-1;
   inicio:
   For i:=1 to aux5 do
    Begin
     Clrscr;
     MensC ('Cria arquivo de dados do DLEARN',26,2);
     MensC ('Linha 5.2: Dados para geração de coordenadas nodais',17,25);
     gotoxy(60,4);
     write ( 'Linha    :');
     gotoxy(60,6);
     write ( 'Variável :');
     gotoxy(71,4);
     write ('5.2');
     gotoxy (3,8);
     if numgp=2 then
       write ( ' Dados do ultimo ponto para geração linear das coordenadas nodais');
     if numgp<>2 then
      begin
       writeln ( ' Dados dos pontos para geração automática das coordenadas nodais');
       writeln ('  Obs.: Pontos no sentido Anti-Horario.');
      end;
     gotoxy(71,6);
     write ('TEMP(1,',i,')');
     gotoxy (3,11);
     write ( '    Coordenada X: ');
     readln(Temp1[ctrlinha]);
     Defzeros(Temp1[ctrlinha]);
     gravareal2(ctrlinha,11);
     gotoxyl(71,6);
     write ('TEMP(2,',i,')');
     gotoxy (3,13);
     write ( '    Coordenada Y: ');
     readln(Temp2[ctrlinha]);
     Defzeros(Temp2[ctrlinha]);
     gravareal2(ctrlinha,21);
     gotoxy(71,6);
     write ('TEMP(3,',i,')');
     gotoxy (3,15);
     write ( '    Coordenada Z: ');
     readln(Temp3[ctrlinha]);
     Defzeros(Temp3[ctrlinha]);
     gravareal2(ctrlinha,31);
     inc(ctrlinha);
    end;
   gotoxyl(70,6);
   gotoxyl(70,4);
   repeat
         gotoxyl(3,23);
         write (' Dados do(s) último(s) ',aux5,' ponto(s) de geração estão OK (S/N): ');
         sn:=readkey;
         writeln(sn);
   until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
   if (sn=chr(78)) or (sn=chr(110)) then
     begin
       Clrscr;
       MensC ('Cria arquivo de dados do DLEARN',26,2);
       gotoxy(61,4);
       write ( 'Linha    : ');
       gotoxy( 61,6);
       write ( 'Variável : ');
       gotoxy (12,12);
       textcolor(red);
       write (' Entrar novamente o(s) último(s) ',aux5,' ponto(s) de geração !!! ');
       normvideo;
       readkey;

       for i:=1 to aux5 do
              linha[ctrlinha-i]:=('                                                                               ');
       ctrlinha:=ctrlinha-aux5;

       goto inicio;
     end;
 { ** Incremento Nodal LINHA 5.3 ** }
   Meio:
   Clrscr;
   MensC ('Cria arquivo de dados do DLEARN',26,2);
   MensC ('Linha 5.3: Incremento Nodal',27,25);
   gotoxy(61,4);
   write ( 'Linha    : ');
   gotoxy( 61,6);
   write ( 'Variável : ');
   gotoxy(72,4);
   write ('5.3');
   gotoxyl(72,6);
   write ('NINC(1)');
   gotoxy (3,8);
   write ( ' Número de nós a mais para direção 1: ');
   readln(NINC1);
   str(NINC1,Auxiliar);
   gravareal(ctrlinha,1);
   gotoxyl(72,6);
   write ('INC(1)');
   gotoxy (3,10);
   write ( '  Incremento da numeração dos nós na direção 1: ');
   readln(INC1);
   str(INC1,Auxiliar);
   gravareal(ctrlinha,6);
   If numgp>2 then
    begin
      gotoxyl(72,6);
      write ('NINC(2)');
      gotoxy (3,12);
      write ( ' Número de nós a mais para direção 2: ');
      readln(NINC2);
      str(NINC2,Auxiliar);
      gravareal(ctrlinha,11);
      gotoxyl(72,6);
      write ('INC(2)');
      gotoxy (3,14);
      write ( '  Incremento da numeração dos nós na direção 2: ');
      readln(INC2);
      str(INC2,Auxiliar);
      gravareal(ctrlinha,16);
      gotoxyl(72,6);
    end;
   If numgp>3 then
    begin
      write ('NINC(3)');
      gotoxy (3,16);
      write ( ' Número de nós a mais para direção 3: ');
      readln(NINC3);
      str(NINC3,Auxiliar);
      gravareal(ctrlinha,21);
      gotoxyl(72,6);
      write ('INC(3)');
      gotoxy (3,18);
      write ( '  Incremento da numeração dos nós na direção 3: ');
      readln(INC3);
      str(INC3,Auxiliar);
      gravareal(ctrlinha,26);
    end;
    gotoxyl(72,6);
    gotoxyl(72,4);
    repeat
      gotoxyl(3,23);
      write (' Dados estão OK (S/N): ');
      sn:=readkey;
      writeln(sn);
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    if (sn=chr(78)) or (sn=chr(110)) then
     begin
      linha[ctrlinha]:=('                                                                               ');
      goto meio;
     end;
 End;


{****************************Rotina LINHA 7.2 e 7.3 NGP diferente de Zero}
PROCEDURE Linha72;

label inicio,meio;

 Begin
 {** Geração de coordenadas nodais LINHA 7.2 **}
  inicio:
  For i:=1 to (ngp-1) do
    Begin
       Clrscr;
       MensC ('Cria arquivo de dados do DLEARN',26,2);
       MensC (' Linha 7.2: Dados para geração de forças nodais e cond. cinemáticas impostas',4,25);
       gotoxy(60,4);
       write ( 'Linha   :');
       gotoxy(60,6);
       write ( 'Variável:');
       gotoxy(72,4);
       writeln ('7.2');
       j:=0;
       gotoxy (3,8);
       textcolor(red);
       write ( '» Linha de sequência da geração: ',i);
       normvideo;
       For k:=1 to ndof do
         begin
             gotoxyl(72,6);
             writeln ('F(',i,',',K,')');
             gotoxy (5,11+k);
             write ( 'Força prescrita/Cond. cinem. impostas do grau de liberdade ',k,': ');
             readln(F2[k]);
             Defzeros(F2[k]);
             gravareal2(ctrlinha,11+j);
             j:=j+10;
          end;
       inc(ctrlinha);
    End;
    gotoxyl(72,6);
    gotoxyl(72,4);
    repeat
       gotoxyl(3,23);
       write (' O(s) último(s) ',ngp-1,' dado(s) de geração estão OK (S/N): ');
       sn:=readkey;
       writeln(sn);
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    IF (sn=chr(78)) or (sn=chr(110)) then
      Begin
        Clrscr;
        MensC ('Cria arquivo de dados do DLEARN',26,2);
        gotoxy(60,4);
        write ( 'Linha    : ');
        gotoxy(60,6);
        write ( 'Variável : ');
        gotoxy (12,14);
        textcolor(red);
        write (' Entrar novamente com o(s) ',ngp-1,' dado(s) de geração !!! ');
        readkey;
        normvideo;
        for i:=1 to (ngp-1) do
          linha[ctrlinha-i]:=('                                                                               ');
        ctrlinha:=ctrlinha-(ngp-1);
        goto inicio;
      End;
    { ** Incremento Nodal LINHA 7.3 ** }
    Meio:
    Clrscr;
    MensC ('Cria arquivo de dados do DLEARN',26,2);
    MensC ('Linha 7.3: Incremento na geração ',24,25);
    gotoxy(60,4);
    write ( 'Linha   :');
    gotoxy(60,6);
    write ( 'Variável:');
    gotoxy(72,4);
    write ('7.3');
    gotoxyl(72,6);
    write ('NINC(1)');
    gotoxy (3,8);
    write ( ' Número de nós a mais para direção 1: ');
    readln(NINC12);
    str(NINC12,Auxiliar);
    gravareal(ctrlinha,1);
    gotoxyl(72,6);
    write ('INC(1)');
    gotoxy (3,10);
    write ( '  Incremento no número de nós na direção 1: ');
    readln(INC12);
    str(INC12,Auxiliar);
    gravareal(ctrlinha,6);
    IF ngp>2 then
       begin
           gotoxyl(72,6);
           write ('NINC(2)');
           gotoxy (3,12);
           write ( ' Número de nós a mais para direção 2: ');
           readln(NINC22);
           str(NINC22,Auxiliar);
           gravareal(ctrlinha,11);
           gotoxyl(72,6);
           write ('INC(2)');
           gotoxy (3,14);
           write ( ' Incremento no número de nós na direção 2: ');
           readln(INC22);
           str(INC22,Auxiliar);
           gravareal(ctrlinha,16);
       end;
    IF ngp>3 then
      begin
        gotoxyl(72,6);
        write ('NINC(3)');
        gotoxy (3,16);
        write ( ' Número de nós a mais para direção 3: ');
        readln(NINC32);
        str(NINC32,Auxiliar);
        gravareal(ctrlinha,21);
        gotoxyl(72,6);
        write ('INC(3)');
        gotoxy (3,18);
        write ( '  Incremento no número de nós na direção 3: ');
        readln(INC32);
        str(INC32,Auxiliar);
        gravareal(ctrlinha,26);
      end;
    gotoxyl(71,6);
    gotoxyl(71,4);
    repeat
        gotoxyl(3,24);
        write (' Dados estão OK (S/N): ');
        sn:=readkey;
        writeln(sn);
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    if (sn=chr(78)) or (sn=chr(110)) then
      begin
        linha[ctrlinha]:=('                                                                                  ');
        goto meio;
      end;

 End;


{ ***************************** Rotina LINHA 9 }
PROCEDURE Linha9;

label inicio,meio,fim,inicio2,meio2,labsn,labn5;

 Begin
    aux7:=0;
    aux8:=0;
    aux9:=0;
    Clrscr;
    MensC ('Cria arquivo de dados do DLEARN',26,2);
    MensC ('Linha 9: Condições Cinemáticas Iniciais ',22,25);
    gotoxy(60,4);
    write ( 'Linha    : ');
    gotoxy(60,6);
    write ( 'Variável : ');
    gotoxy(71,4);
    writeln ('9');
    repeat
        gotoxyl(3,8);
        write (' Existe alguma condição cinemática inicial (S/N): ');
        sn:=readkey;
        writeln(sn);
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    if (sn=chr(78)) or (sn=chr(110)) then
     begin
        aux6:=1;
        goto meio;
     end;
    repeat
        gotoxyl(3,10);
        write ('   Existe condição cinemática inicial de Deslocamento (S/N): ');
        sn:=readkey;
        writeln(sn);
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    if (sn=chr(115)) or (sn=chr(83)) then
        aux7:=1;
    repeat
        gotoxyl(3,12);
        write ('   Existe condição cinemática inicial de Velocidade   (S/N): ');
        sn:=readkey;
        writeln(sn);
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    if (sn=chr(115)) or (sn=chr(83)) then
        aux8:=1;
    repeat
        gotoxyl(3,14);
        write ('   Existe condição cinamática inicial de Aceleração   (S/N): ');
        sn:=readkey;
        writeln(sn);
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    if (sn=chr(115)) or (sn=chr(83)) then
        aux9:=1;
    meio:
    If aux6=1 then
      Begin
        linha[ctrlinha]:=('                                                                               ');
        inc(ctrlinha);
        linha[ctrlinha]:=('                                                                               ');
        inc(ctrlinha);
        linha[ctrlinha]:=('                                                                               ');
        inc(ctrlinha);
        goto fim;
      End;

    Repeat
        IF aux7=1 then
          begin
            aux7:=2;
            straux:='Deslocamento';
            goto labn5;
          end
          else
           begin
            if aux7<>2 then
              begin
                linha[ctrlinha]:=('                                                                               ');
                inc(ctrlinha);
                aux7:=2;
              end;
           end;

        IF aux8=1 then
          begin
            aux8:=2;
            straux:='Velocidade';
            goto labn5;
          end
          else
           begin
            if aux8<>2 then
              begin
                linha[ctrlinha]:=('                                                                               ');
                inc(ctrlinha);
                aux8:=2;
              end;
           end;

        IF aux9=1 then
          begin
            aux9:=2;
            straux:='Aceleração';
            goto labn5;
          end
          else
           begin
            if aux9<>2 then
              begin
                linha[ctrlinha]:=('                                                                               ');
                inc(ctrlinha);
                aux9:=2;
                goto labsn;
              end;
           end;
      labn5:
        Clrscr;
        MensC ('Cria arquivo de dados do DLEARN',26,2);
        MensC ('Linha 9.1: Condições Nodais Iniciais ',22,25);
        gotoxy(60,4);
        write ( 'Linha    : ');
        gotoxy (13,6);
        write ( ' » Condições iniciais para ',straux);
        gotoxy(60,6);
        write ( 'Variável : ');
        gotoxy(71,4);
        write ('9.1');
        gotoxyl(71,6);
        write ('N');
        repeat
          gotoxyl(3,8);
          write ( ' Número do nó: ');
          readln(N5);
        until (N5<=Numnp) and (N5>=1);
        str(N5,Auxiliar);
        gravareal(ctrlinha,1);
        gotoxyl(71,6);
        write ('NUMGP');
        repeat
          gotoxy (5,11);
          writeln (' Obs.: (0) Sem geração');
          gotoxy (12,12);
          writeln ('(2) Interpolação Linear');
          gotoxy (12,13);
          writeln ('(3) Interpolação Quadrática');
          gotoxy (12,14);
          writeln ('(4) Interpolação Bi-Linear (sobre superfície)');
          gotoxy (12,15);
          writeln ('(8) Interpolação Bi-Quadrática ou Tri-linear');
          gotoxy (12,16);
          writeln ('(20) Interpolação Tri-Quadrática');
          gotoxyl (3,10);
          write ( '   Tipo de geração: ');
          readln(NGP2);
        until (ngp2=0) or (ngp2=2) or (ngp2=3) or (ngp2=4) or (ngp2=8) or (ngp2=20);
        str(NGP2,Auxiliar);
        gravareal(ctrlinha,6);
        j:=0;
        for i:=1 to ndof do
          begin
             gotoxyl(71,6);
             write ('F(1,',i,')');
             gotoxy (3,17+i);
             write ( ' Condição inicial do grau de liberdade ',i,': ');
             readln(F3[i]);
             Defzeros(F3[i]);
             gravareal2(ctrlinha,11+j);
             j:=j+10;
          end;
        gotoxyl(71,6);
        gotoxyl(71,4);
        repeat
          gotoxyl(3,24);
          write (' Dados estão OK (S/N): ');
          sn:=readkey;
          writeln(sn);
        until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
        if (sn=chr(78)) or (sn=chr(110)) then
          begin
            linha[ctrlinha]:=('                                                                                ');
            goto labn5;
          end;
        If NGP2=0 then
          Begin
            repeat
              gotoxyl(3,24);
              write (' Terminou a entrada das cond. iniciais de ',straux,' (S/N): ');
              sn:=readkey;
              writeln(sn);
            until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
            if (sn=chr(78)) or (sn=chr(110)) then
              begin
               inc(ctrlinha);
               goto labn5;
              end;
            if (sn=chr(115)) or (sn=chr(83)) then
              begin
               inc(ctrlinha);
               linha[ctrlinha]:=('                                                                               ');
               inc(ctrlinha);
              end;
          End;

   {***************** TELA 12 }
   { ** Dados para geração de condições iniciais dos nós LINHA 9.2 ** }

        If NGP2<>0 then
          BEGIN
           inc(ctrlinha);
           inicio2:
           For i:=1 to (ngp2-1) do
             Begin
               Clrscr;
               MensC ('Cria arquivo de dados do DLEARN',26,2);
               MensC ('Linha 9.2: Dados para geração de condições iniciais nodais',10,25);
               gotoxy(60,4);
               write ( 'Linha    :');
               gotoxy(60,6);
               write ( 'Variável :');
               gotoxy(71,4);
               writeln ('9.2');
               gotoxy (3,8);
               textcolor(red);
               write ( '» Linha de sequência da geração: ',i);
               normvideo;
               j:=0;
               k:=0;
               For k:=1 to ndof do
                begin
                  gotoxyl(71,6);
                  writeln ('F(',i,',',K,')');
                  gotoxy (5,11+k);
                  write ( ' Condição inicial do grau de liberdade ',k,': ');
                  readln(F3[k]);
                  str(F3[k]:5:5,Auxiliar2);
                  gravareal2(ctrlinha,11+j);
                  j:=j+10;
                end;
               inc(ctrlinha);
             End;
             gotoxyl(71,6);
             gotoxyl(71,4);
             repeat
                gotoxyl(3,23);
                write (' O(s) último(s) ',ngp2-1,' dado(s) de geração estão OK (S/N): ');
                sn:=readkey;
                writeln(sn);
             until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
             IF (sn=chr(78)) or (sn=chr(110)) then
               Begin
                  Clrscr;
                  MensC ('Cria arquivo de dados do DLEARN',26,2);
                  gotoxy(60,4);
                  write ( 'Linha    : ');
                  gotoxy(60,6);
                  write ( 'Variável : ');
                  gotoxy (12,14);
                  textcolor(red);
                  write (' Entrar novamente com o(s) ',ngp2-1,' dado(s) de geração !!! ');
                  readkey;
                  normvideo;
                  for i:=1 to (ngp2-1) do
                    linha[ctrlinha-i]:=('                                                                               ');

                  ctrlinha:=ctrlinha-(ngp2-1);
                  goto inicio2;
               End;

             { ** Incremento Nodal LINHA 9.3 ** }
             Meio2:
             Clrscr;
             MensC ('Cria arquivo de dados do DLEARN',26,2);
             MensC ('Linha 9.3: Incremento na geração ',18,25);
             gotoxy(60,4);
             write ( 'Linha    :');
             gotoxy(60,6);
             write ( 'Variável :');
             gotoxy(71,4);
             write ('9.3');
             gotoxyl(71,6);
             write ('NINC(1)');
             gotoxy (3,8);
             write ( ' Número de condições nodais iniciais a mais para direção 1: ');
             readln(NINC13);
             str(NINC13,Auxiliar);
             gravareal(ctrlinha,1);
             gotoxyl(71,6);
             write ('INC(1)');
             gotoxy (3,10);
             write ( '  Incremento de condições nodais na direção 1: ');
             readln(INC13);
             str(INC13,Auxiliar);
             gravareal(ctrlinha,6);
             IF ngp2>2 then
               begin
                 gotoxyl(71,6);
                 write ('NINC(2)');
                 gotoxy (3,12);
                 write ( ' Número de condições nodais iniciais a mais para direção 2: ');
                 readln(NINC23);
                 str(NINC23,Auxiliar);
                 gravareal(ctrlinha,11);
                 gotoxyl(71,6);
                 write ('INC(2)');
                 gotoxy (3,14);
                 write ( '  Incremento de condições nodais na direção 2: ');
                 readln(INC23);
                 str(INC23,Auxiliar);
                 gravareal(ctrlinha,16);
               end;
             IF ngp2>3 then
               begin
                 gotoxyl(72,6);
                 write ('NINC(3)');
                 gotoxy (3,16);
                 write ( ' Número de condições nodais iniciais a mais para direção 3: ');
                 readln(NINC33);
                 str(NINC33,Auxiliar);
                 gravareal(ctrlinha,21);
                 gotoxyl(71,6);
                 write ('INC(3)');
                 gotoxy (3,18);
                 write ( ' Incremento de forca/cond. de contorno na direção 3: ');
                 readln(INC33);
                 str(INC33,Auxiliar);
                 gravareal(ctrlinha,26);
               end;
               gotoxyl(71,6);
               gotoxyl(71,4);
               repeat
                 gotoxyl(3,24);
                 write (' Dados estão OK (S/N): ');
                 sn:=readkey;
                 writeln(sn);
               until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
               if (sn=chr(78)) or (sn=chr(110)) then
                 begin
                   linha[ctrlinha]:=('                                                                               ');
                   goto meio2;
                 end;

           repeat
             gotoxyl(3,24);
             write (' Terminou a entrada das cond. iniciais de ',straux,' (S/N): ');
             sn:=readkey;
             writeln(sn);
           until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
           if (sn=chr(78)) or (sn=chr(110)) then
             begin
               inc(ctrlinha);
               goto labn5;
             end;
           if (sn=chr(115)) or (sn=chr(83)) then
             begin
              inc(ctrlinha);
              linha[ctrlinha]:=('                                                                                ');
              inc(ctrlinha);
             end;

          END;

     labsn:
    until (aux9=2);

  fim:
 End;




{****************************Rotina completa da Linha 10.1}
PROCEDURE Linha101;

Label Ilinha1011,Ilinha1012,Flinha1012,Flinha1013,Ilinha1014,Mlinha1014,
Ilinha1015,Ilinha1016,lablinha1016;

Begin

  { ***************** TELA 13 }
  { **** Controle de grupo de elemento LINHA 10.1.1  ***** }
     Ilinha1011:
     Clrscr;
     MensC ('Cria arquivo de dados do DLEARN',26,2);
     MensC ('Linha 10.1.1: Grupo de Elementos de CHAPA ',18,25);
     gotoxy(60,4);
     write ( 'Linha   : ');
     gotoxy( 60,6);
     write ( 'Variável: ');
     gotoxy(70,4);
     write ('10.1.1');
     NTYPE:=1;
     str(NTYPE,Auxiliar);
     gravareal(ctrlinha,1);
     gotoxy(70,6);
     write ('NUMEL');
     gotoxy (3,8);
     write ( ' Número de elementos deste grupo: ');
     readln(NUMEL);
     str(NUMEL,Auxiliar);
     gravareal(ctrlinha,6);
     gotoxyl(70,6);
     write ('NUMAT');
     gotoxy (3,10);
     write ( ' Número de materiais deste grupo: ');
     readln(NUMAT);
     str(NUMAT,Auxiliar);
     gravareal(ctrlinha,11);
     gotoxyl(70,6);
     write ('NSURF');
     gotoxy (3,12);
     write ( ' Número de forças de superfície deste grupo: ');
     readln(NSURF);
     str(NSURF,Auxiliar);
     gravareal(ctrlinha,16);
     if (IACODE<>1) then
       begin
          gotoxyl(70,6);
          write ('NSOUT');
          gotoxy (3,14);
          write ( ' Número de histórias Tensão / Deformação: ');
          readln(NSOUT);
          str(NSOUT,Auxiliar);
          gravareal(ctrlinha,21);
       end
       else
        begin
          NSOUT:=0;
          str(NSOUT,Auxiliar);
          gravareal(ctrlinha,21);
        end;
     gotoxyl(70,6);
     write ('IOPT');
     repeat
        gotoxy (10,17);
        writeln (' (0) Estado plano de tensões');
        gotoxy (10,18);
        writeln (' (1) Estado plano de deformações');
        gotoxy (10,19);
        writeln (' (2) Sem torção axisimétrica');
        gotoxyl(3,16);
        write ( ' Opção de Análise: ');
        sn:=readkey;
        writeln(sn);
     until ( (sn=chr(48)) or (sn=chr(49)) or (sn=chr(50)) );
     if sn=chr(48) then
        iopt:=0;
     if sn=chr(49) then
        iopt:=1;
     if sn=chr(50) then
        iopt:=2;
     str(IOPT,Auxiliar);
     gravareal(ctrlinha,26);

  { ***************** TELA 14 }
  { ** Controle de grupo de elemento LINHA 10.1.1 **  CONT....}
     Clrscr;
     MensC ('Cria arquivo de dados do DLEARN',26,2);
     MensC ('Linha 10.1.1: Grupo de Elementos de CHAPA ',18,25);
     gotoxy(60,4);
     write ( 'Linha   : ');
     gotoxy( 60,6);
     write ( 'Variável: ');
     gotoxy(70,4);
     write ('10.1.1');
     gotoxyl(70,6);
     write ('ISTPRT');
     repeat
        gotoxyl(3,8);
        write ( ' Deseja que seja impressa a saída de Tensões (S/N): ');
        sn:=readkey;
        writeln(sn);
     until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
     if (sn=chr(83)) or (sn=chr(115)) then
        begin
         grava0(ctrlinha,31); {opção sim}
         ISTPRT:=0;
        end;
      if (sn=chr(78)) or (sn=chr(110)) then
        begin
          grava1(ctrlinha,31); {opção não}
          ISTPRT:=1;
        end;

      gotoxyl(70,6);
      write ('LFSURF');
      repeat
        If (LFSURF>NLTFTN) then
          begin
            gotoxy(08,13);
            textcolor(red);
            writeln (' Atenção !!!! O número deve ser uma Função no Tempo existente. ');
            readkey;
            normvideo;
            gotoxyl(1,13);
          end;
        gotoxyl (3,10);
        write ( ' Número da função já existente de carga de forças de superfície: ');
        readln(LFSURF);
      until (LFSURF<=NLTFTN) and (LFSURF>=0);
      str(LFSURF,Auxiliar);
      gravareal(ctrlinha,36);
      gotoxyl(70,6);
      write ('LFBODY');
      repeat
        If (LFBODY>NLTFTN) then
          begin
            gotoxy(08,15);
            textcolor(red);
            writeln (' Atenção !!!! O número deve ser uma Função no Tempo existente. ');
            readkey;
            normvideo;
            gotoxyl(1,15);
          end;
      gotoxyl (3,12);
      write ( ' Número da função já existente de carga de forças volumétricas: ');
      readln(LFBODY);
      until (LFBODY<=NLTFTN) and (LFBODY>=0);
      str(LFBODY,Auxiliar);
      gravareal(ctrlinha,41);
      gotoxyl(70,6);
      write ('NICODE');
      repeat
        gotoxy (10,15);
        writeln (' (0) Quadratura Gaussiana 2x2 (Obrigatório no caso estático)');
        gotoxy (10,16);
        writeln (' (1) Quadratura Gaussiana de 1 ponto');
        gotoxyl(3,14);
        write ( ' Código de Integração Numérica: ');
        sn:=readkey;
        writeln(sn);
      until ( (sn=chr(48)) or (sn=chr(49)) );
      if sn=chr(48) then
         NICODE:=0;
      if sn=chr(49) then
         begin
            gotoxy (4,18);
            textcolor(white);
            writeln ('Atenção !!! Ao escolher esta opção deve se estar certo do que esta fazendo.');
            writeln;
            write ('       Deseja continuar com Quadratura Gaussiana de 1 ponto ? (S/N)');
            sn:=readkey;
            normvideo;
            gotoxyl(1,18);
            gotoxyl(1,19);
            gotoxyl(1,20);
            if (sn=chr(115)) or (sn=chr(83)) then
              NICODE:=1;
            If (sn=chr(78)) or (sn=chr(110)) then
              begin
                gotoxy (10,18);
                write ('MODIFICADO PARA IOPT = 0 ( Quadratura Gaussiana 2 x 2 )');
                readkey;
                NICODE:=0;
                gotoxyl(1,18);
              end;
         end;
      str(NICODE,Auxiliar);
      gravareal(ctrlinha,46);
      gotoxyl(70,6);
      write ('IBBAR');
      repeat
        gotoxyl(10,19);
        writeln (' (0) Formulação padrão');
        gotoxyl(10,20);
        writeln (' (1) Formulação de deformação principal; ( B-barra )');
        gotoxyl(3,18);
        write ( ' Opção de deformação / deslocamento: ');
        sn:=readkey;
        writeln(sn);
      until ( (sn=chr(48)) or (sn=chr(49)) );
      if sn=chr(48) then
        IBBAR:=0;
      if sn=chr(49) then
        IBBAR:=1;
      str(IBBAR,Auxiliar);
      gravareal(ctrlinha,51);

  { ***************** TELA 15 }
  { * Controle de grupo de elemento LINHA 10.1.1 **  CONT....}
      Clrscr;
      MensC ('Cria arquivo de dados do DLEARN',26,2);
      MensC ('Linha 10.1.1: Grupo de Elementos de CHAPA ',18,25);
      gotoxy(60,4);
      write ( 'Linha   : ');
      gotoxy(60,6);
      write ( 'Variável: ');
      gotoxy(70,4);
      write ('10.1.1');
      gotoxyl(70,6);
      write ('IMASS');
      repeat
        gotoxy (10,9);
        writeln (' (0) Matriz de massa consistente');
        gotoxy (10,10);
        writeln (' (1) Matriz de massa concentrada');
        gotoxy (10,11);
        writeln (' (2) Matriz de massa inexistente');
        gotoxyl(3,8);
        write ( ' Código de matriz de massa: ');
        sn:=readkey;
        writeln(sn);
      until ( (sn=chr(48)) or (sn=chr(49)) or (sn=chr(50)) );
      if sn=chr(48) then
        IMASS:=0;
      if sn=chr(49) then
         IMASS:=1;
      if sn=chr(50) then
         IMASS:=2;
      str(IMASS,Auxiliar);
      gravareal(ctrlinha,56);
      gotoxyl(70,6);
      write ('IMPEXP');
      repeat
        gotoxy (10,14);
        writeln (' (0) Grupo de elemento implicito ');
        gotoxy (10,15);
        writeln (' (1) Grupo de elemento explicito');
        gotoxyl(3,13);
        write ( ' Código Implicito / Explicito: ');
        sn:=readkey;
        writeln(sn);
      until ( (sn=chr(48)) or (sn=chr(49)) );
      if sn=chr(48) then
        IMEXP:=0;
      if sn=chr(49) then
        IMEXP:=1;
      str(IMEXP,Auxiliar);
      gravareal(ctrlinha,61);
      gotoxyl(70,6);
      gotoxyl(70,4);
      repeat
         gotoxyl(3,24);
         write (' Dados estão OK (S/N): ');
         sn:=readkey;
         writeln(sn);
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
        begin
          linha[ctrlinha]:=('                                                                               ');
          goto Ilinha1011;
        end;
      inc(ctrlinha);

  { ***************** TELA 16 }
  { ** Propriedades dos Materiais LINHA 10.1.2 }
      For i:=1 to numat do
        Begin
         Ilinha1012:
         Clrscr;
         MensC ('Cria arquivo de dados do DLEARN',26,2);
         MensC ('Linha 10.1.2: Propriedades dos Materiais ',20,25);
         gotoxy(60,4);
         write ( 'Linha   : ');
         gotoxy( 60,6);
         write ( 'Variável: ');
         gotoxy(70,4);
         write ('10.1.2');
         gotoxy(3,8);
         textcolor(red);
         write (' Material número : ',i);
         normvideo;
         M:=i;
         str(M,Auxiliar);
         gravareal(ctrlinha,1);
         gotoxyl(70,6);
         write ('E(',i,')');
         gotoxy (3,10);
         write ( '    Módulo de elasticidade: ');
         readln(E[i]);
         defzeros(E[i]);
         gravareal2(ctrlinha,11);
         gotoxyl(70,6);
         write ('POIS(',i,')');
         repeat
           gotoxyl(1,15);
           gotoxyl(3,12);
           write ( '    Coeficiente de Poisson: ');
           readln(POIS[i]);
           If POIS[i]=0.5 then
             begin
               gotoxy(7,15);
               textcolor(red);
               write (' O coeficiente de poisson não pode ser 0.5 ( DIVISÃO POR ZERO ) !!! ');
               readkey;
               normvideo;
             end;
         until (POIS[i]>0) and (POIS[i]<0.5);
         str(POIS[i]:7:7,Auxiliar2);
         gravareal2(ctrlinha,21);
         gotoxyl(70,6);
         write ('RHO(',i,')');
         gotoxy (3,14);
         write ( '    Densidade: ');
         readln(RHO[i]);
         defzeros(RHO[i]);
         gravareal2(ctrlinha,31);
         gotoxyl(70,6);
         write ('RDAMPM(',i,')');
         gotoxy (3,16);
         write ( '    Coeficiente de amortecimento de Rayleigh na matriz de massa: ');
         readln(RDAMPM[i]);
         defzeros(RDAMPM[i]);
         gravareal2(ctrlinha,41);
         gotoxyl(70,6);
         write ('RDAMPK(',i,')');
         gotoxy (3,18);
         write ( '    Coeficiente de amortecimento de Rayleigh na matriz de rigidez: ');
         readln(RDAMPK[i]);
         defzeros(RDAMPK[i]);
         gravareal2(ctrlinha,51);
         gotoxyl(70,6);
         write ('TH(',i,')');
         gotoxy (3,20);
         write ( '    Espessura: ');
         readln(TH[i]);
         defzeros(TH[i]);
         gravareal2(ctrlinha,61);
         gotoxyl(70,6);
         gotoxyl(70,4);
         repeat
           gotoxyl(3,24);
           write (' Dados estão OK (S/N): ');
           sn:=readkey;
           writeln(sn);
         until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
         if (sn=chr(78)) or (sn=chr(110)) then
           begin
             linha[ctrlinha]:=('                                                                               ');
             goto Ilinha1012;
           end;
         inc(ctrlinha);
       End;

  { ***************** TELA 17 }
  { ** Vetor Gravitacional LINHA 10.1.3 }
      If LFBODY=0 then
        goto flinha1013;
      Clrscr;
      MensC ('Cria arquivo de dados do DLEARN',26,2);
      MensC ('Linha 10.1.3: Vetor Gravitacional ',19,25);
      gotoxy(60,4);
      write ( 'Linha   : ');
      gotoxy(60,6);
      write ( 'Variável: ');
      gotoxy(70,4);
      write ('10.1.3');
      gotoxyl(70,6);
      write ('GRAV(1)');
      gotoxy (3,10);
      write (' Componente do vetor gravitacional na direção X: ' );
      readln(GRAV[1]);
      defzeros(GRAV[1]);
      str(GRAV[1]:3:3,Auxiliar2);
      gravareal2(ctrlinha,1);
      gotoxyl(70,6);
      write ('GRAV(2)');
      gotoxy (3,12);
      write (' Componente do vetor gravitacional na direção Y: ' );
      readln(GRAV[2]);
      defzeros(GRAV[2]);
      gravareal2(ctrlinha,11);
      Flinha1013:

  { ***************** TELA 18 }
  { ** Definição de elementos LINHA 10.1.4 }
      Ilinha1014:
      inc(ctrlinha);
      Clrscr;
      MensC ('Cria arquivo de dados do DLEARN',26,2);
      MensC ('Linha 10.1.4: Definição de elementos ',19,25);
      gotoxy(60,4);
      write ( 'Linha   : ');
      gotoxy(60,6);
      write ( 'Variável: ');
      gotoxy(70,4);
      write ('10.1.4');
      gotoxy(70,6);
      write ('N');
      repeat
        gotoxyl(3,8);
        write (' Número do elemento: ' );
        readln(N6);
      until (N6<=NUMEL) and (N6>=1);
      str(N6,Auxiliar);
      gravareal(ctrlinha,1);
      gotoxy(70,6);
      write ('M');
      repeat
        gotoxyl(3,10);
        write (' Número do Material: ' );
        readln(M);
      until (M<=NUMAT) and (M>=1);
      str(M,Auxiliar);
      gravareal(ctrlinha,6);
      j:=0;
      gotoxy(12,17);
      write ( ' Os nós devem entrar no sentido ANTI-HORÁRIO ' );
      For i:=1 to 4 do
       begin
         gotoxy(71,6);
         write ('IEN(',i,',',N6,')');
         repeat
           gotoxyl(3,11+i);
           write ('   Número do ',i,'º  nó: ');
           readln(IEN[i]);
         until (IEN[i]<=NUMNP) and (IEN[i]>=1);
         str(IEN[i],Auxiliar);
         gravareal(ctrlinha,11+J);
         j:=j+5;
       end;
      gotoxyl(1,17);
      gotoxyl(70,6);
      write ('NG');
      repeat
        gotoxy (10,19);
        writeln (' (0) Não faz geração automática');
        gotoxy (10,20);
        writeln (' (1) Faz geração automática');
        gotoxyl(3,18);
        write ( ' Código de geração (0/1): ');
        sn:=readkey;
        writeln(sn);
      until ( (sn=chr(48)) or (sn=chr(49)) );
      if sn=chr(48) then
        NG:=0;
      if sn=chr(49) then
        NG:=1;
      str(NG,Auxiliar);
      gravareal(ctrlinha,31);
      gotoxyl(70,6);
      gotoxyl(70,4);
      repeat
        gotoxyl(3,24);
        write (' Dados estão OK (S/N): ');
        sn:=readkey;
        writeln(sn);
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
        begin
           linha[ctrlinha]:=('                                                                               ');
           ctrlinha:=ctrlinha-1;
            goto Ilinha1014;
        end;
      inc(ctrlinha);
      If NG=0 then
        Begin
         repeat
            gotoxyl(3,24);
            write (' Terminou a entrada das definições dos elemento  (S/N): ');
             sn:=readkey;
             writeln(sn);
         until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
         if (sn=chr(78)) or (sn=chr(110)) then
             goto Ilinha1014;
        End;

  { ***************** TELA 19 }
  { * Definição do Número de elementos LINHA 10.1.4.2 }
      If NG=1 then
       Begin
        Mlinha1014:
        Clrscr;
        MensC ('Cria arquivo de dados do DLEARN',26,2);
        MensC ('Linha 10.1.4.2: Definição de elementos ',19,25);
        gotoxy(60,4);
        write ( 'Linha   : ');
        gotoxy(60,6);
        write ( 'Variável: ');
        gotoxy(70,4);
        write ('10.1.4');
        gotoxy(70,6);
        write ('NEL');
        gotoxy (3,8);
        write ( ' Número de elementos a mais na direção 1: ');
        readln(NEL[1]);
        str(NEL[1],Auxiliar);
        gravareal(ctrlinha,1);
        gotoxyl(70,6);
        write ('INCEL(1)');
        gotoxy (3,10);
        write ( '  Incremento do número de elementos para direção 1: ');
        readln(INCEL[1]);
        str(INCEL[1],Auxiliar);
        gravareal(ctrlinha,6);
        gotoxyl(70,6);
        write ('INC(1)');
        gotoxy (3,12);
        write ( ' Incremento de nós para direção 1: ');
        readln(INC1);
        str(INC1,Auxiliar);
        gravareal(ctrlinha,11);
        gotoxyl(70,6);
        write ('NEL(2)');
        gotoxy (3,14);
        write ( ' Número de elementos a mais na direção 2: ');
        readln(NEL[2]);
        str(NEL[2],Auxiliar);
        gravareal(ctrlinha,16);
        gotoxyl(70,6);
        write ('INCEL(2)');
        gotoxy (3,16);
        write ( '  Incremento do número de elementos para direção 2: ');
        readln(INCEL[2]);
        str(INCEL[2],Auxiliar);
        gravareal(ctrlinha,21);
        gotoxyl(70,6);
        write ('INC(2)');
        gotoxy (3,18);
        write ( ' Incremento de nós para direção 2: ');
        readln(INC2);
        str(INC2,Auxiliar);
        gravareal(ctrlinha,26);
        gotoxyl(70,6);
        gotoxyl(70,4);
        repeat
          gotoxyl(3,23);
          write (' Dados estão OK (S/N): ');
          sn:=readkey;
          writeln(sn);
        until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
        if (sn=chr(78)) or (sn=chr(110)) then
         begin
           linha[ctrlinha]:=('                                                                               ');
           goto Mlinha1014;
         end;
      End;
      repeat
        gotoxyl(3,24);
        write (' Terminou a entrada de dados dos elementos desse grupo (S/N): ');
        sn:=readkey;
        writeln(sn);
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
          goto Ilinha1014;
      inc(ctrlinha);
      linha[ctrlinha]:=('                                                                                  ');
      inc(ctrlinha);

  { ***************** TELA 20 }
  { * Leitura da Superfície do Elemento LINHA 10.1.5 }
      For k:=1 to NSURF do
       Begin
         ILinha1015:
         Clrscr;
         MensC ('Cria arquivo de dados do DLEARN',26,2);
         MensC ('Linha 10.1.5: Dados da Superfície do Elemento  ',19,25);
         gotoxy(60,4);
         write ( 'Linha   : ');
         gotoxy(60,6);
         write ( 'Variável: ');
         gotoxy(70,4);
         write ('10.1.5');
         gotoxyl(70,6);
         write ('IELNO(',K,')');
         gotoxy(3,8);
         textcolor(red);
         write (' Superfície número :',k);
         normvideo;
         repeat
            gotoxyl(3,10);
            write ('   Número do elemento: ' );
            readln(IELNO);
         until (IELNO<=NUMEL) and (IELNO>=1);
         str(IELNO,Auxiliar);
         gravareal(ctrlinha,1);
         gotoxyl(70,6);
         write ('ISIDE(',K,')');
         gotoxy(7,14);
         writeln (' Obs.: Seguindo a numeração dos nós no elemento.');
         repeat
            gotoxyl(3,12);
            write ('   Lado do elemento (1 a 4): ' );
            readln(ISIDE);
         until (ISIDE<=4) and (ISIDE>=1);
         str(ISIDE,Auxiliar);
         gravareal(ctrlinha,6);
         gotoxyl(1,14);
         gotoxyl(70,6);
         write ('PRESS(1,',K,')');
         gotoxy (3,14);
         write ('   Pressão no nó inicial: ' );
         readln(PRESS[1]);
         defzeros(PRESS[1]);
         gravareal2(ctrlinha,11);
         gotoxy(70,6);
         write ('PRESS(2,',K,')');
         gotoxy (3,16);
         write ('   Pressão no nó final: ' );
         readln(PRESS[2]);
         str(PRESS[2]:3:3,Auxiliar2);
         defzeros(PRESS[2]);
         gravareal2(ctrlinha,21);
         gotoxyl(70,6);
         write ('SHEAR(1,',K,')');
         gotoxy (3,18);
         write ('   Tensão tangencial no nó inicial: ' );
         readln(SHEAR[1]);
         defzeros(SHEAR[1]);
         gravareal2(ctrlinha,31);
         gotoxy(70,6);
         write ('SHEAR(2,',K,')');
         gotoxy (3,20);
         write ('   Tensão tangencial no nó final: ' );
         readln(SHEAR[2]);
         defzeros(SHEAR[2]);
         gravareal2(ctrlinha,41);
         gotoxyl(70,6);
         gotoxyl(70,4);
         repeat
            gotoxyl(3,23);
            write (' Dados estão OK (S/N): ');
            sn:=readkey;
            writeln(sn);
         until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
         if (sn=chr(78)) or (sn=chr(110)) then
          begin
            linha[ctrlinha]:=('                                                                               ');
            goto Ilinha1015;
          end;
         inc(ctrlinha);
       End;

  { ***************** TELA 21 }
  { * Dados de história no tempo dos elementos LINHA 10.1.6 }
      Lablinha1016:
      For i:=1 to NSOUT do
        Begin
          Ilinha1016:
          Clrscr;
          MensC ('Cria arquivo de dados do DLEARN',26,2);
          MensC ('Linha 10.1.6: Dados de história no tempo dos elementos  ',19,25);
          gotoxy(60,4);
          write ( 'Linha   : ');
          gotoxy(60,6);
          write ( 'Variável: ');
          gotoxy(70,4);
          write ('10.1.6');
          gotoxyl(70,6);
          write ('ISHIST(1,',i,')');
          gotoxy(3,8);
          repeat
            gotoxyl(3,10);
            write (' Número do elemento: ' );
            readln(ISHIST[1]);
          until (ISHIST[1]<=NUMEL) and (ISHIST[1]>=1);
          str(ISHIST[1],Auxiliar);
          gravareal(ctrlinha,1);
          gotoxyl(70,6);
          write ('ISHIST(2,',i,')');
          if NICODE=0 then
            NINT:=4;
          if NICODE<>0 then
            NINT:=1;
          repeat
            gotoxyl(3,12);
            write (' Número do ponto de quadratura (1 a ',NINT,'): ' );
            readln(ISHIST[2]);
          until (ISHIST[2]<=NINT) and (ISHIST[2]>=1);
          str(ISHIST[2],Auxiliar);
          gravareal(ctrlinha,6);
          gotoxyl(70,6);
          write ('ISHIST(3,',i,')');
          repeat
            gotoxy (1,15);
            writeln ('  (01) Tensão XX                  (S11)  │ (09) Deformação  XX            (E11)');
            writeln ('  (02) Tensão YY                  (S22)  │ (10) Deformação  YY            (E22)');
            writeln ('  (03) Tensão XY                  (S21)  │ (11) GAMMA XY                  (G12)');
            writeln ('  (04) Tensão Z                   (S33)  │ (12) Deformação Z              (E33)');
            writeln ('  (05) Tensão Principal 1         (PS1)  │ (13) Deformação Principal 1    (PE1)');
            writeln ('  (06) Tensão Principal 2         (PS2)  │ (14) Deformação Principal 2    (PE2)');
            writeln ('  (07) Tensão 12                  (TAU)  │ (15) GAMMA 12                  (GAM)');
            writeln ('  (08) Angulo Principal de Tensão (SANG) │ (16) Angulo Principal de Def.  (EANG)');
            gotoxyl(3,14);
            write (' Número da componente Tensão / Deformação (1 a 16): ' );
            readln(ISHIST[3]);
          until (ISHIST[3]<=16) and (ISHIST[3]>=1);
          for j:=1 to 9 do
          gotoxyl(1,14+j);
          str(ISHIST[3],Auxiliar);
          gravareal(ctrlinha,11);
          gotoxyl(70,6);
          gotoxyl(70,4);
          repeat
            gotoxyl(3,23);
            write (' Dados estão OK (S/N): ');
            sn:=readkey;
            writeln(sn);
          until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
          if (sn=chr(78)) or (sn=chr(110)) then
           begin
             linha[ctrlinha]:=('                                                                               ');
             goto Ilinha1016;
           end;
         inc(ctrlinha);
        End;
End;





{****************************Rotina completa da Linha 10.2}
PROCEDURE Linha102;

Label Ilinha1021,Ilinha1022,Ilinha1023,Flinha1023,Ilinha1024,Mlinha1024,
Ilinha1025,Ilinha1026;

Begin

  {***************** TELA 13 }
  { ** Controle de grupo de elemento de BARRA  LINHA 10.2.1 **  }
      Ilinha1021:
      Clrscr;
      MensC ('Cria arquivo de dados do DLEARN',26,2);
      MensC ('Linha 10.2.1: Grupo de Elementos de BARRA',18,25);
      gotoxy(60,4);
      write ( 'Linha   : ');
      gotoxy(60,6);
      write ( 'Variável: ');
      gotoxy(70,4);
      write ('10.2.1');
      NTYPE:=2;
      str(NTYPE,Auxiliar);
      gravareal(ctrlinha,1);
      gotoxy(70,6);
      write ('NUMEL');
      gotoxy (3,10);
      write ( ' Número de elementos deste grupo: ');
      readln(NUMEL);
      str(NUMEL,Auxiliar);
      gravareal(ctrlinha,6);
      gotoxyl(70,6);
      write ('NUMAT');
      gotoxy (3,12);
      write ( ' Número de materiais deste grupo: ');
      readln(NUMAT);
      str(NUMAT,Auxiliar);
      gravareal(ctrlinha,11);
      gotoxyl(71,6);
      write ('NEN');
      repeat
        gotoxyl(3,14);
        write ( ' Número maximo de nós para todos os elementos do grupo (2 ou 3): ');
        readln(NEN);
      until (NEN=2) or (NEN=3);
      str(NEN,Auxiliar);
      gravareal(ctrlinha,16);
      if (IACODE<>1) then
       begin
          gotoxyl(70,6);
          write ('NSOUT');
          gotoxy (3,16);
          write ( ' Número de histórias Tensão / Deformação: ');
          readln(NSOUT);
          str(NSOUT,Auxiliar);
          gravareal(ctrlinha,21);
       end
       else
        begin
          NSOUT:=0;
          str(NSOUT,Auxiliar);
          gravareal(ctrlinha,21);
        end;
      gotoxyl(70,6);
      write ('ISTPRT');
      repeat
         gotoXYl(3,18);
         write ( ' Deseja que seja impressa saída de tensões (S/N): ');
         sn:=readkey;
         writeln(sn);
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(83)) or (sn=chr(115)) then
         begin
             grava0(ctrlinha,26); {opção sim}
             ISTPRT:=0;
         end;
      if (sn=chr(78)) or (sn=chr(110)) then
         begin
            grava1(ctrlinha,26); {opção não}
            ISTPRT:=1;
        end;
      gotoxyl(70,6);
      write ('LFBODY');
      repeat
        If (LFBODY>NLTFTN) then
          begin
            gotoxy(08,22);
            textcolor(red);
            writeln (' Atenção !!!! O número deve ser uma Função no Tempo existente. ');
            readkey;
            normvideo;
            gotoxyl(1,15);
          end;
      gotoxy (3,20);
      write ( ' Número da função já existente de carga de forças volumétricas: ');
      readln(LFBODY);
      until (LFBODY<=NLTFTN) and (LFBODY>=0);
      str(LFBODY,Auxiliar);
      gravareal(ctrlinha,31);



  {***************** TELA 14 }
  { ** Controle de grupo de elemento LINHA 10.2.1 **  CONT....}
      Clrscr;
      MensC ('Cria arquivo de dados do DLEARN',26,2);
      MensC ('Linha 10.2.1: Grupo de Elementos de BARRA',18,25);
      gotoxy(60,4);
      write ( 'Linha   : ');
      gotoxy(60,6);
      write ( 'Variável: ');
      gotoxy(70,4);
      write ('10.2.1');
      gotoxy(70,6);
      write ('NINT');
      repeat
         gotoxy (10,9);
         writeln (' (1) 1 ponto de quadratura gaussiana ');
         gotoxy (10,10);
         writeln (' (2) 2 pontos de quadratura gaussiana ');
         gotoxy (10,11);
         writeln (' (3) 3 pontos de quadratura gaussiana ');
         gotoxyl(3,8);
         write ( ' Número de pontos de integração: ');
         sn:=readkey;
         writeln(sn);
      until ( (sn=chr(49)) or (sn=chr(50)) or (sn=chr(51)) );
      if sn=chr(49) then
         NINT:=1;
      if sn=chr(50) then
         NINT:=2;
      if sn=chr(51) then
         NINT:=3;
      str(NINT,Auxiliar);
      gravareal(ctrlinha,36);
      gotoxyl(70,6);
      write ('IMASS');
      repeat
         gotoxy (10,14);
         writeln (' (0) Matriz de massa consistente');
         gotoxy (10,15);
         writeln (' (1) Matriz de massa concentrada');
         gotoxy (10,16);
         writeln (' (2) Matriz de massa inexistente');
         gotoxyl(3,13);
         write ( ' Código da matriz de massa: ');
         sn:=readkey;
         writeln(sn);
      until ( (sn=chr(48)) or (sn=chr(49)) or (sn=chr(50)) );
      if sn=chr(48) then
         IMASS:=0;
      if sn=chr(49) then
         IMASS:=1;
      if sn=chr(50) then
         IMASS:=2;
      str(IMASS,Auxiliar);
      gravareal(ctrlinha,41);
      gotoxyl(70,6);
      write ('IMPEXP');
      repeat
         gotoxy (10,19);
         writeln (' (0) Grupo de elemento implicito ');
         gotoxy (10,20);
         writeln (' (1) Grupo de elemento explicito');
         gotoxyl(3,18);
         write ( ' Código Implicito / Explicito: ');
         sn:=readkey;
         writeln(sn);
      until ( (sn=chr(48)) or (sn=chr(49)) );
      if sn=chr(48) then
         IMEXP:=0;
      if sn=chr(49) then
         IMEXP:=1;
      str(IMEXP,Auxiliar);
      gravareal(ctrlinha,46);
      gotoxyl(70,6);
      gotoxyl(70,4);
      repeat
         gotoxyl(3,24);
         write (' Dados estão OK (S/N): ');
         sn:=readkey;
         writeln(sn);
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
        begin
          linha[ctrlinha]:=('                                                                               ');
          goto Ilinha1021;
        end;
      inc(ctrlinha);



  {***************** TELA 15 }
  { ** Propriedades dos Materiais LINHA 10.2.2 **  }

      For i:=1 to numat do
       Begin
         Ilinha1022:
         Clrscr;
         MensC ('Cria arquivo de dados do DLEARN',26,2);
         MensC ('Linha 10.2.2: Propriedades dos Materiais ',20,25);
         gotoxy(60,4);
         write ( 'Linha   : ');
         gotoxy(60,6);
         write ( 'Variável: ');
         gotoxy(70,4);
         write ('10.2.2');
         gotoxy(3,8);
         textcolor(red);
         write (' Material número : ',i);
         normvideo;
         M:=i;
         str(M,Auxiliar);
         gravareal(ctrlinha,1);
         gotoxy(70,6);
         write ('E(',i,')');
         gotoxy (3,10);
         write ( '    Módulo de Elasticidade: ');
         readln(E[i]);
         Defzeros(E[i]);
         gravareal2(ctrlinha,11);
         gotoxyl(70,6);
         write ('RHO(',i,')');
         gotoxy (3,12);
         write ( '    Densidade: ');
         readln(RHO[i]);
         Defzeros(RHO[i]);
         gravareal2(ctrlinha,21);
         gotoxyl(70,6);
         write ('RDAMPM(',i,')');
         gotoxy (3,14);
         write ( '    Coeficiente de amortecimento de Rayleigh na matriz de massa: ');
         readln(RDAMPM[i]);
         Defzeros(RDAMPM[i]);
         gravareal2(ctrlinha,31);
         gotoxyl(70,6);
         write ('RDAMPK(',i,')');
         gotoxy (3,16);
         write ( '    Coeficiente de amortecimento de Rayleigh na matriz de rigidez: ');
         readln(RDAMPK[i]);
         Defzeros(RDAMPK[i]);
         gravareal2(ctrlinha,41);
         gotoxyl(70,6);
         write ('AREA(',i,')');
         gotoxy (3,18);
         write ( '    Área: ');
         readln(AREA[i]);
         Defzeros(AREA[i]);
         gravareal2(ctrlinha,51);
         gotoxyl(70,6);
         gotoxyl(70,4);
         repeat
           gotoxyl(3,24);
           write (' Dados estão OK (S/N): ');
           sn:=readkey;
           writeln(sn);
         until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
         if (sn=chr(78)) or (sn=chr(110)) then
          begin
            linha[ctrlinha]:=('                                                                               ');
            goto Ilinha1022;
          end;
         inc(ctrlinha);
       End;

  {***************** TELA 16 }
  { ** Vetor Gravitacional  LINHA 10.2.3 **  }
      If LFBODY=0 then
        goto Flinha1023;
      Ilinha1023:
      Clrscr;
      MensC ('Cria arquivo de dados do DLEARN',26,2);
      MensC ('Linha 10.2.3: Vetor Gravitacional ',19,25);
      gotoxy(61,4);
      write ( 'Linha   : ');
      gotoxy( 61,6);
      write ( 'Variável: ');
      gotoxy(71,4);
      write ('10.2.3');
      gotoxyl(71,6);
      write ('GRAV(1)');
      gotoxy (3,10);
      write (' Componente do vetor gravitacional na direção X: ' );
      readln(GRAV[1]);
      defzeros(GRAV[1]);
      gravareal2(ctrlinha,1);
      gotoxy(71,6);
      write ('GRAV(2)');
      gotoxy (3,12);
      write (' Componente do vetor gravitacional na direção Y: ' );
      readln(GRAV[2]);
      defzeros(GRAV[2]);
      gravareal2(ctrlinha,11);
      gotoxy(71,6);
      write ('GRAV(3)');
      gotoxy (3,14);
      write (' Componente do vetor gravitacional na direção Z: ' );
      readln(GRAV[3]);
      Defzeros(GRAV[3]);
      gravareal2(ctrlinha,21);
      gotoxyl(70,6);
      gotoxyl(70,4);
      repeat
         gotoxyl(3,24);
         write (' Dados estão OK (S/N): ');
         sn:=readkey;
         writeln(sn);
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
        begin
          linha[ctrlinha]:=('                                                                               ');
          goto Ilinha1023;
        end;
      Flinha1023:

  {***************** TELA 17 }
  { ** Definição de elementos  LINHA 10.2.4.1 **  }
      inc(ctrlinha);
      Ilinha1024:
      Clrscr;
      MensC ('Cria arquivo de dados do DLEARN',26,2);
      MensC ('Linha 10.2.4.1: Definição de elementos ',19,25);
      gotoxy(60,4);
      write ( 'Linha   : ');
      gotoxy(60,6);
      write ( 'Variável: ');
      gotoxy(70,4);
      write ('10.2.4');
      gotoxy(70,6);
      write ('N');
      repeat
        gotoxyl(3,8);
        write (' Número do elemento: ' );
        readln(N6);
      until (N6<=NUMEL) and (N6>=1);
      str(N6,Auxiliar);
      gravareal(ctrlinha,1);
      gotoxy(70,6);
      write ('M');
      repeat
        gotoxyl(3,10);
        write (' Número do Material: ' );
        readln(M);
      until (M<=NUMAT) and (M>=1);
      str(M,Auxiliar);
      gravareal(ctrlinha,6);
      j:=0;
      For i:=1 to NEN do
        begin
          gotoxy(70,6);
          write ('IEN(',i,',',N6,')');
          repeat
            gotoxyl(3,11+i);
            write ('   Número do ',i,'º  nó: ');
            readln(IEN[i]);
         until (IEN[i]<=NUMNP) and (IEN[i]>=1);
         str(IEN[i],Auxiliar);
         gravareal(ctrlinha,11+J);
         j:=j+5;
        end;
      gotoxyl(1,17);
      gotoxyl(70,6);
      write ('NG');
      repeat
         gotoxy (10,18);
         writeln (' (0) Não faz geração automática');
         gotoxy (10,19);
         writeln (' (1) Faz geração automática');
         gotoxyl(3,17);
         write ( ' Código de geração (0/1): ');
         sn:=readkey;
         writeln(sn);
      until ( (sn=chr(48)) or (sn=chr(49)) );
      if sn=chr(48) then
         NG:=0;
      if sn=chr(49) then
         NG:=1;
      str(NG,Auxiliar);
       if NEN=2 then
         gravareal(ctrlinha,21);
       if NEN=3 then
         gravareal(ctrlinha,26);
      gotoxyl(70,6);
      gotoxyl(70,4);
      repeat
         gotoxyl(3,23);
         write (' Dados estão OK (S/N): ');
         sn:=readkey;
         writeln(sn);
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
      begin
         linha[ctrlinha]:=('                                                                               ');
         goto ilinha1024;
      end;
      inc(ctrlinha);
      If NG=0 then
        Begin
          repeat
              gotoxyl(3,24);
              write (' Terminou a entrada de dados dos elementos desse grupo (S/N): ');
              sn:=readkey;
              writeln(sn);
          until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
          if (sn=chr(78)) or (sn=chr(110)) then
            begin
              inc(ctrlinha);
              goto Ilinha1024;
            end;
        End;

  {***************** TELA 18 }
  { ** Definição de elementos  LINHA 10.2.4.2 **  }
    If NG=1 then
       Begin
         Mlinha1024:
         Clrscr;
         MensC ('Cria arquivo de dados do DLEARN',26,2);
         MensC ('Linha 10.2.4.2: Definição de elementos ',19,25);
         gotoxy(60,4);
         write ( 'Linha   : ');
         gotoxy(60,6);
         write ( 'Variável: ');
         gotoxy(70,4);
         write ('10.2.4');
         gotoxy(70,6);
         write ('NEL');
         gotoxy (3,8);
         write ( ' Número de elementos a mais na direção 1: ');
         readln(NEL[1]);
         str(NEL[1],Auxiliar);
         gravareal(ctrlinha,1);
         gotoxyl(70,6);
         write ('INCEL(1)');
         gotoxy (3,10);
         write ( ' Incremento do número de elementos para direção 1: ');
         readln(INCEL[1]);
         str(INCEL[1],Auxiliar);
         gravareal(ctrlinha,6);
         gotoxyl(70,6);
         write ('INC(1)');
         gotoxy (3,12);
         write ( ' Incremento de nós para direção 1: ');
         readln(INC1);
         str(INC1,Auxiliar);
         gravareal(ctrlinha,11);
         gotoxyl(70,6);
         gotoxyl(70,4);
         repeat
           gotoxyl(3,23);
           write (' Dados estão OK (S/N): ');
           sn:=readkey;
           writeln(sn);
         until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
         if (sn=chr(78)) or (sn=chr(110)) then
           begin
             linha[ctrlinha]:=('                                                                               ');
             goto Mlinha1024;
           end;
         repeat
             gotoxyl(3,24);
             write (' Terminou a entrada de dados dos elementos desse grupo (S/N): ');
             sn:=readkey;
             writeln(sn);
         until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
         if (sn=chr(78)) or (sn=chr(110)) then
           begin
             inc(ctrlinha);
             goto Ilinha1024;
           end;
       End;
       inc(ctrlinha);
       linha[ctrlinha]:=('                                                                               ');
       inc(ctrlinha);

  {***************** TELA 19 }
  { ** Dados de história no tempo dos elemento  LINHA 10.2.5 **  }
    For i:=1 to NSOUT do
       Begin
          Ilinha1025:
          Clrscr;
          MensC ('Cria arquivo de dados do DLEARN',26,2);
          MensC ('Linha 10.2.5: Dados de história no tempo dos elementos  ',19,25);
          gotoxy(60,4);
          write ( 'Linha   : ');
          gotoxy(60,6);
          write ( 'Variável: ');
          gotoxy(70,4);
          write ('10.2.5');
          gotoxyl(70,6);
          write ('ISHIST(1,',i,')');
          gotoxy(3,8);
          repeat
             gotoxyl(3,10);
             write (' Número do elemento: ' );
             readln(ISHIST[1]);
          until (ISHIST[1]<=NUMEL) and (ISHIST[1]>=1);
          str(ISHIST[1],Auxiliar);
          gravareal(ctrlinha,1);
          gotoxyl(70,6);
          write ('ISHIST(2,',i,')');
          if NICODE=0 then
           NINT:=4;
          if NICODE<>0 then
           NINT:=1;
          repeat
             gotoxyl(3,12);
             write (' Número dos pontos de quadratura (1 a ',NINT,'): ' );
             readln(ISHIST[2]);
          until (ISHIST[2]<=NINT) and (ISHIST[2]>=1);
          str(ISHIST[2],Auxiliar);
          gravareal(ctrlinha,6);
          gotoxyl(70,6);
          write ('ISHIST(3,',i,')');
          repeat
              gotoxy (1,15);
              writeln ('  (01) Tensão Axial              (STRS)  ');
              writeln ('  (02) Força  Axial              (FORC)  ');
              writeln ('  (03) Deformação Axial          (STRN)  ');
              gotoxyl(3,14);
              write (' Número de componentes Tensão / Deformação (1 a 3): ' );
              readln(ISHIST[3]);
          until (ISHIST[3]>=1) and (ISHIST[3]<=3);
          str(ISHIST[3],Auxiliar);
          gravareal(ctrlinha,11);
          gotoxyl(71,6);
          gotoxyl(71,4);
          repeat
             gotoxyl(3,23);
             write (' Dados estão OK (S/N): ');
             sn:=readkey;
             writeln(sn);
          until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
          if (sn=chr(78)) or (sn=chr(110)) then
            begin
              linha[ctrlinha]:=('                                                                               ');
              goto Ilinha1025;
            end;
          inc(ctrlinha);
      End;
End;



{****************************Rotina auxiliar Linha10}
PROCEDURE Linha10;


Begin
 For ctrnumeg:=1 to numeg do
   Begin
     Clrscr;
     MensC ('Cria arquivo de dados do DLEARN',26,2);
     MensC ('Linha 10: Tipo de Elementos ',27,25);
     gotoxy(60,4);
     write ( 'Linha    : ');
     gotoxy( 60,6);
     write ( 'Variável : ');
     gotoxy(71,4);
     write ('10');
     textcolor(red);
     gotoxy(3,8);
     write (' » ', ctrnumeg,'º Grupo de Elementos ');
     normvideo;
     repeat
        gotoxy (14,11);
        writeln ('(1) Elemento de Chapa');
        gotoxy (14,12);
        writeln ('(2) Elemento de Barra');
        gotoxyl(5,10);
        write ( ' Tipo de elemento presente neste grupo: ');
        readln(Tipoele);
     until (Tipoele=1) or (Tipoele=2);

     If Tipoele=1 then  { Chama procedure de elemento tipo Chapa }
        Linha101;

     If Tipoele=2 then  { Chama procedure de elemento tipo Barra }
        Linha102;

   End;

End;








{****************************CRIAR ARQUIVOS*********************************}
PROCEDURE Cria;

Label Saida,Labnumseq,Labnumnp,Labndprt,Labnsprt,Labnhplt,Labniter,Labalfa,
Labbeta,Labgamma,Labdt,Lablinha4,Lablinha5,Lablinha6,Lablinha71,Lablinha8,
Lablinha9,Lablinha91,Lablinha10,Lablinha0,Labn5,Labsn;

Begin

   for i:=1 to 100 do
      linha[i]:=('                                                                                ');

{ ************* TELA 1 }
   Clrscr;
   MensC ('Cria arquivo de dados do DLEARN',26,2);
   MensC ('Entre com um nome para o arquivo de dados',21,25);
   gotoxy(61,4);
   write ( 'Linha    : ');
   gotoxy(61,6);
   write ( 'Variável : ');
   { Nome do arquivo }
   gotoxy(3,7);
   write ( 'Digite um nome para o arquivo ( c/ extensão ): ');
   if aux=15 then
    begin
      write ('nome');
    end
    else
    begin
      readln(nome);
    end;
   gotoxyl(50,7);
   writeln(nome);
   writeln;
   writeln;
   assign(arq,nome);
   {if aux<>15 then
      rewrite(arq); NAO SEI PRA QUE SERVE}
   {$I-}
   Reset(Arq);
   {$I+}
   a:=IOResult;
   controle:=1;
   if a=0 then
      begin
        gotoxy(28,11);
        textcolor(red+blink);
        write ('Arquivo já existe !!!!');
        normvideo;
        repeat
          gotoXYl(3,14);
          write ( '   Deseja sobrepor o arquivo (S/N): ');
          sn:=readkey;
          writeln (sn);
        until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
        if (sn=chr(83)) or (sn=chr(115)) then   { sim }
           begin
             gotoxyl(1,11);
             gotoxyl(1,14);
             rewrite(arq);
           end;
        if (sn=chr(78)) or (sn=chr(110)) then   { nao }
           begin
             controle:=15;
             goto saida;
          end;
      end;
   if  controle=1 then
     rewrite(arq);
 { ** Ecoar dados de entrada  LINHA 00 ** }
   lablinha0:
   If volta=1 then
     begin
       Clrscr;
       MensC ('Cria arquivo de dados do DLEARN',26,2);
       gotoxy(61,4);
       write ( 'Linha    : ');
       gotoxy(61,6);
       write ( 'Variável : ');
       volta:=0;
     end;
   repeat
     MensC ('Linha 00: Eco de Dados de Entrada',26,25);
     gotoxy(72,4);
     write ('0');
     gotoxy(72,6);
     write ('IECHO');
     gotoXYl(3,9);
     write ( ' Ecoar arquivo de dados (S/N): ');
     sn:=readkey;
     writeln (sn);
     if (sn=chr(27)) then
      goto saida;
   until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
   if (sn=chr(83)) or (sn=chr(115)) then
    begin
     grava1(1,1); {opção sim}
     IECHO:=1;
    end;
   if (sn=chr(78)) or (sn=chr(110)) then
    begin
     grava0(1,1); {opção não}
     IECHO:=0;
    end;
 { ** Titulo do Arquivo LINHA 01 ** }
   gotoxy(72,4);
   write ('1');
   gotoxy(72,6);
   write ('TITLE');
   MensC ('Linha 01: Titulo (máx 80 caracteres)',25,25);
   gotoXY(3,11);
   write ( ' Título para a estrutura: ');
   readln(titulo);
   linha[2]:=titulo;
   gotoxyl(1,13);
   gotoxy(29,11);
   writeln(titulo);
 {** Controle de Execução LINHA 02 **}
   gotoxy(72,4);
   write ('2');
   gotoxy(72,6);
   write ('IEXEC');
   MensC ('Linha 02: Controle de Execução ',27,25);
   repeat
     gotoxy(6,14);
     writeln ('(0) Somente check de dados');
     gotoxy(6,15);
     writeln ('(1) Executa');
     gotoXYl(3,13);
     write ( ' Código de execução (0/1): ');
     sn:=readkey;
     writeln(sn);
   until (sn=chr(48)) or (sn=chr(49));
   if (sn=chr(48)) then
    begin
      grava0(3,1); {opção 0}
      IEXEC:=0;
    end;
   if (sn=chr(49)) then
    begin
      grava1(3,1); {opção 1}
      IEXEC:=1;
    end;
   if (sn=chr(27)) then
    goto saida;
   gotoxyl(72,6);
   write ('IACODE');
   repeat
     gotoxy(6,18);
     writeln ('(0) Análise Dinâmica');
     gotoxy(6,19);
     writeln ('(1) Análise Estática');
     {gotoxy(6,20);
     writeln ('(2) Algoritimo Hermitiano');}
     gotoXYl(3,17);
     write ( ' Qual o tipo de análise: ');
     sn:=readkey;
     writeln(sn);
   if (sn=chr(27)) then
     goto saida;
   until (sn=chr(48)) or (sn=chr(49)) {or (sn=chr(50))};
   if (sn=chr(48)) then
     iacode:=0;
   If (sn=chr(49)) then
     iacode:=1;
   {If (sn=chr(50)) then
     iacode:=2;}
   for i:=0 to 1 do
    Begin
      j:=48+i;
      if sn=chr(j) then
       begin
         str(i,Auxiliar);
         gravareal(3,6);
       end;
    End;
   gotoxyl(72,6);
   write ('IREADR');
   repeat
     gotoXYl(3,22);
     write ( ' Deseja fazer a leitura do arquivo de reinício (S/N): ');
     sn:=readkey;
     writeln(sn);
     if (sn=chr(27)) then
       goto saida;
   until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
   if (sn=chr(83)) or (sn=chr(115)) then
     begin
       grava1(3,11); {opção sim}
       IREADR:=1;
     end;
   if (sn=chr(78)) or (sn=chr(110)) then
     begin
       grava0(3,11); {opção não}
       IREADR:=0;
     end;
   gotoxyl(72,6);
   write ('IWRITR');
   repeat
     gotoXYl(3,24);
     write ( ' Deseja gravar no arquivo de reinício (S/N): ');
     sn:=readkey;
     writeln(sn);
   if (sn=chr(27)) then
     goto saida;
   until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
   if (sn=chr(83)) or (sn=chr(115)) then
    begin
      grava1(3,16); {opção sim}
      IWRITR:=1;
    end;
   if (sn=chr(78)) or (sn=chr(110)) then
    begin
      grava0(3,16); {opção não}
      IWRITR:=0
    end;

  { ****************** TELA 2 }
   Clrscr;
   MensC ('Cria arquivo de dados do DLEARN',26,2);
   MensC ('Linha 02: Controle de Execução ',27,25);
   gotoxy(61,4);
   write ( 'Linha    : ');
   gotoxy(61,6);
   write ( 'Variável : ');
   gotoxy(72,4);
   write ('2');
   {If (iacode=2) then
    Begin
      repeat
        gotoxyl(72,6);
        write ('IHERM');
        gotoXYl(3,7);
        write ( ' Entre com a ordem do Algoritimo Hermitiano a ser usado (1 a 8): ');
        sn:=readkey;
        writeln(sn);
        if (sn=chr(27)) then
          goto saida;
      until (sn=chr(49)) or (sn=chr(50)) or (sn=chr(51)) or (sn=chr(52)) or
      (sn=chr(53)) or (sn=chr(54)) or (sn=chr(55)) or (sn=chr(56));
      for i:=1 to 8 do
       begin
         j:=48+i;
         if sn=chr(j) then
          begin
            str(i,Auxiliar);
            gravareal(3,21);
          end;
       end;
    End;
   If (iacode<>2) then
     begin
       IHERM:=0;
       str(IHERM,Auxiliar);
       gravareal(3,21);
     end;}
   gotoxyl(72,6);
   write ('IPRTIN');
   repeat
     gotoXYl(3,9);
     write ( ' Imprime dados de nós e elementos (S/N): ');
     sn:=readkey;
     writeln(sn);
     if (sn=chr(27)) then
       goto saida;
   until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
   if (sn=chr(83)) or (sn=chr(115)) then
    begin
      grava0(3,21); {opção sim}
      IPRTIN:=0;
    end;
   if (sn=chr(78)) or (sn=chr(110)) then
    begin
      grava1(3,21); {opção não}
      IPRTIN:=1;
    end;
   gotoxyl(72,6);
   write ('IRANK');
   repeat
     gotoxy(6,12);
     writeln ('(0) Não realiza check');
     gotoxy(6,13);
     writeln ('(1) Imprime número de pivôs negativos');
     gotoxy(6,14);
     writeln ('(2) Imprime todos os pivôs');
     gotoXYl(3,11);
     write ( ' Código de checagem do RANK (0/1/2): ');
     sn:=readkey;
     writeln(sn);
     if (sn=chr(27)) then
      goto saida;
   until ( (sn=chr(48)) or (sn=chr(49)) or (sn=chr(50)) );
   if (sn=chr(48)) then
     begin
       grava0(3,26);              {opção 0}
       IRANK:=0;
     end;
   if (sn=chr(49)) then
     begin
       grava1(3,26);              {opção 1}
       IRANK:=1;
     end;
   if (sn=chr(50)) then
     begin
       grava2(3,26);              {opção 2}
       IRANK:=2;
      end;

   If (IACODE<>1) then
    begin
      gotoxyl(72,6);
      write ('NUMSEQ');
      labnumseq:
      gotoxyl(3,16);
      write ( ' Número de seqüências de tempo: ');
      readln(NUMSEQ);
      if (numseq<=0) then
        goto labnumseq;
      str(NUMSEQ,Auxiliar);
      gravareal(3,31);
    end
    else
       begin
         NUMSEQ:=1;
         str(NUMSEQ,Auxiliar);
         gravareal(3,31);
       end;

   IF (IACODE<>1) then
    begin
        gotoxyl(72,6);
        write ('NDOUT');
        gotoxy (3,18);
        write ( ' Número de histórias nodais a serem impressas: ');
        readln(NDOUT);
        str(NDOUT,Auxiliar);
        gravareal(3,36);
    end
    else
     begin
       NDOUT:=0;
       str(NDOUT,Auxiliar);
       gravareal(3,36);
     end;

   gotoxyl(72,6);
   write ('NSD');
   repeat
     gotoxy (5,21);
     write (' Obs.: Para estado plano de tensões ou deformações --> 2 ');
     gotoxy (5,22);
     write ('       Para estrutura tipo treliça  --> 3 ');
     gotoxyl(3,20);
     write ( ' Número de dimensões do espaço (2/3): ');
     sn:=readkey;
     writeln(sn);
     if (sn=chr(27)) then
       goto saida;
   until ( (sn=chr(51)) or (sn=chr(50)) );
   if sn=chr(50) then
     nsd:=2;
   if sn=chr(51) then
     nsd:=3;
   str(nsd,Auxiliar);
   gravareal(3,41);
   gotoxyl(1,21);
   gotoxyl(1,22);
   gotoxyl(72,6);
   write ('NUMNP');
   labnumnp:
   gotoxyl(3,22);
   write ( ' Número total de nós da estrutura: ');
   readln(NUMNP);
   if (numnp<=0) then
      goto labnumnp;
   str(NUMNP,Auxiliar);
   gravareal(3,46);
   gotoxyl(72,6);
   write ('NDOF');
   repeat
     gotoxyl(3,24);
     write ( ' Número de graus de liberdade por nó (2 a 6): ');
     readln(ndof);
   until (ndof=2) or (ndof=3) or (ndof=4) or (ndof=5) or (ndof=6);
   str(ndof,Auxiliar);
   gravareal(3,51);

 { ******************* TELA 3 }
   Clrscr;
   MensC ('Cria arquivo de dados do DLEARN',26,2);
   MensC ('Linha 02: Controle de Execução ',27,25);
   gotoxy(61,4);
   write ( 'Linha    : ');
   gotoxy(61,6);
   write ( 'Variável : ');
   gotoxy(72,4);
   write ('2');
   gotoxyl(72,6);
   write ('NLVECT');
   gotoxy (3,8);
   write ( ' Número de situações de carregamento: ');
   readln(NLVECT);
   str(NLVECT,Auxiliar);
   gravareal(3,56);
   gotoxyl(72,6);
   write ('NLTFTN');
   gotoxy (3,11);
   writeln ( '   Obs1: As funções no tempo são aproximadas por retas. ');
   gotoxy (3,12);
   writeln ( '   Obs2: NLTFTN = 1 ( recomendado para análise estática ) ');
   gotoxy (3,10);
   write ( ' Número de funções de carga no tempo: ');
   readln(NLTFTN);
   str(NLTFTN,Auxiliar);
   gravareal(3,61);
   gotoxyl(72,6);
   write ('NPTSLF');
   gotoxy (3,15);
   writeln ( '   Obs.: NPTSLF = 1 ( para análise estática ) ');
   gotoxy (3,14);
   write ( ' Número de pontos definindo função de carga no tempo: ');
   readln(NPTSLF);
   str(NPTSLF,Auxiliar);
   gravareal(3,66);
   gotoxyl(72,6);
   write ('NUMEG');
   gotoxy (3,17);
   write ( ' Número de grupos de elementos: ');
   readln(NUMEG);
   str(NUMEG,Auxiliar);
   gravareal(3,71);
   gotoxyl(72,4);
   gotoxyl(72,6);
   repeat
      gotoxyl(3,23);
      write (' Dados das Linhas 0 1 e 2 estão OK (S/N): ');
      sn:=readkey;
      writeln(sn);
      if (sn=chr(27)) then
          goto saida;
      if (sn=chr(13)) then
          sn:=chr(115);
   until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
   if (sn=chr(78)) or (sn=chr(110)) then
    begin
       linha[1]:=('                                                                                ');
       linha[2]:=('                                                                                ');
       linha[3]:=('                                                                                ');
       volta:=1;
       goto lablinha0;
    end;

{ ******************* TELA 4 }

{ ** Dados das sequências de tempo LINHA 03 **}
   If (IACODE=1) then
     goto lablinha4;
   For i:=1 to numseq do
     Begin
        Clrscr;
        MensC ('Cria arquivo de dados do DLEARN',26,2);
        MensC ('Linha 03: Dados das Seqüências de Tempo ',22,25);
        gotoxy(61,4);
        write ( 'Linha    : ');
        gotoxy(61,6);
        write ( 'Variável : ');
        gotoxy(72,4);
        write ('3');
        linha[3+i]:=('                                                                                ');
        gotoxy (3,7);
        textcolor(Red);
        writeln ( ' Seqüência de tempo número: ',i);
        normvideo;
        N1[i]:=i;
        str(N1[i],Auxiliar);
        gravareal(3+i,1);
        gotoxy(72,6);
        write ('NSTEP(',i,')');
        gotoxy (3,9);
        write ( '    Número de passos desta seqüência ',i,' : ');
        readln(NSTEP[i]);
        str(NSTEP[i],Auxiliar);
        gravareal(3+i,6);
        If ndout<>0 then
          Begin
            gotoxy(72,6);
            write ('NDPRT');
            labndprt:
            gotoXYl(3,11);
            write ( '    A cada quantos passos serão impressos desl/vel/acel: ');
            readln(NDPRT[i]);
            if (NDPRT[i]<0) then
               goto labndprt;
            str(NDPRT[i],Auxiliar);
            gravareal(3+i,11);
            gotoxyl(72,6);
            write ('NSPRT(',i,')');
            labnsprt:
            gotoXYl(3,13);
            write ( '    A cada quantos passos serão impressos tensão/deformação: ');
            readln(NSPRT[i]);
            if (NSPRT[i]<0) then
               goto labnsprt;
            str(NSPRT[i],Auxiliar);
            gravareal(3+i,16);
            gotoxyl(72,6);
            write ('NHPLT');
            labnhplt:
            gotoXYl(3,15);
            write ( '    A cada quantos passos serão plotados as informações acima: ');
            readln(NHPLT[i]);
            if (NHPLT[i]<0) then
              goto labnhplt;
            str(NHPLT[i],Auxiliar);
            gravareal(3+i,21);
          End;
        gotoxyl(72,6);
        write ('NITER(',i,')');
        labniter:
        gotoxyl(3,17);
        write ( '    Número de iterações no loop corretor: ');
        readln(NITER[i]);
        if (niter[i]<1) then
           goto labniter;
        str(NITER[i],Auxiliar);
        gravareal(3+i,26);
        gotoxyl(72,6);
        write ('ALPHA(',i,')');
        labalfa:
        gotoxyl(3,19);
        write ( '    Parâmetro Alfa (<=0): ');
        readln(ALPHA[i]);
        if (alpha[i]>0) then
          goto labalfa;
        Defzeros(ALPHA[i]);
        gravareal2(3+i,31);
        gotoxyl(72,6);
        write ('BETA(',i,')');
        labbeta:
        gotoxyl(3,20);
        write ( '    Parâmetro Beta (>=0): ');
        readln(BETA[i]);
        if (Beta[i]<0) then
          goto labbeta;
        Defzeros(BETA[i]);
        gravareal2(3+i,41);
        gotoxyl(72,6);
        write ('GAMMA(',i,')');
        labgamma:
        gotoxyl(3,21);
        write ( '    Parâmetro Gamma(>=0): ');
        readln(GAMMA[i]);
        if (Gamma[i]<0) then
          goto labgamma;
        Defzeros(GAMMA[i]);
        gravareal2(3+i,51);
        gotoxyl(72,6);
        write ('DT(',i,')');
        labdt:
        gotoxyl(3,22);
        write ( '    Passo Delta(t) (>=0): ');
        readln(DT[i]);
        if (Dt[i]<0) then
          goto labdt;
        Defzeros(DT[i]);
        gravareal2(3+i,61);
        gotoxyl(72,6);
        gotoxyl(72,4);
        repeat
              gotoxyl(3,24);
              write (' Dados estão OK (S/N): ');
              sn:=readkey;
              writeln(sn);
              if (sn=chr(27)) then
                 goto saida;
        until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
        if (sn=chr(78)) or (sn=chr(110)) then
          begin
              i:=i-1;
          end;
     End;

{ ******************* TELA 5 }
{ ** Dados dos históricos nodais LINHA 04 ** }
  Lablinha4:
   For i:=1 to ndout do
     Begin
       Clrscr;
       MensC ('Cria arquivo de dados do DLEARN',26,2);
       MensC ('Linha 04: Dados das Histórias Nodais',24,25);
       gotoxy(60,4);
       write ( 'Linha    : ');
       gotoxy(60,6);
       write ( 'Variável : ');
       linha[3+numseq+i]:=('                                                                                ');
       gotoxy(71,4);
       write ('4');
       gotoxy(71,6);
       write ('IDHIST(',i,')');
       repeat
          gotoxy (7,10);
          write ('Obs.: Um por vez, e em qualquer ordem');
          gotoxyl (3,8);
          write ( ' Número do nó a ser impresso ou plotado: ');
          readln(IDHIST1[i]);
       until (IDHIST1[i]>0) and (IDHIST1[i]<=NUMNP);
       str(IDHIST1[i],Auxiliar);
       gravareal(3+numseq+i,1);
       gotoxyl(71,6);
       write ('IDHIST2(',i,')');
       gotoxyl(1,10);
       gotoxyl(1,11);
       repeat
          gotoxy (8,13);
          write (' (1) X');
          gotoxy (8,14);
          write (' (2) Y');
          gotoxy (8,15);
          write (' (3) Z');
          gotoxyl(3,12);
          write ( '   Número do grau de liberdade do nó (1/2/3): ');
          sn:=readkey;
          writeln(sn);
          if (sn=chr(27)) then
              goto saida;
       until (sn=chr(49)) or (sn=chr(50)) or (sn=chr(51));
       if (sn=chr(49)) then
        begin
          grava1(3+numseq+i,6); {opção 1}
          IDHIST2[i]:=1;
        end;
       if (sn=chr(50)) then
        begin
          grava2(3+numseq+i,6); {opção 2}
          IDHIST2[i]:=2;
        end;
       if (sn=chr(51)) then
        begin
         insert('3',linha[3+numseq+i],6); {opção 3}
         IDHIST2[i]:=3;
        end;
       gotoxyl(71,6);
       write ('IDHIST3(',i,')');
       repeat
         gotoxy (8,18);
         writeln ('(1) Deslocamento ');
         gotoxy (8,19);
         writeln ('(2) Velocidade ');
         gotoxy (8,20);
         writeln ('(3) Aceleração ');
         gotoxyl(3,17);
         write ( '   Especificador da grandeza cinemática (1/2/3): ');
         sn:=readkey;
         writeln(sn);
         if (sn=chr(27)) then
              goto saida;
       until (sn=chr(49)) or (sn=chr(50)) or (sn=chr(51));
       if (sn=chr(49)) then
         begin
             grava1(3+numseq+i,11); {opção 1}
             IDHIST3[i]:=1;
         end;
       if (sn=chr(50)) then
         begin
             grava2(3+numseq+i,11); {opção 2}
             IDHIST3[i]:=2;
         end;
       if (sn=chr(51)) then
         begin
             insert('3',linha[3+numseq+i],11); {opção 3}
             IDHIST3[i]:=3;
         end;
       gotoxyl(71,6);
       gotoxyl(71,4);
       repeat
             gotoxyl(3,24);
             write (' Dados estão OK (S/N): ');
             sn:=readkey;
             writeln(sn);
             if (sn=chr(27)) then
                goto saida;
       until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
       if (sn=chr(78)) or (sn=chr(110)) then
         begin
              i:=i-1;
         end;
     End;

 { ***************** TELA 6 }
 { ** Coordenadas nodais LINHA 5.1 ** }
    ctrlinha:=3+numseq+ndout+1;
    lablinha5:
    Clrscr;
    MensC ('Cria arquivo de dados do DLEARN',26,2);
    MensC ('Linha 5.1: Coordenadas Nodais',27,25);
    gotoxy(61,4);
    write ( 'Linha    : ');
    gotoxy( 61,6);
    write ( 'Variável : ');
    gotoxy(72,4);
    write ('5.1');
    linha[ctrlinha]:=('                                                                                ');
    gotoxyl(72,6);
    write ('N');
    repeat
      gotoxyl(3,8);
      write ( ' Número do nó: ');
      readln(N2);
    until (N2<=NUMNP) and (N2>=1);
    str(N2,Auxiliar);
    gravareal(ctrlinha,1);
    gotoxy(72,6);
    write ('NUMGP');
    repeat
      gotoxy (5,11);
      writeln (' Obs.: (0) Sem geração');
      gotoxy (12,12);
      writeln ('(2) Interpolação Linear');
      gotoxy (12,13);
      writeln ('(3) Interpolação Quadrática');
      gotoxy (12,14);
      writeln ('(4) Interpolação Bi-Linear (sobre superfície)');
      gotoxy (12,15);
      writeln ('(8) Interpolação Bi-Quadrática ou Tri-linear');
      gotoxy (12,16);
      writeln ('(20) Interpolação Tri-Quadrática');
      gotoxyl(3,10);
      write ( '   Tipo de geração: ');
      readln(NUMGP);
    until (numgp=0) or (numgp=2) or (numgp=3) or (numgp=4) or (numgp=8) or (numgp=20);
    str(NUMGP,Auxiliar);
    gravareal(ctrlinha,6);
    for i:=11 to 16 do
      gotoxyl(1,i);
    gotoxy(72,6);
    write ('X(1,',N2,')');
    gotoxy (4,13);
    write ( '    Coordenada X: ');
    readln(X1[ctrlinha]);
    Defzeros(X1[ctrlinha]);
    gravareal2(ctrlinha,11);
    gotoxy(72,6);
    write ('X(2,',N2,')');
    gotoxy (4,15);
    write ( '    Coordenada Y: ');
    readln(X2[ctrlinha]);
    Defzeros(X2[ctrlinha]);
    gravareal2(ctrlinha,21);
    gotoxy(72,6);
    write ('X(3,',N2,')');
    gotoxy (4,17);
    write ( '    Coordenada Z: ');
    readln(X3[ctrlinha]);
    Defzeros(X3[ctrlinha]);
    gravareal2(ctrlinha,31);
    if numgp=0 then
      begin
        gotoxyl(72,6);
        gotoxyl(72,4);
        repeat
           gotoxyl(3,23);
           write (' Dados estão OK (S/N): ');
           sn:=readkey;
           writeln(sn);
           if (sn=chr(27)) then
             goto saida;
        until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
        if (sn=chr(78)) or (sn=chr(110)) then
           goto lablinha5;
        if (sn=chr(115)) or (sn=chr(83)) then
          begin
             repeat
               gotoxyl(3,24);
               write (' Terminou a entrada dos nós (S/N): ');
               sn:=readkey;
               writeln(sn);
               if (sn=chr(27)) then
                 goto saida;
             until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
          end;
        if (sn=chr(78)) or (sn=chr(110)) then
          begin
             inc(ctrlinha);
             goto lablinha5;
          end;
        if (sn=chr(115)) or (sn=chr(83)) then
          begin
             inc(ctrlinha);
             linha[ctrlinha]:=('                                                                                ');
             inc(ctrlinha);
             goto lablinha6;
          end;
      end;
    if (numgp=2) or (numgp=3) or (numgp=4) or (numgp=8) or (numgp=20) then
      begin
         inc(ctrlinha);
         Linha52;
      end;
    gotoxyl(72,6);
    gotoxyl(72,4);
    repeat
        gotoxyl(3,24);
        write (' Terminou a entrada dos nós (S/N): ');
        sn:=readkey;
        writeln(sn);
        if (sn=chr(27)) then
          goto saida;
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    if (sn=chr(78)) or (sn=chr(110)) then
      begin
        inc(ctrlinha);
        goto lablinha5;
      end;
    if (sn=chr(115)) or (sn=chr(83)) then
      begin
        inc(ctrlinha);
        linha[ctrlinha]:=('                                                                                ');
        inc(ctrlinha);
      end;

 { ***************** TELA 7 }
 { ** Dados de Vinculação LINHA 6 ** }
    lablinha6:
    Clrscr;
    MensC ('Cria arquivo de dados do DLEARN',26,2);
    MensC ('Linha 6: Dados de Vinculação',27,25);
    gotoxy(60,4);
    write ( 'Linha    : ');
    gotoxy( 60,6);
    write ( 'Variável : ');
    gotoxy(71,4);
    write ('6');
    gotoxyl(71,6);
    write ('N');
    repeat
      gotoxyl(3,8);
      write ( ' Número do primeiro nó da sequência para vinculação: ');
      readln(N3);
    until (N3<=NUMNP) and (N3>=1);
    str(N3,Auxiliar);
    gravareal(ctrlinha,1);
    gotoxyl(71,6);
    write ('NG');
    gotoxy (5,11);
    write (' Obs.: (0) Sem geração');
    gotoxy (3,10);
    write ( ' Incremento no número dos nós para geração: ');
    readln(NG);
    gotoxyl(1,11);
    If (NG>=1) then
      Begin
         gotoxyl(71,6);
         write ('NE');
         repeat
            gotoxyl(3,12);
            write ( ' Número do último nó da sequência para vinculação: ');
            readln(NE);
         until (NE<=NUMNP) and (NE>=1) and (NE>=N3);
         str(NE,Auxiliar);
         gravareal(ctrlinha,6);
         str(NG,Auxiliar);
         gravareal(ctrlinha,11);
      End;
    j:=0;
    for i:=1 to ndof do
      Begin
         gotoxyl(71,6);
         write ('ID(',i,',',N3,')');
         repeat
            gotoxy (3,14+i);
            write ( '     (0) Grau de liberdade ativo');
            gotoxy (3,15+i);
            write ( '     (1) Deslocamento prescrito');
            gotoxy (3,16+i);
            write ( '     (2) Velocidade prescrita');
            gotoxy (3,17+i);
            write ( '     (3) Aceleração prescrita');
            gotoxy (3,13+i);
            write ( '    Código de vinculação do grau de liberdade ',i,': ');
            sn:=readkey;
         until (sn=chr(48)) or (sn=chr(49)) or (sn=chr(50)) or (sn=chr(51));
         if sn=chr(48) then
            ID[i]:=0;
         if sn=chr(49) then
            ID[i]:=1;
         if sn=chr(50) then
            ID[i]:=2;
         if sn=chr(51) then
            ID[i]:=3;
         str(ID[i],Auxiliar);
         gravareal(ctrlinha,16+j);
         gotoxy (85,13+i);
         write(ord(sn)-48);
         j:=j+5;
      End;
    k:=i;
    for i:=1 to 4 do
      gotoxyl(1,13+k+i);
      gotoxyl(71,6);
      gotoxyl(71,4);
      repeat
         gotoxyl(3,24);
         write (' Dados estão OK (S/N): ');
         sn:=readkey;
         writeln(sn);
         if (sn=chr(27)) then
            goto saida;
         inc(ctrlinha);
         linha[ctrlinha]:=('                                                                                ');
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
       begin
         ctrlinha:=ctrlinha-1;
         linha[ctrlinha]:=('                                                                                ');
         goto lablinha6;
       end;
      repeat
         gotoxyl(3,24);
         write (' Terminou a entrada das vinculações (S/N): ');
         sn:=readkey;
         writeln(sn);
         if (sn=chr(27)) then
           goto saida;
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
         goto lablinha6;
      inc(ctrlinha);

{ ***************** TELA 8 }
{ ** Forças Nodais Prescritas / Condições Cinemáticas Impostas LINHA 7.1 ** }
    IF (NLVECT=0) then
     goto lablinha8;
    lablinha71:
    Clrscr;
    MensC ('Cria arquivo de dados do DLEARN',26,2);
    MensC ('  Linha 7.1: Forças Nodais Prescritas / Condições Cinemáticas Impostas',4,25);
    gotoxy(61,4);
    write ( 'Linha    : ');
    gotoxy( 61,6);
    write ( 'Variável : ');
    gotoxy(72,4);
    write ('7.1');
    gotoxyl(72,6);
    write ('N');
    repeat
      gotoxyl(3,8);
      write ( ' Número do nó: ');
      readln(N4);
    until (N4<=Numnp) and (N4>=1);
    str(N4,Auxiliar);
    gravareal(ctrlinha,1);
    gotoxyl(72,6);
    write ('NUMGP');
    repeat
      gotoxy (5,11);
      writeln (' Obs.: (0) Sem geração');
      gotoxy (12,12);
      writeln ('(2) Interpolação Linear');
      gotoxy (12,13);
      writeln ('(3) Interpolação Quadrática');
      gotoxy (12,14);
      writeln ('(4) Interpolação Bi-Linear (sobre superfície)');
      gotoxy (12,15);
      writeln ('(8) Interpolação Bi-Quadrática ou Tri-linear');
      gotoxy (12,16);
      writeln ('(20) Interpolação Tri-Quadrática');
      gotoxyl(3,10);
      write ( '   Tipo de geração: ');
      readln(NGP);
    until (ngp=0) or (ngp=2) or (ngp=3) or (ngp=4) or (ngp=8) or (ngp=20);
    str(NGP,Auxiliar);
    gravareal(ctrlinha,6);
    j:=0;
    for i:=1 to ndof do
     begin
       gotoxyl(72,6);
       write ('F(1,',i,')');
       gotoxy (3,17+i);
       write ( ' Força prescrita/Cond. cinem. impostas do grau de liberdade ',i,': ');
       readln(F[i]);
       Defzeros(F[i]);
       gravareal2(ctrlinha,11+j);
       j:=j+10;
     end;
    inc(ctrlinha);
    gotoxyl(72,6);
    gotoxyl(72,4);
    repeat
      gotoxyl(3,24);
      write (' Dados estão OK (S/N): ');
      sn:=readkey;
      writeln(sn);
      if (sn=chr(27)) then
       goto saida;
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    if (sn=chr(78)) or (sn=chr(110)) then
     begin
      ctrlinha:=ctrlinha-1;
      linha[ctrlinha]:=('                                                                                ');
      goto lablinha71;
     end;
    If NGP=0 then
     Begin
      repeat
        gotoxyl(3,24);
        write (' Terminou a entrada das forças / cond. cinemática imposta (S/N): ');
        sn:=readkey;
        writeln(sn);
        if (sn=chr(27)) then
          goto saida;
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
         goto lablinha71;
      if (sn=chr(115)) or (sn=chr(83)) then
       begin
         linha[ctrlinha]:=('                                                                                ');
         inc(ctrlinha);
       end;
     End;

{ ***************** TELA 9 }
{ ** Dados para geração de forças nodais e cond. cinemáticas impostas LINHA 7.2 ** }
    If NGP<>0 then
     Begin
      Linha72;
      repeat
         gotoxyl(3,24);
         write (' Terminou a entrada das forças / cond. cinemática imposta (S/N): ');
         sn:=readkey;
         writeln(sn);
         if (sn=chr(27)) then
          goto saida;
      until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
      if (sn=chr(78)) or (sn=chr(110)) then
       begin
         inc(ctrlinha);
         goto lablinha71;
       end;
      if (sn=chr(115)) or (sn=chr(83)) then
       begin
         inc(ctrlinha);
         linha[ctrlinha]:=('                                                                                ');
         inc(ctrlinha);
       end;
    End;

 { ***************** TELA 10 }
 { ** Funcoes de tempo LINHA 8 ** }
    lablinha8:
    IF NLTFTN=0 then
      goto lablinha9;
    For i:=1 to NLTFTN do
      Begin
       Clrscr;
       MensC ('Cria arquivo de dados do DLEARN',26,2);
       MensC ('Linha 8: Funções de Tempo',27,25);
       gotoxy(60,4);
       write ( 'Linha    : ');
       gotoxy(60,6);
       write ( 'Variável : ');
       gotoxy(71,4);
       write ('8');
       gotoxy(3,8);
       textcolor(red);
       writeln ('» Função no tempo = ',i);
       normvideo;
       writeln;
       writeln ( '    Obs.: As funções no tempo são aproximadas por retas. ');
       For J:=1 to (NPTSLF) do
         begin
           gotoxyl(1,12);
           gotoxyl(1,14);
           gotoxy (3,12);
           write (' Ponto = ',j);

           gotoxyl(71,6);
           write ('G(',J,',1)');
           gotoxyl(3,15);
           write ( '       Caso Estático --> Instante = 1 ');
           gotoxyl(3,14);
           write ( '    Instante : ');
           readln(FK[1]);
           Defzeros(FK[1]);
           gravareal2(ctrlinha,1);
           gotoxyl(1,15);

           gotoxy(71,6);
           write ('G(',J,',2)');
           gotoxyl(3,17);
           write ( '       Caso Estático --> Valor no Tempo = 1 ');
           gotoxyl(3,16);
           write ( '    Valor da função no tempo : ');
           readln(FK[2]);
           Defzeros(FK[2]);
           gravareal2(ctrlinha,11);
           gotoxyl(1,17);
           inc(ctrlinha);
         end;
      End;
    gotoxyl(71,6);
    gotoxyl(71,4);
    repeat
       gotoxyl(3,24);
       write (' Dados das funções no tempo estão OK (S/N): ');
       sn:=readkey;
       writeln(sn);
       if (sn=chr(27)) then
          goto saida;
    until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
    if (sn=chr(78)) or (sn=chr(110)) then
     begin
       for i:=1 to (1+nltftn*nptslf) do
         linha[ctrlinha-i]:=('                                                                                  ');
       ctrlinha:=ctrlinha-(1+NLTFTN*NPTSLF);
       goto lablinha8;
     end;

 { ***************** TELA 11 }
 { ** Condições iniciais dos nós LINHA 9 ** }
  IF Iacode=1 then
   begin
     ctrlinha:=ctrlinha-1;
     goto lablinha10;
   end;
  lablinha9:
    Linha9;

 {***************** TELA 13 }
  lablinha10:
    Linha10; { Chama a procedure auxiliar para os dois tipos de elementos }

  linha[ctrlinha]:=('*END');


  Saida: { GRAVAÇÃO DAS LINHAS NO ARQUIVO TEXTO }
  if controle<>15 then { Verifica se o usuário deu entrada nos dados para poder gravar }
   begin
        for i:=1 to 70 do
            begin
                 writeln(arq,linha[i]);
            end;
            close (arq);
   end;

End;
{***************************** F I M **************************Criar Arquivos}



{*************  Modificar Arquivos ***************}
PROCEDURE Modifica;

label saida;

begin
  Clrscr;
  MensC ('Modifica arquivo de dados do DLEARN',26,2);
  gotoxy(3,8);
  write ( 'Digite o nome do arquivo ( c/ extensão ): ');
  readln(nome);
  gotoxyl(45,8);
  writeln(nome);
  writeln;
  writeln;
  Assign(arq,nome);
  {$I-}
  Reset(Arq);
  {$I+}
  a:=IOResult;
  if a<>0 then
    Begin
       gotoxy(28,11);
       textcolor(red+blink);
       write ('Arquivo não encontrado');
       normvideo;
       readkey;
       repeat
           gotoXYl(3,18);
           write ( 'Deseja criar o arquivo (S/N): ');
           sn:=readkey;
           writeln (sn);
           if (sn=chr(27)) then
             goto saida;
       until (sn=chr(115)) or (sn=chr(83)) or (sn=chr(78)) or (sn=chr(110));
       if (sn=chr(83)) or (sn=chr(115)) then
         begin
           aux:=15;
           goto saida;
         end;
       if (sn=chr(78)) or (sn=chr(110)) then
          goto saida;
    End;

{*************** Leitura das variaveis no arquivo OK}
 for i:=1 to 100 do
   begin
    readln(arq,linha[i]);
   end;
 if aux<>15 then
   rewrite(arq);
 {modvar;  É NECESSARIO IMPLEMENTAR A UNIT MODVAR }


SAIDA:
  if (aux3=1) then
   begin
    for i:=1 to 100 do
     writeln(arq,linha[i]);
     close(arq);
   end;
  {if (nPos=11) and (aux<>15) then
   begin
    for i:=1 to 100 do
     writeln(arq,linha[i]);
     close(arq);
   end;}
  closegraph;
  npos:=1;
  cMenu[1] := 'Criar Arquivo ';
  cMenu[2] := 'Modificar Arquivo ';
  cMenu[3] := 'Conferir Arquivo  ';
  cMenu[4] := 'Ajuda';
  cMenu[5] := 'Sair do Programa';
  if aux =15 then
   cria;
end;





{****************************Conferir Arquivos}
PROCEDURE Confere;

Label saida;

Begin
 {Confere; EH NECESSARIO IMPLEMENTAR A UNIT CONFERE }
End;



{************************** PROGRAMA PRINCIPAL*******************************}
BEGIN
 Zerarvariaveis;
 Clrscr;
 Tela;
 { Aqui são as opções de escolha }
    cMenu[1] := 'Criar Arquivo ';
    cMenu[2] := 'Modificar Arquivo ';
    cMenu[3] := 'Conferir Arquivo  ';
    cMenu[4] := 'Sobre';
    cMenu[5] := 'Sair do Programa';

    {abertura;}
    repeat
          textbackground(0);
          textcolor(7);
          Clrscr;
          window(1,2,80,2);
          textbackground(9);
          {aqui é a parte de cima da tela}
          Clrscr;
          window(1,1,80,25);
          textcolor(white);
          gotoxy( 33, 2);
          write('Menu Principal');
          window(1,24,80,24);
          textbackground(9);
          {aqui é a parte de baixo da tela}
          Clrscr;
          window(1,1,80,25);
          textcolor(white );
          gotoxy( 25, 24);
          write('Use as setas <', chr(24),'> <', chr(25),'> e <Enter>');
          textcolor(7);
          textbackground(0);
          { Escrever na tela as opções }
          for ni := 1 to 5 do
          begin
               gotoxy( 30, ni + 8 );
               write(cMenu[ni]);
          end;
          nPos := 1;
          textcolor(8);
          { Retângulos externos e sombra }
          for ni:=1 to 6 do
          begin
             gotoxy( 28, ni+7);
             write('║');
          end;
          for ni:=1 to 6 do
          begin
             gotoxy( 61, ni+7);
             write('║');
          end;
          gotoxy (28,ni+8);
          write ('╚════════════════════════════════╝ ');
          gotoxy (28,8);
          write ('╔════════════════════════════════╗ ');
          for ni := 1 to 5 do
          begin
              gotoxy( 62, ni + 9);
              write('░');
          end;
          gotoxy( 30, ni + 10);
          write ('░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░');

          { Controle de repetições }
          repeat
                nPos_ant := nPos;

                if cte = 'P' then
                   nPos := nPos + 1
                else if cte = 'H' then
                   nPos := nPos - 1;

                if nPos < 1 then
                   nPos := 5
                else if nPos > 5 then
                   nPos := 1;

                window( 30, nPos_ant + 8, 60, nPos_ant + 8 );
                Textbackground(0);
                clrEol;
                window(1,1,80,25);
                Textcolor(7);
                gotoxy( 30, nPos_ant + 8 );
                write(cMenu[nPos_ant]);

                window( 30, nPos + 8, 60, nPos + 8 );
                Textbackground(11);
                ClrEol;
                window(1,1,80,25);
                Textcolor(0);
                gotoxy( 30, nPos + 8 );
                write(cMenu[nPos]);
                textbackground(0);
                textcolor(7);

                cte := readkey;

          until ( Ord(cte) = 13 );

               { Chamada das procedures nas opções }
               if nPos = 1 then Cria
          else if nPos = 2 then Modifica
          else if nPos = 3 then Confere
          else if nPos = 4 then Ajuda
          else if nPos = 5 then nPos := 11;
    Until ( nPos > 10 );
    Textcolor(7);
    Textbackground(0);
    Closegraph;
    Clrscr;

END.




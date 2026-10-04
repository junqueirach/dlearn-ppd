UNIT Geral;

INTERFACE
 Procedure Tela;
 Procedure Center( mensagem: string; tamanho: integer );
 Procedure MensC ( mensagem: string; c,l : integer );
 Procedure Ajuda;
 Procedure zerarvariaveis;
 Procedure gotoxyl ( x,y : integer );


IMPLEMENTATION
 uses Graph, Crt;



Procedure Tela;

Var
 i:integer;
 Linha: Array [1..100] of String[80];


 Begin
   clrscr;
   gotoxy(1,1);
   writeln ('  ┌───────────────────────────────────────────────────────────────────────────┐');
   writeln ('  │                                                                           │');
   write   ('  │             ');
   textcolor(white);
   write   (' Programa gerador de Arquivo de Dados para o DLEARN');
   normvideo;
   writeln ('           │');
   writeln ('  │                                                                           │');
   writeln ('  │                                                                           │');
   gotoxy(3,6);
   write ('│');
   gotoxy(4,6);
   textcolor(red+blink);
   write  ('                       Versão 1.02  - Sistema gratuito');
   normvideo;
   gotoxy(79,6);
   write ('│');
   gotoxy(1,7);
   write ('  │                                                                           │');
   gotoxy(3,8);
   write ('│');
   gotoxy(4,8);
   textcolor(blue);
   write ('                          UNESP - Campus de Bauru');
   normvideo;
   gotoxy(79,8);
   writeln ('│');
   normvideo;
   writeln ('  │                                                                           │');
   writeln ('  │                                                                           │');
   write   ('  │                      ');
   textcolor(white);
   write   ('Departamento de Engenharia Civil');
   normvideo;
   writeln ('                     │');
   writeln ('  │                                                                           │');
   writeln ('  │                                                                           │');
   writeln ('  │                                                                           │');
   writeln ('  │                                                                           │');
   writeln ('  │   Autor: Luiz Eduardo Lollato Junqueira   ( duda100@hotmail.com )         │');
   writeln ('  │                                                                           │');
   writeln ('  │   Orientador: Prof. Dr. Heitor M. Bottura ( heitor@feb.unesp.br )         │');
   writeln ('  │                                                                           │');
   writeln ('  │                                                                           │');
   writeln ('  │                                                                           │');
   writeln ('  │                                                                           │');
   writeln ('  │                                            Ultima atualização: 01/12/2001 │');
   writeln ('  └───────────────────────────────────────────────────────────────────────────┘');
   readkey;
   for i:=1 to 100 do
     linha[i]:='                                                                                                         ';
 End;



Procedure Center( mensagem: string; tamanho: integer );
 Begin
  tamanho:= 40 + length(mensagem) div 2;
  writeln (Mensagem:tamanho);
 End;



Procedure MensC( mensagem: string; c,l : integer );
 Begin
     window( 1, l, 80, l);
     textbackground(9);
     clrscr;
     window(1,1,80,25);
     textcolor(10);
     gotoxy(c,l);
     write( mensagem );
     textbackground(0);
     textcolor(7);
 End;



Procedure gotoxyl( x,y : integer );

 Begin
     gotoxy(x,y);
     clreol;
 End;



{****************************Zerar Variaveis do Programa}
Procedure Zerarvariaveis;

VAR

IECHO,IEXEC,IACODE,IREADR,IWRITR,IPRTIN,IRANK,NUMSEQ,NDOUT,NSD,NUMNP,NDOF,
NLVECT,NLTFTN,NPTSLF,NUMEG,NUMGP,NGP,NGP2,N2,NINC1,NINC2,NINC3,INC1,INC2,
INC3,NINC12,NINC22,NINC32,INC12,INC22,INC32,NINC13,NINC23,NINC33,INC13,
INC23,INC33,M,MGEN,N3,N4,NE,NG,N5,NTYPE,NUMEL,NUMAT,NSURF,NSOUT,IOPT,
ISTPRT,LFSURF,LFBODY,NICODE,IBBAR,IMASS,IMEXP,IELNO,ISIDE,NINT,NEN:Integer;

N1,NSTEP,NDPRT,NSPRT,NHPLT,NITER,IDHIST1,IDHIST2,IDHIST3,ID,IEN,
NEL,INCEL,ISHIST,AUXI:Array[1..70] of Integer;

ALPHA,BETA,GAMMA,DT,X1,X2,X3,Temp1,Temp2,Temp3,F,F2,F3,FK,E,

POIS,RHO,RDAMPM,RDAMPK,TH,GRAV,PRESS,SHEAR,AREA:Array[1..70] of REAL;
i,j,k,a,b,num,aux,aux2,aux3,aux4,aux5,aux6,aux7,aux8,aux9,
controle,linhamod,colmod,ctrlinha,ctrnumeg,tipoele:Integer;

Auxiliar:   String[5];
Auxiliar2:  String[10];
Npos, NPos_ant, Ni:Integer;


 Begin

   IECHO:=0;IEXEC:=0;IACODE:=0;IREADR:=0;IWRITR:=0;IPRTIN:=0;IRANK:=0;NUMSEQ:=0;
   NDOUT:=0;NSD:=0;NUMNP:=0;NDOF:=0;NLVECT:=0;NLTFTN:=0;NPTSLF:=0;NUMEG:=0;NUMGP:=0;
   NGP:=0;NGP2:=0;N2:=0;NINC1:=0;NINC2:=0;NINC3:=0;INC1:=0;INC2:=0;INC3:=0;
   NINC12:=0;NINC22:=0;NINC32:=0;INC12:=0;INC22:=0;INC32:=0;NINC13:=0;NINC23:=0;
   NINC33:=0;INC13:=0;INC23:=0;INC33:=0;M:=0;MGEN:=0;N3:=0;N4:=0;NE:=0;NG:=0;
   N5:=0;NTYPE:=0;NUMEL:=0;NUMAT:=0;NSURF:=0;NSOUT:=0;IOPT:=0;ISTPRT:=0;
   LFSURF:=0;LFBODY:=0;NICODE:=0;IBBAR:=0;IMASS:=0;IMEXP:=0;IELNO:=0;ISIDE:=0;
   NINT:=0;NEN:=0;

   For i:=1 to 70 do
     begin
        N1[i]:=0;NSTEP[i]:=0;NDPRT[i]:=0;NSPRT[i]:=0;NHPLT[i]:=0;NITER[i]:=0;
        IDHIST1[i]:=0;IDHIST2[i]:=0;IDHIST3[i]:=0;ID[i]:=0;IEN[i]:=0;NEL[i]:=0;
        INCEL[i]:=0;ISHIST[i]:=0;AUXI[i]:=0;ALPHA[i]:=0;BETA[i]:=0;
        GAMMA[i]:=0;DT[i]:=0;X1[i]:=0;X2[i]:=0;X3[i]:=0;Temp1[i]:=0;
        Temp2[i]:=0;Temp3[i]:=0;ID[i]:=0;F[i]:=0;F2[i]:=0;F3[i]:=0;
        FK[i]:=0;E[i]:=0;POIS[i]:=0;RHO[i]:=0;RDAMPM[i]:=0;RDAMPK[i]:=0;
        TH[i]:=0;GRAV[i]:=0;PRESS[i]:=0;SHEAR[i]:=0;AREA[i]:=0;
     end;

   i:=0;j:=0;k:=0;a:=0;b:=0;num:=0;aux:=0;aux2:=0;aux3:=0;aux4:=0;aux5:=0;
   aux6:=0;aux7:=0;aux8:=0;aux9:=0;controle:=0;linhamod:=0;colmod:=0;
   ctrlinha:=0;ctrnumeg:=0;tipoele:=0;
   Npos:=0;NPos_ant:=0;Ni:=0;

 End;



Procedure Ajuda;

 Begin
   clrscr;
   MensC ('Help do programa',31,1);
   writeln;
   writeln;
   writeln ('   Este programa esta sendo desenvolvido com o objetivo de agilizar a entrada');
   writeln (' de dados do DLEARN que funciona em linguagem FORTRAN.              ');
   writeln;
   writeln;
   writeln ('   Foi desenvolvido apenas a parte de criação de arquivos, mais informações  ');
   writeln (' podem ser encontradas no CD junto do trabalho ou no web-site do autor:');
   writeln;
   textcolor(lightblue);
   writeln ('  http://www.geocities.com/dlearnbr');
   normvideo;
   writeln;
   writeln ('    ou redirecionado:');
   textcolor(lightblue);
   writeln ('  http://dlearnbr.cjb.net ');
   normvideo;
   writeln;
   writeln;
   writeln;
   writeln ('   Juntamente com o programa é distribuído um arquivo texto (Formato Word97) ');
   writeln ('discrevendo todas as variaveis do DLEARN');
   writeln;
   gotoxy(1,22);
   write ('      Dúvidas ou sugestões: Autor: ');
   textcolor(blue);
   writeln ('duda100@hotmail.com ');
   normvideo;
   write ('                            Orientador: ');
   textcolor(blue);
   writeln ('heitor@feb.unesp.br');
   normvideo;
   MensC ('Tecle algo para voltar ao Menu Pricipal',23,25);
   readkey;
 End;



BEGIN

END.

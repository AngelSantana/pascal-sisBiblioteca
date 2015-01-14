program
  SisBiblioteca;
uses
  crt, sysutils, DOS;
 
// ------------- ALUNO --------------------
type listISBNLivros = array[1..2, 1..3] of string;
	type Aluno = record   //Registro de Aluno
	nome : string[30];
	mat : integer;
	isbnLivros : listISBNLivros;
	sexo: char;
	curso : string[20];
end;

type returnVerifMatricula = record //Criado para guardar dados da mattrícula
	nome : string[30];
	mat : integer;
	isbnLivros : listISBNLivros;
	pos: integer;
	sexo : char;
	curso : string[20];
end;

tableAlunos = file of Aluno; //Arquivo do tipo Aluno

// ----------- LIVRO ---------------------
type Livro = record
	nome : string[30];
	autor : string[30];
	editora : string[20];
	isbn: string[13];
	quant: integer;
end;

type r_infLivro = record
	nome : string[30];
	isbn : string[13];
	autor : string[30];
	editora : string[20];
	quant: integer;
	pos: integer;
end;

tableLivros = file of Livro;
const MAXLVR = 6;
type array_inforLivro = array[1..MAXLVR+1] of r_infLivro;
 
//--------------------------------- Funções------------------------------------
//===================== Aluno ======================
{Funcao para verificar a existencia de um arquivo}
function ExisteTabelaAluno(var f : tableAlunos): boolean;
begin
	{$I-}
	Reset(f);
	if IOResult = 0 then 
		ExisteTabelaAluno := true
	else ExisteTabelaAluno := false;
	{$I+}
end;

function ExtArqTextAlunos(var f : text): boolean;
begin
	{$I-}
	Reset(f);
	if IOResult = 0 then 
		ExtArqTextAlunos := true
	else ExtArqTextAlunos := false;
	{$I+}
end;
function verificaMatricula(var f : tableAlunos; matricula:integer;  r: Aluno): returnVerifMatricula;
var infor : returnVerifMatricula;
begin
      infor.nome := '';
      infor.mat := -1;
      infor.pos := -1;
	  // Aqui irei tribuir -1 para o nome do livro, -1 para a data de emprestimo e -1 para
	  // a data de devolução
	  //======== Livro 1, isbn, emprestimo e devolução
	  infor.isbnLivros[1,1] := '-1' ;//isbn
	  infor.isbnLivros[1,2] := '-1' ;// data emprestimo
	  infor.isbnLivros[1,3] := '-1' ;// data devolução
	  //======== Livro 1, isbn, emprestimo e devolução
      infor.isbnLivros[2,1] := '-1' ; //isbn
	  infor.isbnLivros[2,2] := '-1' ;//data emprestimo
	  infor.isbnLivros[2,3] := '-1' ;// data devolução
                      
      infor.curso := '';
      verificaMatricula :=  infor;
      Reset(f);
      read(f,r);
      while (not Eof(f)) and (r.mat <> matricula) do
          read(f,r);
          if r.mat = matricula then
              begin
                  with r do
                      infor.nome := r.nome;
                      infor.mat := r.mat;
                      infor.pos := FilePos(f);
                      infor.curso := r.curso;
                      infor.isbnLivros[1,1] := r.isbnLivros[1,1] ;//isbn
                      infor.isbnLivros[1,2] := r.isbnLivros[1,2] ;// data emprestimo
		      		  infor.isbnLivros[1,3] := r.isbnLivros[1,3] ;// data devolução
	      			  //======== Livro 1, isbn, emprestimo e devolução
                      infor.isbnLivros[2,1] := r.isbnLivros[2,1] ; //isbn
		              infor.isbnLivros[2,2] := r.isbnLivros[2,2] ;//data emprestimo
		              infor.isbnLivros[2,3] :=   r.isbnLivros[2,3] ;// data devolução
                      infor.sexo := r.sexo;
                      verificaMatricula :=  infor;
              end
          else
              begin
                  infor.nome := '';
                  infor.mat := -1;
                  infor.pos := -1;
		      	  // Aqui irei tribuir -1 para o nome do livro, -1 para a data de emprestimo e -1 para
		          // a data de devolução
		          //======== Livro 1, isbn, emprestimo e devolução
		          infor.isbnLivros[1,1] := '-1' ;//isbn
		          infor.isbnLivros[1,2] := '-1' ;// data emprestimo
		          infor.isbnLivros[1,3] := '-1' ;// data devolução
		          //======== Livro 1, isbn, emprestimo e devolução
                  infor.isbnLivros[2,1] := '-1' ; //isbn
                  infor.isbnLivros[2,2] := '-1' ;//data emprestimo
		          infor.isbnLivros[2,3] := '-1' ;// data devolução
                  infor.curso := '';
                  verificaMatricula :=  infor;
              end;
end;

// ========================== Livros ===================================
function ExisteTabelaLivros(var f : tableLivros): boolean;
begin
	{$I-}
	Reset(f);
	if IOResult = 0 then 
		ExisteTabelaLivros := true
	else ExisteTabelaLivros := false;
	{$I+}
end;

function ExtArqTextLivros(var f : text): boolean;
begin
	{$I-}
	Reset(f);
	if IOResult = 0 then 
		ExtArqTextLivros := true
	else ExtArqTextLivros := false;
	{$I+}
end;

function verificaISBN(var f : tableLivros; isbn:string[13];  r: Livro): r_infLivro;
var inforLivro : r_infLivro;
begin
	  inforLivro.nome := '';
	  inforLivro.isbn := '';
	  inforLivro.autor := '';
	  inforLivro.editora :='';
	  inforLivro.quant := -1;					  
	  inforLivro.pos := -1;
	  verificaISBN :=  inforLivro;
	  Reset(f);
	  read(f,r);
	  
      while (not Eof(f)) and (r.isbn <> isbn) do
		   read(f,r);
		   if r.isbn = isbn then
		     begin
			  with r do
				  inforLivro.nome := r.nome;
				  inforLivro.isbn := r.isbn;
				  inforLivro.autor := r.autor;
				  inforLivro.editora := r.editora;
				  inforLivro.quant := r.quant;
				  inforLivro.pos := FilePos(f);
				  verificaISBN :=  inforLivro;
		      end
		  else
			  begin
					  inforLivro.nome := '';
					  inforLivro.isbn := '';
					  inforLivro.autor := '';
					  inforLivro.editora :='';
					  inforLivro.quant := -1;
					  inforLivro.pos := -1;
					  verificaISBN :=  inforLivro;
			  end;
end;

function buscaPor(var f : tableLivros; campo: string[30] ;escolha: string;  r: Livro): array_inforLivro;
var arrayInforLivro :  array_inforLivro;
i : integer;
begin
	i := 0;
	Reset(f);
    while (not Eof(f)) do
	begin
		read(f,r);
		if escolha = 'N' then
		begin
			if r.nome = campo then
			begin	
				i := i+1;									
				arrayInforLivro[i].isbn :=  r.isbn;
				arrayInforLivro[i].autor := r.autor;
				arrayInforLivro[i].editora := r.editora;
				arrayInforLivro[i].quant := r.quant;
				arrayInforLivro[i].pos := 0;
			end;
		end
		else if escolha = 'A' then
		begin
			if r.autor = campo then
				begin	
					i := i+1;									
					arrayInforLivro[i].nome := r.nome;
					arrayInforLivro[i].isbn := r.isbn;
					arrayInforLivro[i].editora := r.editora;
					arrayInforLivro[i].quant := r.quant;
					arrayInforLivro[i].pos := 0;
					
				end;
		end
		else if escolha = 'E' then
		begin
			if r.editora = campo then
				begin		
					i := i+1;									
					arrayInforLivro[i].nome := r.nome;
					arrayInforLivro[i].isbn := r.isbn;
					arrayInforLivro[i].autor := r.autor;
					arrayInforLivro[i].quant := r.quant;
					arrayInforLivro[i].pos := 0;									
				end;
		end;			
	end;
	i := i+1 ;
	arrayInforLivro[i].pos := -1;
	i := 0;
	buscaPor := arrayInforLivro;


end;

//================================ Time
function obterDataAtual(comBarra:string):string;
Var
	Dia,
	Mes,
	Ano ,
	Dia_Semana,
	Hora,
	Minuto,
	Segundo,
	Dec_Segundo : Word; {O tipo das variáveis deve ser WORD
	pois até agora não vi data negativa...}
    d1, m1, a1 : integer;
    d, m, a : string;
begin
	GetDate(Ano, Mes, Dia, Dia_Semana);  
	GetTime(Hora, Minuto, Segundo, Dec_Segundo);
	//Writeln(Hora, ':', Minuto, ':', Segundo); {Escreve a hora}
    d1 := Dia;
    m1 := Mes;
    a1 := Ano;
	if upCase(comBarra) = 'S' then
		begin
            Str(d1, d);
            Str(m1, m);
            Str(a1, a);
			obterDataAtual := concat(d, '/',m, '/', a, '/'); {Escreve a data}
		end
    else 
		begin	
			obterDataAtual := concat(d,'',m,'',a,''); {Escreve a data}
		end;
end;
	
function obter(data, get :string):integer;
var dia, mes, ano, i : integer;
begin
        for i := 1 to length(data) do
        begin
           if data[i] = '/' then
           begin
	           Val(Copy(data,1,i-1), dia);
	           Delete(data,1,i);
	           break;
           end;
       end;
       
       for i := 1 to length(data) do
	   begin
	          if data[i] = '/' then
	          begin
	              Val(Copy(data,1,i-1), mes);
	              Delete(data,1,i);
	              break;
	           end;
	   end;
	   
       Val(Copy(data,1,LENGTH(data)), ano);
       if upCase(get) = 'DIA' then
	   begin
			obter := dia;
	   end
	   else if upCase(get) = 'MES' then
	   begin
			obter := mes;
		end
	    else if upCase(get) = 'ANO' then
		begin
			obter := ano;
		end;
end;
	
function quantDias(diaInicial, mesInicial, diaFinal, mesFinal, ano:integer):integer;
const mesesDias : array [1 .. 2, 1 ..12] of integer = ((1,2,3,4,5,6,7,8,9,10,11,12),(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));
var i,quantD : integer;
	bissexto : boolean;
begin
	bissexto := false;
	//Bissexto --------------------------------------------------------------
    IF ((ano mod 4 = 0)  AND ((ano mod 400 = 0)  or (ano mod 100 <> 0))) THEN
	  	BEGIN
			bissexto := true;
	    END
	ELSE
		BEGIN
			bissexto := false;
        END;		
	 //----------------------------------------------------------------------- 
	IF bissexto = true THEN
	   BEGIN
			mesesDias[2, 2] := 29;
	   END
	ELSE
		BEGIN
			 mesesDias[2, 2] := 28;
		END;
		
    if mesInicial <> mesFinal then
         begin
			for i := mesInicial to mesFinal do
				BEGIN
						IF (i = mesInicial) THEN
						   BEGIN
								quantD := mesesDias[2, mesInicial] - diaInicial;
						   END
						else IF (i = mesFinal) THEN
						   BEGIN
								quantD := quantD + diaFinal;
						   END
						else
							BEGIN
								 quantD := quantD+mesesDias[2,i];
							 END;

                       quantDias := quantD;
				  END;
          end
      else
          begin
               quantDias :=     diaFinal - diaInicial;
          end;
end;	

// =========================== Aluno Livro ================

function verifPendencia(dataEmp, dataDev:string):boolean;
begin
	if (quantDias(obter(dataEmp, 'DIA'), obter(dataEmp, 'MES'), obter(dataDev, 'DIA'), obter(dataDev, 'MES'), obter(dataDev, 'ANO'))) > 7  then
		begin
			verifPendencia := true;
		end
	else 
		begin
			verifPendencia := false;
		end;
end;

var
opcao: integer;
//################### Alunos
tabelaAlunos : tableAlunos;
regAluno : Aluno;
arquivoTextAluno:Text;
buscaMatricula : integer;
//################## Livros
tabelaLivros : tableLivros;
regLivro : Livro;
aquivoTextLivros:Text;
full: boolean;
campo: string;
i, contReg:integer;
inforLivro : r_infLivro;
listaLivros : array_inforLivro;
 //############## Outras ...
escolha : char;
buscaISBN : string[13];
n, n1, local :integer;
nome : string;
contSacola : integer;
ok, inseriu : boolean;
 //############### Data
dataEmp, dataDev : string;
Dia,
Mes,
Ano ,
Dia_Semana,
Hora,
Minuto,
Segundo,
Dec_Segundo : Word;
d1, m1, a1 : integer;
d, m, a : string;
	
	
//#################################

begin
  //+++++++++++++++++ Alunos +++++++++++++++++
  assign(tabelaAlunos, 'Alunos.arq');      
  assign(arquivoTextAluno, 'Alunos.txt');
  // +++++++++++++++++++++ Livros +++++++++++++
  assign(tabelaLivros, 'Biblioteca.arq');
  assign(aquivoTextLivros, 'Biblioteca.txt');
  //Irei deixar separado a principio depois analisar e juntar ...
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     Alunooooooo
  if not ExtArqTextAlunos(arquivoTextAluno) OR ExisteTabelaAluno(tabelaAlunos) then
  begin
	  	//Atenção! Verificar quando for cadastrar sem os arquivos criados.
		rewrite(arquivoTextAluno);
		close(arquivoTextAluno);									
  end;
  //~~~~~~~~~~~~~~~~~ AS:130907
  if not  ExtArqTextLivros(aquivoTextLivros) OR ExisteTabelaLivros(tabelaLivros) then
  begin
	  	//Atenção! Verificar quando for cadastrar sem os arquivos criados.
		rewrite(aquivoTextLivros);
		close(aquivoTextLivros);									
   end;			
   full := false;
   i := 1;
   contReg := 0;
   ok := true;
   inseriu := false;
   local := 0;

	repeat
		clrscr;
 
		writeln('     SISBiblioteca ');
		writeln;
		writeln(' 1. Cadastrar Aluno(s)');
		writeln(' 2. Cadastrar Livro(s)');
		writeln(' 3. Consultar Livro(s)');
		writeln(' 4. Consulta de pendencia de aluno');
        writeln(' 5. Pedido de emprestimo/devolucoes de livros');
        writeln(' 6. Listar Aluno(s)');
        writeln(' 7. Encerrar');
		writeln;
		write(' Digite a opcao desejada: ');
		readln(opcao); 

 
		case opcao of
			1: 
				begin
					clrscr;
					writeln('     SISBiblioteca - Cadastro de Aluno(s)');
					writeln;
					write(' Nome: ');
					readln(regAluno.nome);
					write(' Matricula: ');
					readln(regAluno.mat);
					write(' Sexo: ');
					readln(regAluno.sexo);
					write(' Curso: ');
					readln(regAluno.curso);
					// Aqui irei tribuir -1 para o nome do livro, -1 para a data de emprestimo e -1 para
					// a data de devolução
					//======== Livro 1, isbn, emprestimo e devolução
					regAluno.isbnLivros[1,1] := '-1' ;//isbn
					regAluno.isbnLivros[1,2] := '-1' ;// data emprestimo
					regAluno.isbnLivros[1,3] := '-1' ;// data devolução
					//======== Livro 1, isbn, emprestimo e devolução
					regAluno.isbnLivros[2,1] := '-1' ; //isbn
					regAluno.isbnLivros[2,2] := '-1' ;//data emprestimo
					regAluno.isbnLivros[2,3] := '-1' ;// data devolução
                    if not   ExisteTabelaAluno(tabelaAlunos) then
	                    begin
                           rewrite(tabelaAlunos);
	                       write(tabelaAlunos, regAluno);
                           close(tabelaAlunos);
						   write('Cadastrado com sucesso. Pressione ENTER para retornar ao menu.');
                           readln;								  
                        end
                    else
                        begin
                             Reset(tabelaAlunos);
                             buscaMatricula := regAluno.mat;
                             n := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).pos;
                             if  n = -1 then
                                begin
                                      Seek(tabelaAlunos, FileSize(tabelaAlunos));
                                      write(tabelaAlunos, regAluno);
                                      close(tabelaAlunos);
                                      writeln;
                                      write('Cadastrado com sucesso. Pressione ENTER para retornar ao menu.');
                                      readln;
                                end
                             else
                                 begin
                                      nome := verificaMatricula(tabelaAlunos, regAluno.mat, regAluno).nome;
                                      writeln('Aluno(a) ', nome , ' ja cadastrado(a). ');
                                      write(' Deseja atualizar os dados deste aluno?  S/N: ');
                                      readln(escolha);

                                      if upCase(escolha) = 'S' then
                                         begin
                                              clrscr;
                                              Reset(tabelaAlunos);
                                              writeln('     SISBiblioteca - Atualizacao dados do(a) aluno(a) ', nome);
                                              writeln;
                                              write('Digite o novo nome: ');
                                              readln(regAluno.nome);
                                              write('Digite o novo sexo: ');
                                              readln(regAluno.sexo);
                                              write('Digite o novo curso: ');
                                              readln(regAluno.curso);
											  regAluno.isbnLivros[1,1] := verificaMatricula(tabelaAlunos, regAluno.mat, regAluno).isbnLivros[1,1];
											  regAluno.isbnLivros[2,1] := verificaMatricula(tabelaAlunos, regAluno.mat, regAluno).isbnLivros[2,1];
											  regAluno.isbnLivros[1,2] := verificaMatricula(tabelaAlunos, regAluno.mat, regAluno).isbnLivros[1,2];
											  regAluno.isbnLivros[2,2] := verificaMatricula(tabelaAlunos, regAluno.mat, regAluno).isbnLivros[2,2];
											  regAluno.isbnLivros[1,3] := verificaMatricula(tabelaAlunos, regAluno.mat, regAluno).isbnLivros[1,3];
											  regAluno.isbnLivros[2,3] := verificaMatricula(tabelaAlunos, regAluno.mat, regAluno).isbnLivros[2,3];												  
                                              Seek(tabelaAlunos, n-1);
                                              write(tabelaAlunos, regAluno);
                                              writeln;
                                              write('Usuario atualizado com sucesso. Pressione ENTER para retornar ao menu.');
                                         end
                                      else
                                          begin
                                               clrscr;
                                               write('Cancelado pelo usuario. Pressione ENTER para retornar ao menu.');
                                          end;
                                      readln;
                                 end;
                         end;
				end;
			2: //Cadastro de Livros;
				begin
					clrscr;
					writeln('     SISBiblioteca - Cadastro de Livros');
					writeln;														
					write(' Nome: ');
					readln(regLivro.nome);
					write(' Autor: ');
					readln(regLivro.autor);
					write(' Editora: ');
					readln(regLivro.editora);
					write(' ISBN: ');
					readln(regLivro.isbn);
					write(' Quantidade em estoque: ');
					readln(regLivro.quant);

					if not  ExisteTabelaLivros(tabelaLivros) then
						begin																			
							rewrite(tabelaLivros);
							write(tabelaLivros, regLivro);
							close(tabelaLivros);
							write('Cadastrado com sucesso. Pressione ENTER para retornar ao menu.');
	                        readln;
						end
					else
					   begin
							Reset(tabelaLivros);
							if FileSize(tabelaLivros) = MAXLVR then
								begin
									full := true;
								end
							else
								begin
									full := false;
								end;
							buscaISBN := regLivro.isbn;
							n := verificaISBN(tabelaLivros, buscaISBN, regLivro).pos;
							if (n = -1) and (full = false) then
								begin
									Seek(tabelaLivros, FileSize(tabelaLivros));
									write(tabelaLivros, regLivro);
									close(tabelaLivros);
									writeln;
									write('Cadastrado com sucesso. Pressione ENTER para retornar ao menu.');
									readln;
								end
							else if ( ((n <> -1) and (full = true)) OR ((n <> -1) and (full = false)) ) then 
								begin
									inforLivro := verificaISBN(tabelaLivros, regLivro.isbn, regLivro);
									nome := inforLivro.nome;
									clrscr;
									writeln('Livro(a) ', nome , ' ja cadastrado(a). ');
									write(' Deseja atualizar o estoque?  S/N: ');
									readln(escolha);

									if upCase(escolha) = 'S' then
										begin
											clrscr;
											Reset(tabelaLivros);
											writeln('     SISBiblioteca - Atualizacao do livro ', nome);
											writeln;

											regLivro.nome :=  inforLivro.nome;
											regLivro.autor :=  inforLivro.autor;
											regLivro.editora :=  inforLivro.editora;
											regLivro.isbn :=  inforLivro.isbn;
											write('Digite a nova quantidade: ');
											read(regLivro.quant);
											Seek(tabelaLivros, n-1);
											write(tabelaLivros, regLivro);
											writeLN('Estoque atualizado com sucesso. Pressione ENTER para retornar ao menu.');
										end
									else
										begin
											clrscr;
											write('Cancelado pelo usuario. Pressione ENTER para retornar ao menu.');
											readln;
										end;
								end
							else
								begin
									write('Novo registro nao sera inserido. So eh permitido atualizacao!');
									readln;
								end;
						end;
				    	readln;
				end;
			3: 
				begin
					clrscr;
					writeln('     SISBiblioteca - Consulta de Livros');
					writeln;
					writeln(' Digite por qual informacao sera efetuada a busca ');
					writeln;
					writeLN(' N - Nome   A - Autor   E - Editora ou Qualquer Letra para exibir todos');
					readln(escolha);
		          	case UPCASE(escolha) of
			              'N':
                               begin
									writeln('Digite o nome do livro para efetuar a busca: ');
									readln(campo);
									listaLivros := buscaPor(tabelaLivros, campo ,escolha, regLivro);
									while (listaLivros[i].pos <> -1) do
										begin
											 writeln('Autor : ', listaLivros[i].autor);
											 writeln('Editora: ', listaLivros[i].editora);
											 writeln('ISBN: ', listaLivros[i].isbn);
											 writeln('Quant. Estoque: ', listaLivros[i].quant);												 
											 writeln('');
											 i:=i+1;
										end;
                                    writeln('----------------------------------------------');
                                    writeln('Busca concluida, total de registros: ', i - 1);
									i := 1;
									readln;
                               end;
                          'A':
                              begin
									writeln('Digite o nome do autor para efetuar a busca: ');
									readln(campo);
									listaLivros := buscaPor(tabelaLivros, campo ,escolha, regLivro);
									while (listaLivros[i].pos <> -1) do
										begin
											 writeln('Nome: : ', listaLivros[i].nome);
											 writeln('Editora: ', listaLivros[i].editora);
											 writeln('ISBN: ', listaLivros[i].isbn);
											 writeln('Quant. Estoque: ', listaLivros[i].quant);												 
											 writeln('');
											 i:=i+1;
										end;
                                    writeln('----------------------------------------------');
                                    writeln('Busca concluida, total de registros: ', i - 1);
									i := 1;
									readln;							  
                              end;
                          'E':
                              begin
									writeln('Digite o nome da editora para efetuar a busca: ');
									readln(campo);
									listaLivros := buscaPor(tabelaLivros, campo ,escolha, regLivro);
										while (listaLivros[i].pos <> -1) do
											begin

												 writeln('Nome: : ', listaLivros[i].nome);
												 writeln('Autor: ', listaLivros[i].autor);
												 writeln('ISBN: ', listaLivros[i].isbn);
												 writeln('Quant. Estoque: ', listaLivros[i].quant);												 
												 writeln('');
												  i:=i+1;
											end;
                                            writeln('----------------------------------------------');
                                            writeln('Busca concluida, total de registros: ', i - 1);
											i := 1;
											readln;							  
                              end
                          else // lista todos
                              begin
                                   Reset(tabelaLivros);
                                   rewrite(aquivoTextLivros);
                                   while not Eof(tabelaLivros) do
                                         begin
                                                  contReg := contReg + 1;
                                                 read(tabelaLivros, regLivro);
                                                 writeln('Nome: ', regLivro.nome);
                                                 writeln('Autor : ', regLivro.autor);
                                                 writeln('Editora: ', regLivro.editora);
                                                 writeln('ISBN: ', regLivro.isbn);
                                                 writeln('Quant. Estoque: ', regLivro.quant);												 
                                                 writeln('');
                                               if not   ExtArqTextLivros(aquivoTextLivros) then
                                                begin
                                                        rewrite(aquivoTextLivros);
                                                   end
                                               else
                                                   begin
                                                        Append(aquivoTextLivros);
                                                  end;
												  writeln(aquivoTextLivros, 'Nome: ', regLivro.nome);
												  writeln(aquivoTextLivros, 'Autor : ', regLivro.autor);
												  writeln(aquivoTextLivros, 'Editora: ', regLivro.editora);
												  writeln(aquivoTextLivros, 'ISBN: ', regLivro.isbn);
												  writeln(aquivoTextLivros, 'Quant. Estoque: ', regLivro.quant);
                                                  writeln(aquivoTextLivros, '');
												  close(aquivoTextLivros);
                                         end;
                                            writeln('----------------------------------------------');
                                            writeln(' Total de registros: ', contReg);
                                             if not   ExtArqTextLivros(aquivoTextLivros) then
                                                begin
                                                    rewrite(aquivoTextLivros);
                                                end
                                             else
                                                 begin  
                                                    Append(aquivoTextLivros);
                                             end;   
                                             writeln(aquivoTextLivros, '----------------------------------------------');
                                             writeln(aquivoTextLivros, ' Total de registros: ', contReg);
                                             close(aquivoTextLivros);
                                             contReg := 0;


                            end;
					   readln;						

                        end;
				end;
			4: //excluirAluno;
				begin
							clrscr;
							writeln('     SISBiblioteca - Consulta de pendencia de alunos');
							writeln;
							write(' Digite a matricula do aluno: ');
							readln(buscaMatricula);
                            Reset(tabelaAlunos);
							if verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).pos <> -1 then
								begin
									writeln(' Nome: ',verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).nome);
									writeln(' Curso: ',verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).curso);																																		
									for contSacola := 1 to 2 do 
										begin
											//verificarPrazoEntrega
											dataEmp := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[contSacola,2];
											dataDev := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[contSacola,3];
																				
											if  verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[contSacola,1] <> '-1' then
												begin
													GetDate(Ano, Mes, Dia, Dia_Semana);								
													d1 := Dia;
													m1 := Mes;
													a1 := Ano;
													Str(d1, d);
													Str(m1, m);
													Str(a1, a);
													if (quantDias(obter(dataEmp, 'DIA'), obter(dataEmp, 'MES'), d1,    m1, ano )) > 7  then
														begin
															write(' O livro ',  verificaISBN(tabelaLivros, verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[contSacola,1] ,  regLivro).nome, ' esta com prazo vencido!');
															writeln;
														end
													else 
														begin
															write(' O livro ',  verificaISBN(tabelaLivros, verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[contSacola,1] ,  regLivro).nome, ' esta em dia!');
															writeln;
														end;
												end
                                             else
                                                 begin
                                                      writeln(' Espaco livre!');
                                                 end;
										end;
                                        readln;
								end
							else
								begin
									write(' Matricula inexistente. Pressione ENTER para retornar ao menu');
									readln;
								end;
				end;
            5:
				begin
						clrscr;
						writeln('     SISBiblioteca - Pedido de emprestimo/devolucoes de livros');
						writeln;
                        write(' Escolha [E - Emprestimo] ou [D - Devolucoes]');
                        readln(escolha);

                        if upcase(escolha) = 'E' then
                           begin
								writeln(' Menu: Emprestimo ');
								writeln(' ----------------- ');
								write(' Digite a matricula do aluno: ');
								readln(buscaMatricula);
								Reset(tabelaAlunos);
								if verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).pos <> -1 then
									begin
										for contSacola := 1 to 2 do 
											begin
												//verificarPrazoEntrega
												dataEmp := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[contSacola,2];
												dataDev := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[contSacola,3];
												if dataEmp <> '-1' then
													begin             				 
														if verifPendencia(dataEmp, dataDev) = true then
															begin
																ok := false;
															end
														else
															begin
																ok := true;
															end;														
													end;
											 end;
												if ok = true then
													begin
														write(' Digite o ISBN do livro para efetuar o emprestimo: ');
														readln(buscaISBN);
														Reset(tabelaLivros);
														n1 := verificaISBN(tabelaLivros, buscaISBN, regLivro).pos;													
														if n1 <> -1 then
															begin
																//Se houver estoque
																if verificaISBN(tabelaLivros, buscaISBN, regLivro).quant > 0 then																
																	begin
																		write(' Digite a da para devolucao (Considere 7 dias, formato DD/MM/AAAA) : ');
																		readln(dataDev);
																		for contSacola := 1 to 2 do 
																			begin	
																				if (verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[contSacola,1] = '-1') then
																					begin
																						local := contSacola;
																						break;
																					end
																				  else
																					  begin
																					     local := 0;
																					  end;																																							
																			end;
																			GetDate(Ano, Mes, Dia, Dia_Semana);								
																			d1 := Dia;
																			m1 := Mes;
																			a1 := Ano;
																			Str(d1, d);
																			Str(m1, m);
																			Str(a1, a);																				
																			if  local = 1 then																				
																				begin
																				   regAluno.nome := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).nome;
																				   regAluno.curso := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).curso;
																				   regAluno.mat:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).mat;
																				   regAluno.sexo:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).sexo;
																				   regAluno.isbnLivros[1,1] := buscaISBN;
																				   regAluno.isbnLivros[1,2] := concat(d,'/',m,'/',a);
																				   regAluno.isbnLivros[1,3] := dataDev;
																				   regAluno.isbnLivros[2,1] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,1];
																				   regAluno.isbnLivros[2,2] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,2];
																				   regAluno.isbnLivros[2,3] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,3];
																				   Reset(tabelaAlunos);
																				   n := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).pos;
																				   Seek(tabelaAlunos, n-1);
																				   write(tabelaAlunos, regAluno);
																				   writeln;
																				   inseriu :=  true;
																			    end
																			else if local =  2 then
																				begin
																				   regAluno.nome := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).nome;
																				   regAluno.curso := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).curso;
																				   regAluno.mat:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).mat;
																				   regAluno.isbnLivros[1,1] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,1];
																				   regAluno.isbnLivros[1,2] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,2];
																				   regAluno.isbnLivros[1,3] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,3];
																				   regAluno.sexo:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).sexo;
																				   regAluno.isbnLivros[2,1] := buscaISBN;
																				   regAluno.isbnLivros[2,2] := concat(d,'/',m,'/',a);																																
																				   regAluno.isbnLivros[2,3] := dataDev;
																				   Reset(tabelaAlunos);
																				   n := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).pos;
																				   Seek(tabelaAlunos, n-1);
																				   write(tabelaAlunos, regAluno);
																				   writeln;
																				   inseriu :=  true;
																				end
																		   else
																				begin
																					inseriu := false;
																				end;
																				
																			if inseriu = true then
																				begin
																					inforLivro := verificaISBN(tabelaLivros, buscaISBN, regLivro);
												      								Reset(tabelaLivros);
																					regLivro.nome :=  inforLivro.nome;
																					regLivro.autor :=  inforLivro.autor;
																					regLivro.editora :=  inforLivro.editora;
																					regLivro.isbn :=  inforLivro.isbn;
																					regLivro.quant :=  inforLivro.quant - 1;
																					Seek(tabelaLivros, n1 - 1);
																					write(tabelaLivros, regLivro);
																					writeln(' Adicionado com sucesso.');
																					readln;													
																				end
																			else
																			   begin
																					inseriu := false;
																					writeln(' Erro ao adicionar ');
																					readln;
																					
																			   end;
																	end
																else
																	begin
																		inseriu := false;
																		writeln(' Quantidade nao disponivel! ');
																		readln;
																	end;
															end
														else
															begin
																inseriu := false;
																writeln(' ISBN invalido! ');
																readln;															
															end;
													end
												else
													begin
													  writeln(' Existem pendencias para o aluno ', verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).nome);
													  readln;														
													end;
									end
								else
									begin
										write(' Matricula inexistente. Pressione ENTER para retornar ao menu');
										readln;									
									end;
	
                           end
                        else if upcase(escolha) = 'D' then
                           begin
								writeln(' Menu: Devolucoes ');
								writeln(' ---------------- ');
								write(' Digite a matricula do aluno: ');
								readln(buscaMatricula);
								Reset(tabelaAlunos);	
								if verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).pos <> -1 then
									begin
										Reset(tabelaLivros);									
										/////////////////////////////////////////////////////////////////////////
										  writeln(' Livros em posse do aluno : [',  verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).nome, ']');

										   if   verificaISBN(tabelaLivros, verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,1], regLivro).pos <> -1 then
										   writeln(' Nome livro [1]: ', verificaISBN(tabelaLivros, verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,1], regLivro).nome, '- ISBN: ' , verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,1]);
										   if  verificaISBN(tabelaLivros, verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,1], regLivro).pos <> -1 then
										   writeln(' Nome Livro [2]: ', verificaISBN(tabelaLivros, verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,1], regLivro).nome, ' - ISBN: ', verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,1] );
										   writeln(' Deseja devolver todos [T] ou um livro  [U]: ');
										   readln(escolha);
										   if upcase(escolha) = 'T' then
											  begin
                                                    inforLivro := verificaISBN(tabelaLivros, verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,1], regLivro);

													regLivro.nome :=  inforLivro.nome;
													regLivro.autor :=  inforLivro.autor;
													regLivro.editora :=  inforLivro.editora;
													regLivro.isbn :=  inforLivro.isbn;
													regLivro.quant :=  inforLivro.quant + 1;
													Seek(tabelaLivros, inforLivro.pos - 1);
													write(tabelaLivros, regLivro);

                                                    inforLivro := verificaISBN(tabelaLivros, verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,1], regLivro);
													Reset(tabelaLivros);
													regLivro.nome :=  inforLivro.nome;
													regLivro.autor :=  inforLivro.autor;
													regLivro.editora :=  inforLivro.editora;
													regLivro.isbn :=  inforLivro.isbn;
													regLivro.quant :=  inforLivro.quant + 1;
													Seek(tabelaLivros, inforLivro.pos - 1);
													write(tabelaLivros, regLivro);


             	                                    regAluno.nome := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).nome;
													regAluno.curso := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).curso;
													regAluno.mat:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).mat;
													regAluno.sexo:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).sexo;
													regAluno.isbnLivros[1,1] := '-1';
													regAluno.isbnLivros[1,2] := '-1';
													regAluno.isbnLivros[1,3] := '-1';
													regAluno.isbnLivros[2,1] := '-1';
													regAluno.isbnLivros[2,2] := '-1';
													regAluno.isbnLivros[2,3] := '-1';
													Reset(tabelaAlunos);
													n := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).pos;
													Seek(tabelaAlunos, n-1);
													write(tabelaAlunos, regAluno);

                                                    writeln(' Devolvido com sucesso.');
													readln;
											  end
										   else if upcase(escolha) = 'U' then
												begin
													write(' Digite o ISBN do livro a ser devolvido: ');
													readln(buscaISBN);
													Reset(tabelaAlunos);													
													Reset(tabelaLivros);
													n1 := verificaISBN(tabelaLivros, buscaISBN, regLivro).pos;															
													if n1 <> -1 then
														begin
														 inseriu :=  false;
															for contSacola := 1 to 2 do 
																begin	
																	if (verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[contSacola,1] = buscaISBN) then
																		begin
																		       local := contSacola;
                                                                               break;
																			end
																	  else
																		  begin
																			   local := 0;
																		  end;																																							
																end;																		
															if  local = 1 then																				
																begin
																   regAluno.nome := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).nome;
																   regAluno.curso := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).curso;
																   regAluno.mat:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).mat;
																   regAluno.sexo:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).sexo;
																   regAluno.isbnLivros[1,1] := '-1';
																   regAluno.isbnLivros[1,2] := '-1';
																   regAluno.isbnLivros[1,3] := '-1';
																   regAluno.isbnLivros[2,1] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,1];
																   regAluno.isbnLivros[2,2] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,2];
																   regAluno.isbnLivros[2,3] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[2,3];
																   Reset(tabelaAlunos);
																   n := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).pos;
																   Seek(tabelaAlunos, n-1);
																   write(tabelaAlunos, regAluno);
																   writeln;
																   inseriu :=  true;
																end
															else if local =  2 then
																begin
																   regAluno.nome := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).nome;
																   regAluno.curso := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).curso;
																   regAluno.mat:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).mat;
																   regAluno.isbnLivros[1,1] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,1];
																   regAluno.isbnLivros[1,2] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,2];
																   regAluno.isbnLivros[1,3] := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).isbnLivros[1,3];
																   regAluno.sexo:= verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).sexo;
																   regAluno.isbnLivros[2,1] := '-1';
																   regAluno.isbnLivros[2,2] := '-1';																												
																   regAluno.isbnLivros[2,3] := '-1';
																   Reset(tabelaAlunos);
																   n := verificaMatricula(tabelaAlunos, buscaMatricula, regAluno).pos;
																   Seek(tabelaAlunos, n-1);
																   write(tabelaAlunos, regAluno);
																   writeln;
																   inseriu :=  true;
																end
														   else
																begin
																	inseriu := false;
																end;
															if inseriu = true then
																begin
																	inforLivro := verificaISBN(tabelaLivros, buscaISBN, regLivro);
																	Reset(tabelaLivros);
																	regLivro.nome :=  inforLivro.nome;
																	regLivro.autor :=  inforLivro.autor;
																	regLivro.editora :=  inforLivro.editora;
																	regLivro.isbn :=  inforLivro.isbn;
																	regLivro.quant :=  inforLivro.quant + 1;
																	Seek(tabelaLivros, n1 - 1);
																	write(tabelaLivros, regLivro);
																	writeln(' Devolvido com sucesso.');
																	readln;													
																end
															else
															   begin
																	inseriu := false;
																	writeln(' Erro ao Devolver ');
																	readln;
															   end;
														end
													else
														begin
															writeln(' ISBN Invalido ');
															readln;
														end;
									end
								else
									begin	
										writeln('  Invalida ');
										readln;
									end;

							end;
					   end;
				end;
			6: //Lista de Aluno;
				begin
						clrscr;
						writeln('     SISBiblioteca - Listar de Aluno(s)');
						writeln;
						try
							Reset(tabelaAlunos);
							rewrite(arquivoTextAluno);
							while not Eof(tabelaAlunos) do
									begin
										   read(tabelaAlunos, regAluno);
										   writeln(' Nome: ', regAluno.nome);
										   writeln(' Matricula : ', regAluno.mat);
										   writeln(' Sexo: ', regAluno.sexo);
										   writeln(' Curso: ', regAluno.curso);
										   writeln(' Livros em sua posse: ' );
										   if regAluno.isbnLivros[1,1] = '-1' then
												   begin
													  writeln('   1.  - ' );
												   end
											   else
												   begin
														writeln('   1.  ', regAluno.isbnLivros[1,1] );
												   end;
											   if regAluno.isbnLivros[1,2] = '-1' then
												   begin
														 writeln('       Data de Emprestimo: - ');
												   end
											   else
													begin
														  writeln('       Data de Emprestimo:', regAluno.isbnLivros[1,2]);
													end;
											   if regAluno.isbnLivros[1,3] = '-1' then
												   begin
														writeln('       Data de Devolucao: - ');
													end
												else
													begin
														writeln('       Data de Devolucao:', regAluno.isbnLivros[1,3]);																
													end;
											   if regAluno.isbnLivros[2,1] = '-1' then
												   begin															
														writeln('   2.  - ');	
												   end
											   else
												   begin
														writeln('   2.  ', regAluno.isbnLivros[2,1]);
												   end;
											   if regAluno.isbnLivros[2,2] = '-1' then
												   begin															   
														writeln('       Data de Emprestimo: - ');
													end
												else
													begin
														writeln('       Data de Emprestimo:', regAluno.isbnLivros[2,2]);
													end;
											  if regAluno.isbnLivros[2,3] = '-1' then
												   begin															
														writeln('       Data de Devolucao: - ');
													end
												else
													begin
														 writeln('       Data de Devolucao:', regAluno.isbnLivros[2,3]);
													end;
											   writeln('');
											   if not   ExtArqTextAlunos(arquivoTextAluno) then
													begin
														rewrite(arquivoTextAluno);
													 end
												else
													begin
														Append(arquivoTextAluno);
													end;
													
													
											   writeln(arquivoTextAluno, 'Nome: ', regAluno.nome);
											   writeln(arquivoTextAluno,' Matricula : ', regAluno.mat);
											   writeln(arquivoTextAluno,' Sexo: ', regAluno.sexo);
											   writeln(arquivoTextAluno,' Curso: ', regAluno.curso);
											   writeln(arquivoTextAluno,' Livros em sua posse: ' );
											   if regAluno.isbnLivros[1,1] = '-1' then
												   begin
													  writeln(arquivoTextAluno,'   1.  - ' );
												   end
											   else
												   begin
														writeln(arquivoTextAluno,'   1.  ', regAluno.isbnLivros[1,1] );
												   end;
											   if regAluno.isbnLivros[1,2] = '-1' then
												   begin
														 writeln(arquivoTextAluno,'       Data de Emprestimo: - ');
												   end
											   else
													begin
														  writeln(arquivoTextAluno,'       Data de Emprestimo:', regAluno.isbnLivros[1,2]);
													end;
											   if regAluno.isbnLivros[1,3] = '-1' then
												   begin
														writeln(arquivoTextAluno,'       Data de Devolucao: - ');
													end
												else
													begin
														writeln(arquivoTextAluno,'       Data de Devolucao:', regAluno.isbnLivros[1,3]);																
													end;

											   if regAluno.isbnLivros[2,1] = '-1' then
												   begin															
														writeln(arquivoTextAluno,'   2.  - ');	
												   end
											   else
												   begin
														writeln(arquivoTextAluno,'   2.  ', regAluno.isbnLivros[2,1]);
												   end;
													   //
											   if regAluno.isbnLivros[2,2] = '-1' then
												   begin															   
														writeln(arquivoTextAluno,'       Data de Emprestimo: - ');
													end
												else
													begin
														writeln(arquivoTextAluno,'       Data de Emprestimo:', regAluno.isbnLivros[2,2]);
													end;
														//
											   if regAluno.isbnLivros[2,3] = '-1' then
												   begin															
														writeln(arquivoTextAluno,'       Data de Devolucao: - ');
													end
												else
													begin
														 writeln(arquivoTextAluno,'       Data de Devolucao:', regAluno.isbnLivros[2,3]);
													end;
														//
											   writeln;
											   close(arquivoTextAluno);
								   end;
							  readln;
				    except
						on e: EInOutError do
						begin
							writeln('Ocorreu um erro ao ler alunos. Verifique se existem alunos cadastrados. \n Detalhes: '+ e.ClassName+'/'+ e.Message);
							readln;
						end;    
  					end;
				end;				
			7:
				begin
					writeln;
					write(' Encerrando...');
					readln;
				end
			else
				begin
					writeln;
					write(' Opcao invalida!');
					readln;
				end
		end;
	until opcao = 7;
end.

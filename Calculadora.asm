TITLE Pedro Di Grazia (22002293), Pedro Pistarini (22000341)
.model small
.data

    ; Criando variaveis
    op1 db ?                   
    op2 db ?
    operando db ?


    Titulo db     '<---------------------------- Calculadora - Assembly --------------------------> $'
    cabecalho db  '================================================================================ $'    

    Instrucao1 db '-> Digite o primeiro numero (0 a 9): $'
            
    Instrucao2 db '-> Digite o segundo numero [0 a 9]: $'
        
    Operador db   '-> Digite a operacao(+ - * /): $'
            
    Resultado db  '-> Resultado: $'

    Erro db       '-> Operando nao eh valido, digite outro! $'
    Numeroinvalido db '-> Numero invalido, tente outro! $'
    
    continuacao db '-> Deseja continuar (S / N): $'
       
.code
    
    ; Função Soma
    soma proc                               ; Cria função

        mov cl,op1                          ; Jogando valor de op1 para cl
        sub cl,30h                          ; Subtraindo 30h da tabela ascii

        mov bl,op2                        
        sub bl,30h                          ; Subtraindo 30h da tabela ascii

        add cl,bl                    ; Adicionando cl com bl
        add cl, 30h                  ; Acionando 30h na tabela ascii
        call duascasasdecimais

    ret                                 ; Retorno função
    soma endp   

    ; Função Subtração
    subtracao proc                      ; Cria função

        mov ch,op1                   ; Jogando valor de op1 para ch
        sub ch,30h                   ; Subraindo 30h da tabela ascii

        mov bl,ch                    ; Jogando valor de ch para bl, para não perder o valor de ch

        mov cl,op2                   ; Jogando valor de op2 para cl
        sub cl,30h                   ; Subtraindo 30h da tabela ascii

        sub bl,cl                    ; Pegando o valor que foi jogado para bl e subtraindo com cl
        js negativo                  ; Verifica se o numero for negativo
        jns positivo                 ; Verifica se o numero é positivo
        
        negativo:                    ; Se for negativo o neg é realizado  
        neg bl                       ; Transforma o numero em negativo
        positivo:

        add bl,30h                   ; Retornando o valor original na tabela ascii
        add ch,30h                   ; Retornando o valor original na tabela ascii
        add cl,30h                   ; Retornando o valor original na tabela ascii

        cmp ch, cl                   ; Compara ch com cl
        jae chmaior                  ; Caso ch seja maior ele pula, caso contrario continua


            call resultado1

            mov dl,'-'
            mov ah,2              ; Printando sinal de '-'
            int 21h

            mov dl,bl
            mov ah,2              ; Jogando valor da subtração para dl
            int 21h

            jmp fim               ; Pular para fim do programa para não continuar realizando operações não desejadas


        chmaior:                      ; Pula aqui quando ch for maior que cl

            call resultado1

            mov dl,bl
            mov ah,2                   ; Passa valor da subtração para dl e assim printar o valor
            int 21h


    ret                          ; Retorno função
    subtracao endp

    ; Função Multiplicação
    multiplicacao proc

    mov bh,op1                         ; Joga valor para bh
    mov bl,op2                         ; Joga valor para bl

    sub bh, 30h
    sub bl, 30h

        xor cl,cl                   ; Zera valor de cl

        pular:

        shr bl, 1              
        jnc igual0                  ; Verifica primeiro numero do multiplicador

        add cl, bh                  ; Se o primeiro valor for 1 ele joga pra outro registrador

        igual0:                     ; Caso seja zero 
        
        shl bh, 1                   ; Ocorre uma rotação em BH onde está o multiplicando 

        cmp bl,0                    ; Comparando bl com 0, porque ñ tem sentido continuar rodando, 
        jne pular                   ; quando não se tem mais nada dentro
                
        add cl, 30h
        call duascasasdecimais      ; Chamada de função

    ret
    multiplicacao endp

    ; Função divisão
    divisao proc

    mov bh,op1
    mov bl,op2

    sub bh, 30h      
    sub bl, 30h      

    cmp bh,bl  
    je iguais                       ; Se forem igual pula
    jmp pulaigual

    iguais:
    mov cl,31h                      ; Printa resultado
    call duascasasdecimais
    jmp finaldivi                   ; Pula pro final

    pulaigual:                      ; Se não forem iguais

    jmp divisaogeral                ; Pula para divisao geral

    resultpar:

    shr bl, 1        ;0400           
    jnc Divisaopar         

    add cl, bh      ;04     
    jmp finaldadivi

    Divisaopar:
    
        shr bh, 1        ;0401  
                            
        cmp bl,0           
        jne resultpar
                
        add cl, 30h         
        call duascasasdecimais
        
        jmp finaldivi

        divisaogeral:
        xor cl,cl    ;CL = 00

        pulardi:

        shr bl, 1           ;0903 -> 0901         
        jnc Divisaopar      ;Se for um numero impar tera carry, se não não!       

        add cl, bh        

        Divisaoimpar:     
        
        shr bh, 1        
                            
        jmp pulad

        impardivi:
        xchg ch,bl     ;CH = 01

        sub bh,ch      ; 
        mov cl,bh     

        pulad:  
        cmp bl,1        ;0401
        je impardivi

        finaldadivi:
        add cl, 30h         
        call duascasasdecimais
        finaldivi:
        ret
    divisao endp

    ; Função para printar duas casas decimais
    duascasasdecimais proc

        xor ax,ax                      ; Zera registrador ax
        mov al,cl                      ; Joga o resultado da soma em al
        sub al,30h                     ; Tirando 30h da tabela ascii

        mov bl,10                      ; Jogando valor de 10 para bl 

        div bl                         ; Usando valor jogado para bl para dividir al

        mov bx,ax                      ; Assim que dividido separa o resultado em al e outro para ah, assim jogado para bx os valores que estão em ax
        mov dl,bl                      ; Pegando o primeiro valor separado e joga para dl
        or dl, 30h                     ; Adcionando 30h da tabela ascii para printar o numero
        mov ah, 2                      ; Printar o numero
        int 21h 

        mov dl,bh                      ; Pegar o outro valor do restultado e jogar em dl
        or dl, 30h                     ; Adiciona 30h da tabela ascii para printar o numero 
        mov ah, 2                      ; Printar o numero
        int 21h

    ret
    duascasasdecimais endp

    ; Função Pula
    pula proc

        mov dl,10
        mov ah,2                     ; Função pula 1 linha
        int 21h

    ret
    pula endp  

    ; Função Pula
    pula1 proc

        mov dl,10
        mov ah,2                     ; Função pula 2 linhas
        int 21h
        int 21h

    ret
    pula1 endp

    ; Imprimindo a operação na tela
    resultado1 proc

        lea dx,Resultado        
        mov ah,9                    ; Printa resultado
        int 21h

        mov ah,2
        mov dl, op1                 ; Jogando valor de op1 para dl
        int 21h

        mov ah,02
        mov dl,32                   ; Print 'espaço'
        int 21h

        mov ah,2
        mov dl,operando             ; Jogando valor do operando para dl
        int 21h

        mov ah,02
        mov dl,32                   ; Print 'espaço'
        int 21h

        mov ah,2 
        mov dl,op2                  ; Jogando valor de op2 para dl
        int 21h

        mov ah,02
        mov dl,32                   ; Print 'espaço'
        int 21h

        mov ah,02
        mov dl,'='                  ; Print '='
        int 21h

        mov ah,02
        mov dl,32                   ; Print 'espaço'
        int 21h

    ret 
    resultado1 endp

    ; Validação dos sinais
    validasinal proc

        operadornovo:

            lea dx,Operador
            mov ah,9                    ; Printa Operador
            int 21h

            mov ah,1                    ; Digitar um Operador
            int 21h       
            mov operando,al             ; Passar al para operando

            cmp operando, '+'            ; Compara com '+' na tabela ascii   
            je existe                   ; Se for igual pula se não ele continua 
            cmp operando, '-'            ; Compara com '-' na tabela ascii 
            je existe                   ; Se for igual pula se não ele continua
            cmp operando, '*'            ; Compara com '*' na tabela ascii
            je existe                   ; Se for igual pula se não ele continua
            cmp operando, '/'            ; Compara com '/' na tabela ascii
            je existe                   ; Se for igual pula se não ele continua

                call pula1

                lea dx, erro
                mov ah,09                   ; Printa mensagem 
                int 21h
                
                call pula1

            jmp operadornovo            ; Caso não seja igual a nenhum dos numeros ele pula e pede outro operando 
        
        existe:

    ret 
    validasinal endp

    ; Validação dos numeros
    validanumero1 proc

        outronumero:

            call pula1                  ; Função Pula linha

            lea dx,Instrucao1            
            mov ah,9                    ; Printa instrucao1
            int 21h

            mov ah,1                    ; Digitar o primeiro numero
            int 21h 

            cmp al, '9'                          
            jle menor9                  ; Salta se AL for menor do que '9' caso contrario ele continua  

                call pula 

                lea dx,Numeroinvalido 
                mov ah,9
                int 21h
                
                jmp outronumero             ; Jump para retornar e colocar um numero correto

            menor9:                     ; Pula caso o Al for menor que 47

                cmp al,'0'
                jge maior0                  ; Se o al for menor que 48 ele continua, caso contrario ele pula

                call pula 

                lea dx,Numeroinvalido       
                mov ah,9
                int 21h
            
            jmp outronumero             ; Jump para retornar e colocar um numero correto

            maior0:                     ; Pula quando o valor de al for maior de 48

            mov op1,al                  ; Jogando o numero al para op1

            call pula1

    ret 
    validanumero1 endp

    ; Validação dos numeros
    validanumero2 proc

        outronumero2:

            call pula1                  ; Função Pula linha

            lea dx,Instrucao2            
            mov ah,9                    ; Printa instrucao1
            int 21h

            mov ah,1                    ; Digitar o primeiro numero
            int 21h 

            cmp al, '9'                          
            jle Menor09                  ; Salta se AL for menor do que '9' caso contrario ele continua  

                call pula 

                lea dx,Numeroinvalido 
                mov ah,9
                int 21h
                
                jmp outronumero2             ; Jump para retornar e colocar um numero correto

            Menor09:                     ; Pula caso o Al for menor que 47

            cmp al,'0'
            jge Maior00                  ; Se o al for menor que 48 ele continua, caso contrario ele pula

                call pula 

                lea dx,Numeroinvalido       
                mov ah,9
                int 21h
                
            jmp outronumero             ; Jump para retornar e colocar um numero correto

            Maior00:                     ; Pula quando o valor de al for maior de 48

        mov op2,al                  ; Jogando o numero al para op1

    ret 
    validanumero2 endp

    ; Função que verifica sinal
    verifica_sinal proc

        cmp operando,'+'                           ; Comparando o operando com '+'
        je mais                                    ; Se o operando for igual ao simbolo '+' ele pula, caso contrario ele continua

            cmp operando,'-'                    ; Comparando o operando com '+'
            je menos                            ; Se o operando for igual ao simbolo '-' ele pula, caso contrario ele continua

                cmp operando,'*'             ; Comparando o operando com '*'
                je multi                     ; Se for igual ao '*' ele pula

                    cmp operando,'/'      ; Comparando operando com '/'
            
                        call limpa_tela      
                        call cabecalho1
                        call pula1                 ; Chamada de Funções
                        call resultado1
                        call divisao
                
                    jmp fim

                multi:

                    call limpa_tela
                    call cabecalho1
                    call pula1                  ; Chamada de Funções
                    call resultado1
                    call multiplicacao
                
                jmp fim
                                        
            menos:                        ; Caso seja sinal de '-'

                call limpa_tela
                call cabecalho1
                call pula                   ; Chamada de Funções
                call subtracao               
            
            jmp fim                      

        mais:                             ; Caso seja utlizado o sinal de '+'
                                            
            call limpa_tela
            call cabecalho1                       
            call pula                   ; Chamada de Funções
            call resultado1               
            call soma

        fim:                                ; Pular para o fim do programa

    ret
    verifica_sinal endp

    ; Função que limpa a tela
    limpa_tela proc

        mov ah, 00h
        mov al, 03h
        int 10h                     ; Comando com funcionalidade de limpar a tela 
        mov cx, 02h

        mov dh,1
        mov dl,1
        mov ah,02h
        int 10h

    ret
    limpa_tela endp

    ; Função que printa o cabeçalho
    cabecalho1 proc

        call pula
        lea dx,cabecalho             ; Printa cabçalho
        mov ah,9
        int 21h

        call pula
        lea dx,Titulo
        mov ah,9                     ; Printa Titulo
        int 21h

        call pula
        lea dx,cabecalho             ; Printa cabeçalho
        mov ah,9
        int 21h

    ret
    cabecalho1 endp

    ; Função que verifica se quer continuar ou não
    continuacao1 proc

        mov ah, 09
        lea dx, continuacao         ; Printa continuação
        int 21h

        mov ah, 01                  ; Entrada de caracter
        int 21h

        cmp al, 'S'                 ; Se for digitado 'S' ou 's' ele vai pro começo do codigo,
        je comeco                   ; e está pronto para começar uma nova operação
        cmp al, 's'
        je comeco

        ret
    continuacao1 endp

    ; Função encerraento
    final proc

        mov ah,4ch                          ; Encerramento do programa 
        int 21h

        ret
    final endp

    ; Função pro segmento de data
    segmento proc

        mov ax,@data                 ; Move o segmento data para ax         
        mov ds,ax

        ret
    segmento endp

    main proc   

        comeco:                     ; Jump condicional para a calculadora ser recomeçada

        call limpa_tela

        call segmento

        call cabecalho1

        call validanumero1

        call validasinal            ; Chamada de funções 
        
        call validanumero2

        call verifica_sinal

        call pula1

        call continuacao1

        call final
        
        main endp
    END main

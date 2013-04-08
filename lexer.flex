import java_cup.runtime.*;
import java_cup.sym;
import java_cup.symbol;
import java.io.*;

%%

%public
%class LexerX
%unicode
%char
%line
%column
%cup
%standalone

%{
  StringBuffer string = new StringBuffer();

  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
  
  private static final int _TAG  =  1;
  private static final int _ATRIBUTO  =  2;
  private static final int TAG_EXC=  3;
  private static final int TAG_INTE=  4;
  private static final int TAG_SLA =  5;
  private static final int TAG_SIM =  6;
  private static final int CERRAR_SLA =  7;
  private static final int CERRAR_SIM =  8;
%}



%xstate COMENTARIO, TAG, ATRIBUTO
/*Letras*/
letras = [A-Z]|[a-z]

/*Numeros*/
numeros = [0-9]

/*Espacios en blanco, incluye Tabs y retorno de carril*/
espacio = (\u0020 | \u0009 | \u000D | \u000A)+

/*Comentario de comentarios*/
comentarioInicio = "<!--"
comentarioFinal = "-->"
COMENTARIO = {comentarioInicio}.{comentarioFinal}

/*Unico tag en mayuscula !DOCTYPE*/

TAG = "!DOCTYPE" |
 "address" |
"applet" |
"area" |
"a" |
"b" |
"base" |
"basefont" |
"big" |
"blockquote" |
"body" |
"br" |
"caption" |
"center" |
"cite" |
"code" |
"dd" |
"dfn" |
"dir" |
"div" |
"dl" |
"dt" |
"font" |
"form" |
"h"[1-6] |
"head" |
"hr" |
"html" |
"img" |
"input" |
"isindex" |
"kbd" |
"li" |
"link" |
"LINK" |
"map" |
"META" |
"menu" |
"meta" |
"ol" |
"option" |
"param" |
"pre" |
"p" |
"samp" |
"span" |
"select" |
"small" |
"strike" |
"sub" |
"sup" |
"table" |
"td" |
"textarea" |
"th" |
"title" |
"tr" |
"tt" |
"ul" |
"var" |
"xmp" |
"script" |
"noscript" |
"style" 

ATRIBUTO =
"action" |
"align" |
"alink" |
"alt" |
"archive" |
"background" |
"bgcolor" |
"border" |
"bordercolor" |
"cellpadding" |
"cellspacing" |
"checked" |
"class" |
"clear" |
"code" |
"codebase" |
"color" |
"cols" |
"colspan" |
"content" |
"coords" |
"enctype" |
"face" |
"gutter" |
"height" |
"hspace" |
"href" |
"id" |
"link" |
"lowsrc" |
"marginheight" |
"marginwidth" |
"maxlength" |
"method" |
"name" |
"prompt" |
"rel" |
"rev" |
"rows" |
"rowspan" |
"scrolling" |
"selected" |
"shape" |
"size" |
"src" |
"start" |
"target" |
"text" |
"type" |
"url" |
"usemap" |
"ismap" |
"valign" |
"value" |
"vlink" |
"vspace" |
"width" |
"wrap" |
"abbr" |
"accept" |
"accesskey" |
"axis" |
"char" |
"charoff" |
"charset" |
"cite" |
"classid" |
"codetype" |
"compact" |
"data" |
"datetime" |
"declare" |
"defer" |
"dir" |
"disabled" |
"for" |
"frame" |
"headers" |
"hreflang" |
"lang" |
"language" |
"longdesc" |
"multiple" |
"nohref" |
"nowrap" |
"object" |
"profile" |
"readonly" |
"rules" |
"scheme" |
"scope" |
"span" |
"standby" |
"style" |
"summary" |
"tabindex" |
"valuetype" |
"version"

/*Caracteres*/
caracterRegular = [\u0000-\uFFFF]
caracterUnicode = [\u10000-\10FFFF]

%%
<YYINITIAL>{	

	"<!" 							{System.out.println(yytext());
									return symbol(TAG_EXC);}
	"<?"							{System.out.println(yytext());
									return symbol(TAG_INTE);}
	"</"							{System.out.println(yytext());
									return symbol(TAG_SLA);}
	"<"								{System.out.println(yytext());
									return symbol(TAG_SIM);}
	"/>"							{System.out.println(yytext());
									return symbol(CERRAR_SLA);}
	">"								{System.out.println(yytext());
									return symbol(CERRAR_SIM);}
	{TAG}							{System.out.println(yytext());
									return symbol(_TAG);}
	{ATRIBUTO}						{System.out.println(yytext());
									return symbol(_ATRIBUTO);}
									
	{COMENTARIO}					{}
									
	(&){espacio}					{FileOutputStream f = new FileOutputStream("errores.log");
									System.setErr(new PrintStream(f));
								 	System.err.println("Line: "+yyline + " Error lexico: El uso del caracter \"&\" por si solo es invalido; use &amp");
								 	System.out.println("Line: "+yyline + " Error lexico: El uso del caracter \"&\" por si solo es invalido; use &amp");
									throw new Error("Error lexico: El uso del caracter \"&\" por si solo es invalido; use &amp");}
	
	{caracterRegular}				{}
									
	{caracterUnicode} 				{System.out.println("Caracter Unicode: " + yytext());}
}

/*Todo caracter que no haya sido atrapado por caracterRegular o CaracterUnicode, no pertenece a Unicode y por lo tanto es invalido*/

.                            	 {FileOutputStream f = new FileOutputStream("errores.log");
										 System.setErr(new PrintStream(f));
								 		System.err.println("Caracter invalido");
								 		System.out.println("Caracter invalido");
										throw new Error("Caracter invalido"); }
										
 <<EOF>>                       		{ return symbol(0); }

 


